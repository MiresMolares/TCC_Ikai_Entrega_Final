import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../services/api_client.dart';
import 'estilo.dart';

/// Foto redonda de uma pessoa. Sem foto (ou se ela não carregar), mostra a
/// inicial do nome: a tela nunca quebra por causa da imagem.
class AvatarPessoa extends StatelessWidget {
  final String nome;
  final Uint8List? bytes;

  /// Endereço da foto no servidor (ex.: `/usuarios/<id>/foto?v=...`).
  final String? url;
  final double raio;

  const AvatarPessoa({
    super.key,
    required this.nome,
    this.bytes,
    this.url,
    this.raio = 18,
  });

  Widget _inicial() {
    final t = nome.trim();
    return Container(
      color: Cores.rosado,
      alignment: Alignment.center,
      child: t.isEmpty
          ? Icon(Icons.person_outline, size: raio * 1.1, color: Cores.laranja)
          : Text(
              t.characters.first.toUpperCase(),
              style: TextStyle(
                fontSize: raio * 0.9,
                fontWeight: FontWeight.bold,
                color: Cores.laranja,
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget imagem;
    if (bytes != null) {
      imagem = Image.memory(
        bytes!,
        fit: BoxFit.cover,
        gaplessPlayback: true,
        errorBuilder: (_, _, _) => _inicial(),
      );
    } else if (url != null && ApiClient.instance.ativo) {
      imagem = Image.network(
        ApiClient.instance.url(url!).toString(),
        fit: BoxFit.cover,
        gaplessPlayback: true,
        errorBuilder: (_, _, _) => _inicial(),
      );
    } else {
      imagem = _inicial();
    }
    return Semantics(
      image: true,
      label: 'Foto de $nome',
      child: ClipOval(
        child: SizedBox(width: raio * 2, height: raio * 2, child: imagem),
      ),
    );
  }
}
