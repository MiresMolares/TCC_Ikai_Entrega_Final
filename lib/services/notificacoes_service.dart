import 'package:flutter/foundation.dart';

import 'api_client.dart';

/// Uma notificação da caixa (comentário no seu artigo, resposta a um
/// comentário seu...).
class Notificacao {
  final String id;
  final String tipo;
  final String titulo;
  final String descricao;
  final DateTime criadaEm;
  final bool lida;

  /// Artigo ligado à notificação (para abrir ao tocar), se houver.
  final String? artigoId;

  const Notificacao({
    required this.id,
    required this.tipo,
    required this.titulo,
    required this.descricao,
    required this.criadaEm,
    required this.lida,
    this.artigoId,
  });

  Notificacao lidaAgora() => Notificacao(
    id: id,
    tipo: tipo,
    titulo: titulo,
    descricao: descricao,
    criadaEm: criadaEm,
    lida: true,
    artigoId: artigoId,
  );

  /// Devolve null se o mapa vier incompleto (nunca lança).
  static Notificacao? tentarLer(Object? m) {
    if (m is! Map) return null;
    final id = m['id'], tipo = m['tipo'], titulo = m['titulo'];
    final quando = DateTime.tryParse('${m['criadaEm']}');
    if (id is! String || tipo is! String || titulo is! String) return null;
    if (quando == null) return null;
    final artigo = m['artigo'];
    return Notificacao(
      id: id,
      tipo: tipo,
      titulo: titulo,
      descricao: (m['descricao'] ?? '').toString(),
      criadaEm: quando.toLocal(),
      lida: m['lida'] == true,
      artigoId: artigo is String && artigo.isNotEmpty ? artigo : null,
    );
  }
}

/// A caixa de notificações, que vem do servidor (sem a API não há outras
/// pessoas, então a caixa fica vazia).
///
/// Não existe atualização em tempo real nem alerta insistente: a caixa é
/// lida ao entrar, ao voltar para a Home e ao abrir o sino.
class NotificacoesService extends ChangeNotifier {
  NotificacoesService._(this._api);
  static final NotificacoesService instance = NotificacoesService._(
    ApiClient.instance,
  );

  @visibleForTesting
  NotificacoesService.paraTeste(this._api);

  final ApiClient _api;

  List<Notificacao> _itens = const [];
  int _naoLidas = 0;
  bool _carregando = false;
  String? _erro;

  List<Notificacao> get itens => _itens;
  int get naoLidas => _naoLidas;
  bool get carregando => _carregando;

  /// Mensagem de erro da última leitura (null se deu certo).
  String? get erro => _erro;

  bool get disponivel => _api.ativo;

  Future<void> atualizar() async {
    if (!_api.ativo || _api.token == null || _carregando) return;
    _carregando = true;
    notifyListeners();
    try {
      final d = await _api.pedir('GET', '/notificacoes?limite=50');
      if (d is Map) {
        final lista = d['itens'];
        _itens = [
          if (lista is List)
            for (final m in lista)
              if (Notificacao.tentarLer(m) != null) Notificacao.tentarLer(m)!,
        ];
        final n = d['naoLidas'];
        _naoLidas = n is int ? n : _itens.where((x) => !x.lida).length;
      }
      _erro = null;
    } on ErroApi catch (e) {
      _erro = e.mensagem;
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  Future<void> marcarLida(Notificacao n) async {
    if (n.lida) return;
    _itens = [for (final x in _itens) x.id == n.id ? x.lidaAgora() : x];
    if (_naoLidas > 0) _naoLidas--;
    notifyListeners();
    try {
      await _api.pedir('PATCH', '/notificacoes/${n.id}', corpo: {'lida': true});
    } on ErroApi {
      // Fica marcada aqui; na próxima leitura o servidor corrige.
    }
  }

  Future<void> lerTodas() async {
    if (_naoLidas == 0) return;
    _itens = [for (final x in _itens) x.lidaAgora()];
    _naoLidas = 0;
    notifyListeners();
    try {
      await _api.pedir('POST', '/notificacoes/ler-todas');
    } on ErroApi {
      // Idem.
    }
  }

  Future<bool> apagar(Notificacao n) async {
    try {
      await _api.pedir('DELETE', '/notificacoes/${n.id}');
    } on ErroApi {
      return false;
    }
    _itens = [
      for (final x in _itens)
        if (x.id != n.id) x,
    ];
    if (!n.lida && _naoLidas > 0) _naoLidas--;
    notifyListeners();
    return true;
  }

  void limpar() {
    _itens = const [];
    _naoLidas = 0;
    _erro = null;
    notifyListeners();
  }
}
