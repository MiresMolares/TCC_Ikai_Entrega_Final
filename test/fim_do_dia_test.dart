import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikai/core/sem_emoji.dart';
import 'package:ikai/pages_configurar/tela_fim_do_dia.dart';
import 'package:ikai/services/tempo_diario.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A tela de fim do dia (sem IA): contar o que aprendeu, pedir mais tempo
/// com um motivo (até 2 vezes) ou encerrar. Os dois caminhos têm o mesmo
/// peso visual.
void main() {
  final t = TempoDiarioService.instance;
  late DateTime agora;

  setUp(() async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    SharedPreferences.setMockInitialValues({});
    agora = DateTime(2026, 11, 11, 9);
    t.agora = () => agora;
    await t.carregarPara('a@x.com');
    t.agora = () => agora;
    t.definirMeta(20);
  });

  Future<void> montar(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 3200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MaterialApp(home: TelaFimDoDia()));
  }

  testWidgets('mostra o uso e os caminhos', (tester) async {
    t.tick(1200);
    await montar(tester);
    expect(find.text('Seu tempo de hoje acabou'), findsOneWidget);
    expect(find.text('Você usou 20 min de 20 min hoje.'), findsOneWidget);
    expect(find.text('Resumo do que você consumiu hoje'), findsOneWidget);
    expect(find.text('Para depois da tela'), findsOneWidget);
    expect(find.text('Vou fazer isso'), findsNWidgets(3));
    expect(find.text('Continuar mais 10 min'), findsOneWidget);
    expect(find.text('Encerrar por hoje'), findsOneWidget);
    // Os dois botões têm o mesmo tipo (nenhum em destaque).
    expect(find.byType(ElevatedButton), findsNothing);
  });

  testWidgets('continuar exige motivo e libera o app', (tester) async {
    t.tick(1200);
    await montar(tester);
    await tester.tap(find.text('15 min'));
    await tester.pump();
    await tester.tap(find.text('Continuar mais 15 min'));
    await tester.pump();
    expect(t.fase, FaseDoDia.fimDeTempo);
    expect(
      find.text('Conte em poucas palavras por que quer continuar.'),
      findsOneWidget,
    );

    await tester.enterText(find.byType(TextField).last, 'terminar o capítulo');
    await tester.tap(find.text('Continuar mais 15 min'));
    await tester.pump();
    expect(t.fase, FaseDoDia.dentro);
    expect(t.limiteHojeSeg, 1200 + 900);
    expect(t.reflexoes.single.tipo, 'continuar');
    expect(t.reflexoes.single.texto, 'terminar o capítulo');
  });

  testWidgets('depois de 2 extensões, não oferece mais', (tester) async {
    t.tick(1200);
    t.prorrogar(10, 'primeira vez');
    t.tick(600);
    t.prorrogar(10, 'segunda vez');
    t.tick(600);
    await montar(tester);
    expect(find.textContaining('Continuar mais'), findsNothing);
    expect(find.textContaining('já usou os pedidos'), findsOneWidget);
  });

  testWidgets('guardar o que aprendeu e encerrar o dia', (tester) async {
    t.tick(1200);
    await montar(tester);
    await tester.enterText(find.byType(TextField).first, 'li sobre o mar');
    await tester.tap(find.text('Guardar resumo'));
    await tester.pump();
    expect(find.text('Guardado no seu dia.'), findsOneWidget);
    expect(t.reflexoes.single.tipo, 'aprendi');

    await tester.tap(find.text('Encerrar por hoje'));
    await tester.pump();
    expect(t.fase, FaseDoDia.encerrado);
  });

  testWidgets('escolher uma sugestão fica registrado no dia', (tester) async {
    t.tick(1200);
    await montar(tester);
    await tester.tap(find.text('Vou fazer isso').first);
    await tester.pump();
    expect(find.text('Escolhida para hoje'), findsOneWidget);
    expect(t.reflexoes.single.tipo, 'sugestao');
    // "Ver outras ideias" troca as sugestões mostradas.
    await tester.tap(find.text('Ver outras ideias'));
    await tester.pump();
    expect(find.text('Vou fazer isso'), findsWidgets);
  });

  testWidgets('o resumo escrito vale mesmo encerrando direto', (tester) async {
    t.tick(1200);
    await montar(tester);
    await tester.enterText(find.byType(TextField).first, 'li sobre o céu');
    await tester.tap(find.text('Encerrar por hoje'));
    await tester.pump();
    expect(t.fase, FaseDoDia.encerrado);
    expect(t.reflexoes.single.texto, 'li sobre o céu');
  });

  testWidgets('fim voluntário: pode voltar ao app e não oferece continuar', (
    tester,
  ) async {
    t.tick(300);
    t.abrirFimVoluntario();
    await montar(tester);
    expect(find.text('Encerrar por hoje?'), findsOneWidget);
    expect(find.textContaining('Continuar mais'), findsNothing);
    await tester.tap(find.text('Voltar ao app'));
    await tester.pump();
    expect(t.fase, FaseDoDia.dentro);
  });

  testWidgets('nenhum texto da tela tem emoji', (tester) async {
    t.tick(1200);
    await montar(tester);
    for (final w in tester.widgetList<Text>(find.byType(Text))) {
      final s = w.data ?? '';
      expect(removerEmojis(s), s);
    }
  });
}
