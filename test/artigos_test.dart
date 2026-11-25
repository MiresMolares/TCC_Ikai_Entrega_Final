import 'package:flutter_test/flutter_test.dart';
import 'package:ikai/core/sem_emoji.dart';
import 'package:ikai/core/texto.dart';
import 'package:ikai/data/artigo.dart';
import 'package:ikai/data/artigos_dados.dart';
import 'package:ikai/pages_configurar/controle_objetivo.dart';
import 'package:ikai/pages_configurar/objetivo_leitura.dart';
import 'package:ikai/services/artigos_repositorio.dart';

void main() {
  group('Artigos', () {
    test('ids de artigo são únicos', () {
      final ids = artigosDados.map((a) => a.id).toList();
      expect(ids.toSet().length, equals(ids.length));
    });

    test('todo artigo aponta para objetivo e categoria que existem', () {
      for (final a in artigosDados) {
        final objetivo = buscarObjetivo(a.objetivoId);
        expect(objetivo, isNotNull, reason: 'objetivo de ${a.id}');
        expect(
          objetivo!.buscarCategoria(a.categoriaId),
          isNotNull,
          reason: 'categoria de ${a.id} (${a.categoriaId})',
        );
      }
    });

    test('toda categoria tem pelo menos um artigo (nenhum feed vazio)', () {
      for (final o in todosOsObjetivos) {
        for (final cat in o.categorias) {
          expect(
            ArtigosRepositorio.doModo(o.id, {cat.id}).isNotEmpty,
            isTrue,
            reason: 'sem artigos em ${cat.id}',
          );
        }
      }
    });

    test('campos obrigatórios preenchidos e sem emojis', () {
      for (final a in artigosDados) {
        expect(a.titulo.trim().isNotEmpty, isTrue, reason: a.id);
        expect(a.autor.trim().isNotEmpty, isTrue, reason: a.id);
        expect(a.resumo.trim().isNotEmpty, isTrue, reason: a.id);
        expect(a.tags.isNotEmpty, isTrue, reason: a.id);
        expect(a.paragrafos.isNotEmpty, isTrue, reason: a.id);
        final tudo = '${a.titulo} ${a.resumo} ${a.paragrafos.join(' ')}';
        expect(temEmoji(tudo), isFalse, reason: a.id);
        expect(a.minutosLeitura, greaterThanOrEqualTo(1));
      }
    });

    test('o feed só traz artigos do modo escolhido', () {
      final feed = ArtigosRepositorio.feedDaSessao('ler', {'ler_distopia'});
      expect(feed.isNotEmpty, isTrue);
      for (final a in feed) {
        expect(a.objetivoId, equals('ler'));
        expect(a.categoriaId, equals('ler_distopia'));
      }
    });

    test('várias categorias se intercalam e o feed continua finito', () {
      final ids = objetivoLeitura.categorias.take(3).map((c) => c.id).toSet();
      final feed = ArtigosRepositorio.feedDaSessao('ler', ids);
      expect(feed.length, lessThanOrEqualTo(conteudosPorSessao));
      expect(feed.every((a) => ids.contains(a.categoriaId)), isTrue);
      // as duas primeiras posições vêm de categorias diferentes
      expect(feed[0].categoriaId == feed[1].categoriaId, isFalse);
      // nenhuma categoria sozinha ocupa o feed inteiro
      expect(feed.map((a) => a.categoriaId).toSet().length, greaterThan(1));
    });

    test('artigos de usuário entram pela fonte extra e saem sem ela', () {
      const meu = Artigo(
        id: 'u001',
        objetivoId: 'ler',
        categoriaId: 'ler_distopia',
        titulo: 'Meu texto',
        autor: 'Eu',
        resumo: 'r',
        tags: ['teste'],
        paragrafos: ['p'],
        doUsuario: true,
      );
      ArtigosRepositorio.extras = () => const [meu];
      try {
        expect(ArtigosRepositorio.porId('u001'), isNotNull);
        expect(
          ArtigosRepositorio.doModo('ler', {'ler_distopia'}).contains(meu),
          isTrue,
        );
      } finally {
        ArtigosRepositorio.extras = () => const [];
      }
      expect(ArtigosRepositorio.porId('u001'), isNull);
    });

    test('o feed é finito', () {
      for (final o in todosOsObjetivos) {
        for (final cat in o.categorias) {
          expect(
            ArtigosRepositorio.feedDaSessao(o.id, {cat.id}).length,
            lessThanOrEqualTo(conteudosPorSessao),
          );
        }
      }
    });

    test('sem modo definido, o feed é vazio', () {
      expect(ArtigosRepositorio.feedDaSessao(null, <String>{}), isEmpty);
      expect(ArtigosRepositorio.doModo('ler', <String>{}), isEmpty);
      expect(ArtigosRepositorio.feedDaEscolha(<String>{}, <String>{}), isEmpty);
    });

    test('dois objetivos: o feed mistura os dois e continua finito', () {
      final feed = ArtigosRepositorio.feedDaEscolha(
        {'ler', 'estudar'},
        {'ler_distopia', 'estudar_matematica'},
      );
      expect(feed.length, lessThanOrEqualTo(conteudosPorSessao));
      expect(feed.map((a) => a.objetivoId).toSet(), {'ler', 'estudar'});
    });

    test('"Passar o tempo": de tudo um pouco, ainda finito', () {
      final feed = ArtigosRepositorio.feedDaEscolha(
        <String>{},
        <String>{},
        livre: true,
      );
      expect(feed.length, conteudosPorSessao);
      expect(feed.map((a) => a.categoriaId).toSet().length, greaterThan(1));
    });

    test('busca ignora acentos e maiúsculas, em título, autor e assunto', () {
      final base = artigosDados;
      expect(
        ArtigosRepositorio.buscar('sócrates', base).map((a) => a.id),
        contains('a025'),
      );
      expect(
        ArtigosRepositorio.buscar('SOCRATES', base).map((a) => a.id),
        contains('a025'),
      );
      expect(
        ArtigosRepositorio.buscar('machado', base).map((a) => a.id),
        contains('a007'),
      );
      expect(ArtigosRepositorio.buscar('xyzxyz', base), isEmpty);
      expect(ArtigosRepositorio.buscar('  ', base).length, equals(base.length));
    });

    test('a busca nunca sai da lista-base recebida (respeita o filtro)', () {
      final doModo = ArtigosRepositorio.doModo('estudar', {'estudar_historia'});
      final r = ArtigosRepositorio.buscar('machado', doModo);
      expect(r, isEmpty); // artigo de Machado existe, mas em outro modo
    });

    test('tags e filtro por tag', () {
      final base = ArtigosRepositorio.doModo('ler', {'ler_distopia'});
      final tags = ArtigosRepositorio.tagsDe(base);
      expect(tags, contains('distopia'));
      final comTag = ArtigosRepositorio.comTag('distopia', base);
      expect(comTag, isNotEmpty);
      expect(comTag.every((a) => a.tags.contains('distopia')), isTrue);
      // Um artigo da mesma categoria sem a tag fica de fora.
      final semTag = ArtigosRepositorio.comTag('huxley', base);
      expect(semTag.length, lessThan(base.length));
    });

    test('normalizarTexto', () {
      expect(
        normalizarTexto('Ação Rápida É Ótima'),
        equals('acao rapida e otima'),
      );
    });
  });
}
