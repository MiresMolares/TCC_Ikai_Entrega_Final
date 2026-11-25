import 'dart:convert';

/// A escolha do dia (objetivos, categorias, foco), gravada para que
/// fechar o app não obrigue a repetir tudo. Vale só no dia em que foi feita:
/// no dia seguinte a pessoa escolhe de novo (o feed é finito por escolha).
/// Dart puro.
class SelecaoSalva {
  /// O primeiro objetivo (formato antigo, com um só).
  final String objetivoId;

  /// Todos os objetivos escolhidos (até 2). Sem eles, vale [objetivoId].
  final List<String>? _objetivoIds;
  List<String> get objetivoIds {
    final os = _objetivoIds;
    return (os == null || os.isEmpty) ? [objetivoId] : os;
  }

  final List<String> categoriaIds;
  final int focoMin;

  /// 'aaaa-mm-dd' do dia em que a escolha foi feita.
  final String dia;

  const SelecaoSalva({
    required this.objetivoId,
    List<String>? objetivoIds,
    required this.categoriaIds,
    required this.focoMin,
    required this.dia,
  }) : _objetivoIds = objetivoIds;

  /// "Passar o tempo" não tem categorias.
  static const String idLivre = 'passar_tempo';

  String toJson() => jsonEncode({
    'o': objetivoId,
    'os': objetivoIds,
    'c': categoriaIds,
    'f': focoMin,
    'd': dia,
  });

  /// Devolve null se o texto gravado for inválido (nunca lança).
  static SelecaoSalva? tentarLer(String? texto) {
    if (texto == null || texto.isEmpty) return null;
    try {
      final m = jsonDecode(texto);
      if (m is! Map) return null;
      final o = m['o'];
      final c = m['c'];
      final f = m['f'];
      final d = m['d'];
      if (o is! String || c is! List) return null;
      if (f is! int || d is! String) return null;
      final ids = c.whereType<String>().toList();
      final os = m['os'] is List
          ? (m['os'] as List).whereType<String>().toList()
          : <String>[o];
      // Sem categoria só vale para "Passar o tempo".
      if (ids.isEmpty && !os.contains(idLivre)) return null;
      return SelecaoSalva(
        objetivoId: o,
        objetivoIds: os,
        categoriaIds: ids,
        focoMin: f,
        dia: d,
      );
    } catch (_) {
      return null;
    }
  }
}
