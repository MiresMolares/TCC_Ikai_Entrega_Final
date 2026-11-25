import 'package:flutter/material.dart';

import '../data/artigo.dart';
import '../pages_configurar/controle_objetivo.dart';
import '../pages_configurar/fluxo_objetivos_page.dart';
import '../services/artigos_repositorio.dart';
import '../services/auth_service.dart';
import '../services/config_service.dart';
import '../services/notificacoes_service.dart';
import '../services/tempo_diario.dart';
import '../core/uso_diario.dart';
import '../widgets/artigo_card.dart';
import '../widgets/cartao_uso_semanal.dart';
import '../widgets/estilo.dart';
import '../widgets/seletor_nivel.dart';
import 'botoes_home/notificacao.dart';
import 'biblioteca.dart';
import 'comunidade.dart';
import 'explorar.dart';
import 'perfil.dart';
import 'progresso.dart';

/// Estrutura do app: cinco abas. Todas ficam montadas (IndexedStack), então
/// buscas e filtros continuam onde a pessoa deixou.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _indice = 0;

  /// Cada incremento pede para o Explorar focar o campo de busca.
  final ValueNotifier<int> _pedidoDeBusca = ValueNotifier(0);

  @override
  void dispose() {
    _pedidoDeBusca.dispose();
    super.dispose();
  }

  void _irParaBusca() {
    setState(() => _indice = 1);
    _pedidoDeBusca.value++;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.fundo,
      body: SafeArea(
        child: IndexedStack(
          index: _indice,
          children: [
            InicioTab(aoBuscar: _irParaBusca),
            ExplorarPage(pedidoDeBusca: _pedidoDeBusca),
            const ComunidadePage(),
            const ProgressoPage(),
            const PerfilPage(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        height: 68,
        backgroundColor: Cores.cartao,
        indicatorColor: Cores.verdeClaro,
        selectedIndex: _indice,
        onDestinationSelected: (i) => setState(() => _indice = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: Cores.verde),
            label: 'Início',
          ),
          NavigationDestination(
            icon: const Icon(Icons.search),
            selectedIcon: Icon(Icons.search, color: Cores.verde),
            label: 'Explorar',
          ),
          NavigationDestination(
            icon: const Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people, color: Cores.verde),
            label: 'Comunidade',
          ),
          NavigationDestination(
            icon: const Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart, color: Cores.verde),
            label: 'Progresso',
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: Cores.verde),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

// =====================================================
// ABA INÍCIO
// =====================================================

class InicioTab extends StatefulWidget {
  final VoidCallback aoBuscar;

  const InicioTab({super.key, required this.aoBuscar});

  @override
  State<InicioTab> createState() => _InicioTabState();
}

class _InicioTabState extends State<InicioTab> {
  final ControleObjetivos _c = ControleObjetivos.instance;
  String? _tag;

  /// Nível e assuntos ficam aqui dentro, fora do caminho até o feed.
  void _abrirFiltros(BuildContext context, List<String> tags) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Cores.fundo,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, atualizar) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filtrar o feed',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Cores.titulo,
                  ),
                ),
                const SizedBox(height: 16),
                const SeletorNivel(),
                if (tags.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  Text(
                    'Assunto',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Cores.subtitulo,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      ChoiceChip(
                        label: const Text('Todos'),
                        selected: _tag == null,
                        onSelected: (_) {
                          setState(() => _tag = null);
                          atualizar(() {});
                        },
                      ),
                      for (final t in tags)
                        ChoiceChip(
                          label: Text(t),
                          selected: _tag == t,
                          onSelected: (_) {
                            setState(() => _tag = t);
                            atualizar(() {});
                          },
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Cores.laranja,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('Ver feed'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ConfigService.instance,
      builder: (context, _) => _construir(context),
    );
  }

  Widget _construir(BuildContext context) {
    final nome = AuthService.instance.usuarioAtual?.primeiroNome ?? '';
    final nivel = ConfigService.instance.nivelConteudo;
    final semFiltro = ArtigosRepositorio.feedDaEscolha(
      _c.objetivoIds,
      _c.categoriaIds,
      livre: _c.modoLivre,
    );
    final feed = ArtigosRepositorio.feedDaEscolha(
      _c.objetivoIds,
      _c.categoriaIds,
      livre: _c.modoLivre,
      nivel: nivel,
    );
    final tags = ArtigosRepositorio.tagsDe(feed);
    final tagAtiva = (_tag != null && tags.contains(_tag)) ? _tag : null;
    final visiveis = tagAtiva == null
        ? feed
        : ArtigosRepositorio.comTag(tagAtiva, feed);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        _Cabecalho(nome: nome),
        const SizedBox(height: 20),
        _CampoBuscaFalso(aoTocar: widget.aoBuscar),
        const SizedBox(height: 20),
        const CartaoUsoSemanal(),
        const _CartaoMeta(),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Seu feed de hoje',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Cores.titulo,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    feed.length == 1
                        ? 'Um conteúdo escolhido para hoje.'
                        : '${feed.length} conteúdos escolhidos para hoje.',
                    style: TextStyle(fontSize: 13, color: Cores.subtitulo),
                  ),
                ],
              ),
            ),
            if (semFiltro.isNotEmpty)
              TextButton.icon(
                onPressed: () => _abrirFiltros(context, tags),
                icon: const Icon(Icons.tune, size: 18),
                label: const Text('Filtrar'),
                style: TextButton.styleFrom(foregroundColor: Cores.laranja),
              ),
          ],
        ),
        if (nivel != 0 || tagAtiva != null)
          _FiltrosAtivos(
            texto: [
              if (nivel != 0) Artigo.nomeDoNivel(nivel),
              ?tagAtiva,
            ].join('  ·  '),
            aoLimpar: () {
              ConfigService.instance.definirNivelConteudo(0);
              setState(() => _tag = null);
            },
          ),
        const SizedBox(height: 16),
        if (feed.isEmpty && semFiltro.isNotEmpty)
          _SemNesteNivel(nivel: nivel)
        else if (feed.isEmpty)
          const _Aviso(
            'Ainda não há conteúdos nesta categoria. Eles chegam com o '
            'banco de dados.',
          )
        else
          ListaDeArtigos(artigos: List<Artigo>.of(visiveis)),
        if (feed.isNotEmpty) const _FimDoFeed(),
      ],
    );
  }
}

