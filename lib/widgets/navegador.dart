import 'package:flutter/material.dart';

/// Navegador global: o aviso de tempo fica ACIMA do Navigator (no
/// SessaoGuard), então precisa deste atalho para abrir telas.
class NavegadorIk {
  NavegadorIk._();

  static final GlobalKey<NavigatorState> chave = GlobalKey<NavigatorState>();

  /// Abre uma tela por cima da atual.
  static Future<T?>? abrir<T>(Route<T> rota) => chave.currentState?.push(rota);
}
