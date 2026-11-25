import 'package:flutter/material.dart';

import '../core/uso_diario.dart';
import '../services/artigos_repositorio.dart';
import '../services/progresso_service.dart';
import '../services/sugestoes_service.dart';
import '../services/tempo_diario.dart';
import '../widgets/estilo.dart';
import 'controle_objetivo.dart';

/// Objetivos de hoje, no formato das sugestões ('passar_tempo' = livre).
Set<String> objetivosDeHoje() {
  final c = ControleObjetivos.instance;
  return {
    for (final o in c.objetivos) o.livre ? 'passar_tempo' : o.id,
  };
}

/// O tempo do dia acabou (ou a pessoa pediu para encerrar). Aqui ela:
///  1. escreve o resumo do que consumiu no app (sempre disponível);
///  2. vê sugestões do banco de sugestões para levar a energia longe da
///     tela (meditação, leitura, movimento...), de acordo com o objetivo;
///  3. pede mais um pouco de tempo explicando por quê (até 2 vezes por dia)
///     ou encerra o dia.
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
  List<Sugestao> _base = SugestoesService.reserva;
  int _rodada = 0;
  String? _escolhida;

  @override
  void initState() {
    super.initState();
    _guardou = _t.resumoDeHojeEscrito;
    SugestoesService.instance.todas().then((l) {
      if (mounted) setState(() => _base = l);
    });
  }

  @override
  void dispose() {
    _aprendi.dispose();
    _motivo.dispose();
    super.dispose();
  }

  void _guardarResumo() {
    if (_t.registrarAprendizado(_aprendi.text)) {
      setState(() {
        _guardou = true;
        _aprendi.clear();
      });
    }
  }

  void _continuar() {
    if (_aprendi.text.trim().isNotEmpty) _t.registrarAprendizado(_aprendi.text);
    if (!_t.prorrogar(_minutos, _motivo.text)) {
      setState(
        () => _erroMotivo = 'Conte em poucas palavras por que quer continuar.',
      );
    }
  }

  void _encerrar() {
    if (_aprendi.text.trim().isNotEmpty) _t.registrarAprendizado(_aprendi.text);
    _t.encerrarPorHoje();
  }

  void _escolher(Sugestao s) {
    _t.registrarSugestaoEscolhida(s.titulo);
    setState(() => _escolhida = s.id);
  }

  InputDecoration _decoracao(String dica, {String? erro}) => InputDecoration(
    hintText: dica,
    errorText: erro,
    filled: true,
    fillColor: Cores.cartao,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
  );

  Widget _cartao({
    required String titulo,
    String? subtitulo,
    required List<Widget> filhos,
  }) {
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
          if (subtitulo != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitulo,
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: Cores.subtitulo,
              ),
            ),
          ],
          const SizedBox(height: 10),
          ...filhos,
        ],
      ),
    );
  }

  /// Os caminhos têm o mesmo peso visual: nenhum é empurrado.
  ButtonStyle get _estiloNeutro => OutlinedButton.styleFrom(
    foregroundColor: Cores.tituloVerde,
    side: BorderSide(color: Cores.subtitulo),
    minimumSize: const Size.fromHeight(50),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
  );

  Widget _resumo() {
    final lidos = [
      for (final id in ProgressoService.instance.lidosNoDia(DateTime.now()))
        if (ArtigosRepositorio.porId(id) != null)
          ArtigosRepositorio.porId(id)!.titulo,
    ];
    return _cartao(
      titulo: 'Resumo do que você consumiu hoje',
      subtitulo: _guardou
          ? 'Resumo guardado. Se quiser, acrescente mais alguma coisa.'
          : 'O que você leu, viu ou aprendeu no Ikai? Uma frase basta.',
      filhos: [
        if (lidos.isNotEmpty) ...[
          Text(
            'Você concluiu hoje:',
            style: TextStyle(fontSize: 12.5, color: Cores.subtitulo),
          ),
          const SizedBox(height: 4),
          for (final titulo in lidos.take(5))
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Row(
                children: [
                  Icon(Icons.check, size: 16, color: Cores.verde),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      titulo,
                      style: TextStyle(fontSize: 13, color: Cores.titulo),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 10),
        ],
        TextField(
          controller: _aprendi,
          minLines: 2,
          maxLines: 5,
          maxLength: TempoDiarioService.limiteTexto,
          textCapitalization: TextCapitalization.sentences,
          decoration: _decoracao('Hoje eu li sobre...'),
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 4,
          children: [
            TextButton(
              onPressed: _guardarResumo,
              child: const Text('Guardar resumo'),
            ),
            if (_guardou)
              Text(
                'Guardado no seu dia.',
                style: TextStyle(fontSize: 13, color: Cores.verde),
              ),
          ],
        ),
      ],
    );
  }

  Widget _sugestoes() {
    final lista = SugestoesService.escolher(
      _base,
      objetivosDeHoje(),
      dia: DateTime.now(),
      rodada: _rodada,
    );
    return _cartao(
      titulo: 'Para depois da tela',
      subtitulo: 'Ideias para levar sua energia para fora do app. Escolha '
          'uma, se quiser.',
      filhos: [
        for (final s in lista)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _escolhida == s.id ? Cores.selecao : Cores.fundoEtapas,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _escolhida == s.id ? Cores.verde : Cores.borda,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Cores.verdeClaro,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(s.icone, color: Cores.verde),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.titulo,
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: Cores.titulo,
                        ),
                      ),
                      Text(
                        '${s.nomeDoTipo}  ·  ${s.minutos} min',
                        style: TextStyle(fontSize: 12, color: Cores.verde),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        s.como,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: Cores.subtitulo,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: _escolhida == s.id
                              ? null
                              : () => _escolher(s),
                          child: Text(
                            _escolhida == s.id
                                ? 'Escolhida para hoje'
                                : 'Vou fazer isso',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        TextButton.icon(
          onPressed: () => setState(() => _rodada++),
          icon: const Icon(Icons.refresh, size: 18),
          label: const Text('Ver outras ideias'),
        ),
      ],
    );
  }

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
                  _resumo(),
                  _sugestoes(),
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
                    onPressed: _encerrar,
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

/// O dia foi encerrado: o app só volta amanhã. Mostra o resumo e a
/// sugestão escolhida, e ainda deixa escrever o resumo se faltou.
class TelaEncerrado extends StatefulWidget {
  const TelaEncerrado({super.key});

  @override
  State<TelaEncerrado> createState() => _TelaEncerradoState();
}

class _TelaEncerradoState extends State<TelaEncerrado> {
  final _resumo = TextEditingController();

  @override
  void dispose() {
    _resumo.dispose();
    super.dispose();
  }

  void _guardar() {
    if (TempoDiarioService.instance.registrarAprendizado(_resumo.text)) {
      setState(_resumo.clear);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = TempoDiarioService.instance;
    final hoje = chaveDoDia(DateTime.now());
    final aprendi = [
      for (final r in t.reflexoes)
        if (r.dia == hoje && r.tipo == 'aprendi') r.texto,
    ];
    final sugestoes = [
      for (final r in t.reflexoes)
        if (r.dia == hoje && r.tipo == 'sugestao') r.texto,
    ];

    return Overlay.wrap(
      child: Scaffold(
        backgroundColor: Cores.fundoEtapas,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: ListView(
                padding: const EdgeInsets.all(28),
                children: [
                  const SizedBox(height: 24),
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
                    '${TempoDiarioService.nomeDaMeta(t.metaMin)}.',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.4,
                      color: Cores.subtitulo,
                    ),
                  ),
                  if (sugestoes.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(
                      'Para depois da tela: ${sugestoes.last}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Cores.verde,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Text(
                    aprendi.isEmpty
                        ? 'Quer deixar um resumo do que consumiu hoje?'
                        : 'Seu resumo de hoje',
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
                  TextField(
                    controller: _resumo,
                    minLines: 1,
                    maxLines: 4,
                    maxLength: TempoDiarioService.limiteTexto,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: aprendi.isEmpty
                          ? 'Hoje eu li sobre...'
                          : 'Acrescentar ao resumo',
                      filled: true,
                      fillColor: Cores.cartao,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      suffixIcon: IconButton(
                        tooltip: 'Guardar resumo',
                        onPressed: _guardar,
                        icon: Icon(Icons.check, color: Cores.verde),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
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
    );
  }
}
