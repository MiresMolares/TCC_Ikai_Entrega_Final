import 'package:flutter/material.dart';
import './controle_objetivo.dart';

/// "Passar o tempo": sem preferências. Não tem categorias (pula a etapa de
/// categorias) e o feed mistura um pouco de tudo, continuando finito.
/// Não combina com outros objetivos: escolher ele desmarca os demais.
final Objetivo objetivoLivre = const Objetivo(
  id: 'passar_tempo',
  titulo: 'Passar o tempo',
  descricao: 'Sem preferências: um pouco de tudo, mas o feed continua finito.',
  icone: Icons.local_cafe_outlined,
  categorias: [],
);
