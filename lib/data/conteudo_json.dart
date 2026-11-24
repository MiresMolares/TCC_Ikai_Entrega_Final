import 'dart:convert';
import 'dart:typed_data';

import 'artigo.dart';

/// Conversão de [Artigo] de e para mapas simples (JSON). Serve ao
/// armazenamento local de hoje e ao banco de dados de amanhã. Dart puro.
Map<String, dynamic> artigoParaMapa(Artigo a) => {
  'id': a.id,
  'objetivo': a.objetivoId,
  'categoria': a.categoriaId,
  'titulo': a.titulo,
  'autor': a.autor,
  'resumo': a.resumo,
  'nivel': a.nivel,
  'tags': a.tags,
  'paragrafos': a.paragrafos,
  'usuario': a.doUsuario,
  'email': a.autorEmail,
  'em': a.criadoEm,
  // A capa vai em base64 (aparelho e envio à API). Artigos vindos da API
  // guardam só o endereço dela.
  if (a.capa != null) 'capa': base64Encode(a.capa!),
  if (a.capa == null && a.capaUrl != null) 'capaUrl': a.capaUrl,
};

/// Lê a capa: um endereço ('/artigos/...', vindo da API) ou base64.
/// Capa ilegível é ignorada (o artigo continua valendo, só sem capa).
({List<int>? bytes, String? url}) _capaDeMapa(Map m) {
  final url = m['capaUrl'];
  if (url is String && url.startsWith('/')) return (bytes: null, url: url);
  final c = m['capa'];
  if (c is! String || c.isEmpty) return (bytes: null, url: null);
  if (c.startsWith('/')) return (bytes: null, url: c);
  try {
    return (bytes: base64Decode(c), url: null);
  } on FormatException {
    return (bytes: null, url: null);
  }
}

/// Devolve null se o mapa estiver incompleto ou corrompido (nunca lança).
Artigo? artigoDeMapa(Object? m) {
  if (m is! Map) return null;
  final id = m['id'], obj = m['objetivo'], cat = m['categoria'];
  final titulo = m['titulo'], autor = m['autor'], resumo = m['resumo'];
  final nivel = m['nivel'], tags = m['tags'], pars = m['paragrafos'];
  if (id is! String || id.isEmpty) return null;
  if (obj is! String || cat is! String) return null;
  if (titulo is! String || titulo.trim().isEmpty) return null;
  if (autor is! String || resumo is! String) return null;
  if (nivel is! int ||
      nivel < Artigo.nivelMinimo ||
      nivel > Artigo.nivelMaximo) {
    return null;
  }
  if (tags is! List || pars is! List) return null;
  final paragrafos = pars.whereType<String>().toList();
  if (paragrafos.isEmpty) return null;
  final email = m['email'], em = m['em'];
  final capa = _capaDeMapa(m);
  return Artigo(
    id: id,
    objetivoId: obj,
    categoriaId: cat,
    titulo: titulo,
    autor: autor,
    resumo: resumo,
    nivel: nivel,
    tags: tags.whereType<String>().toList(),
    paragrafos: paragrafos,
    doUsuario: m['usuario'] == true,
    autorEmail: email is String ? email : null,
    criadoEm: em is String ? em : null,
    capa: capa.bytes == null ? null : Uint8List.fromList(capa.bytes!),
    capaUrl: capa.url,
  );
}