/// Linha discreta que mostra o filtro em uso, com um jeito rápido de limpar.
class _FiltrosAtivos extends StatelessWidget {
  final String texto;
  final VoidCallback aoLimpar;

  const _FiltrosAtivos({required this.texto, required this.aoLimpar});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Icon(Icons.filter_alt_outlined, size: 16, color: Cores.verde),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'Filtro: $texto',
              style: TextStyle(fontSize: 13, color: Cores.verde),
            ),
          ),
          TextButton(
            onPressed: aoLimpar,
            style: TextButton.styleFrom(
              foregroundColor: Cores.laranja,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Limpar'),
          ),
        ],
      ),
    );
  }
}

class _SemNesteNivel extends StatelessWidget {
  final int nivel;

  const _SemNesteNivel({required this.nivel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Text(
            'Ainda não há conteúdo de nível ${Artigo.nomeDoNivel(nivel).toLowerCase()} '
            'nesta categoria.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Cores.subtitulo),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => ConfigService.instance.definirNivelConteudo(0),
            child: const Text('Ver todos os níveis'),
          ),
        ],
      ),
    );
  }
}

class _Cabecalho extends StatelessWidget {
  final String nome;

  const _Cabecalho({required this.nome});

  @override
  Widget build(BuildContext context) {
    final inicial = nome.isEmpty
        ? 'I'
        : String.fromCharCode(nome.runes.first).toUpperCase();
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Cores.bege,
            border: Border.all(color: Cores.bege, width: 3),
          ),
          child: Text(
            inicial,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Cores.tituloVerde,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Que bom ver você',
                style: TextStyle(fontSize: 13, color: Cores.subtitulo),
              ),
              Text(
                nome.isEmpty ? 'Olá' : 'Olá, $nome',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Cores.titulo,
                ),
              ),
            ],
          ),
        ),
        _BotaoQuadrado(
          icone: Icons.collections_bookmark_outlined,
          dica: 'Biblioteca',
          fundo: Cores.verdeClaro,
          cor: Cores.verde,
          aoTocar: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BibliotecaPage()),
          ),
        ),
        const SizedBox(width: 8),
        // O número de novas só aparece se a pessoa ligou as notificações.
        ListenableBuilder(
          listenable: Listenable.merge([
            NotificacoesService.instance,
            ConfigService.instance,
          ]),
          builder: (context, _) {
            final novas = ConfigService.instance.notificacoes
                ? NotificacoesService.instance.naoLidas
                : 0;
            return _BotaoQuadrado(
              icone: novas > 0
                  ? Icons.notifications_rounded
                  : Icons.notifications_none_rounded,
              dica: novas > 0 ? 'Notificações ($novas novas)' : 'Notificações',
              fundo: Cores.cartao,
              cor: Cores.titulo,
              borda: true,
              selo: novas,
              aoTocar: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificacaoPage(),
                  ),
                );
                NotificacoesService.instance.atualizar();
              },
            );
          },
        ),
      ],
    );
  }
}

class _BotaoQuadrado extends StatelessWidget {
  final IconData icone;
  final String dica;
  final Color fundo;
  final Color cor;
  final bool borda;
  final VoidCallback aoTocar;

  /// Número pequeno no canto (0 = sem número).
  final int selo;

