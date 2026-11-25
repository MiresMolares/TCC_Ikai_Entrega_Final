import 'package:flutter/material.dart';

/// Cores do Ikai em um só lugar, nos temas claro e escuro.
///
/// São getters (e não constantes) porque mudam com [escuro]: quem troca o
/// tema é o ConfigService, que depois pede para todas as telas se
/// redesenharem.
class Cores {
  Cores._();

  /// true no modo escuro.
  static bool escuro = false;

  static Color _c(int claro, int noEscuro) => Color(escuro ? noEscuro : claro);

  static Color get laranja => _c(0xFFCB5A34, 0xFFD9673F);
  static Color get fundo => _c(0xFFFDFBF7, 0xFF121512);
  static Color get fundoEtapas => _c(0xFFF7F8F4, 0xFF161916);
  static Color get titulo => _c(0xFF243044, 0xFFE9ECE8);
  static Color get tituloVerde => _c(0xFF253D2D, 0xFFD5E6D9);
  static Color get subtitulo => _c(0xFF68756B, 0xFFA5B0A8);
  static Color get verde => _c(0xFF4B7F5A, 0xFF84B893);
  static Color get verdeClaro => _c(0xFFEAF2EC, 0xFF23322A);
  static Color get rosado => _c(0xFFFBEFEA, 0xFF3A2721);
  static Color get borda => _c(0xFFE7EDF1, 0xFF2C332E);
  static Color get bordaQuente => _c(0xFFF0ECE6, 0xFF302D29);
  static Color get bege => _c(0xFFE8D5B1, 0xFF5B4D34);

  /// Fundo de cartões, campos e caixas (branco no claro).
  static Color get cartao => _c(0xFFFFFFFF, 0xFF1D211E);

  /// Fundo das telas de login e cadastro.
  static Color get fundoLogin => _c(0xFFEDF1F3, 0xFF121512);

  /// Fundo da tela de leitura, em volta da folha.
  static Color get fundoLeitura => _c(0xFFF1EEE8, 0xFF0E110F);

  /// Fundo da leitura de um artigo ("folha de papel").
  static Color get folha => _c(0xFFFFFFFF, 0xFF1A1E1B);

  /// Texto corrido dos artigos.
  static Color get textoLeitura => _c(0xFF2B2B2B, 0xFFDCDFDA);

  // Tons das telas de escolha (objetivos, categorias, meta).
  static Color get selecao => _c(0xFFE4EFE5, 0xFF26392D);
  static Color get bordaNeutra => _c(0xFFE0E5DF, 0xFF353C37);
  static Color get bordaSelecao => _c(0xFF8FA3B5, 0xFF7D92A4);
  static Color get cinzaAzul => _c(0xFF4F6275, 0xFFB3C3D2);
  static Color get chipFundo => _c(0xFFEDF1F3, 0xFF262B28);
  static Color get iconeSelecao => _c(0xFFD0E3D2, 0xFF2F4636);
  static Color get iconeFundo => _c(0xFFF0F3EE, 0xFF232824);
  static Color get desativado => _c(0xFFCAD5CA, 0xFF3A423C);

  /// Faixa dos avisos de tempo (fica escura nos dois temas).
  static const Color faixaAviso = Color(0xFF253D2D);
}

/// Mostra uma mensagem curta no rodapé, trocando a anterior.
void mostrarAviso(BuildContext context, String mensagem) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(mensagem), duration: const Duration(seconds: 3)),
    );
}
