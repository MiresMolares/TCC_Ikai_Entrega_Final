import 'package:flutter/material.dart';

import '../pages_home/home.dart';
import '../services/artigos_repositorio.dart' show conteudosPorSessao;
import '../services/tempo_diario.dart';
import '../widgets/cartao_uso_semanal.dart';
import '../widgets/estilo.dart';
import 'controle_objetivo.dart';

// =====================================================
// CARTÕES DE OPÇÃO
// =====================================================

/// Card de opção usado nas etapas. Três estados visuais:
/// normal (borda cinza), sugerido (borda azulada + selo "Sugestão")
/// e selecionado (fundo verde claro, borda laranja, check).
class OpcaoCard extends StatelessWidget {
  final String titulo;

  /// Uma linha abaixo do título explicando a opção (opcional).
  final String descricao;
  final IconData icone;
  final bool selecionado;
  final bool sugerido;
  final VoidCallback onTap;

  const OpcaoCard({
    super.key,
    required this.titulo,
    this.descricao = '',
    required this.icone,
    required this.selecionado,
    required this.sugerido,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final mostrarSugestao = sugerido && !selecionado;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selecionado ? Cores.selecao : Cores.cartao,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selecionado
                ? Cores.laranja
                : mostrarSugestao
                ? Cores.bordaSelecao
                : Cores.bordaNeutra,
            width: (selecionado || mostrarSugestao) ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: selecionado ? Cores.iconeSelecao : Cores.iconeFundo,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icone, color: Cores.laranja, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Cores.tituloVerde,
                    ),
                  ),
                  if (descricao.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      descricao,
                      style: TextStyle(
                        fontSize: 12.5,
                        height: 1.3,
                        color: Cores.subtitulo,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (mostrarSugestao)
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Cores.chipFundo,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Sugestão',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Cores.cinzaAzul,
                  ),
                ),
              ),
            Icon(
              selecionado ? Icons.check_circle : Icons.circle_outlined,
              color: selecionado ? Cores.laranja : Colors.grey.shade400,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

/// Categoria em QUADRADO: ícone grande, título embaixo, várias podem estar
/// marcadas ao mesmo tempo. Vira o item da grade de 2 por fileira.
class CategoriaQuadrada extends StatelessWidget {
  final Categoria categoria;
  final bool selecionada;
  final bool sugerida;
  final VoidCallback onTap;

  const CategoriaQuadrada({
    super.key,
    required this.categoria,
    required this.selecionada,
    required this.sugerida,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final mostrarSugestao = sugerida && !selecionada;
    return Semantics(
      button: true,
      selected: selecionada,
      label: categoria.titulo,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: selecionada ? Cores.selecao : Cores.cartao,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selecionada
                  ? Cores.laranja
                  : mostrarSugestao
                  ? Cores.bordaSelecao
                  : Cores.bordaNeutra,
              width: (selecionada || mostrarSugestao) ? 2 : 1,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          color: selecionada
                              ? Cores.iconeSelecao
                              : Cores.iconeFundo,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(
                          categoria.icone,
                          color: Cores.laranja,
                          size: 42,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        categoria.titulo,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Cores.tituloVerde,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  selecionada ? Icons.check_circle : Icons.circle_outlined,
                  color: selecionada ? Cores.laranja : Colors.grey.shade400,
                  size: 24,
                ),
              ),
              if (mostrarSugestao)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Cores.chipFundo,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Sugestão',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Cores.cinzaAzul,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Grade de categorias: 2 por fileira, quadradas, seleção múltipla.
class GradeCategorias extends StatelessWidget {
  final List<Categoria> categorias;
  final bool Function(String id) estaSelecionada;
  final Set<String> sugeridas;
  final ValueChanged<Categoria> aoAlternar;

  const GradeCategorias({
    super.key,
    required this.categorias,
    required this.estaSelecionada,
    required this.sugeridas,
    required this.aoAlternar,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: categorias.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, i) {
        final cat = categorias[i];
        return CategoriaQuadrada(
          categoria: cat,
          selecionada: estaSelecionada(cat.id),
          sugerida: sugeridas.contains(cat.id),
          onTap: () => aoAlternar(cat),
        );
      },
    );
  }
}

// =====================================================
// FLUXO: OBJETIVO -> CATEGORIAS -> (FOCO -> IK AI no modo avançado)
// =====================================================

class FluxoObjetivosPage extends StatefulWidget {
  const FluxoObjetivosPage({super.key});

  @override
  State<FluxoObjetivosPage> createState() => _FluxoObjetivosPageState();
}

class _FluxoObjetivosPageState extends State<FluxoObjetivosPage> {
  final ControleObjetivos c = ControleObjetivos.instance;

  @override
  void initState() {
    super.initState();
    c.carregarHistorico();
  }

  /// A escolha foi feita: vai direto para a Home, limpando a pilha (a tela
  /// pode ter sido aberta de dentro da Home, por "Trocar categorias").
  void _irParaHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
      (rota) => false,
    );
  }

  bool get _temSugestao {
    switch (c.etapaAtual) {
      case EtapaFluxo.objetivo:
        return c.sugestaoObjetivoId != null;
      case EtapaFluxo.categorias:
        return c.sugestaoCategoriaIds.isNotEmpty;
      case EtapaFluxo.foco:
        return c.sugestaoFoco != null;
    }
  }

  String get _titulo {
    switch (c.etapaAtual) {
      case EtapaFluxo.objetivo:
        return 'Qual é o seu objetivo?';
      case EtapaFluxo.categorias:
        return 'O que você quer ver?';
      case EtapaFluxo.foco:
        return 'Quer um lembrete de foco?';
    }
  }

  String get _subtitulo {
    switch (c.etapaAtual) {
      case EtapaFluxo.foco:
        return 'É opcional e não bloqueia nada: o Ikai só avisa quando esse '
            'tempo passar, para você decidir se faz uma pausa.';
      case EtapaFluxo.categorias:
        return c.objetivos.length > 1
            ? 'Escolha pelo menos uma categoria de cada objetivo (até '
                  '${ControleObjetivos.maxCategorias} no total). O feed '
                  'continua com $conteudosPorSessao conteúdos.'
            : 'Escolha uma ou mais categorias (até '
                  '${ControleObjetivos.maxCategorias}). O feed continua com '
                  '$conteudosPorSessao conteúdos, não importa quantas escolher.';
      case EtapaFluxo.objetivo:
        return 'Escolha até ${ControleObjetivos.maxObjetivos}, por exemplo '
            'Ler e Estudar.${_temSugestao ? ' Sua última escolha aparece '
                      'como sugestão.' : ''}';
    }
  }

  Widget _cabecalho() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _titulo,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Cores.tituloVerde,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _subtitulo,
          style: TextStyle(fontSize: 15, color: Cores.subtitulo),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: c,
      builder: (context, _) {
        if (!c.historicoCarregado) {
          return Scaffold(
            backgroundColor: Cores.fundoEtapas,
            body: Center(
              child: CircularProgressIndicator(color: Cores.laranja),
            ),
          );
        }

        return PopScope(
          canPop: c.etapa == 0,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) c.voltar();
          },
          child: Scaffold(
            backgroundColor: Cores.fundoEtapas,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      color: Cores.chipFundo,
                      child: Text(
                        'Etapa ${c.etapa + 1} de ${c.etapas.length}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(child: _corpo()),
                    const SizedBox(height: 16),
                    _rodape(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _corpo() {
    switch (c.etapaAtual) {
      case EtapaFluxo.objetivo:
        final lista = todosOsObjetivos;
        // Primeira etapa rola inteira: traz o combinado pendente e, para
        // quem já usa de forma recorrente, os dados de uso.
        return ListView(
          children: [
            const CartaoUsoSemanal(),
            _cabecalho(),
            for (final o in lista) ...[
              // "Passar o tempo" é sozinho: fica separado dos outros.
              if (o.livre) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 8),
                  child: Text(
                    'Ou, sem preferências:',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Cores.subtitulo,
                    ),
                  ),
                ),
              ],
              OpcaoCard(
                titulo: o.titulo,
                descricao: o.descricao,
                icone: o.icone,
                selecionado: c.temObjetivo(o.id),
                sugerido: c.sugestaoObjetivoIds.contains(o.id),
                onTap: () {
                  if (!c.alternarObjetivo(o)) {
                    mostrarAviso(
                      context,
                      'Escolha no máximo ${ControleObjetivos.maxObjetivos} '
                      'objetivos. Desmarque um para trocar.',
                    );
                  }
                },
              ),
              const SizedBox(height: 12),
            ],
          ],
        );
      case EtapaFluxo.categorias:
        final sugeridas = c.sugestaoCategoriaIds;
        final semEscolha = c.categorias.isEmpty;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _cabecalho(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    semEscolha
                        ? 'Nenhuma categoria escolhida'
                        : '${c.categorias.length} de '
                              '${ControleObjetivos.maxCategorias} escolhidas',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Cores.subtitulo,
                    ),
                  ),
                ),
                if (sugeridas.isNotEmpty &&
                    !(sugeridas.length == c.categorias.length &&
                        sugeridas.every(c.temCategoria)))
                  TextButton.icon(
                    onPressed: c.aplicarSugestaoCategorias,
                    icon: const Icon(Icons.history, size: 18),
                    label: const Text('Usar a última escolha'),
                  ),
              ],
            ),
            if (c.objetivos.length > 1 && c.objetivosSemCategoria.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Falta escolher em: '
                  '${c.objetivosSemCategoria.map((o) => o.titulo).join(' e ')}',
                  style: TextStyle(fontSize: 13, color: Cores.laranja),
                ),
              ),
            const SizedBox(height: 8),
            Expanded(
              child: GradeCategorias(
                // Com dois objetivos, as categorias dos dois aparecem juntas.
                categorias: [for (final o in c.objetivos) ...o.categorias],
                estaSelecionada: c.temCategoria,
                sugeridas: sugeridas,
                aoAlternar: (cat) {
                  final ok = c.alternarCategoria(cat);
                  if (!ok) {
                    mostrarAviso(
                      context,
                      'No máximo ${ControleObjetivos.maxCategorias} '
                      'categorias. Desmarque uma para trocar.',
                    );
                  }
                },
              ),
            ),
          ],
        );
      case EtapaFluxo.foco:
        return ListView(children: [_cabecalho(), const _PassoFoco()]);
    }
  }

  Widget _rodape() {
    final ultima = c.etapa == c.ultimaEtapa;
    return Row(
      children: [
        if (c.etapa > 0) ...[
          SizedBox(
            height: 54,
            child: OutlinedButton(
              onPressed: c.voltar,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Cores.bordaNeutra),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Icon(Icons.arrow_back, color: Cores.tituloVerde),
            ),
          ),
          const SizedBox(width: 10),
        ],
        Expanded(
          child: SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: c.podeAvancar
                  ? () async {
                      if (!ultima) {
                        c.avancar();
                        return;
                      }
                      final ok = await c.confirmar();
                      if (ok && mounted) _irParaHome();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Cores.laranja,
                disabledBackgroundColor: Cores.desativado,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                ultima ? 'Confirmar e entrar' : 'Continuar',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =====================================================
// ETAPA (AVANÇADO): FOCO DA LEITURA
// =====================================================

/// Lembrete opcional de foco. Não limita nada: a meta do dia é o limite
/// real; este aviso só ajuda a pessoa a perceber o tempo.
class _PassoFoco extends StatelessWidget {
  const _PassoFoco();

  @override
  Widget build(BuildContext context) {
    final c = ControleObjetivos.instance;
    final meta = TempoDiarioService.instance.metaMin;
    final sugestao = c.sugestaoFoco;

    return ListenableBuilder(
      listenable: c,
      builder: (context, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Cores.cartao,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Cores.bordaNeutra),
            ),
            child: Text(
              'Sua meta de hoje é $meta min no Ikai. O lembrete abaixo é '
              'só dentro dela.',
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: Cores.tituloVerde,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Sem lembrete'),
                selected: c.focoMin == 0,
                selectedColor: Cores.selecao,
                onSelected: (_) => c.definirFoco(0),
              ),
              for (final m in ControleObjetivos.opcoesFoco)
                ChoiceChip(
                  label: Text('$m min'),
                  selected: c.focoMin == m,
                  selectedColor: Cores.selecao,
                  onSelected: (_) => c.definirFoco(m),
                ),
            ],
          ),
          if (sugestao != null && sugestao != c.focoMin) ...[
            const SizedBox(height: 12),
            InkWell(
              onTap: c.aplicarSugestaoFoco,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Cores.bordaSelecao, width: 2),
                ),
                child: Row(
                  children: [
                    Icon(Icons.history, color: Cores.cinzaAzul),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Sugestão: $sugestao min (toque para usar)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Cores.cinzaAzul,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
