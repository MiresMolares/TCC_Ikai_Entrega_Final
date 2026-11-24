import 'package:flutter/material.dart';

import '../data/artigo.dart';
import '../pages_home/artigo_page.dart';
import '../services/biblioteca_service.dart';
import '../services/progresso_service.dart';
import 'capa_artigo.dart';
import 'estilo.dart';
import 'salvar_em_pasta.dart';

/// Cartão de artigo usado no feed, na busca, na biblioteca e nas comunidades.
///
/// A capa segue o jeito do Substack: nas listas ela é uma miniatura quadrada
/// à direita do título; com [destaque], vira uma imagem larga no topo do
/// cartão. Artigo sem capa mostra só o texto, sem espaço vazio.
class ArtigoCard extends StatelessWidget {
  final Artigo artigo;
  final bool destaque;

  const ArtigoCard({super.key, required this.artigo, this.destaque = false});

  static const double ladoMiniatura = 76;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        BibliotecaService.instance,
        ProgressoService.instance,
      ]),
      builder: (context, _) {
        final salvo = BibliotecaService.instance.estaSalvo(artigo.id);
        final lido = ProgressoService.instance.foiLido(artigo.id);
        final capaGrande = destaque && artigo.temCapa;
        final miniatura = !destaque && artigo.temCapa;

        return Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => abrirArtigo(context, artigo),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Cores.borda),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (capaGrande)
                    AspectRatio(
                      aspectRatio: proporcaoCapa,
                      child: CapaArtigo(artigo: artigo, raio: 0),
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 6, 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                artigo.titulo,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Cores.titulo,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${artigo.doUsuario ? '${artigo.autor} (leitor)' : artigo.autor}  ·  ${artigo.minutosLeitura} min  ·  ${Artigo.nomeDoNivel(artigo.nivel)}'
                                '${lido ? '  ·  Lido' : ''}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Cores.subtitulo,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                artigo.resumo,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.4,
                                  color: Cores.titulo,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: [
                                  for (final t in artigo.tags.take(3))
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Cores.verdeClaro,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        t,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Cores.verde,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (miniatura) ...[
                          const SizedBox(width: 12),
                          SizedBox(
                            width: ladoMiniatura,
                            height: ladoMiniatura,
                            child: CapaArtigo(artigo: artigo, raio: 10),
                          ),
                        ],
                        IconButton(
                          tooltip: salvo ? 'Salvo na biblioteca' : 'Salvar',
                          onPressed: () =>
                              mostrarSalvarEmPasta(context, artigo),
                          icon: Icon(
                            salvo ? Icons.bookmark : Icons.bookmark_border,
                            color: salvo ? Cores.laranja : Cores.subtitulo,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Lista de cartões com espaçamento. Usada por todas as telas.
class ListaDeArtigos extends StatelessWidget {
  final List<Artigo> artigos;

  const ListaDeArtigos({super.key, required this.artigos});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final a in artigos)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ArtigoCard(artigo: a),
          ),
      ],
    );
  }
}
