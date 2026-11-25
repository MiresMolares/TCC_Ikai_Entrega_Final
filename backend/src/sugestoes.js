// Banco de sugestões para o fim do tempo no Ikai: para onde e como a pessoa
// pode levar a energia longe da tela. Ao iniciar, o servidor grava esta lista
// na coleção `sugestoes` (substitui as antigas com o mesmo id).
//
// tipo: meditacao | leitura | movimento | descanso | estudo | criatividade |
//       conexao | natureza
// objetivos: para quem combina (vazio = todos). 'passar_tempo' é o objetivo
//            "Passar o tempo".

export const TIPOS_DE_SUGESTAO = [
  'meditacao', 'leitura', 'movimento', 'descanso', 'estudo', 'criatividade',
  'conexao', 'natureza',
];

export const SUGESTOES = [
  {
    _id: 's01', tipo: 'meditacao', minutos: 5, objetivos: [],
    titulo: 'Respiração 4-4-6',
    como: 'Sente-se com as costas apoiadas. Inspire contando até 4, segure até 4 e solte o ar contando até 6. Repita por 5 minutos, sem pressa.',
  },
  {
    _id: 's02', tipo: 'meditacao', minutos: 10, objetivos: [],
    titulo: 'Meditação dos cinco sentidos',
    como: 'Olhe ao redor e nomeie 5 coisas que você vê, 4 que você pode tocar, 3 sons, 2 cheiros e 1 sabor. Depois feche os olhos e respire por alguns minutos.',
  },
  {
    _id: 's03', tipo: 'meditacao', minutos: 8, objetivos: ['passar_tempo'],
    titulo: 'Escaneamento do corpo',
    como: 'Deite-se ou sente-se. Leve a atenção dos pés até a cabeça, parte por parte, soltando a tensão de cada região. Se a mente fugir, volte para onde parou.',
  },
  {
    _id: 's04', tipo: 'leitura', minutos: 20, objetivos: ['ler'],
    titulo: 'Um capítulo no papel',
    como: 'Pegue um livro físico que está parado na estante e leia um capítulo inteiro. Deixe o celular em outro cômodo enquanto isso.',
  },
  {
    _id: 's05', tipo: 'leitura', minutos: 15, objetivos: ['ler', 'passar_tempo'],
    titulo: 'Leitura em voz alta',
    como: 'Escolha um poema ou uma crônica curta e leia em voz alta, devagar. Ler em voz alta ajuda a perceber o ritmo do texto.',
  },
  {
    _id: 's06', tipo: 'leitura', minutos: 30, objetivos: ['ler'],
    titulo: 'Visita à biblioteca ou ao sebo',
    como: 'Se puder sair, vá a uma biblioteca pública ou a um sebo perto de você e folheie três livros que nunca leu. Leve um para casa.',
  },
  {
    _id: 's07', tipo: 'estudo', minutos: 15, objetivos: ['estudar'],
    titulo: 'Resumo à mão',
    como: 'Pegue papel e caneta e escreva, sem consultar nada, o que você lembra do que estudou hoje. Depois confira o que faltou.',
  },
  {
    _id: 's08', tipo: 'estudo', minutos: 10, objetivos: ['estudar'],
    titulo: 'Explique para alguém',
    como: 'Conte para uma pessoa da sua casa, em poucas palavras, um assunto que você estudou. Se travar em algum ponto, é ali que vale revisar.',
  },
  {
    _id: 's09', tipo: 'estudo', minutos: 20, objetivos: ['estudar'],
    titulo: 'Cinco exercícios no caderno',
    como: 'Resolva cinco exercícios do assunto do dia no caderno, sem calculadora e sem pesquisa. Marque os que deram dúvida para perguntar depois.',
  },
  {
    _id: 's10', tipo: 'movimento', minutos: 15, objetivos: [],
    titulo: 'Caminhada sem fone',
    como: 'Dê uma volta no quarteirão, sem música e sem celular na mão. Repare em três coisas que você nunca tinha notado no caminho.',
  },
  {
    _id: 's11', tipo: 'movimento', minutos: 10, objetivos: [],
    titulo: 'Alongamento para quem ficou sentado',
    como: 'Gire os ombros 10 vezes, alongue o pescoço para cada lado por 20 segundos, estique os braços acima da cabeça e tente encostar as mãos nos pés.',
  },
  {
    _id: 's12', tipo: 'movimento', minutos: 20, objetivos: ['ver_conteudo', 'passar_tempo'],
    titulo: 'Dança de três músicas',
    como: 'Coloque três músicas de que você gosta e dance do jeito que quiser. Não precisa saber dançar: o objetivo é mexer o corpo.',
  },
  {
    _id: 's13', tipo: 'descanso', minutos: 20, objetivos: [],
    titulo: 'Cochilo curto',
    como: 'Deite-se por no máximo 20 minutos, com um despertador fora do alcance da mão. Cochilos curtos descansam sem deixar a pessoa mais sonolenta.',
  },
  {
    _id: 's14', tipo: 'descanso', minutos: 10, objetivos: [],
    titulo: 'Chá sem tela',
    como: 'Prepare um chá ou um café e tome devagar, sentado, sem celular nem televisão. Preste atenção no cheiro e na temperatura.',
  },
  {
    _id: 's15', tipo: 'descanso', minutos: 15, objetivos: ['passar_tempo'],
    titulo: 'Olhar pela janela',
    como: 'Fique 15 minutos olhando pela janela ou para o céu. Descansar a vista de longe alivia os olhos depois de muito tempo de tela.',
  },
  {
    _id: 's16', tipo: 'criatividade', minutos: 15, objetivos: [],
    titulo: 'Desenho cego',
    como: 'Escolha um objeto à sua frente e desenhe sem olhar para o papel. O resultado não importa: o exercício treina a observação.',
  },
  {
    _id: 's17', tipo: 'criatividade', minutos: 10, objetivos: ['ler'],
    titulo: 'Escreva o próximo capítulo',
    como: 'Pense no último texto que você leu e escreva à mão, em dez linhas, o que poderia acontecer depois.',
  },
  {
    _id: 's18', tipo: 'criatividade', minutos: 20, objetivos: ['ver_conteudo', 'passar_tempo'],
    titulo: 'Cozinhar algo simples',
    como: 'Prepare uma receita simples que você ainda não fez, como um pão de frigideira ou uma salada diferente. Cozinhar ocupa as mãos e a cabeça.',
  },
  {
    _id: 's19', tipo: 'conexao', minutos: 10, objetivos: [],
    titulo: 'Ligação, não mensagem',
    como: 'Ligue para alguém de quem você gosta e com quem não fala há algum tempo. Uma conversa de voz aproxima mais do que dez mensagens.',
  },
  {
    _id: 's20', tipo: 'conexao', minutos: 15, objetivos: ['ver_conteudo'],
    titulo: 'Conte o que você viu',
    como: 'Escolha uma curiosidade que você leu hoje no Ikai e conte para alguém pessoalmente. Pergunte o que a pessoa acha.',
  },
  {
    _id: 's21', tipo: 'conexao', minutos: 30, objetivos: ['passar_tempo'],
    titulo: 'Jogo de tabuleiro ou de cartas',
    como: 'Chame alguém da casa para uma partida de dominó, damas, baralho ou qualquer jogo de mesa que vocês tenham.',
  },
  {
    _id: 's22', tipo: 'natureza', minutos: 10, objetivos: [],
    titulo: 'Cuidar de uma planta',
    como: 'Regue as plantas da casa, tire folhas secas e veja se alguma precisa de sol. Se não tiver plantas, observe uma árvore da rua.',
  },
  {
    _id: 's23', tipo: 'natureza', minutos: 20, objetivos: ['estudar', 'ver_conteudo'],
    titulo: 'Observar o céu',
    como: 'À noite, procure a Lua e tente descobrir em que fase ela está. De dia, observe as nuvens e o caminho do Sol.',
  },
  {
    _id: 's24', tipo: 'natureza', minutos: 25, objetivos: [],
    titulo: 'Praça ou parque perto de casa',
    como: 'Vá até a praça ou o parque mais próximo e fique um tempo ali, sentado ou caminhando. Contato com áreas verdes ajuda a desacelerar.',
  },
];
