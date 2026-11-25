import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/artigo.dart';
import '../services/biblioteca_service.dart';
import '../services/progresso_service.dart';
import '../widgets/capa_artigo.dart';
import '../widgets/comentarios_artigo.dart';
import '../widgets/estilo.dart';
import '../widgets/salvar_em_pasta.dart';

void abrirArtigo(BuildContext context, Artigo artigo) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ArtigoPage(artigo: artigo)),
  );
}

/// Largura máxima do texto: linhas longas demais cansam a leitura.
const double larguraLeitura = 720;

/// Leitura de um artigo. O texto fica numa "folha" com fundo próprio, como
/// numa página impressa, separada do fundo do app. O Ikai nunca marca como
/// lido sozinho: quem decide que terminou é a pessoa, em "Concluir leitura".
class ArtigoPage extends StatelessWidget {
  final Artigo artigo;

  const ArtigoPage({super.key, required this.artigo});

  Future<void> _concluir(BuildContext context) async {
    final primeira = await ProgressoService.instance.registrarLeitura(artigo);
    if (!context.mounted) return;
    mostrarAviso(
      context,
      primeira
          ? 'Leitura registrada no seu progresso.'
          : 'Você já tinha concluído este artigo.',
    );
  }

  Widget _folha(BuildContext context) {
    final larga = MediaQuery.sizeOf(context).width > 600;
    return Container(
      padding: EdgeInsets.fromLTRB(
        larga ? 40 : 20,
        larga ? 36 : 24,
        larga ? 40 : 20,
        larga ? 36 : 24,
      ),
      decoration: BoxDecoration(
        color: Cores.folha,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Cores.bordaQuente),
        boxShadow: Cores.escuro
            ? null
            : const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 18,
                  offset: Offset(0, 6),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            artigo.titulo,
            style: GoogleFonts.lora(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.25,
              color: Cores.titulo,
            ),
          ),
          // Como no Substack: título, subtítulo (o resumo), autor e, logo
          // abaixo, a capa larga antes do texto.
          const SizedBox(height: 10),
          Text(
            artigo.resumo,
            style: TextStyle(
              fontSize: 17,
              height: 1.45,
              color: Cores.subtitulo,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            '${artigo.doUsuario ? '${artigo.autor} (leitor)' : artigo.autor}'
            '  ·  ${artigo.minutosLeitura} min de leitura',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Cores.verde,
            ),
          ),
          const SizedBox(height: 18),
          Divider(height: 1, color: Cores.bordaQuente),
          if (artigo.temCapa) ...[
            const SizedBox(height: 20),
            AspectRatio(
              aspectRatio: proporcaoCapa,
              child: CapaArtigo(artigo: artigo),
            ),
          ],
          const SizedBox(height: 22),
          for (final p in artigo.paragrafos)
            Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Text(
                p,
                style: GoogleFonts.lora(
                  fontSize: 17.5,
                  height: 1.75,
                  color: Cores.textoLeitura,
                ),
              ),
            ),
          if (artigo.tags.isNotEmpty) ...[
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final t in artigo.tags)
                  Chip(
                    label: Text(
                      t,
                      style: TextStyle(fontSize: 12, color: Cores.verde),
                    ),
                    backgroundColor: Cores.verdeClaro,
                    side: BorderSide.none,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.fundoLeitura,
      appBar: AppBar(
        backgroundColor: Cores.fundoLeitura,
        actions: [
          ListenableBuilder(
            listenable: BibliotecaService.instance,
            builder: (context, _) {
              final salvo = BibliotecaService.instance.estaSalvo(artigo.id);
              return IconButton(
                tooltip: salvo ? 'Salvo na biblioteca' : 'Salvar',
                onPressed: () => mostrarSalvarEmPasta(context, artigo),
                icon: Icon(
                  salvo ? Icons.bookmark : Icons.bookmark_border,
                  color: salvo ? Cores.laranja : Cores.titulo,
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(14, 4, 14, 28),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: larguraLeitura),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _folha(context),
                    const SizedBox(height: 20),
                    ListenableBuilder(
                      listenable: ProgressoService.instance,
                      builder: (context, _) {
                        final lido = ProgressoService.instance.foiLido(
                          artigo.id,
                        );
                        return SizedBox(
                          height: 54,
                          child: ElevatedButton.icon(
                            onPressed: lido ? null : () => _concluir(context),
                            icon: Icon(lido ? Icons.check_circle : Icons.check),
                            label: Text(
                              lido ? 'Leitura concluída' : 'Concluir leitura',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Cores.laranja,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Cores.verdeClaro,
                              disabledForegroundColor: Cores.verde,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 28),
                    ComentariosArtigo(artigo: artigo),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
