import 'package:flutter/material.dart';

import '../pages_home/criar_comunidade.dart';
import '../pages_home/escrever_artigo.dart';
import '../pages_home/meus_artigos.dart';
import 'estilo.dart';

/// Abre o menu de criação: escrever artigo, criar comunidade, meus artigos.
Future<void> mostrarMenuCriar(BuildContext context) async {
  final destino = await showModalBottomSheet<Widget>(
    context: context,
    showDragHandle: true,
    backgroundColor: Cores.cartao,
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'O que você quer criar?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Cores.titulo,
              ),
            ),
            const SizedBox(height: 12),
            OpcaoDeCriacao(
              icone: Icons.edit_note_rounded,
              titulo: 'Escrever um artigo',
              descricao: 'Compartilhe o que você sabe com quem lê o Ikai.',
              aoTocar: () => Navigator.pop(ctx, const EscreverArtigoPage()),
            ),
            const SizedBox(height: 10),
            OpcaoDeCriacao(
              icone: Icons.group_add_outlined,
              titulo: 'Criar uma comunidade',
              descricao: 'Um grupo pequeno para conversar sobre um assunto.',
              aoTocar: () => Navigator.pop(ctx, const CriarComunidadePage()),
            ),
            const SizedBox(height: 10),
            OpcaoDeCriacao(
              icone: Icons.article_outlined,
              titulo: 'Meus artigos',
              descricao: 'Veja, edite ou apague o que você já escreveu.',
              aoTocar: () => Navigator.pop(ctx, const MeusArtigosPage()),
            ),
          ],
        ),
      ),
    ),
  );
  if (destino == null || !context.mounted) return;
  Navigator.push(context, MaterialPageRoute(builder: (_) => destino));
}

/// Botão redondo "Criar", no canto da tela. Discreto: só abre o menu.
class BotaoCriar extends StatelessWidget {
  const BotaoCriar({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: 'botao_criar',
      onPressed: () => mostrarMenuCriar(context),
      backgroundColor: Cores.cartao,
      foregroundColor: Cores.laranja,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Cores.bordaQuente),
      ),
      icon: const Icon(Icons.add_rounded),
      label: const Text(
        'Criar',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}

/// Cartão de uma opção de criação (ícone, título e explicação).
class OpcaoDeCriacao extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String descricao;
  final VoidCallback aoTocar;

  const OpcaoDeCriacao({
    super.key,
    required this.icone,
    required this.titulo,
    required this.descricao,
    required this.aoTocar,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Cores.cartao,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: aoTocar,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Cores.bordaQuente),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Cores.rosado,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icone, color: Cores.laranja, size: 24),
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
                        color: Cores.titulo,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      descricao,
                      style: TextStyle(fontSize: 12.5, color: Cores.subtitulo),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Cores.subtitulo),
            ],
          ),
        ),
      ),
    );
  }
}
