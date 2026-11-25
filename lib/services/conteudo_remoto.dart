import '../data/artigo.dart';
import '../data/comentario.dart';
import '../data/comunidade.dart';
import '../data/conteudo_json.dart';
import 'api_client.dart';
import 'conteudo_repositorio.dart';

/// Conteúdo dos usuários (artigos, comunidades e mensagens) no BANCO DE
/// DADOS, pela API do Ikai (pasta `backend/`, Node + Express + MongoDB).
///
/// É usado quando o app roda com `API_URL` (veja [ApiClient]); sem ela, o app
/// usa [ConteudoLocal]. As telas só conhecem a interface
/// [ConteudoRepositorio], então nada mais muda.
///
/// Quem manda é o servidor: o autor vem do token de login, os limites de
/// tamanho são conferidos lá de novo, e o e-mail dos outros nunca chega aqui.
/// Quando o servidor recusa algo, a mensagem dele vira [ErroDeConteudo] e
/// aparece para a pessoa.
class ConteudoRemoto implements ConteudoRepositorio {
  final ApiClient _api;

  ConteudoRemoto(this._api);

  Future<Object?> _pedir(String metodo, String caminho, {Object? corpo}) async {
    try {
      return await _api.pedir(metodo, caminho, corpo: corpo);
    } on ErroApi catch (e) {
      throw ErroDeConteudo(e.mensagem);
    }
  }

  Future<List<Object?>> _lista(String caminho) async {
    final d = await _pedir('GET', caminho);
    return d is List ? d : const [];
  }

  @override
  Future<List<Artigo>> listarArtigos() async => [
    for (final m in await _lista('/artigos'))
      if (artigoDeMapa(m) != null) artigoDeMapa(m)!,
  ];

  @override
  Future<void> salvarArtigo(Artigo artigo) =>
      _pedir('POST', '/artigos', corpo: artigoParaMapa(artigo));

  /// Capa: bytes novos vão em base64; sem bytes e sem endereço, vai `null`
  /// (remove); só com o endereço antigo, o campo nem vai (mantém).
  @override
  Future<Artigo> editarArtigo(Artigo artigo) async {
    final corpo = artigoParaMapa(artigo)..remove('capaUrl');
    if (artigo.capa == null && artigo.capaUrl == null) corpo['capa'] = null;
    final r = await _pedir('PATCH', '/artigos/${artigo.id}', corpo: corpo);
    // A resposta traz o novo endereço da capa; os bytes já estão aqui.
    final doServidor = artigoDeMapa(r);
    if (doServidor == null) return artigo;
    return Artigo(
      id: doServidor.id,
      objetivoId: doServidor.objetivoId,
      categoriaId: doServidor.categoriaId,
      titulo: doServidor.titulo,
      autor: doServidor.autor,
      resumo: doServidor.resumo,
      nivel: doServidor.nivel,
      tags: doServidor.tags,
      paragrafos: doServidor.paragrafos,
      doUsuario: true,
      autorEmail: artigo.autorEmail,
      criadoEm: doServidor.criadoEm,
      capa: artigo.capa,
      capaUrl: artigo.capa == null ? doServidor.capaUrl : null,
    );
  }

  @override
  Future<void> apagarArtigo(String id) => _pedir('DELETE', '/artigos/$id');

  @override
  Future<List<Comentario>> listarComentarios(String artigoId) async => [
    for (final m in await _lista('/artigos/$artigoId/comentarios'))
      if (Comentario.tentarLer(m) != null) Comentario.tentarLer(m)!,
  ];

  @override
  Future<void> salvarComentario(Comentario c, {String? tituloArtigo}) => _pedir(
    'POST',
    '/artigos/${c.artigoId}/comentarios',
    corpo: {...c.toMap(), 'titulo': ?tituloArtigo},
  );

  @override
  Future<void> apagarComentario(String artigoId, String comentarioId) =>
      _pedir('DELETE', '/artigos/$artigoId/comentarios/$comentarioId');

  @override
  Future<List<Comunidade>> listarComunidades() async => [
    for (final m in await _lista('/comunidades'))
      if (Comunidade.tentarLer(m) != null) Comunidade.tentarLer(m)!,
  ];

  @override
  Future<void> salvarComunidade(Comunidade c) =>
      _pedir('POST', '/comunidades', corpo: c.toMap());

  @override
  Future<void> apagarComunidade(String id) =>
      _pedir('DELETE', '/comunidades/$id');

  @override
  Future<List<PostComunidade>> listarPosts(String comunidadeId) async => [
    for (final m in await _lista('/comunidades/$comunidadeId/posts'))
      if (PostComunidade.tentarLer(m) != null) PostComunidade.tentarLer(m)!,
  ];

  @override
  Future<void> salvarPost(PostComunidade p) =>
      _pedir('POST', '/comunidades/${p.comunidadeId}/posts', corpo: p.toMap());

  @override
  Future<void> apagarPost(String comunidadeId, String postId) =>
      _pedir('DELETE', '/comunidades/$comunidadeId/posts/$postId');

  /// Não faz nada de propósito: com a API, quem apaga tudo o que a pessoa
  /// escreveu é a exclusão da conta (`DELETE /meus-dados`, em AuthService).
  @override
  Future<void> apagarDoAutor(String email) async {}
}
