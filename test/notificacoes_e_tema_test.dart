import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikai/data/comentario.dart';
import 'package:ikai/services/notificacoes_service.dart';
import 'package:ikai/widgets/estilo.dart';

void main() {
  group('Notificação vinda da API', () {
    test('lê os campos e o artigo ligado', () {
      final n = Notificacao.tentarLer({
        'id': 'n1',
        'tipo': 'resposta',
        'titulo': 'Bia respondeu ao seu comentário',
        'descricao': 'Em "Um título": Concordo.',
        'criadaEm': '2026-11-24T12:00:00.000Z',
        'lida': false,
        'artigo': 'a001',
      })!;
      expect(n.tipo, 'resposta');
      expect(n.artigoId, 'a001');
      expect(n.lida, isFalse);
      expect(n.lidaAgora().lida, isTrue);
    });

    test('ignora lixo sem quebrar', () {
      expect(Notificacao.tentarLer(null), isNull);
      expect(Notificacao.tentarLer({'id': 'n1'}), isNull);
      expect(
        Notificacao.tentarLer({
          'id': 'n1',
          'tipo': 'sistema',
          'titulo': 'Oi',
          'criadaEm': 'não é data',
        }),
        isNull,
      );
    });
  });

  group('Comentário com resposta e foto', () {
    test('ida e volta do mapa', () {
      const c = Comentario(
        id: 'k1',
        artigoId: 'a001',
        autorNome: 'Ana',
        autorEmail: '',
        texto: 'Olá',
        criadoMs: 1,
        respostaA: 'k0',
      );
      final l = Comentario.tentarLer({
        ...c.toMap(),
        'foto': '/usuarios/x/foto?v=1',
      })!;
      expect(l.respostaA, 'k0');
      expect(l.eResposta, isTrue);
      expect(l.foto, '/usuarios/x/foto?v=1');
      expect(
        Comentario.tentarLer({...c.toMap(), 'resposta': null})!.eResposta,
        isFalse,
      );
    });
  });

  group('Modo escuro', () {
    tearDown(() => Cores.escuro = false);

    test('as cores mudam com o tema e o texto contrasta com o fundo', () {
      Cores.escuro = false;
      final fundoClaro = Cores.fundo;
      final textoClaro = Cores.titulo;
      Cores.escuro = true;
      expect(Cores.fundo, isNot(fundoClaro));
      expect(Cores.titulo, isNot(textoClaro));
      expect(Cores.fundo.computeLuminance(), lessThan(0.05));
      expect(Cores.titulo.computeLuminance(), greaterThan(0.6));
      expect(
        Cores.textoLeitura.computeLuminance(),
        greaterThan(Cores.folha.computeLuminance() + 0.4),
      );
    });

    test('a faixa dos avisos é a mesma nos dois temas', () {
      expect(Cores.faixaAviso, const Color(0xFF253D2D));
    });
  });
}
