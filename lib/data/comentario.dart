/// Um comentário num artigo (do acervo do app ou escrito por um usuário).
/// Pode ser uma resposta a outro comentário (um nível só). Dart puro.
class Comentario {
  final String id;
  final String artigoId;

  /// Só o primeiro nome (é o que os outros veem).
  final String autorNome;

  /// E-mail de quem comentou (só para conferir a autoria; nunca é exibido).
  /// Vindo da API, só chega preenchido nos comentários da própria pessoa.
  final String autorEmail;
  final String texto;

  /// Milissegundos desde 1970.
  final int criadoMs;

  /// Id do comentário principal que este responde (null = principal).
  final String? respostaA;

  /// Endereço da foto de quem comentou, no servidor (null = sem foto).
  final String? foto;

  const Comentario({
    required this.id,
    required this.artigoId,
    required this.autorNome,
    required this.autorEmail,
    required this.texto,
    required this.criadoMs,
    this.respostaA,
    this.foto,
  });

  bool get eResposta => respostaA != null;

  Map<String, dynamic> toMap() => {
    'id': id,
    'artigo': artigoId,
    'nome': autorNome,
    'email': autorEmail,
    'texto': texto,
    'ms': criadoMs,
    if (respostaA != null) 'resposta': respostaA,
  };

  /// Devolve null se o mapa estiver incompleto ou corrompido (nunca lança).
  static Comentario? tentarLer(Object? m) {
    if (m is! Map) return null;
    final id = m['id'], artigo = m['artigo'], nome = m['nome'];
    final email = m['email'], texto = m['texto'], ms = m['ms'];
    final resposta = m['resposta'], foto = m['foto'];
    if (id is! String || id.isEmpty) return null;
    if (artigo is! String || artigo.isEmpty) return null;
    if (nome is! String || email is! String) return null;
    if (texto is! String || texto.trim().isEmpty) return null;
    if (ms is! int) return null;
    return Comentario(
      id: id,
      artigoId: artigo,
      autorNome: nome,
      autorEmail: email,
      texto: texto,
      criadoMs: ms,
      respostaA: resposta is String && resposta.isNotEmpty ? resposta : null,
      foto: foto is String && foto.isNotEmpty ? foto : null,
    );
  }
}
