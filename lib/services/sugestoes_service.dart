import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show IconData, Icons;

import 'api_client.dart';

/// Uma sugestão para o fim do tempo: o que fazer longe da tela e como.
class Sugestao {
  final String id;

  /// meditacao, leitura, movimento, descanso, estudo, criatividade,
  /// conexao ou natureza.
  final String tipo;
  final String titulo;
  final String como;
  final int minutos;

  /// Para quem combina (vazio = todos). 'passar_tempo' = "Passar o tempo".
  final List<String> objetivos;

  const Sugestao({
    required this.id,
    required this.tipo,
    required this.titulo,
    required this.como,
    required this.minutos,
    this.objetivos = const [],
  });

  static const Map<String, String> nomesDosTipos = {
    'meditacao': 'Meditação',
    'leitura': 'Leitura',
    'movimento': 'Movimento',
    'descanso': 'Descanso',
    'estudo': 'Estudo',
    'criatividade': 'Criatividade',
    'conexao': 'Conexão',
    'natureza': 'Natureza',
  };

  String get nomeDoTipo => nomesDosTipos[tipo] ?? 'Ideia';

  IconData get icone => switch (tipo) {
    'meditacao' => Icons.self_improvement,
    'leitura' => Icons.menu_book_outlined,
    'movimento' => Icons.directions_walk,
    'descanso' => Icons.local_cafe_outlined,
    'estudo' => Icons.edit_note,
    'criatividade' => Icons.palette_outlined,
    'conexao' => Icons.people_outline,
    'natureza' => Icons.park_outlined,
    _ => Icons.lightbulb_outline,
  };

  bool combinaCom(Set<String> objetivosDaPessoa) =>
      objetivos.isEmpty ||
      objetivosDaPessoa.isEmpty ||
      objetivos.any(objetivosDaPessoa.contains);

  static Sugestao? tentarLer(Object? m) {
    if (m is! Map) return null;
    final id = m['id'], tipo = m['tipo'], titulo = m['titulo'];
    final como = m['como'], minutos = m['minutos'];
    if (id is! String || tipo is! String || titulo is! String) return null;
    if (como is! String || minutos is! int) return null;
    final objs = m['objetivos'];
    return Sugestao(
      id: id,
      tipo: tipo,
      titulo: titulo,
      como: como,
      minutos: minutos,
      objetivos: objs is List ? objs.whereType<String>().toList() : const [],
    );
  }
}

/// Banco de sugestões. Com o servidor, vem da coleção `sugestoes`
/// (backend/src/sugestoes.js); sem ele, usa uma lista pequena do app.
class SugestoesService {
  SugestoesService._(this._api);
  static final SugestoesService instance = SugestoesService._(
    ApiClient.instance,
  );

  @visibleForTesting
  SugestoesService.paraTeste(this._api);

  final ApiClient _api;
  List<Sugestao>? _doServidor;

  /// Busca no servidor uma vez por sessão (se falhar, usa a lista do app).
  Future<List<Sugestao>> todas() async {
    if (_doServidor != null) return _doServidor!;
    if (_api.ativo && _api.token != null) {
      try {
        final d = await _api.pedir('GET', '/sugestoes');
        if (d is List) {
          final lista = [
            for (final m in d)
              if (Sugestao.tentarLer(m) != null) Sugestao.tentarLer(m)!,
          ];
          if (lista.isNotEmpty) return _doServidor = lista;
        }
      } on ErroApi {
        // Sem rede: segue com a lista do app.
      }
    }
    return reserva;
  }

  void limpar() => _doServidor = null;

  /// Escolhe [quantas] sugestões para os objetivos da pessoa, variando com
  /// o dia e com [rodada] ("ver outras"), e sem repetir o mesmo tipo.
  static List<Sugestao> escolher(
    List<Sugestao> base,
    Set<String> objetivos, {
    required DateTime dia,
    int rodada = 0,
    int quantas = 3,
  }) {
    final combinam = base.where((s) => s.combinaCom(objetivos)).toList();
    if (combinam.isEmpty) return const [];
    // As que são do objetivo da pessoa vêm primeiro, depois as gerais.
    combinam.sort((a, b) {
      final ea = a.objetivos.any(objetivos.contains) ? 0 : 1;
      final eb = b.objetivos.any(objetivos.contains) ? 0 : 1;
      return ea.compareTo(eb);
    });
    final inicio =
        (dia.year * 372 + dia.month * 31 + dia.day + rodada * quantas) %
        combinam.length;
    final ordem = [...combinam.skip(inicio), ...combinam.take(inicio)];
    final escolhidas = <Sugestao>[];
    final tipos = <String>{};
    for (final s in ordem) {
      if (escolhidas.length == quantas) break;
      if (tipos.add(s.tipo)) escolhidas.add(s);
    }
    for (final s in ordem) {
      if (escolhidas.length == quantas) break;
      if (!escolhidas.contains(s)) escolhidas.add(s);
    }
    return escolhidas;
  }

  /// Lista do app, para quando não há servidor.
  static const List<Sugestao> reserva = [
    Sugestao(
      id: 'r1',
      tipo: 'meditacao',
      minutos: 5,
      titulo: 'Respiração 4-4-6',
      como:
          'Inspire contando até 4, segure até 4 e solte o ar contando até '
          '6. Repita por 5 minutos.',
    ),
    Sugestao(
      id: 'r2',
      tipo: 'leitura',
      minutos: 20,
      objetivos: ['ler'],
      titulo: 'Um capítulo no papel',
      como:
          'Leia um capítulo de um livro físico, com o celular em outro '
          'cômodo.',
    ),
    Sugestao(
      id: 'r3',
      tipo: 'estudo',
      minutos: 15,
      objetivos: ['estudar'],
      titulo: 'Resumo à mão',
      como:
          'Escreva no papel o que você lembra do que estudou hoje e depois '
          'confira o que faltou.',
    ),
    Sugestao(
      id: 'r4',
      tipo: 'movimento',
      minutos: 15,
      titulo: 'Caminhada sem fone',
      como: 'Dê uma volta no quarteirão sem música e sem celular na mão.',
    ),
    Sugestao(
      id: 'r5',
      tipo: 'descanso',
      minutos: 10,
      titulo: 'Chá sem tela',
      como: 'Prepare um chá e tome devagar, sentado, sem nenhuma tela.',
    ),
    Sugestao(
      id: 'r6',
      tipo: 'conexao',
      minutos: 10,
      titulo: 'Ligação, não mensagem',
      como: 'Ligue para alguém de quem você gosta e com quem não fala há tempo.',
    ),
  ];
}
