import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/artigo.dart';
import '../data/comentario.dart';
import '../data/comunidade.dart';
import '../data/conteudo_json.dart';

/// Onde o conteúdo criado pelos usuários (artigos, comunidades e posts)
/// mora. O app só conversa com esta interface:
///
///  - HOJE: [ConteudoLocal], que grava no aparelho (SharedPreferences) e
///    simula o banco de dados, para o recurso poder ser testado inteiro.
///  - COM `API_URL`: [ConteudoRemoto] (`conteudo_remoto.dart`), que fala com
///    o banco de dados pela API (`backend/`). A escolha de uma ou outra está
///    em `ConteudoUsuarioService.instance`.
///
/// Os métodos são assíncronos de propósito: o banco de dados será.
/// Erro do repositório com mensagem pronta para a pessoa (por exemplo, o
/// servidor recusou: "Já existe uma comunidade com esse nome.").
class ErroDeConteudo implements Exception {
  final String mensagem;
  const ErroDeConteudo(this.mensagem);

  @override
  String toString() => 'ErroDeConteudo: $mensagem';
}

abstract class ConteudoRepositorio {
  Future<List<Artigo>> listarArtigos();
  Future<void> salvarArtigo(Artigo artigo);

  /// Grava a nova versão de um artigo que já existe e devolve como ficou
  /// (no servidor, o endereço da capa muda a cada edição).
  Future<Artigo> editarArtigo(Artigo artigo);

  /// Apaga o artigo E os comentários dele.
  Future<void> apagarArtigo(String id);

  Future<List<Comentario>> listarComentarios(String artigoId);
  Future<void> salvarComentario(Comentario comentario);
  Future<void> apagarComentario(String artigoId, String comentarioId);

  Future<List<Comunidade>> listarComunidades();
  Future<void> salvarComunidade(Comunidade comunidade);

  /// Apaga a comunidade E os posts dela.
  Future<void> apagarComunidade(String id);

  Future<List<PostComunidade>> listarPosts(String comunidadeId);
  Future<void> salvarPost(PostComunidade post);
  Future<void> apagarPost(String comunidadeId, String postId);

  /// Apaga tudo o que [email] escreveu (usado ao excluir a conta).
  Future<void> apagarDoAutor(String email);
}

/// Implementação que funciona sem servidor: tudo no aparelho.
/// Os dados ficam em três chaves; leituras tolerantes a corrupção.
class ConteudoLocal implements ConteudoRepositorio {
  static const _kArtigos = 'conteudo_v1_artigos';
  static const _kComunidades = 'conteudo_v1_comunidades';
  static const _kPosts = 'conteudo_v1_posts';
  static const _kComentarios = 'conteudo_v1_comentarios';

  Future<List<Object?>> _lerLista(String chave) async {
    try {
      final p = await SharedPreferences.getInstance();
      final bruto = p.getString(chave);
      if (bruto == null || bruto.isEmpty) return const [];
      final d = jsonDecode(bruto);
      return d is List ? d : const [];
    } catch (_) {
      return const [];
    }
  }

  Future<void> _gravarLista(String chave, List<Object?> lista) async {
    try {
      final p = await SharedPreferences.getInstance();
      await p.setString(chave, jsonEncode(lista));
    } catch (_) {
      // Falha ao gravar não derruba o app.
    }
  }

  // ---------- Artigos ----------

  Future<List<Artigo>> _todosArtigos() async => [
    for (final m in await _lerLista(_kArtigos))
      if (artigoDeMapa(m) != null) artigoDeMapa(m)!,
  ];

  @override
  Future<List<Artigo>> listarArtigos() => _todosArtigos();

  @override
  Future<void> salvarArtigo(Artigo artigo) async {
    final lista =
        (await _todosArtigos()).where((a) => a.id != artigo.id).toList()
          ..add(artigo);
    await _gravarLista(_kArtigos, [for (final a in lista) artigoParaMapa(a)]);
  }

  @override
  Future<Artigo> editarArtigo(Artigo artigo) async {
    await salvarArtigo(artigo);
    return artigo;
  }

  @override
  Future<void> apagarArtigo(String id) async {
    final lista = (await _todosArtigos()).where((a) => a.id != id).toList();
    await _gravarLista(_kArtigos, [for (final a in lista) artigoParaMapa(a)]);
    final coms = (await _todosComentarios()).where((c) => c.artigoId != id);
    await _gravarLista(_kComentarios, [for (final c in coms) c.toMap()]);
  }

  // ---------- Comentários ----------

