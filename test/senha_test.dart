import 'package:flutter_test/flutter_test.dart';
import 'package:ikai/core/senha.dart';

void main() {
  group('Senha forte', () {
    test('aceita senha com maiúscula, minúscula, número e especial', () {
      expect(Senha.forte('Abcdef1!'), isTrue);
      expect(Senha.forte('Minha senha 2026#'), isTrue);
      expect(Senha.problema('Abcdef1!'), isNull);
    });

    test('recusa só números, mesmo com 8 ou mais', () {
      expect(Senha.forte('12345678'), isFalse);
      expect(Senha.forte('1234567890'), isFalse);
      expect(Senha.problema('12345678'), contains('maiúscula'));
    });

    test('diz exatamente o que falta', () {
      final p = Senha.problema('abcdefgh')!;
      expect(p, contains('maiúscula'));
      expect(p, contains('número'));
      expect(p, contains('especial'));
      expect(p, isNot(contains('minúscula')));
      expect(Senha.problema('Abc1!'), contains('8 caracteres'));
    });

    test('espaço e letra acentuada não contam como especial', () {
      expect(Senha.forte('Abcdefg 1'), isFalse);
      expect(Senha.forte('Abcdefgç1'), isTrue); // ç não é letra sem acento
    });

    test('limite de tamanho do servidor', () {
      expect(Senha.problema('Aa1!${'x' * 69}'), contains('no máximo'));
    });

    test('cada regra é avaliada à parte (para a lista na tela)', () {
      final cumpridas = [for (final r in Senha.regras) r.cumpre('abc')];
      expect(cumpridas, [false, false, true, false, false]);
    });
  });
}
