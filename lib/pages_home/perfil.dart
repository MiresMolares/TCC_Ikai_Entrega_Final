import 'package:flutter/material.dart';

import '../pages_login/login.dart';
import '../services/auth_service.dart';
import '../services/config_service.dart';
import '../services/sessao_usuario.dart';
import '../widgets/estilo.dart';
import '../widgets/foto_perfil_editavel.dart';
import '../widgets/textos_app.dart';
import 'biblioteca.dart';
import 'botoes_perfil/configuracao.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  Future<void> _sair(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sair da conta?'),
        content: const Text(
          'Sua sessão atual será encerrada. Seus dados continuam salvos '
          'neste aparelho.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Sair', style: TextStyle(color: Cores.laranja)),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    SessaoUsuario.aoSair();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (rota) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AuthService.instance,
      builder: (context, _) {
        final u = AuthService.instance.usuarioAtual;
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Perfil',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Cores.titulo,
                  ),
                ),
                IconButton.filled(
                  tooltip: 'Configurações',
                  style: IconButton.styleFrom(
                    backgroundColor: Cores.verdeClaro,
                    foregroundColor: Cores.verde,
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ConfiguracoesPage(),
                    ),
                  ),
                  icon: const Icon(Icons.settings_outlined),
                ),
              ],
            ),
            const SizedBox(height: 28),
            const Center(child: FotoPerfilEditavel()),
            const SizedBox(height: 16),
            Center(
              child: Text(
                u?.nome ?? '',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Cores.titulo,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Center(
              child: Text(
                u?.email ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14, color: Cores.subtitulo),
              ),
            ),
            const SizedBox(height: 28),
            // Modo escuro à mão, sem precisar entrar em Configurações.
            ListenableBuilder(
              listenable: ConfigService.instance,
              builder: (context, _) {
                final cfg = ConfigService.instance;
                return Material(
                  color: Cores.cartao,
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Cores.bordaQuente),
                    ),
                    child: SwitchListTile(
                      value: cfg.escuro,
                      onChanged: cfg.definirEscuro,
                      activeTrackColor: Cores.verde,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      secondary: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Cores.rosado,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          cfg.escuro
                              ? Icons.dark_mode_outlined
                              : Icons.light_mode_outlined,
                          color: Cores.laranja,
                          size: 23,
                        ),
                      ),
                      title: Text(
                        'Modo escuro',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Cores.titulo,
                        ),
                      ),
                      subtitle: Text(
                        cfg.escuro ? 'Ligado' : 'Desligado',
                        style: TextStyle(fontSize: 12, color: Cores.subtitulo),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _CartaoNavegacao(
              icone: Icons.badge_outlined,
              titulo: 'Meu perfil',
              descricao: 'Edite seu nome e sua foto',
              aoTocar: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditarPerfilPage(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _CartaoNavegacao(
              icone: Icons.collections_bookmark_outlined,
              titulo: 'Biblioteca',
              descricao: 'Seus artigos salvos, em pastas',
              aoTocar: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BibliotecaPage()),
              ),
            ),
            const SizedBox(height: 12),
            _CartaoNavegacao(
              icone: Icons.help_outline,
              titulo: 'Ajuda e suporte',
              descricao: 'Como o Ikai funciona',
              aoTocar: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaginaTexto(
                    titulo: 'Ajuda e suporte',
                    texto: TextosApp.ajuda,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            OutlinedButton.icon(
              onPressed: () => _sair(context),
              icon: const Icon(Icons.logout, size: 20),
              label: const Text(
                'Sair da conta',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Cores.laranja,
                backgroundColor: Cores.cartao,
                side: BorderSide(color: Cores.laranja),
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CartaoNavegacao extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String descricao;
  final VoidCallback aoTocar;

  const _CartaoNavegacao({
    required this.icone,
    required this.titulo,
    required this.descricao,
    required this.aoTocar,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Cores.cartao,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: aoTocar,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Cores.bordaQuente),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Cores.rosado,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icone, color: Cores.laranja, size: 23),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Cores.titulo,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      descricao,
                      style: TextStyle(fontSize: 12, color: Cores.subtitulo),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================
// EDIÇÃO DO PERFIL
// =====================================================

class EditarPerfilPage extends StatefulWidget {
  const EditarPerfilPage({super.key});

  @override
  State<EditarPerfilPage> createState() => _EditarPerfilPageState();
}

class _EditarPerfilPageState extends State<EditarPerfilPage> {
  late final TextEditingController _nome = TextEditingController(
    text: AuthService.instance.usuarioAtual?.nome ?? '',
  );
  late final TextEditingController _email = TextEditingController(
    text: AuthService.instance.usuarioAtual?.email ?? '',
  );

  @override
  void dispose() {
    _nome.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    // O e-mail identifica a conta e os dados salvos dela, por isso não muda.
    final erro = await AuthService.instance.atualizarPerfil(
      nome: _nome.text,
      email: AuthService.instance.usuarioAtual?.email ?? _email.text,
    );
    if (!mounted) return;
    if (erro != null) {
      mostrarAviso(context, erro);
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    Navigator.pop(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Perfil atualizado.')));
  }

  InputDecoration _decoracao(String rotulo, IconData icone) {
    OutlineInputBorder borda(Color cor, [double largura = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cor, width: largura),
        );
    return InputDecoration(
      labelText: rotulo,
      prefixIcon: Icon(icone, color: Cores.laranja),
      filled: true,
      fillColor: Cores.cartao,
      enabledBorder: borda(Cores.bordaQuente),
      focusedBorder: borda(Cores.laranja, 1.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.fundo,
      appBar: AppBar(
        title: const Text('Meu perfil'),
        backgroundColor: Cores.fundo,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Center(child: FotoPerfilEditavel(raio: 44)),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Toque na foto para colocar ou trocar',
                style: TextStyle(fontSize: 12, color: Cores.subtitulo),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nome,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              decoration: _decoracao('Nome', Icons.person_outline),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _email,
              enabled: false,
              decoration: _decoracao('E-mail', Icons.alternate_email).copyWith(
                helperText:
                    'O e-mail identifica a conta e não pode ser '
                    'alterado por enquanto.',
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: _salvar,
              style: ElevatedButton.styleFrom(
                backgroundColor: Cores.laranja,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Salvar alterações',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
