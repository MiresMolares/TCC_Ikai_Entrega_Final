/// "há 5 min", "há 2 h", "há 3 dias"... para comentários e notificações.
/// Dart puro.
String haQuanto(DateTime quando, {DateTime? agora}) {
  final dif = (agora ?? DateTime.now()).difference(quando);
  if (dif.inSeconds < 60) return 'agora mesmo';
  if (dif.inMinutes < 60) return 'há ${dif.inMinutes} min';
  if (dif.inHours < 24) return 'há ${dif.inHours} h';
  final dias = dif.inDays;
  String plural(int n, String um, String varios) =>
      'há $n ${n == 1 ? um : varios}';
  if (dias < 7) return plural(dias, 'dia', 'dias');
  if (dias < 30) return plural(dias ~/ 7, 'semana', 'semanas');
  if (dias < 365) return plural(dias ~/ 30, 'mês', 'meses');
  return plural(dias ~/ 365, 'ano', 'anos');
}
