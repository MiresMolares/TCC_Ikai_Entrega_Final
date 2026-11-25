import 'package:flutter/material.dart';

import '../data/artigo.dart';
import '../data/comentario.dart';
import '../services/conteudo_usuario.dart';
import '../services/foto_perfil_service.dart';
import 'avatar_pessoa.dart';
import 'estilo.dart';

/// Comentários de um artigo, no fim da leitura: a conversa em ordem (do mais
/// antigo para o mais novo), com as respostas logo abaixo de cada
/// comentário, um campo para comentar ou responder e a lixeira para quem
/// pode apagar (quem comentou, ou quem escreveu o artigo).
class ComentariosArtigo extends StatefulWidget {
  final Artigo artigo;

  const ComentariosArtigo({super.key, required this.artigo});

  @override
  State<ComentariosArtigo> createState() => _ComentariosArtigoState();
}

class _ComentariosArtigoState extends State<ComentariosArtigo> {
  final ConteudoUsuarioService _s = ConteudoUsuarioService.instance;
  final TextEditingController _texto = TextEditingController();
  final FocusNode _foco = FocusNode();
  List<Comentario>? _lista;
  Comentario? _respondendo;
  bool _enviando = false;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  @override
  void dispose() {
    _texto.dispose();
    _foco.dispose();
    super.dispose();
  }

  Future<void> _carregar() async {
    final l = await _s.comentariosDe(widget.artigo.id);
    if (mounted) setState(() => _lista = List.of(l));
  }

  void _responder(Comentario c) {
    setState(() {
      _respondendo = c;
      _erro = null;
    });
    _foco.requestFocus();
  }

  Future<void> _enviar() async {
    if (_enviando) return;
    setState(() {
      _enviando = true;
      _erro = null;
    });
    final r = await _s.comentar(
      widget.artigo.id,
      _texto.text,
      respostaA: _respondendo,
      tituloArtigo: widget.artigo.titulo,
    );
    if (!mounted) return;
    setState(() {
      _enviando = false;
      if (r.ok) {
        (_lista ??= []).add(r.valor!);
        _texto.clear();
        _respondendo = null;
        FocusScope.of(context).unfocus();
      } else {
        _erro = r.erro;
      }
    });
  }

  Future<void> _apagar(Comentario c) async {
    final temRespostas = _lista?.any((x) => x.respostaA == c.id) ?? false;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Apagar comentário?'),
        content: Text(
          temRespostas
              ? 'Ele e as respostas a ele somem para todo mundo.'
              : 'Ele some para todo mundo.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Apagar'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    final apagou = await _s.apagarComentario(c, widget.artigo);
    if (!mounted) return;
    if (apagou) {
      setState(() {
        _lista?.removeWhere((x) => x.id == c.id || x.respostaA == c.id);
        if (_respondendo?.id == c.id) _respondendo = null;
      });
    } else {
      mostrarAviso(context, 'Não foi possível apagar agora.');
    }
  }

  static String _quando(int ms) {
    final d = DateTime.fromMillisecondsSinceEpoch(ms);
    String dois(int n) => n.toString().padLeft(2, '0');
    return '${dois(d.day)}/${dois(d.month)}/${d.year} às '
        '${dois(d.hour)}:${dois(d.minute)}';
  }

  Widget _avatar(Comentario c, double raio) {
    if (_s.euComentei(c)) {
      final f = FotoPerfilService.instance;
      return AvatarPessoa(
        nome: c.autorNome,
        bytes: f.bytes,
        url: f.url ?? c.foto,
        raio: raio,
      );
    }
    return AvatarPessoa(nome: c.autorNome, url: c.foto, raio: raio);
  }

  Widget _comentario(Comentario c, {required bool resposta}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10, left: resposta ? 40 : 0),
      padding: const EdgeInsets.fromLTRB(12, 10, 4, 4),
      decoration: BoxDecoration(
        color: resposta ? Cores.fundoEtapas : Cores.cartao,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Cores.borda),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: _avatar(c, resposta ? 14 : 17),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: _s.euComentei(c) ? 'Você' : c.autorNome,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Cores.titulo,
                        ),
                      ),
                      TextSpan(
                        text: '  ·  ${_quando(c.criadoMs)}',
                        style: TextStyle(fontSize: 12, color: Cores.subtitulo),
                      ),
                    ],
                  ),
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  c.texto,
                  style: TextStyle(
                    fontSize: 14.5,
                    height: 1.45,
                    color: Cores.titulo,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => _responder(c),
                    icon: const Icon(Icons.reply_rounded, size: 18),
                    label: const Text('Responder'),
                    style: TextButton.styleFrom(
                      foregroundColor: Cores.subtitulo,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      minimumSize: const Size(0, 34),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_s.podeApagarComentario(c, widget.artigo))
            IconButton(
              tooltip: 'Apagar comentário',
              onPressed: () => _apagar(c),
              icon: Icon(
                Icons.delete_outline,
                size: 20,
                color: Cores.subtitulo,
              ),
            ),
        ],
      ),
    );
  }

  /// Comentários principais, cada um seguido das respostas a ele. Uma
  /// resposta cujo comentário sumiu aparece como principal.
  List<Widget> _conversa(List<Comentario> lista) {
    final ids = {for (final c in lista) c.id};
    final principais = [
      for (final c in lista)
        if (c.respostaA == null || !ids.contains(c.respostaA)) c,
    ];
    return [
      for (final p in principais) ...[
        _comentario(p, resposta: false),
        for (final r in lista)
          if (r.respostaA == p.id) _comentario(r, resposta: true),
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    final lista = _lista;
    final respondendo = _respondendo;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          lista == null ? 'Comentários' : 'Comentários (${lista.length})',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Cores.titulo,
          ),
        ),
        const SizedBox(height: 12),
        if (lista == null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Cores.laranja,
                ),
              ),
            ),
          )
        else if (lista.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Ninguém comentou ainda. Conte o que você achou.',
              style: TextStyle(fontSize: 14, color: Cores.subtitulo),
            ),
          )
        else
          ..._conversa(lista),
        const SizedBox(height: 6),
        if (respondendo != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Icon(Icons.reply_rounded, size: 18, color: Cores.verde),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Respondendo a '
                    '${_s.euComentei(respondendo) ? 'você' : respondendo.autorNome}',
                    style: TextStyle(fontSize: 13, color: Cores.verde),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => _respondendo = null),
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ),
        TextField(
          controller: _texto,
          focusNode: _foco,
          minLines: 1,
          maxLines: 4,
          maxLength: ConteudoUsuarioService.comentarioMax,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: respondendo == null
                ? 'Escreva um comentário'
                : 'Escreva sua resposta',
            filled: true,
            fillColor: Cores.cartao,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            suffixIcon: IconButton(
              tooltip: respondendo == null
                  ? 'Enviar comentário'
                  : 'Enviar resposta',
              onPressed: _enviando ? null : _enviar,
              icon: _enviando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(Icons.send_rounded, color: Cores.laranja),
            ),
          ),
        ),
        if (_erro != null)
          Text(
            _erro!,
            style: TextStyle(fontSize: 13, color: Colors.red.shade700),
          ),
      ],
    );
  }
}
