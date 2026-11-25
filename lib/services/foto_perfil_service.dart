import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_client.dart';
import 'auth_service.dart';
import 'conteudo_usuario.dart';

/// A foto de perfil da pessoa conectada.
///
///  - COM a API: a foto vai para o servidor (`PUT /auth/eu/foto`) e todo
///    mundo vê nos comentários. [url] é o endereço dela lá.
///  - SEM a API: fica só neste aparelho, separada por conta.
///
/// [bytes] guarda a foto escolhida agora, para aparecer na hora, sem esperar
/// o download.
class FotoPerfilService extends ChangeNotifier {
  FotoPerfilService._(this._api);
  static final FotoPerfilService instance = FotoPerfilService._(
    ApiClient.instance,
  );

  @visibleForTesting
  FotoPerfilService.paraTeste(this._api);

  final ApiClient _api;

  /// O app reduz a foto para isto ao escolher (a foto é pequena na tela).
  static const double ladoMax = 512;

  /// O teto, igual ao do servidor (backend/src/rotas/perfil.js).
  static const int maxBytes = 300 * 1024;

  Uint8List? _bytes;
  String? _url;
  String? _email;

  Uint8List? get bytes => _bytes;
  String? get url => _url;
  bool get temFoto => _bytes != null || _url != null;

  String _chave(String email) => 'foto_v1_${email.toLowerCase()}';

  /// Mensagem de erro, ou null se a imagem serve.
  static String? problema(Uint8List b) {
    if (b.length > maxBytes) {
      return 'A foto é grande demais (máximo de ${maxBytes ~/ 1024} KB).';
    }
    if (!ConteudoUsuarioService.ehImagem(b)) {
      return 'A foto precisa ser uma imagem JPEG, PNG ou WebP.';
    }
    return null;
  }

  /// Chame logo depois do login.
  Future<void> carregarPara(String email) async {
    _email = email;
    _bytes = null;
    _url = AuthService.instance.usuarioAtual?.foto;
    if (!_api.ativo) {
      try {
        final p = await SharedPreferences.getInstance();
        final b = p.getString(_chave(email));
        if (b != null && b.isNotEmpty) _bytes = base64Decode(b);
      } catch (_) {
        // Foto corrompida ou sem armazenamento: fica sem foto.
      }
    }
    notifyListeners();
  }

  /// Coloca ou troca a foto. Devolve a mensagem de erro, ou null.
  Future<String?> definir(Uint8List foto) async {
    final erro = problema(foto);
    if (erro != null) return erro;
    final email = _email;
    if (email == null) return 'Entre na sua conta.';
    if (_api.ativo) {
      try {
        final r = await _api.pedir(
          'PUT',
          '/auth/eu/foto',
          corpo: {'foto': base64Encode(foto)},
        );
        _url = r is Map && r['foto'] is String ? r['foto'] as String : null;
      } on ErroApi catch (e) {
        return e.mensagem;
      }
    } else {
      try {
        final p = await SharedPreferences.getInstance();
        await p.setString(_chave(email), base64Encode(foto));
      } catch (_) {
        return 'Não foi possível guardar a foto neste aparelho.';
      }
    }
    _bytes = foto;
    AuthService.instance.atualizarFoto(_url);
    notifyListeners();
    return null;
  }

  Future<String?> remover() async {
    final email = _email;
    if (email == null) return 'Entre na sua conta.';
    if (_api.ativo) {
      try {
        await _api.pedir('DELETE', '/auth/eu/foto');
      } on ErroApi catch (e) {
        return e.mensagem;
      }
    } else {
      try {
        final p = await SharedPreferences.getInstance();
        await p.remove(_chave(email));
      } catch (_) {}
    }
    _bytes = null;
    _url = null;
    AuthService.instance.atualizarFoto(null);
    notifyListeners();
    return null;
  }

  /// Ao sair: esquece a foto da memória (a gravada continua).
  void limpar() {
    _email = null;
    _bytes = null;
    _url = null;
    notifyListeners();
  }

  /// Ao excluir a conta: apaga a foto deste aparelho também.
  Future<void> apagarDaConta() async {
    final email = _email;
    limpar();
    if (email == null) return;
    try {
      final p = await SharedPreferences.getInstance();
      await p.remove(_chave(email));
    } catch (_) {}
  }
}