  const _BotaoQuadrado({
    required this.icone,
    required this.dica,
    required this.fundo,
    required this.cor,
    required this.aoTocar,
    this.borda = false,
    this.selo = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: dica,
      child: Material(
        color: fundo,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: aoTocar,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: borda ? Border.all(color: Cores.borda, width: 2) : null,
            ),
            child: Badge(
              isLabelVisible: selo > 0,
              label: Text(selo > 9 ? '9+' : '$selo'),
              backgroundColor: Cores.laranja,
              child: Icon(icone, color: cor, size: 26),
            ),
          ),
        ),
      ),
    );
  }
}

/// Parece um campo de busca, mas só leva para a aba Explorar (onde a busca
/// acontece de verdade, já com o teclado aberto).
class _CampoBuscaFalso extends StatelessWidget {
  final VoidCallback aoTocar;

  const _CampoBuscaFalso({required this.aoTocar});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Cores.cartao,
      borderRadius: BorderRadius.circular(19),
      child: InkWell(
        borderRadius: BorderRadius.circular(19),
        onTap: aoTocar,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(19),
            border: Border.all(color: Cores.borda),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: Cores.titulo),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Buscar no seu feed de hoje',
                  style: TextStyle(fontSize: 14, color: Cores.subtitulo),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// O tempo de hoje: quanto falta da meta que a PESSOA escolheu, o que ela
/// está vendo, e as duas saídas: trocar as categorias ou encerrar o dia.
/// Fechado, é uma faixa pequena (para não atrapalhar o caminho até o feed);
/// ao tocar, abre os detalhes.
class _CartaoMeta extends StatefulWidget {
  const _CartaoMeta();

  @override
  State<_CartaoMeta> createState() => _CartaoMetaState();
}

class _CartaoMetaState extends State<_CartaoMeta> {
  bool _aberto = false;

  Future<void> _encerrar(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Encerrar por hoje?'),
        content: const Text(
          'Você pode contar o que aprendeu hoje e depois o app descansa '
          'até amanhã.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Continuar aqui'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Encerrar'),
          ),
        ],
      ),
    );
    if (ok == true) TempoDiarioService.instance.abrirFimVoluntario();
  }

  void _trocarCategorias(BuildContext context) {
    ControleObjetivos.instance.reiniciarSessao();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const FluxoObjetivosPage()),
      (rota) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = TempoDiarioService.instance;
    final c = ControleObjetivos.instance;
    return Material(
      color: Cores.rosado,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => setState(() => _aberto = !_aberto),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Faixa sempre visível: anel pequeno + quanto falta.
                ValueListenableBuilder<int>(
                  valueListenable: t.usadoHoje,
                  builder: (context, _, _) => Row(
                    children: [
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          value: 1 - t.fracaoUsada.clamp(0.0, 1.0),
                          strokeWidth: 4,
                          color: Cores.laranja,
                          backgroundColor: Cores.bege,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: formatarHm(t.restanteSeg),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Cores.laranja,
                                ),
                              ),
                              const TextSpan(text: ' restantes hoje'),
                            ],
                          ),
                          style: TextStyle(fontSize: 15, color: Cores.titulo),
                        ),
                      ),
                      Icon(
                        _aberto ? Icons.expand_less : Icons.expand_more,
                        color: Cores.subtitulo,
                        semanticLabel: _aberto
                            ? 'Fechar detalhes'
                            : 'Ver detalhes',
                      ),
                    ],
                  ),
                ),
                if (_aberto) ...[
                  const SizedBox(height: 12),
                  Text(
                    c.modoLivre
                        ? 'Passar o tempo: um pouco de tudo'
                        : '${c.titulosDosObjetivos}: '
                              '${c.titulosDasCategorias.isEmpty ? 'sem categoria' : c.titulosDasCategorias}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Cores.titulo,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Meta de ${formatarHm(t.limiteHojeSeg)} por dia',
                    style: TextStyle(fontSize: 13, color: Cores.subtitulo),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 14,
                    children: [
                      _LinkPequeno(
                        'Trocar escolha',
                        () => _trocarCategorias(context),
                      ),
                      _LinkPequeno('Encerrar o dia', () => _encerrar(context)),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LinkPequeno extends StatelessWidget {
  final String texto;
  final VoidCallback aoTocar;

  const _LinkPequeno(this.texto, this.aoTocar);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: aoTocar,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: Cores.laranja,
      ),
      child: Text(
        texto,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      ),
    );
  }
}

class _Aviso extends StatelessWidget {
  final String texto;

  const _Aviso(this.texto);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Text(
        texto,
        textAlign: TextAlign.center,
        style: TextStyle(color: Cores.subtitulo),
      ),
    );
  }
}

/// O feed acaba. Esse cartão existe para que a pessoa perceba isso.
class _FimDoFeed extends StatelessWidget {
  const _FimDoFeed();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Cores.verdeClaro,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.check_circle_outline, color: Cores.verde, size: 32),
          const SizedBox(height: 8),
          Text(
            'Você chegou ao fim do feed',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Cores.tituloVerde,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Não há mais nada para rolar. Faça uma pausa, ou volte a um '
            'artigo que você quer reler.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Cores.subtitulo),
          ),
        ],
      ),
    );
  }
}
