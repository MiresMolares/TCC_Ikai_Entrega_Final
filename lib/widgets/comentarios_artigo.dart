import 'package:flutter/material.dart';

import '../data/artigo.dart';
import '../data/comentario.dart';
import '../services/conteudo_usuario.dart';
import 'estilo.dart';

/// Comentários de um artigo, no fim da leitura: a conversa em ordem (do mais
/// antigo para o mais novo), um campo para comentar e a lixeira para quem
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
  List<Comentario>? _lista;
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
    super.dispose();
  }

  Future<void> _carregar() async {
    final l = await _s.comentariosDe(widget.artigo.id);
    if (mounted) setState(() => _lista = List.of(l));
  }

  Future<void> _enviar() async {
    if (_enviando) return;
    setState(() {
      _enviando = true;
      _erro = null;
    });
    final r = await _s.comentar(widget.artigo.id, _texto.text);
    if (!mounted) return;
    setState(() {
      _enviando = false;
      if (r.ok) {
        (_lista ??= []).add(r.valor!);
        _texto.clear();
        FocusScope.of(context).unfocus();
      } else {
        _erro = r.erro;
      }
    });
  }

  Future<void> _apagar(Comentario c) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Apagar comentário?'),
        content: const Text('Ele some para todo mundo.'),
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
      setState(() => _lista?.removeWhere((x) => x.id == c.id));
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

  @override
  Widget build(BuildContext context) {
    final lista = _lista;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          lista == null ? 'Comentários' : 'Comentários (${lista.length})',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Cores.titulo,
          ),
        ),
        const SizedBox(height: 12),
        if (lista == null)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
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
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'Ninguém comentou ainda. Conte o que você achou.',
              style: TextStyle(fontSize: 14, color: Cores.subtitulo),
            ),
          )
        else
          for (final c in lista)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.fromLTRB(14, 10, 4, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Cores.borda),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: _s.euComentei(c) ? 'Você' : c.autorNome,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Cores.titulo,
                                ),
                              ),
                              TextSpan(
                                text: '  ·  ${_quando(c.criadoMs)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Cores.subtitulo,
                                ),
                              ),
                            ],
                          ),
                          style: const TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          c.texto,
                          style: const TextStyle(
                            fontSize: 14.5,
                            height: 1.45,
                            color: Cores.titulo,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_s.podeApagarComentario(c, widget.artigo))
                    IconButton(
                      tooltip: 'Apagar comentário',
                      onPressed: () => _apagar(c),
                      icon: const Icon(
                        Icons.delete_outline,
                        size: 20,
                        color: Cores.subtitulo,
                      ),
                    ),
                ],
              ),
            ),
        const SizedBox(height: 6),
        TextField(
          controller: _texto,
          minLines: 1,
          maxLines: 4,
          maxLength: ConteudoUsuarioService.comentarioMax,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: 'Escreva um comentário',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            suffixIcon: IconButton(
              tooltip: 'Enviar comentário',
              onPressed: _enviando ? null : _enviar,
              icon: _enviando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send_rounded, color: Cores.laranja),
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
