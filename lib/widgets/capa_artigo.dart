import 'package:flutter/material.dart';

import '../data/artigo.dart';
import '../services/api_client.dart';
import 'estilo.dart';

/// Proporção da capa na leitura e no cartão em destaque (larga, como no
/// Substack). Nas listas ela vira uma miniatura quadrada, sempre cortada no
/// centro: por isso a dica ao escrever é "deixe o principal no meio".
const double proporcaoCapa = 16 / 9;

/// A imagem de capa de um artigo, recortada para caber em [largura] x
/// [altura] (BoxFit.cover). Usa os bytes quando o artigo foi escrito neste
/// aparelho, ou o endereço do servidor quando veio da API. Se a imagem não
/// carregar, mostra um fundo neutro: a tela nunca quebra por causa da capa.
class CapaArtigo extends StatelessWidget {
  final Artigo artigo;
  final double raio;
  final String rotuloSemantico;

  const CapaArtigo({
    super.key,
    required this.artigo,
    this.raio = 12,
    this.rotuloSemantico = 'Imagem de capa do artigo',
  });

  Widget _reserva() => Container(
    color: Cores.verdeClaro,
    alignment: Alignment.center,
    child: const Icon(Icons.image_outlined, color: Cores.verde),
  );

  @override
  Widget build(BuildContext context) {
    final Widget imagem;
    if (artigo.capa != null) {
      imagem = Image.memory(
        artigo.capa!,
        fit: BoxFit.cover,
        gaplessPlayback: true,
        errorBuilder: (_, _, _) => _reserva(),
      );
    } else if (artigo.capaUrl != null && ApiClient.instance.ativo) {
      imagem = Image.network(
        ApiClient.instance.url(artigo.capaUrl!).toString(),
        fit: BoxFit.cover,
        gaplessPlayback: true,
        errorBuilder: (_, _, _) => _reserva(),
        loadingBuilder: (context, filho, progresso) =>
            progresso == null ? filho : Container(color: Cores.verdeClaro),
      );
    } else {
      imagem = _reserva();
    }
    return Semantics(
      image: true,
      label: rotuloSemantico,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(raio),
        child: SizedBox.expand(child: imagem),
      ),
    );
  }
}
