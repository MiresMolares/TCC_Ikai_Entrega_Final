import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_client.dart';
import 'biblioteca_service.dart';
import 'progresso_service.dart';
import 'tempo_diario.dart';

/// Guarda no servidor uma cópia da biblioteca, do progresso e do tempo de
/// uso da conta (rota `/meus-dados-app`). Assim, ao entrar em outro
/// aparelho ou navegador, a pessoa encontra tudo como deixou.
///
/// - Ao entrar: baixa a cópia e grava no aparelho ANTES de os serviços
///   lerem (eles continuam lendo do aparelho, como sempre).
/// - Enquanto usa: no máximo uma vez a cada [intervalo], envia o que mudou.
/// - Ao sair: envia uma última vez.
///
/// Sem servidor, não faz nada (tudo continua só no aparelho).
class SincronizacaoService {
  SincronizacaoService._(this._api);
  static final SincronizacaoService instance = SincronizacaoService._(
    ApiClient.instance,
  );

  @visibleForTesting
  SincronizacaoService.paraTeste(this._api);

  final ApiClient _api;

  static const Duration intervalo = Duration(seconds: 30);

  /// Mesmas chaves que os serviços usam no aparelho.
  static String chaveBiblioteca(String e) => 'biblioteca_v1_${e.toLowerCase()}';
  static String chaveProgresso(String e) => 'progresso_v1_${e.toLowerCase()}';
  static String chaveTempo(String e) => 'tempo_v1_${e.toLowerCase()}';

  String? _email;
  Timer? _agendado;
  String? _ultimoEnviado;

  bool get ativo => _api.ativo && _api.token != null;

  /// Baixa a cópia do servidor e grava no aparelho. Chame antes dos
  /// `carregarPara` dos serviços.
  Future<void> baixar(String email) async {
    if (!ativo) return;
    try {
      final d = await _api.pedir('GET', '/meus-dados-app');
      if (d is! Map) return;
      final p = await SharedPreferences.getInstance();
      Future<void> gravar(String campo, String chave) async {
        final v = d[campo];
        if (v is String && v.length >= 2) await p.setString(chave, v);
      }

      await gravar('biblioteca', chaveBiblioteca(email));
      await gravar('progresso', chaveProgresso(email));
      await gravar('tempo', chaveTempo(email));
    } on ErroApi {
      // Sem rede: fica com o que já está no aparelho.
    } catch (_) {}
  }

  /// Começa a acompanhar as mudanças da conta [email].
  void acompanhar(String email) {
    if (!_api.ativo) return;
    parar(enviar: false);
    _email = email;
    _ultimoEnviado = _pacote();
    BibliotecaService.instance.addListener(_agendar);
    ProgressoService.instance.addListener(_agendar);
    TempoDiarioService.instance.addListener(_agendar);
  }

  void _agendar() {
    if (_email == null || _agendado != null) return;
    _agendado = Timer(intervalo, () {
      _agendado = null;
      enviar();
    });
  }

  String _pacote() =>
      '${BibliotecaService.instance.exportarJson()}\n'
      '${ProgressoService.instance.exportarJson()}\n'
      '${TempoDiarioService.instance.exportarJson()}';

  /// Envia agora (se algo mudou desde o último envio).
  Future<void> enviar() async {
    if (_email == null || !ativo) return;
    final pacote = _pacote();
    if (pacote == _ultimoEnviado) return;
    final corpo = {
      'biblioteca': BibliotecaService.instance.exportarJson(),
      'progresso': ProgressoService.instance.exportarJson(),
      'tempo': TempoDiarioService.instance.exportarJson(),
    };
    try {
      // O token é lido aqui, antes de qualquer espera: mesmo que a pessoa
      // saia logo depois, o envio é da conta certa.
      await _api.pedir('PUT', '/meus-dados-app', corpo: corpo);
      _ultimoEnviado = pacote;
    } on ErroApi {
      // Tenta de novo na próxima mudança.
    }
  }

  /// Para de acompanhar. Com [enviar], manda o estado atual antes.
  void parar({bool enviar = true}) {
    _agendado?.cancel();
    _agendado = null;
    if (enviar && _email != null) unawaited(this.enviar());
    BibliotecaService.instance.removeListener(_agendar);
    ProgressoService.instance.removeListener(_agendar);
    TempoDiarioService.instance.removeListener(_agendar);
    _email = null;
  }
}
