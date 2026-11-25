import 'dart:async';

import 'package:flutter/material.dart';

import '../pages_configurar/confirmar_entrada.dart';
import '../services/auth_service.dart';
import '../services/sessao_usuario.dart';
import '../widgets/estilo.dart';
import 'login.dart';

/// Tela de abertura com a logo. Se a pessoa marcou "Lembrar de mim", entra
/// sozinha (ainda passando pela pergunta "quer entrar agora?"); senão, segue
/// para o login.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _seguir();
  }

  Future<void> _seguir() async {
    // A logo aparece por pelo menos 2 s enquanto o login guardado é conferido.
    final espera = Future<void>.delayed(const Duration(seconds: 2));
    final entrou = await AuthService.instance.restaurarSessao();
    if (entrou) await SessaoUsuario.aoEntrar();
    await espera;
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            entrou ? const ConfirmarEntradaPage() : const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.bege,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Image.asset(
            'assets/ikai.png',
            height: 350,
            fit: BoxFit.contain,
            errorBuilder: (context, erro, pilha) => Text(
              'Ikai',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Cores.laranja,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
