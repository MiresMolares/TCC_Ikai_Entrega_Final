import 'package:flutter/material.dart';

import '../core/senha.dart';
import '../widgets/estilo.dart';

/// Lista das regras de senha forte, marcando as que a senha digitada já
/// cumpre. Atualiza a cada letra.
class RequisitosSenha extends StatelessWidget {
  final TextEditingController controller;

  const RequisitosSenha({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, valor, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final r in Senha.regras)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Icon(
                    r.cumpre(valor.text)
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    size: 18,
                    color: r.cumpre(valor.text) ? Cores.verde : Cores.subtitulo,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      r.descricao,
                      style: TextStyle(
                        fontSize: 13,
                        color: r.cumpre(valor.text)
                            ? Cores.verde
                            : Cores.subtitulo,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
