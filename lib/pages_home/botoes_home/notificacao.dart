import 'package:flutter/material.dart';

import '../../services/artigos_repositorio.dart';
import '../../services/config_service.dart';
import '../../services/notificacoes_service.dart';
import '../../widgets/estilo.dart';
import '../artigo_page.dart';

/// Caixa de notificações: comentários nos seus artigos e respostas aos seus
/// comentários. Sem alertas insistentes: as notificações só aparecem aqui, e
/// o número no sino só aparece se a pessoa ligar em Configurações.
class NotificacaoPage extends StatefulWidget {
  const NotificacaoPage({super.key});

  @override
  State<NotificacaoPage> createState() => _NotificacaoPageState();
}

class _NotificacaoPageState extends State<NotificacaoPage> {
  final NotificacoesService _n = NotificacoesService.instance;

  @override
  void initState() {
    super.initState();
    _n.atualizar();
  }

  void _abrir(Notificacao n) {
    _n.marcarLida(n);
    final id = n.artigoId;
    if (id == null) return;
    final artigo = ArtigosRepositorio.porId(id);
    if (artigo == null) {
      mostrarAviso(context, 'Este artigo não está mais disponível.');
      return;
    }
    abrirArtigo(context, artigo);
  }

  static String _quando(DateTime d) {
    final agora = DateTime.now();
    final dif = agora.difference(d);
    if (dif.inMinutes < 1) return 'agora';
    if (dif.inMinutes < 60) return 'há ${dif.inMinutes} min';
    if (dif.inHours < 24) return 'há ${dif.inHours} h';
    String dois(int n) => n.toString().padLeft(2, '0');
    return '${dois(d.day)}/${dois(d.month)}/${d.year}';
  }

  static IconData _icone(String tipo) => switch (tipo) {
    'resposta' => Icons.reply_rounded,
    'comentario' => Icons.chat_bubble_outline,
    'comunidade' => Icons.groups_outlined,
    'conquista' => Icons.emoji_events_outlined,
    _ => Icons.notifications_none_rounded,
  };

  Widget _vazio({
    required IconData icone,
    required String titulo,
    required String texto,
  }) {
    return ListView(
      // ListView para o "puxar para atualizar" funcionar também vazio.
      padding: const EdgeInsets.all(32),
      children: [
        const SizedBox(height: 60),
        Icon(icone, size: 56, color: Cores.verde),
        const SizedBox(height: 16),
        Text(
          titulo,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Cores.titulo,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          texto,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Cores.subtitulo),
        ),
      ],
    );
  }

  Widget _item(Notificacao n) {
    return Material(
      color: n.lida ? Cores.cartao : Cores.rosado,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _abrir(n),
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 4, 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Cores.bordaQuente),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(_icone(n.tipo), color: Cores.laranja),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      n.titulo,
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: n.lida ? FontWeight.w600 : FontWeight.bold,
                        color: Cores.titulo,
                      ),
                    ),
                    if (n.descricao.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        n.descricao,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.35,
                          color: Cores.subtitulo,
                        ),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      n.lida
                          ? _quando(n.criadaEm)
                          : '${_quando(n.criadaEm)}  ·  nova',
                      style: TextStyle(fontSize: 12, color: Cores.subtitulo),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Apagar notificação',
                onPressed: () async {
                  final ok = await _n.apagar(n);
                  if (!ok && mounted) {
                    mostrarAviso(context, 'Não foi possível apagar agora.');
                  }
                },
                icon: Icon(Icons.close, size: 20, color: Cores.subtitulo),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.fundo,
      appBar: AppBar(
        title: const Text('Notificações'),
        backgroundColor: Cores.fundo,
        actions: [
          ListenableBuilder(
            listenable: _n,
            builder: (context, _) => _n.naoLidas == 0
                ? const SizedBox.shrink()
                : TextButton(
                    onPressed: _n.lerTodas,
                    child: const Text('Marcar todas como lidas'),
                  ),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _n,
        builder: (context, _) {
          final Widget corpo;
          if (!_n.disponivel) {
            corpo = _vazio(
              icone: Icons.cloud_off_outlined,
              titulo: 'Sem servidor, sem notificações',
              texto:
                  'Os avisos de comentários e respostas precisam do app '
                  'ligado ao servidor do Ikai.',
            );
          } else if (_n.itens.isEmpty && _n.carregando) {
            corpo = Center(
              child: CircularProgressIndicator(color: Cores.laranja),
            );
          } else if (_n.itens.isEmpty && _n.erro != null) {
            corpo = _vazio(
              icone: Icons.wifi_off_rounded,
              titulo: 'Não deu para buscar as notificações',
              texto: '${_n.erro} Puxe a tela para baixo para tentar de novo.',
            );
          } else if (_n.itens.isEmpty) {
            corpo = _vazio(
              icone: Icons.notifications_none_rounded,
              titulo: 'Nenhuma notificação por enquanto',
              texto: ConfigService.instance.notificacoes
                  ? 'Quando alguém comentar no seu artigo ou responder a '
                        'você, aparece aqui.'
                  : 'Quando alguém comentar no seu artigo ou responder a '
                        'você, aparece aqui. Para ver o número de novas no '
                        'sino, ligue as notificações em Perfil, '
                        'Configurações.',
            );
          } else {
            corpo = ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: _n.itens.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, i) => _item(_n.itens[i]),
            );
          }
          return RefreshIndicator(
            color: Cores.laranja,
            onRefresh: _n.atualizar,
            child: corpo,
          );
        },
      ),
    );
  }
}
