import 'package:flutter_test/flutter_test.dart';
import 'package:ikai/core/tempo_relativo.dart';
import 'package:ikai/services/sugestoes_service.dart';
import 'package:ikai/services/tempo_diario.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Tempo relativo', () {
    final agora = DateTime(2026, 11, 25, 12);
    String h(Duration d) => haQuanto(agora.subtract(d), agora: agora);

    test('minutos, horas, dias, semanas, meses e anos', () {
      expect(h(const Duration(seconds: 20)), 'agora mesmo');
      expect(h(const Duration(minutes: 5)), 'há 5 min');
      expect(h(const Duration(hours: 3)), 'há 3 h');
      expect(h(const Duration(days: 1)), 'há 1 dia');
      expect(h(const Duration(days: 4)), 'há 4 dias');
      expect(h(const Duration(days: 15)), 'há 2 semanas');
      expect(h(const Duration(days: 40)), 'há 1 mês');
      expect(h(const Duration(days: 100)), 'há 3 meses');
      expect(h(const Duration(days: 800)), 'há 2 anos');
    });
  });

  group('Sugestões do fim do tempo', () {
    final base = [
      ...SugestoesService.reserva,
      const Sugestao(
        id: 'x1',
        tipo: 'leitura',
        minutos: 10,
        objetivos: ['ler'],
        titulo: 'Poema em voz alta',
        como: 'Leia um poema em voz alta, devagar.',
      ),
    ];

    test('só mostra as que combinam com o objetivo (ou servem a todos)', () {
      final l = SugestoesService.escolher(
        base,
        {'estudar'},
        dia: DateTime(2026, 11, 25),
        quantas: 10,
      );
      expect(
        l.every((s) => s.objetivos.isEmpty || s.objetivos.contains('estudar')),
        isTrue,
      );
      expect(l.any((s) => s.objetivos.contains('ler')), isFalse);
    });

    test('três por vez, sem repetir o tipo, e "ver outras" muda a lista', () {
      final dia = DateTime(2026, 11, 25);
      final a = SugestoesService.escolher(base, {'ler'}, dia: dia);
      final b = SugestoesService.escolher(base, {'ler'}, dia: dia, rodada: 1);
      expect(a.length, 3);
      expect(a.map((s) => s.tipo).toSet().length, 3);
      expect(a.map((s) => s.id).toList(), isNot(equals(b.map((s) => s.id).toList())));
    });

    test('lê o formato da API e ignora lixo', () {
      final s = Sugestao.tentarLer({
        'id': 's01',
        'tipo': 'meditacao',
        'titulo': 'Respiração',
        'como': 'Respire devagar.',
        'minutos': 5,
        'objetivos': <String>[],
      })!;
      expect(s.nomeDoTipo, 'Meditação');
      expect(Sugestao.tentarLer({'id': 1}), isNull);
    });
  });

  group('Meta de apresentação (2 min)', () {
    final t = TempoDiarioService.instance;

    setUp(() async {
      await Future<void>.delayed(const Duration(milliseconds: 10));
      SharedPreferences.setMockInitialValues({});
      t.agora = () => DateTime(2026, 11, 25, 9);
      await t.carregarPara('apresentacao@x.com');
    });

    test('2 min vale, e o tempo acaba em 2 min', () {
      expect(TempoDiarioService.metaValida(2), isTrue);
      expect(TempoDiarioService.metaValida(5), isFalse);
      expect(t.definirMeta(2), ResultadoMeta.aplicadaAgora);
      t.tick(60);
      expect(t.fase, FaseDoDia.dentro);
      t.tick(60);
      expect(t.fase, FaseDoDia.fimDeTempo);
    });

    test('sair da meta de apresentação para uma maior vale na hora', () {
      t.definirMeta(30);
      expect(t.definirMeta(45), ResultadoMeta.aPartirDeAmanha);
      t.definirMeta(2);
      expect(t.definirMeta(45), ResultadoMeta.aplicadaAgora);
      expect(t.metaMin, 45);
    });

    test('nome da opção', () {
      expect(TempoDiarioService.nomeDaMeta(2), '2 min (apresentação)');
    });
  });
}