  Future<List<Comentario>> _todosComentarios() async => [
    for (final m in await _lerLista(_kComentarios))
      if (Comentario.tentarLer(m) != null) Comentario.tentarLer(m)!,
  ];

  /// Do mais antigo para o mais novo (como uma conversa).
  @override
  Future<List<Comentario>> listarComentarios(String artigoId) async =>
      (await _todosComentarios()).where((c) => c.artigoId == artigoId).toList()
        ..sort((a, b) => a.criadoMs.compareTo(b.criadoMs));

  @override
  Future<void> salvarComentario(Comentario comentario) async {
    final lista =
        (await _todosComentarios()).where((c) => c.id != comentario.id).toList()
          ..add(comentario);
    await _gravarLista(_kComentarios, [for (final c in lista) c.toMap()]);
  }

  @override
  Future<void> apagarComentario(String artigoId, String comentarioId) async {
    final lista = (await _todosComentarios())
        .where((c) => !(c.artigoId == artigoId && c.id == comentarioId))
        .toList();
    await _gravarLista(_kComentarios, [for (final c in lista) c.toMap()]);
  }

  // ---------- Comunidades ----------

  Future<List<Comunidade>> _todasComunidades() async => [
    for (final m in await _lerLista(_kComunidades))
      if (Comunidade.tentarLer(m) != null) Comunidade.tentarLer(m)!,
  ];

  @override
  Future<List<Comunidade>> listarComunidades() => _todasComunidades();

  @override
  Future<void> salvarComunidade(Comunidade comunidade) async {
    final lista =
        (await _todasComunidades()).where((c) => c.id != comunidade.id).toList()
          ..add(comunidade);
    await _gravarLista(_kComunidades, [for (final c in lista) c.toMap()]);
  }

  @override
  Future<void> apagarComunidade(String id) async {
    final lista = (await _todasComunidades()).where((c) => c.id != id).toList();
    await _gravarLista(_kComunidades, [for (final c in lista) c.toMap()]);
    final posts = (await _todosPosts()).where((p) => p.comunidadeId != id);
    await _gravarLista(_kPosts, [for (final p in posts) p.toMap()]);
  }

  // ---------- Posts ----------

  Future<List<PostComunidade>> _todosPosts() async => [
    for (final m in await _lerLista(_kPosts))
      if (PostComunidade.tentarLer(m) != null) PostComunidade.tentarLer(m)!,
  ];

  @override
  Future<List<PostComunidade>> listarPosts(String comunidadeId) async {
    final lista =
        (await _todosPosts())
            .where((p) => p.comunidadeId == comunidadeId)
            .toList()
          ..sort((a, b) => b.criadoMs.compareTo(a.criadoMs));
    return lista;
  }

  @override
  Future<void> salvarPost(PostComunidade post) async {
    final lista = (await _todosPosts()).where((p) => p.id != post.id).toList()
      ..add(post);
    await _gravarLista(_kPosts, [for (final p in lista) p.toMap()]);
  }

  @override
  Future<void> apagarPost(String comunidadeId, String postId) async {
    final lista = (await _todosPosts())
        .where((p) => !(p.comunidadeId == comunidadeId && p.id == postId))
        .toList();
    await _gravarLista(_kPosts, [for (final p in lista) p.toMap()]);
  }

  @override
  Future<void> apagarDoAutor(String email) async {
    final e = email.toLowerCase();
    final todosArtigos = await _todosArtigos();
    final meusArtigos = {
      for (final a in todosArtigos)
        if ((a.autorEmail ?? '').toLowerCase() == e) a.id,
    };
    final artigos = todosArtigos.where((a) => !meusArtigos.contains(a.id));
    await _gravarLista(_kArtigos, [for (final a in artigos) artigoParaMapa(a)]);
    // Comentários da pessoa e os feitos nos artigos dela.
    final coms = (await _todosComentarios()).where(
      (c) =>
          c.autorEmail.toLowerCase() != e && !meusArtigos.contains(c.artigoId),
    );
    await _gravarLista(_kComentarios, [for (final c in coms) c.toMap()]);

    final todas = await _todasComunidades();
    final minhas = {
      for (final c in todas)
        if ((c.criadaPor ?? '').toLowerCase() == e) c.id,
    };
    await _gravarLista(_kComunidades, [
      for (final c in todas)
        if (!minhas.contains(c.id)) c.toMap(),
    ]);
    final posts = (await _todosPosts()).where(
      (p) =>
          p.autorEmail.toLowerCase() != e && !minhas.contains(p.comunidadeId),
    );
    await _gravarLista(_kPosts, [for (final p in posts) p.toMap()]);
  }
}
