import 'package:flutter/material.dart';

import '../core/uso_diario.dart';
import '../services/tempo_diario.dart';
import '../widgets/estilo.dart';

/// O tempo do dia acabou (ou a pessoa pediu para encerrar). Aqui ela pode
/// contar o que aprendeu, pedir mais um pouco de tempo explicando por quê
/// (no máximo duas vezes por dia, e fica registrado) ou encerrar o dia.
///
/// Fica ACIMA do Navigator (veja SessaoGuard): tem o próprio Overlay, que o
/// campo de texto exige, e não abre diálogos nem menus.
class TelaFimDoDia extends StatefulWidget {
  const TelaFimDoDia({super.key});

  @override
  State<TelaFimDoDia> createState() => _TelaFimDoDiaState();
}

class _TelaFimDoDiaState extends State<TelaFimDoDia> {
  final _t = TempoDiarioService.instance;
  final _aprendi = TextEditingController();
  final _motivo = TextEditingController();
  int _minutos = TempoDiarioService.opcoesProrrogacao.first;
  bool _guardou = false;
  String? _erroMotivo;

  @override
  void dispose() {
    _aprendi.dispose();
    _motivo.dispose();
    super.dispose();
  }

  void _guardarAprendizado() {
    if (_t.registrarAprendizado(_aprendi.text)) {
      setState(() {
        _guardou = true;
        _aprendi.clear();
      });
    }
  }

  void _continuar() {
    if (!_t.prorrogar(_minutos, _motivo.text)) {
      setState(
        () => _erroMotivo = 'Conte em poucas palavras por que quer continuar.',
      );
    }
  }

  InputDecoration _decoracao(String dica, {String? erro}) => InputDecoration(
    hintText: dica,
    errorText: erro,
    filled: true,
    fillColor: Cores.cartao,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
  );

  Widget _cartao({required String titulo, required List<Widget> filhos}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Cores.cartao,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Cores.bordaQuente),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Cores.tituloVerde,
            ),
          ),
          const SizedBox(height: 10),
          ...filhos,
        ],
      ),
    );
  }

  /// Os dois caminhos têm o mesmo peso visual: nenhum é empurrado.
  ButtonStyle get _estiloNeutro => OutlinedButton.styleFrom(
    foregroundColor: Cores.tituloVerde,
    side: BorderSide(color: Cores.subtitulo),
    minimumSize: const Size.fromHeight(50),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
  );

  @override
  Widget build(BuildContext context) {
    final voluntario = _t.fimVoluntario;
    return Overlay.wrap(
      child: Scaffold(
        backgroundColor: Cores.fundoEtapas,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.hourglass_bottom_rounded,
                        size: 36,
                        color: Cores.laranja,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              voluntario
                                  ? 'Encerrar por hoje?'
                                  : 'Seu tempo de hoje acabou',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Cores.tituloVerde,
                              ),
                            ),
                            Text(
                              'Você usou ${formatarHm(_t.usadoHojeSeg)} de '
                              '${formatarHm(_t.limiteHojeSeg)} hoje.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Cores.subtitulo,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _cartao(
                    titulo: 'O que você aprendeu hoje?',
                    filhos: [
                      TextField(
                        controller: _aprendi,
                        minLines: 2,
                        maxLines: 4,
                        maxLength: TempoDiarioService.limiteTexto,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: _decoracao('É opcional. Uma frase basta.'),
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: _guardarAprendizado,
                            child: const Text('Guardar'),
                          ),
                          if (_guardou)
                            Text(
                              'Guardado no seu dia.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Cores.verde,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  if (!voluntario)
                    _cartao(
                      titulo: 'Precisa de mais um pouco?',
                      filhos: _t.podeProrrogar
                          ? [
                              Text(
                                'Explique por quê. Você pode pedir mais '
                                '${_t.prorrogacoesRestantes} de '
                                '${TempoDiarioService.maxProrrogacoes} '
                                'vezes hoje, e o motivo fica registrado.',
                                style: TextStyle(
                                  fontSize: 13,
                                  height: 1.4,
                                  color: Cores.subtitulo,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                children: [
                                  for (final m
                                      in TempoDiarioService.opcoesProrrogacao)
                                    ChoiceChip(
                                      label: Text('$m min'),
                                      selected: _minutos == m,
                                      onSelected: (_) =>
                                          setState(() => _minutos = m),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: _motivo,
                                maxLength: TempoDiarioService.limiteTexto,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                onChanged: (_) {
                                  if (_erroMotivo != null) {
                                    setState(() => _erroMotivo = null);
                                  }
                                },
                                decoration: _decoracao(
                                  'Quero continuar porque...',
                                  erro: _erroMotivo,
                                ),
                              ),
                              OutlinedButton(
                                onPressed: _continuar,
                                style: _estiloNeutro,
                                child: Text('Continuar mais $_minutos min'),
                              ),
                            ]
                          : [
                              Text(
                                'Você já usou os pedidos de tempo extra de '
                                'hoje. Amanhã tem mais.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Cores.subtitulo,
                                ),
                              ),
                            ],
                    ),
                  if (voluntario) ...[
                    OutlinedButton(
                      onPressed: _t.voltarAoApp,
                      style: _estiloNeutro,
                      child: const Text('Voltar ao app'),
                    ),
                    const SizedBox(height: 12),
                  ],
                  OutlinedButton(
                    onPressed: () {
                      if (_aprendi.text.trim().isNotEmpty) {
                        _t.registrarAprendizado(_aprendi.text);
                      }
                      _t.encerrarPorHoje();
                    },
                    style: _estiloNeutro,
                    child: const Text('Encerrar por hoje'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// O dia foi encerrado: o app só volta amanhã. Mostra o que a pessoa
/// registrou hoje, sem empurrar nada.
class TelaEncerrado extends StatelessWidget {
  const TelaEncerrado({super.key});

  @override
  Widget build(BuildContext context) {
    final t = TempoDiarioService.instance;
    final hoje = chaveDoDia(DateTime.now());
    final aprendi = [
      for (final r in t.reflexoes)
        if (r.dia == hoje && r.tipo == 'aprendi') r.texto,
    ];

    return Overlay.wrap(
      child: Scaffold(
        backgroundColor: Cores.fundoEtapas,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.nights_stay_outlined,
                      size: 48,
                      color: Cores.laranja,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Por hoje é só',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Cores.tituloVerde,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Você usou ${formatarHm(t.usadoHojeSeg)} hoje. '
                      'Amanhã o Ikai estará aqui, com a sua meta de '
                      '${t.metaMin} min.',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.4,
                        color: Cores.subtitulo,
                      ),
                    ),
                    if (aprendi.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text(
                        'O que você contou que aprendeu hoje',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Cores.tituloVerde,
                        ),
                      ),
                      const SizedBox(height: 6),
                      for (final a in aprendi.take(3))
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            '"$a"',
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.4,
                              color: Cores.tituloVerde,
                            ),
                          ),
                        ),
                    ],
                    const SizedBox(height: 24),
                    Text(
                      'Você pode fechar o app. Descansar a tela também é '
                      'parte do método.',
                      style: TextStyle(fontSize: 13, color: Cores.subtitulo),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
