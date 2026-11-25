import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../data/artigo.dart';
import '../pages_configurar/controle_objetivo.dart';
import '../services/api_client.dart';
import '../services/conteudo_usuario.dart';
import '../widgets/artigo_card.dart';
import '../widgets/capa_artigo.dart';
import '../widgets/estilo.dart';

/// Formulário para o usuário escrever um artigo. O nível de dificuldade e a
/// categoria são escolhidos por quem escreve (o app nunca deduz).
/// Com [editando], o formulário já vem preenchido e salva as alterações.
class EscreverArtigoPage extends StatefulWidget {
  final Artigo? editando;

  const EscreverArtigoPage({super.key, this.editando});

  @override
  State<EscreverArtigoPage> createState() => _EscreverArtigoPageState();
}

class _EscreverArtigoPageState extends State<EscreverArtigoPage> {
  final _titulo = TextEditingController();
  final _resumo = TextEditingController();
  final _corpo = TextEditingController();
  final _tags = TextEditingController();

  Objetivo? _objetivo;
  Categoria? _categoria;
  int _nivel = 1;
  bool _enviando = false;
  String? _erro;

  // Capa opcional. Ao editar um artigo vindo do servidor, a capa atual é só
  // um endereço ([_capaUrl]) até a pessoa trocar.
  Uint8List? _capa;
  String? _capaUrl;
  String? _erroCapa;
  bool _escolhendoCapa = false;

  bool get _editando => widget.editando != null;
  bool get _temCapa => _capa != null || _capaUrl != null;

  @override
  void initState() {
    super.initState();
    final a = widget.editando;
    if (a == null) return;
    _titulo.text = a.titulo;
    _resumo.text = a.resumo;
    _corpo.text = a.paragrafos.join('\n\n');
    _tags.text = a.tags.join(', ');
    _objetivo = buscarObjetivo(a.objetivoId);
    _categoria = _objetivo?.buscarCategoria(a.categoriaId);
    _nivel = a.nivel;
    _capa = a.capa;
    _capaUrl = a.capa == null ? a.capaUrl : null;
  }

