import 'dart:async';

import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/tempo_diario.dart';
import '../widgets/estilo.dart';
import 'tela_fim_do_dia.dart';

/// Fica ACIMA do Navigator (ver MaterialApp.builder em main.dart).
///
/// Cuida de três coisas ligadas ao tempo do dia:
///  1. Conta o tempo só com o app à frente (pausa em segundo plano).
///  2. Mostra os avisos (metade da meta, lembrete de foco) sem bloquear nada.
///  3. Quando a meta acaba, troca o app pela tela de fim de tempo
///     ([TelaFimDoDia]); quando a pessoa encerra o dia, por [TelaEncerrado].
///
/// Como está acima do Navigator, não há Overlay nem Navigator aqui: os
/// widgets daqui só usam Material, nunca Tooltip, diálogo ou menu.
class SessaoGuard extends StatefulWidget {
  final Widget child;

  const SessaoGuard({super.key, required this.child});

  @override
  State<SessaoGuard> createState() => _SessaoGuardState();
}

class _SessaoGuardState extends State<SessaoGuard> with WidgetsBindingObserver {
  final TempoDiarioService _t = TempoDiarioService.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Em segundo plano o tempo não conta; ao voltar, a contagem retoma.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (AuthService.instance.logado && _t.metaDefinida) {
        _t.iniciarContagem();
      }
    } else {
      _t.pausarContagem();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_t, AuthService.instance]),
      builder: (context, _) {
        if (AuthService.instance.logado) {
          // O Navigator sai da árvore: nenhuma tela, diálogo ou menu aberto
          // sobrevive ao fim do tempo, e ele volta do zero depois.
          if (_t.fase == FaseDoDia.fimDeTempo) {
            return const TelaFimDoDia();
          }
          if (_t.fase == FaseDoDia.encerrado) {
            return const TelaEncerrado();
          }
        }

        final logado = AuthService.instance.logado;
        final aviso = logado ? _t.aviso : null;

        return Stack(
          children: [
            Positioned.fill(child: widget.child),
            if (aviso != null)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _BannerAviso(
                  key: ValueKey('${aviso.tipo}-${aviso.texto}'),
                  aviso: aviso,
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Aviso de tempo no topo da tela: some sozinho depois de alguns segundos,
/// e a pessoa pode dispensar. Nunca bloqueia o app.
class _BannerAviso extends StatefulWidget {
  final AvisoTempo aviso;

  const _BannerAviso({super.key, required this.aviso});

  @override
  State<_BannerAviso> createState() => _BannerAvisoState();
}

class _BannerAvisoState extends State<_BannerAviso> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 20), _dispensar);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _dispensar() => TempoDiarioService.instance.consumirAviso();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
        child: Material(
          color: Cores.faixaAviso,
          elevation: 8,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.schedule, color: Colors.white),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.aviso.texto,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _dispensar,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Entendi'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
