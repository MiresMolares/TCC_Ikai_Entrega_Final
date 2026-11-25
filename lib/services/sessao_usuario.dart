import '../pages_configurar/controle_objetivo.dart';
import 'auth_service.dart';
import 'biblioteca_service.dart';
import 'conteudo_usuario.dart';
import 'foto_perfil_service.dart';
import 'notificacoes_service.dart';
import 'progresso_service.dart';
import 'sincronizacao_service.dart';
import 'sugestoes_service.dart';
import 'tempo_diario.dart';

/// O que acontece quando alguém entra ou sai da conta.
/// Garante que nenhum dado de um usuário apareça para o próximo.
class SessaoUsuario {
  SessaoUsuario._();

  /// Chame logo depois de `AuthService.entrar` dar certo.
  static Future<void> aoEntrar() async {
    final u = AuthService.instance.usuarioAtual;
    if (u == null) return;
    ControleObjetivos.instance.descartarSessaoEmMemoria();
    ControleObjetivos.instance.descartarHistoricoEmMemoria();
    // A cópia do servidor (biblioteca, progresso, tempo) vem antes de os
    // serviços lerem o aparelho.
    await SincronizacaoService.instance.baixar(u.email);
    await Future.wait([
      BibliotecaService.instance.carregarPara(u.email),
      ProgressoService.instance.carregarPara(u.email),
      TempoDiarioService.instance.carregarPara(u.email),
      ConteudoUsuarioService.instance.carregar(),
      FotoPerfilService.instance.carregarPara(u.email),
    ]);
    NotificacoesService.instance.atualizar();
    // Se a pessoa já escolheu o que ver hoje, a escolha volta (vale só no
    // dia). O tempo usado hoje também volta: sair e entrar não zera a meta.
    await ControleObjetivos.instance.restaurarSelecao();
    TempoDiarioService.instance.iniciarContagem();
    SincronizacaoService.instance.acompanhar(u.email);
  }

  /// Sair da conta limpa a memória do aparelho. O tempo usado e a escolha
  /// do dia ficam gravados: sair e entrar não reinicia a meta.
  static void aoSair() {
    SincronizacaoService.instance.parar(); // envia o estado atual antes
    SugestoesService.instance.limpar();
    TempoDiarioService.instance.limpar(); // pausa, grava e esquece a memória
    ControleObjetivos.instance.descartarSessaoEmMemoria();
    ControleObjetivos.instance.descartarHistoricoEmMemoria();
    BibliotecaService.instance.limpar();
    ProgressoService.instance.limpar();
    ConteudoUsuarioService.instance.limpar();
    FotoPerfilService.instance.limpar();
    NotificacoesService.instance.limpar();
    AuthService.instance.sair();
  }

  /// Exclui a conta e limpa tudo. Com a API, o servidor apaga primeiro: se
  /// falhar, devolve o erro e nada é apagado do aparelho.
  static Future<String?> aoExcluirConta() async {
    final erro = await AuthService.instance.apagarNoServidor();
    if (erro != null) return erro;
    SincronizacaoService.instance.parar(enviar: false);
    SugestoesService.instance.limpar();
    TempoDiarioService.instance.apagarDaConta(); // lê o e-mail antes
    ControleObjetivos.instance.reiniciarSessao();
    ControleObjetivos.instance.descartarHistoricoEmMemoria();
    BibliotecaService.instance.limpar();
    ProgressoService.instance.limpar();
    FotoPerfilService.instance.apagarDaConta();
    NotificacoesService.instance.limpar();
    final email = AuthService.instance.usuarioAtual?.email;
    if (email != null) ConteudoUsuarioService.instance.apagarDaConta(email);
    return AuthService.instance.excluirConta();
  }
}
