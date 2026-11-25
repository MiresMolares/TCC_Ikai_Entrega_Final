import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/estilo.dart';

/// Logo no topo das telas de login. Mostra o nome se a imagem faltar.
class LogoIkai extends StatelessWidget {
  final double altura;
  const LogoIkai({super.key, this.altura = 100});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/ikai.png',
      height: altura,
      fit: BoxFit.contain,
      errorBuilder: (context, erro, pilha) => SizedBox(
        height: altura,
        child: Center(
          child: Text(
            'Ikai',
            style: GoogleFonts.inter(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Cores.laranja,
            ),
          ),
        ),
      ),
    );
  }
}

/// Campo de texto padrão das telas de login.
class CampoLogin extends StatelessWidget {
  final TextEditingController controller;
  final String rotulo;
  final IconData icone;
  final String? dica;
  final bool senha;
  final bool esconder;
  final VoidCallback? aoAlternarVisibilidade;
  final TextInputType? teclado;
  final TextInputAction? acao;
  final VoidCallback? aoEnviar;

  const CampoLogin({
    super.key,
    required this.controller,
    required this.rotulo,
    required this.icone,
    this.dica,
    this.senha = false,
    this.esconder = false,
    this.aoAlternarVisibilidade,
    this.teclado,
    this.acao,
    this.aoEnviar,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: senha && esconder,
      keyboardType: teclado,
      textInputAction: acao,
      onSubmitted: aoEnviar == null ? null : (_) => aoEnviar!(),
      autocorrect: !senha,
      enableSuggestions: !senha,
      decoration: InputDecoration(
        labelText: rotulo,
        labelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold),
        hintText: dica,
        prefixIcon: Icon(icone),
        suffixIcon: senha
            ? IconButton(
                tooltip: esconder ? 'Mostrar senha' : 'Ocultar senha',
                onPressed: aoAlternarVisibilidade,
                icon: Icon(esconder ? Icons.visibility : Icons.visibility_off),
              )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

/// Botão principal (terracota).
class BotaoPrincipal extends StatelessWidget {
  final String texto;
  final VoidCallback? onPressed;
  const BotaoPrincipal({super.key, required this.texto, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Cores.laranja,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: Colors.black38,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: Color(0xFF4B86ED), width: 1.5),
          ),
        ),
        child: Text(
          texto,
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
