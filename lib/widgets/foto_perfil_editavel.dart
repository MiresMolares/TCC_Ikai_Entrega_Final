import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../services/auth_service.dart';
import '../services/foto_perfil_service.dart';
import 'avatar_pessoa.dart';
import 'estilo.dart';

/// A foto de perfil da pessoa conectada, com o botão de câmera para
/// colocar, trocar ou remover.
class FotoPerfilEditavel extends StatefulWidget {
  final double raio;

  const FotoPerfilEditavel({super.key, this.raio = 52});

  @override
  State<FotoPerfilEditavel> createState() => _FotoPerfilEditavelState();
}

class _FotoPerfilEditavelState extends State<FotoPerfilEditavel> {
  final FotoPerfilService _f = FotoPerfilService.instance;
  bool _ocupado = false;

  Future<void> _escolher() async {
    setState(() => _ocupado = true);
    try {
      // O image_picker já reduz a foto (lado máximo e qualidade).
      final arquivo = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: FotoPerfilService.ladoMax,
        maxHeight: FotoPerfilService.ladoMax,
        imageQuality: 80,
      );
      if (arquivo == null || !mounted) return; // a pessoa desistiu
      final bytes = await arquivo.readAsBytes();
      final erro = await _f.definir(bytes);
      if (!mounted) return;
      mostrarAviso(context, erro ?? 'Foto de perfil atualizada.');
    } on PlatformException {
      if (mounted) {
        mostrarAviso(context, 'Não foi possível abrir as suas imagens.');
      }
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

  Future<void> _remover() async {
    setState(() => _ocupado = true);
    final erro = await _f.remover();
    if (!mounted) return;
    setState(() => _ocupado = false);
    mostrarAviso(context, erro ?? 'Foto removida.');
  }

  Future<void> _opcoes() async {
    if (_ocupado) return;
    if (!_f.temFoto) return _escolher();
    final escolha = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      backgroundColor: Cores.cartao,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library_outlined, color: Cores.laranja),
              title: const Text('Trocar foto'),
              onTap: () => Navigator.pop(ctx, 'trocar'),
            ),
            ListTile(
              leading: Icon(Icons.delete_outline, color: Cores.subtitulo),
              title: const Text('Remover foto'),
              onTap: () => Navigator.pop(ctx, 'remover'),
            ),
          ],
        ),
      ),
    );
    if (!mounted) return;
    if (escolha == 'trocar') await _escolher();
    if (escolha == 'remover') await _remover();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _f,
      builder: (context, _) {
        final nome = AuthService.instance.usuarioAtual?.nome ?? '';
        return Semantics(
          button: true,
          label: _f.temFoto
              ? 'Trocar foto de perfil'
              : 'Colocar foto de perfil',
          child: GestureDetector(
            onTap: _opcoes,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                AvatarPessoa(
                  nome: nome,
                  bytes: _f.bytes,
                  url: _f.url,
                  raio: widget.raio,
                ),
                if (_ocupado)
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.black38,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Material(
                    color: Cores.laranja,
                    shape: CircleBorder(
                      side: BorderSide(color: Cores.fundo, width: 3),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.photo_camera_outlined,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
