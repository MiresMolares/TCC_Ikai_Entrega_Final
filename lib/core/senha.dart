/// Regras de senha forte do Ikai (as mesmas do servidor, em
/// backend/src/rotas/auth.js). Valem ao criar a conta e ao trocar a senha.
/// Dart puro.
class RegraSenha {
  final String descricao;
  final bool Function(String) cumpre;
  const RegraSenha(this.descricao, this.cumpre);
}

class Senha {
  Senha._();

  static const int minimo = 8;
  static const int maximo = 72; // limite do bcrypt, no servidor

  static final RegExp _maiuscula = RegExp(r'[A-Z]');
  static final RegExp _minuscula = RegExp(r'[a-z]');
  static final RegExp _numero = RegExp(r'[0-9]');

  /// Qualquer coisa que não seja letra sem acento, número ou espaço.
  static final RegExp _especial = RegExp(r'[^A-Za-z0-9\s]');

  static final List<RegraSenha> regras = [
    RegraSenha('Pelo menos $minimo caracteres', (s) => s.length >= minimo),
    RegraSenha('Uma letra maiúscula', _maiuscula.hasMatch),
    RegraSenha('Uma letra minúscula', _minuscula.hasMatch),
    RegraSenha('Um número', _numero.hasMatch),
    RegraSenha('Um caractere especial (ex.: ! @ # \$ %)', _especial.hasMatch),
  ];

  static bool forte(String senha) => problema(senha) == null;

  /// A mensagem do que falta, ou null se a senha é forte.
  static String? problema(String senha) {
    if (senha.length > maximo) {
      return 'A senha pode ter no máximo $maximo caracteres.';
    }
    final faltam = [
      for (final r in regras)
        if (!r.cumpre(senha)) r.descricao.toLowerCase(),
    ];
    if (faltam.isEmpty) return null;
    return 'A senha precisa ter: ${faltam.join(', ')}.';
  }
}