  /// Abre a galeria. O image_picker já reduz a imagem (largura máxima e
  /// qualidade), então uma foto do celular vira uma capa leve.
  Future<void> _escolherCapa() async {
    if (_escolhendoCapa) return;
    setState(() {
      _escolhendoCapa = true;
      _erroCapa = null;
    });
    try {
      final arquivo = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: ConteudoUsuarioService.capaLarguraMax,
        maxHeight: ConteudoUsuarioService.capaLarguraMax,
        imageQuality: 80,
      );
      if (arquivo == null || !mounted) return; // a pessoa desistiu
      final bytes = await arquivo.readAsBytes();
      if (!mounted) return;
      final problema = ConteudoUsuarioService.problemaDaCapa(bytes);
      setState(() {
        _erroCapa = problema;
        if (problema == null) _capa = bytes;
      });
    } on PlatformException {
      if (mounted) {
        setState(() => _erroCapa = 'Não foi possível abrir as suas imagens.');
      }
    } finally {
      if (mounted) setState(() => _escolhendoCapa = false);
    }
  }

  /// Um artigo de mentira só para a pré-visualização da capa, com o título
  /// e o resumo que a pessoa está escrevendo.
  Artigo _previa() => Artigo(
    id: 'previa',
    objetivoId: _objetivo?.id ?? '',
    categoriaId: _categoria?.id ?? '',
    titulo: _titulo.text.trim().isEmpty
        ? 'Título do seu artigo'
        : _titulo.text.trim(),
    autor: 'Você',
    resumo: _resumo.text.trim().isEmpty
        ? 'O resumo aparece aqui.'
        : _resumo.text.trim(),
    nivel: _nivel,
    tags: [],
    paragrafos: [_corpo.text.isEmpty ? '.' : _corpo.text],
    capa: _capa,
    capaUrl: _capa == null ? _capaUrl : null,
  );

  Widget _rotuloPrevia(String texto) => Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 6),
    child: Text(texto, style: TextStyle(fontSize: 12, color: Cores.subtitulo)),
  );

  Widget _campoCapa() {
    if (!_temCapa) {
      return Material(
        color: Cores.cartao,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: _escolhendoCapa ? null : _escolherCapa,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Cores.borda, width: 1.5),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.add_photo_alternate_outlined,
                  size: 32,
                  color: Cores.verde,
                ),
                const SizedBox(height: 8),
                Text(
                  _escolhendoCapa ? 'Abrindo...' : 'Adicionar imagem de capa',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Cores.titulo,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ela abre o artigo, larga, e aparece como miniatura nas '
                  'listas. Prefira uma imagem horizontal com o principal no '
                  'centro.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Cores.subtitulo),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Com capa: mostra como ela vai aparecer, com os cartões de verdade.
    return ListenableBuilder(
      listenable: Listenable.merge([_titulo, _resumo]),
      builder: (context, _) {
        final previa = _previa();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _rotuloPrevia('No topo do artigo e em "Meus artigos"'),
            AspectRatio(
              aspectRatio: proporcaoCapa,
              child: CapaArtigo(artigo: previa),
            ),
            _rotuloPrevia('No feed, na busca e na biblioteca'),
            IgnorePointer(child: ArtigoCard(artigo: previa)),
            const SizedBox(height: 6),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: _escolhendoCapa ? null : _escolherCapa,
                  icon: const Icon(Icons.image_outlined, size: 18),
                  label: const Text('Trocar'),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () => setState(() {
                    _capa = null;
                    _capaUrl = null;
                    _erroCapa = null;
                  }),
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('Remover'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red.shade700,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _titulo.dispose();
    _resumo.dispose();
    _corpo.dispose();
    _tags.dispose();
    super.dispose();
  }

  Future<void> _publicar() async {
    if (_enviando) return;
    setState(() {
      _enviando = true;
      _erro = null;
    });
    final s = ConteudoUsuarioService.instance;
    final r = _editando
        ? await s.editarArtigo(
            id: widget.editando!.id,
            objetivoId: _objetivo?.id ?? '',
            categoriaId: _categoria?.id ?? '',
            nivel: _nivel,
            titulo: _titulo.text,
            resumo: _resumo.text,
            corpo: _corpo.text,
            tagsTexto: _tags.text,
            capa: _capa,
            manterCapa: _capa == null && _capaUrl != null,
          )
        : await s.publicarArtigo(
            objetivoId: _objetivo?.id ?? '',
            categoriaId: _categoria?.id ?? '',
            nivel: _nivel,
            titulo: _titulo.text,
            resumo: _resumo.text,
            corpo: _corpo.text,
            tagsTexto: _tags.text,
            capa: _capa,
          );
    if (!mounted) return;
    if (!r.ok) {
      setState(() {
        _enviando = false;
        _erro = r.erro;
      });
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    Navigator.pop(context, r.valor);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            _editando
                ? 'Alterações salvas.'
                : 'Artigo publicado em "Meus artigos".',
          ),
        ),
      );
  }

  InputDecoration _decoracao(String rotulo, {String? dica}) => InputDecoration(
    labelText: rotulo,
    hintText: dica,
    alignLabelWithHint: true,
    filled: true,
    fillColor: Cores.cartao,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
  );

  Widget _secao(String texto) => Padding(
    padding: const EdgeInsets.only(top: 18, bottom: 8),
    child: Text(
      texto,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Cores.tituloVerde,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.fundo,
      appBar: AppBar(
        title: Text(_editando ? 'Editar artigo' : 'Escrever artigo'),
        backgroundColor: Cores.fundo,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
          children: [
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Cores.verdeClaro,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                ApiClient.instance.ativo
                    ? 'O que você publica aparece para as outras pessoas do '
                          'Ikai, na categoria que você escolher.'
                    : 'Por enquanto, o que você publica fica só neste '
                          'aparelho.',
                style: TextStyle(fontSize: 12, color: Cores.tituloVerde),
              ),
            ),
            _secao('Onde ele aparece'),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final o in objetivosComCategorias)
                  ChoiceChip(
                    label: Text(o.titulo),
                    selected: _objetivo?.id == o.id,
                    onSelected: (_) => setState(() {
                      if (_objetivo?.id != o.id) _categoria = null;
                      _objetivo = o;
                    }),
                  ),
              ],
            ),
            if (_objetivo != null) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (final c in _objetivo!.categorias)
                    ChoiceChip(
                      label: Text(c.titulo),
                      selected: _categoria?.id == c.id,
                      onSelected: (_) => setState(() => _categoria = c),
                    ),
                ],
              ),
            ],
            _secao('Nível de dificuldade'),
            Wrap(
              spacing: 8,
              children: [
                for (var n = Artigo.nivelMinimo; n <= Artigo.nivelMaximo; n++)
                  ChoiceChip(
                    label: Text(Artigo.nomeDoNivel(n)),
                    selected: _nivel == n,
                    onSelected: (_) => setState(() => _nivel = n),
                  ),
              ],
            ),
            _secao('Capa (opcional)'),
            _campoCapa(),
            if (_erroCapa != null) ...[
              const SizedBox(height: 8),
              Text(
                _erroCapa!,
                style: TextStyle(fontSize: 13, color: Colors.red.shade700),
              ),
            ],
            _secao('O texto'),
            TextField(
              controller: _titulo,
              maxLength: ConteudoUsuarioService.tituloMax,
              textCapitalization: TextCapitalization.sentences,
              decoration: _decoracao('Título'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _resumo,
              maxLength: ConteudoUsuarioService.resumoMax,
              minLines: 2,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              decoration: _decoracao(
                'Resumo',
                dica: 'Uma ou duas frases para o cartão.',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _corpo,
              minLines: 8,
              maxLines: 20,
              textCapitalization: TextCapitalization.sentences,
              decoration: _decoracao(
                'Texto do artigo',
                dica: 'Separe os parágrafos com uma linha em branco.',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _tags,
              decoration: _decoracao(
                'Assuntos (opcional)',
                dica:
                    'Separados por vírgula, até '
                    '${ConteudoUsuarioService.maxTags}.',
              ),
            ),
            if (_erro != null) ...[
              const SizedBox(height: 12),
              Text(
                _erro!,
                style: TextStyle(fontSize: 13, color: Colors.red.shade700),
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _enviando ? null : _publicar,
              style: ElevatedButton.styleFrom(
                backgroundColor: Cores.laranja,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                _enviando
                    ? 'Salvando...'
                    : (_editando ? 'Salvar alterações' : 'Publicar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
