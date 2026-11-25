import 'comunidade.dart';

/// Comunidades fixas do app. As criadas pelos usuários vêm do repositório de
/// conteúdo (hoje local, depois o banco de dados). Os ícones são ids de
/// `iconesDeComunidade` (lib/pages_home/icones_comunidade.dart).
const List<Comunidade> comunidadesFixas = [
  Comunidade(
    id: 'historia',
    nome: 'História em pauta',
    descricao: 'Fatos, contextos e personagens que ajudam a entender o hoje.',
    iconeId: 'historia',
    categoriaIds: {'estudar_historia', 'ver_cultura'},
    regras: [
      'Cite sempre de onde veio a informação.',
      'Debata ideias, nunca pessoas.',
      'Sem conteúdo que incite ódio.',
    ],
  ),
  Comunidade(
    id: 'leitores',
    nome: 'Clube de leitores',
    descricao: 'Romances, aventuras e clássicos para conversar com calma.',
    iconeId: 'livro',
    categoriaIds: {'ler_romance', 'ler_aventura', 'ler_biografia'},
    regras: [
      'Evite revelar o final sem avisar.',
      'Indique a leitura, não cobre a de ninguém.',
      'Respeite gostos diferentes.',
    ],
  ),
  Comunidade(
    id: 'ciencia',
    nome: 'Curiosos da ciência',
    descricao: 'Do átomo ao cosmos, em textos curtos e sem pressa.',
    iconeId: 'ciencia',
    categoriaIds: {
      'ver_cientifico',
      'ver_curiosidades',
      'estudar_fisica',
      'estudar_quimica',
      'estudar_biologia',
    },
    regras: [
      'Prefira fontes e estudos a opiniões soltas.',
      'Dúvida é bem-vinda; deboche não.',
    ],
  ),
  Comunidade(
    id: 'ideias',
    nome: 'Filosofia e sociedade',
    descricao: 'Perguntas grandes, respostas abertas.',
    iconeId: 'ideias',
    categoriaIds: {'estudar_filosofia', 'estudar_sociologia'},
    regras: ['Ouça antes de responder.', 'Nenhum assunto vale uma ofensa.'],
  ),
  Comunidade(
    id: 'fantasia',
    nome: 'Mundos imaginados',
    descricao: 'Fantasia, ficção científica e distopias: mundos que fazem pensar no nosso.',
    iconeId: 'estrela',
    categoriaIds: {'ler_fantasia', 'ler_fc', 'ler_distopia'},
    regras: [
      'Avise antes de contar o final.',
      'Toda teoria é bem-vinda, desde que respeitosa.',
    ],
  ),
  Comunidade(
    id: 'misterio',
    nome: 'Clube do mistério',
    descricao: 'Suspense, horror e terror para quem gosta de virar a página no escuro.',
    iconeId: 'livro',
    categoriaIds: {'ler_suspense', 'ler_horror', 'ler_terror'},
    regras: [
      'Nada de revelar o culpado sem aviso.',
      'Medo é gosto pessoal: respeite os limites de cada um.',
    ],
  ),
  Comunidade(
    id: 'jogos',
    nome: 'Tabuleiro e controle',
    descricao: 'Jogos de mesa e videogames: estratégia, história e boas partidas.',
    iconeId: 'conversa',
    categoriaIds: {'ver_jogos'},
    regras: [
      'Sem ofensa a quem joga diferente.',
      'Indique jogos, não force ninguém a jogar.',
    ],
  ),
  Comunidade(
    id: 'movimento',
    nome: 'Corpo em movimento',
    descricao: 'Esporte, educação física e saúde, para assistir e para praticar.',
    iconeId: 'natureza',
    categoriaIds: {'ver_esporte', 'estudar_ef'},
    regras: [
      'Cada corpo tem seu ritmo.',
      'Dica de treino não substitui orientação profissional.',
    ],
  ),
  Comunidade(
    id: 'idiomas',
    nome: 'Palavras e idiomas',
    descricao: 'Português e inglês sem medo de errar: dúvidas, dicas e curiosidades.',
    iconeId: 'escrita',
    categoriaIds: {'estudar_lp', 'estudar_ingles'},
    regras: [
      'Corrija com gentileza.',
      'Pergunta simples também é pergunta.',
    ],
  ),
  Comunidade(
    id: 'exatas',
    nome: 'Números sem medo',
    descricao: 'Matemática, física e química explicadas passo a passo.',
    iconeId: 'lampada',
    categoriaIds: {'estudar_matematica', 'estudar_fisica', 'estudar_quimica'},
    regras: [
      'Mostre o raciocínio, não só a resposta.',
      'Ninguém nasce sabendo: sem deboche.',
    ],
  ),
  Comunidade(
    id: 'arte',
    nome: 'Ateliê aberto',
    descricao: 'Artes, música e cultura: o que você viu, ouviu ou criou.',
    iconeId: 'arte',
    categoriaIds: {'estudar_artes', 'ver_cultura'},
    regras: [
      'Crítica com respeito ao trabalho dos outros.',
      'Dê os créditos a quem criou.',
    ],
  ),
  Comunidade(
    id: 'planeta',
    nome: 'Vida e planeta',
    descricao: 'Biologia e geografia: seres vivos, paisagens e o mundo que dividimos.',
    iconeId: 'mundo',
    categoriaIds: {'estudar_biologia', 'estudar_geografia'},
    regras: [
      'Traga a fonte dos dados.',
      'Discorde dos argumentos, não das pessoas.',
    ],
  ),
  Comunidade(
    id: 'crescer',
    nome: 'Crescer aos poucos',
    descricao: 'Hábitos, biografias e textos que ajudam a pensar a própria vida.',
    iconeId: 'lampada',
    categoriaIds: {'ler_dp', 'ler_biografia', 'ler_religioso'},
    regras: [
      'Compartilhe experiência, não receita pronta.',
      'Cada caminho é único.',
    ],
  ),
  Comunidade(
    id: 'atualidades',
    nome: 'Notícias com calma',
    descricao: 'Acontecimentos explicados sem pressa, com fonte e contexto.',
    iconeId: 'mundo',
    categoriaIds: {'ver_noticia', 'ler_tecnico'},
    regras: [
      'Sempre com fonte confiável.',
      'Sem boato e sem discurso de ódio.',
    ],
  ),
];
