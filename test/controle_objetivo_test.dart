import 'package:flutter_test/flutter_test.dart';
import 'package:ikai/core/selecao_salva.dart';
import 'package:ikai/pages_configurar/controle_objetivo.dart';
import 'package:ikai/pages_configurar/objetivo_estudo.dart';
import 'package:ikai/pages_configurar/objetivo_leitura.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late DateTime agora;
  late bool avancado;
  late ControleObjetivos c;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await Future<void>.delayed(const Duration(milliseconds: 10));
    agora = DateTime(2026, 11, 4, 10);
    avancado = false;
    c = ControleObjetivos.paraTeste(
      avancado: () => avancado,
      agora: () => agora,
    );
  });

  tearDown(() async {
    c.reiniciarSessao();
    await Future<void>.delayed(const Duration(milliseconds: 10));
  });

  void escolherObjetivoECategorias(int quantas) {
    c.selecionarObjetivo(objetivoLeitura);
    c.avancar();
    for (final cat in objetivoLeitura.categorias.take(quantas)) {
      c.alternarCategoria(cat);
    }
  }

  group('Até 2 objetivos e "Passar o tempo"', () {
    test('escolhe Ler e Estudar; o terceiro é recusado', () {
      expect(c.alternarObjetivo(objetivoLeitura), isTrue);
      expect(c.alternarObjetivo(objetivoEstudo), isTrue);
      expect(c.objetivoIds, {objetivoLeitura.id, objetivoEstudo.id});
      expect(c.alternarObjetivo(todosOsObjetivos.first), isFalse);
      expect(c.objetivos.length, ControleObjetivos.maxObjetivos);
    });

    test('com dois objetivos, precisa de categoria de cada um', () async {
      c.alternarObjetivo(objetivoLeitura);
      c.alternarObjetivo(objetivoEstudo);
      c.avancar();
      c.alternarCategoria(objetivoLeitura.categorias.first);
      expect(c.podeAvancar, isFalse);
      expect(c.objetivosSemCategoria.map((o) => o.id), [objetivoEstudo.id]);
      c.alternarCategoria(objetivoEstudo.categorias.first);
      expect(c.podeAvancar, isTrue);
      expect(await c.confirmar(), isTrue);
      expect(c.estado, EstadoSessao.ativa);
    });

    test('desmarcar um objetivo leva junto as categorias dele', () {
      c.alternarObjetivo(objetivoLeitura);
      c.alternarObjetivo(objetivoEstudo);
      c.alternarCategoria(objetivoLeitura.categorias.first);
      c.alternarCategoria(objetivoEstudo.categorias.first);
      c.alternarObjetivo(objetivoEstudo);
      expect(c.categoriaIds, {objetivoLeitura.categorias.first.id});
    });

    test('"Passar o tempo" é sozinho e pula a etapa de categorias', () async {
      final livre = todosOsObjetivos.firstWhere((o) => o.livre);
      c.alternarObjetivo(objetivoLeitura);
      c.alternarObjetivo(livre);
      expect(c.objetivoIds, {livre.id});
      expect(c.modoLivre, isTrue);
      expect(c.etapas, [EtapaFluxo.objetivo]);
      expect(await c.confirmar(), isTrue);

      // Marcar outro objetivo tira o "Passar o tempo".
      c.reiniciarSessao();
      c.alternarObjetivo(livre);
      c.alternarObjetivo(objetivoEstudo);
      expect(c.objetivoIds, {objetivoEstudo.id});
    });

    test(
      'a escolha com dois objetivos volta depois de reabrir o app',
      () async {
        c.alternarObjetivo(objetivoLeitura);
        c.alternarObjetivo(objetivoEstudo);
        c.avancar();
        c.alternarCategoria(objetivoLeitura.categorias.first);
        c.alternarCategoria(objetivoEstudo.categorias.first);
        await c.confirmar();
        await Future<void>.delayed(const Duration(milliseconds: 20));

        final outro = ControleObjetivos.paraTeste(
          avancado: () => avancado,
          agora: () => agora,
        );
        await outro.restaurarSelecao();
        expect(outro.objetivoIds, {objetivoLeitura.id, objetivoEstudo.id});
        expect(outro.categoriaIds.length, 2);
      },
    );

    test('escolha gravada no formato antigo (um objetivo) ainda é lida', () {
      final s = SelecaoSalva.tentarLer(
        '{"o":"ler","c":["ler_romance"],"t":"","g":false,"f":0,"d":"2026-11-04"}',
      )!;
      expect(s.objetivoIds, ['ler']);
      expect(
        SelecaoSalva.tentarLer(
          '{"o":"ler","c":[],"t":"","g":false,"f":0,"d":"2026-11-04"}',
        ),
        isNull,
      );
    });
  });

  group('Etapas por modo', () {
    test('iniciante tem 2 etapas: objetivo e categorias', () {
      expect(c.etapas, [EtapaFluxo.objetivo, EtapaFluxo.categorias]);
      expect(c.ultimaEtapa, 1);
    });

    test('avançado tem 3 etapas, terminando no foco', () {
      avancado = true;
      expect(c.etapas.length, 3);
      expect(c.etapas.last, EtapaFluxo.foco);
    });

    test('não avança sem escolher o objetivo', () {
      expect(c.podeAvancar, isFalse);
      c.avancar();
      expect(c.etapa, 0);
    });

    test('não avança da categoria sem escolher nenhuma', () {
      c.selecionarObjetivo(objetivoLeitura);
      c.avancar();
      expect(c.etapa, 1);
      expect(c.podeAvancar, isFalse);
    });

    test('voltar na primeira etapa não faz nada', () {
      c.voltar();
      expect(c.etapa, 0);
    });
  });

  group('Várias categorias', () {
    test('escolhe e desmarca mais de uma', () {
      escolherObjetivoECategorias(3);
      expect(c.categorias.length, 3);
      expect(c.podeAvancar, isTrue);
      c.alternarCategoria(objetivoLeitura.categorias.first);
      expect(c.categorias.length, 2);
      expect(c.temCategoria(objetivoLeitura.categorias.first.id), isFalse);
    });

    test('respeita o limite máximo', () {
      escolherObjetivoECategorias(ControleObjetivos.maxCategorias);
      final extra = objetivoLeitura.categorias[ControleObjetivos.maxCategorias];
      expect(c.alternarCategoria(extra), isFalse);
      expect(c.categorias.length, ControleObjetivos.maxCategorias);
    });

    test('categoria de outro objetivo é ignorada', () {
      c.selecionarObjetivo(objetivoLeitura);
      c.alternarCategoria(objetivoEstudo.categorias.first);
      expect(c.categorias, isEmpty);
    });

    test('trocar de objetivo limpa as categorias', () {
      escolherObjetivoECategorias(2);
      c.selecionarObjetivo(objetivoEstudo);
      expect(c.categorias, isEmpty);
    });

    test('categoriaIds e títulos refletem a escolha', () {
      escolherObjetivoECategorias(2);
      expect(c.categoriaIds.length, 2);
      expect(c.titulosDasCategorias, contains(', '));
    });
  });

  group('Confirmação', () {
    test('iniciante confirma na etapa de categorias', () async {
      escolherObjetivoECategorias(2);
      expect(await c.confirmar(), isTrue);
      expect(c.estado, EstadoSessao.ativa);
    });

    test('avançado só confirma na última etapa', () async {
      avancado = true;
      escolherObjetivoECategorias(1);
      expect(await c.confirmar(), isFalse);
      c.avancar(); // foco
      expect(await c.confirmar(), isTrue);
    });

    test('sem categoria não confirma', () async {
      c.selecionarObjetivo(objetivoLeitura);
      c.avancar();
      expect(await c.confirmar(), isFalse);
      expect(c.estado, EstadoSessao.naoIniciada);
    });

    test('iniciante nunca guarda foco', () async {
      escolherObjetivoECategorias(1);
      c.definirFoco(15);
      await c.confirmar();
      expect(c.focoMin, 0);
    });

    test('depois de ativa, escolhas ficam travadas', () async {
      escolherObjetivoECategorias(1);
      await c.confirmar();
      c.selecionarObjetivo(objetivoEstudo);
      expect(c.objetivo?.id, objetivoLeitura.id);
      c.alternarCategoria(objetivoLeitura.categorias[1]);
      expect(c.categorias.length, 1);
    });
  });

  group('Modo avançado: foco', () {
    setUp(() => avancado = true);

    test('foco só aceita opções válidas', () {
      c.definirFoco(7);
      expect(c.focoMin, 0);
      c.definirFoco(20);
      expect(c.focoMin, 20);
      c.definirFoco(0);
      expect(c.focoMin, 0);
    });
  });

  group('Histórico como sugestão', () {
    test('sugere, mas não aplica sozinho', () async {
      avancado = true;
      escolherObjetivoECategorias(2);
      c.definirFoco(30);
      c.avancar();
      await c.confirmar();
      await Future<void>.delayed(const Duration(milliseconds: 20));
      c.reiniciarSessao();

      c.descartarHistoricoEmMemoria();
      await c.carregarHistorico();
      expect(c.objetivo, isNull);
      expect(c.sugestaoObjetivoId, objetivoLeitura.id);
      expect(c.sugestaoFoco, 30);

      c.selecionarObjetivo(objetivoLeitura);
      expect(c.sugestaoCategoriaIds.length, 2);
      expect(c.categorias, isEmpty);
      c.aplicarSugestaoCategorias();
      expect(c.categorias.length, 2);
    });

    test('sugestão de categoria só vale para o objetivo escolhido', () async {
      escolherObjetivoECategorias(2);
      await c.confirmar();
      await Future<void>.delayed(const Duration(milliseconds: 20));
      c.reiniciarSessao();
      c.descartarHistoricoEmMemoria();
      await c.carregarHistorico();
      c.selecionarObjetivo(objetivoEstudo);
      expect(c.sugestaoCategoriaIds, isEmpty);
    });
  });

  group('Escolha gravada (vale só no dia)', () {
    test('volta no mesmo dia', () async {
      escolherObjetivoECategorias(2);
      await c.confirmar();
      await Future<void>.delayed(const Duration(milliseconds: 20));
      c.descartarSessaoEmMemoria();
      expect(c.estado, EstadoSessao.naoIniciada);

      await c.restaurarSelecao();
      expect(c.estado, EstadoSessao.ativa);
      expect(c.objetivo?.id, objetivoLeitura.id);
      expect(c.categorias.length, 2);
    });

    test('não volta no dia seguinte', () async {
      escolherObjetivoECategorias(1);
      await c.confirmar();
      await Future<void>.delayed(const Duration(milliseconds: 20));
      c.descartarSessaoEmMemoria();

      agora = agora.add(const Duration(days: 1));
      await c.restaurarSelecao();
      expect(c.estado, EstadoSessao.naoIniciada);
    });

    test('reiniciar apaga a escolha gravada', () async {
      escolherObjetivoECategorias(1);
      await c.confirmar();
      await Future<void>.delayed(const Duration(milliseconds: 20));
      c.reiniciarSessao();
      await Future<void>.delayed(const Duration(milliseconds: 20));
      await c.restaurarSelecao();
      expect(c.estado, EstadoSessao.naoIniciada);
    });

    test('texto corrompido é ignorado', () {
      expect(SelecaoSalva.tentarLer('{ruim'), isNull);
      expect(SelecaoSalva.tentarLer(''), isNull);
      expect(SelecaoSalva.tentarLer(null), isNull);
      expect(SelecaoSalva.tentarLer('{"o":1}'), isNull);
    });

    test('ida e volta do JSON', () {
      const s = SelecaoSalva(
        objetivoId: 'ler',
        categoriaIds: ['a', 'b'],
        focoMin: 15,
        dia: '2026-11-04',
      );
      final l = SelecaoSalva.tentarLer(s.toJson())!;
      expect(l.categoriaIds, ['a', 'b']);
      expect(l.focoMin, 15);
      expect(l.dia, '2026-11-04');
    });
  });
}
