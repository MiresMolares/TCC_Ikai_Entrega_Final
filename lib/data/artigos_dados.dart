import 'artigo.dart';
import 'artigos_estudar.dart';
import 'artigos_estudar2.dart';
import 'artigos_ler.dart';
import 'artigos_ler2.dart';
import 'artigos_ver.dart';

/// ============================================================
/// BANCO DE ARTIGOS (TEMPORÁRIO, até existir o banco de dados)
/// ============================================================
///
/// Para adicionar um artigo, copie o modelo abaixo, cole no FIM da lista
/// `artigosDados` e preencha. Não precisa mexer em mais nenhum arquivo.
///
///   Artigo(
///     id: 'a031',                      // único; continue a numeração
///     objetivoId: 'ler',               // 'ver_conteudo' | 'ler' | 'estudar'
///     categoriaId: 'ler_romance',      // id de uma categoria do objetivo
///     nivel: 1,                        // 1 iniciante | 2 intermediário | 3 avançado
///     titulo: 'Título do artigo',
///     autor: 'Nome do autor',
///     resumo: 'Uma ou duas frases para o cartão.',
///     tags: ['assunto um', 'assunto dois'],
///     paragrafos: [
///       'Primeiro parágrafo.',
///       'Segundo parágrafo.',
///     ],
///   ),
///
/// Os ids válidos de objetivo e categoria estão em
/// lib/pages_configurar/objetivo_conteudo.dart, objetivo_leitura.dart e
/// objetivo_estudo.dart. O teste `flutter test` avisa se algum id estiver
/// errado ou repetido.
///
/// Todos os textos abaixo foram escritos para o Ikai.

/// Todo o acervo do app: os 66 primeiros artigos (abaixo) e os das listas
/// por objetivo (artigos_ver.dart, artigos_ler*.dart, artigos_estudar*.dart).
/// Cada categoria tem pelo menos 6 artigos (o teste confere).
const List<Artigo> artigosDados = [
  ...artigosOriginais,
  ...artigosVer,
  ...artigosLer,
  ...artigosLer2,
  ...artigosEstudar,
  ...artigosEstudar2,
];

const List<Artigo> artigosOriginais = [
  // ------------------------------------------------------------
  // VER CONTEÚDO
  // ------------------------------------------------------------
  Artigo(
    id: 'a001',
    objetivoId: 'ver_conteudo',
    categoriaId: 'ver_cientifico',
    nivel: 1,
    titulo: 'Por que o céu é azul',
    autor: 'Equipe Ikai',
    resumo:
        'A luz do Sol parece branca, mas carrega todas as cores. O que '
        'acontece com ela na atmosfera explica o azul que vemos.',
    tags: ['física', 'luz', 'atmosfera'],
    paragrafos: [
      'A luz do Sol é a mistura de todas as cores. Ao entrar na atmosfera, '
          'ela encontra moléculas de gases, como nitrogênio e oxigênio, que '
          'espalham a luz em todas as direções. Esse fenômeno se chama '
          'espalhamento de Rayleigh.',
      'As cores de comprimento de onda curto, como o azul, são espalhadas '
          'com muito mais intensidade do que as de comprimento longo, como o '
          'vermelho. Por isso, para onde quer que você olhe no céu, chega '
          'até você luz azul espalhada.',
      'No pôr do sol, a luz atravessa um caminho muito maior na atmosfera. '
          'Quase todo o azul é espalhado para longe da sua linha de visão e '
          'sobram os tons de laranja e vermelho.',
    ],
  ),
  Artigo(
    id: 'a002',
    objetivoId: 'ver_conteudo',
    categoriaId: 'ver_cultura',
    nivel: 1,
    titulo: 'Capoeira: luta, dança e resistência',
    autor: 'Equipe Ikai',
    resumo:
        'Nascida no Brasil entre pessoas escravizadas, a capoeira é hoje '
        'reconhecida como patrimônio cultural.',
    tags: ['cultura brasileira', 'patrimônio', 'música'],
    paragrafos: [
      'A capoeira é uma manifestação cultural brasileira que reúne luta, '
          'dança, música e jogo. Ela se formou entre africanos escravizados '
          'e seus descendentes, e durante muito tempo foi perseguida.',
      'A roda de capoeira é organizada em torno de instrumentos como o '
          'berimbau e o pandeiro, e das cantigas que os jogadores respondem '
          'em coro. O ofício dos mestres de capoeira foi registrado como '
          'patrimônio cultural imaterial do Brasil em 2008, e a roda de '
          'capoeira foi reconhecida pela Unesco em 2014.',
    ],
  ),
  Artigo(
    id: 'a003',
    objetivoId: 'ver_conteudo',
    categoriaId: 'ver_jogos',
    nivel: 2,
    titulo: 'O que o xadrez ensina sobre decisões',
    autor: 'Equipe Ikai',
    resumo:
        'Um jogo com mais de mil anos que treina a habilidade de prever '
        'consequências antes de agir.',
    tags: ['xadrez', 'estratégia', 'raciocínio'],
    paragrafos: [
      'O xadrez descende do chaturanga, um jogo surgido na Índia por volta '
          'do século VI. Séculos depois, chegou à Europa e ganhou as regras '
          'que conhecemos hoje.',
      'Cada lance muda as opções de quem joga e de quem enfrenta. Por isso, '
          'jogar bem exige imaginar a resposta do outro antes de mexer uma '
          'peça. Esse hábito de pensar na consequência de uma decisão, e não '
          'só no ganho imediato, é útil bem fora do tabuleiro.',
    ],
  ),
  Artigo(
    id: 'a004',
    objetivoId: 'ver_conteudo',
    categoriaId: 'ver_noticia',
    nivel: 2,
    titulo: 'Três perguntas antes de compartilhar uma notícia',
    autor: 'Equipe Ikai',
    resumo: 'Um roteiro simples para não espalhar informação falsa sem querer.',
    tags: ['educação midiática', 'checagem', 'informação'],
    paragrafos: [
      'Antes de compartilhar uma notícia, faça três perguntas. Quem '
          'publicou? Veja se o veículo ou a pessoa tem histórico e se '
          'assina o que escreve.',
      'Qual é a fonte? Uma boa notícia diz de onde veio a informação: um '
          'documento, um especialista, um dado oficial. E outros veículos '
          'independentes confirmam o mesmo fato?',
      'Por fim, confira a data. Textos antigos circulam como se fossem '
          'novos e causam confusão. Se alguma resposta ficar em aberto, '
          'espere antes de repassar.',
    ],
  ),
  Artigo(
    id: 'a005',
    objetivoId: 'ver_conteudo',
    categoriaId: 'ver_esporte',
    nivel: 1,
    titulo: 'A primeira Copa do Mundo',
    autor: 'Equipe Ikai',
    resumo:
        'Em 1930, no Uruguai, treze seleções disputaram o primeiro mundial '
        'de futebol.',
    tags: ['futebol', 'história do esporte', 'copa do mundo'],
    paragrafos: [
      'A primeira Copa do Mundo de futebol aconteceu em 1930, no Uruguai. '
          'Foram treze seleções, e muitas das europeias enfrentaram uma '
          'longa viagem de navio para participar.',
      'O Uruguai, país-sede, venceu a final contra a Argentina por 4 a 2 e '
          'ficou com o primeiro título. O Brasil também esteve lá, mas foi '
          'eliminado ainda na primeira fase.',
    ],
  ),
  Artigo(
    id: 'a006',
    objetivoId: 'ver_conteudo',
    categoriaId: 'ver_curiosidades',
    nivel: 1,
    titulo: 'O mel que quase não estraga',
    autor: 'Equipe Ikai',
    resumo:
        'Pouca água, acidez e uma substância produzida pelas abelhas ajudam '
        'o mel a durar muito tempo.',
    tags: ['alimentos', 'química', 'curiosidade'],
    paragrafos: [
      'O mel guardado de forma correta pode durar muito tempo sem estragar. '
          'Isso acontece por alguns motivos juntos. Ele tem pouquíssima água, '
          'e a maioria das bactérias e fungos precisa de água para crescer.',
      'Além disso, o mel é ácido e as abelhas adicionam a ele uma enzima que '
          'produz pequenas quantidades de peróxido de hidrogênio, o que '
          'dificulta a vida dos microrganismos.',
      'Com o tempo, o mel pode cristalizar. Isso não significa que estragou: '
          'basta aquecê-lo suavemente em banho-maria para ele voltar ao '
          'estado líquido.',
    ],
  ),

  // ------------------------------------------------------------
  // LER
  // ------------------------------------------------------------
  Artigo(
    id: 'a007',
    objetivoId: 'ler',
    categoriaId: 'ler_romance',
    nivel: 2,
    titulo: 'Dom Casmurro e a dúvida que atravessa gerações',
    autor: 'Equipe Ikai',
    resumo:
        'No romance de Machado de Assis, a dúvida sobre Capitu é mais '
        'importante do que a resposta.',
    tags: ['machado de assis', 'literatura brasileira', 'realismo'],
    paragrafos: [
      'Publicado em 1899, Dom Casmurro é narrado por Bentinho, que anos '
          'depois conta a própria história e tenta convencer o leitor de que '
          'foi traído por Capitu, a amiga de infância com quem se casou.',
      'O truque de Machado de Assis é que tudo chega até nós pelo ponto de '
          'vista de um narrador interessado. Não há prova definitiva, e é '
          'essa dúvida que mantém o livro vivo: cada leitor precisa decidir '
          'em quem confiar.',
    ],
  ),
  Artigo(
    id: 'a008',
    objetivoId: 'ler',
    categoriaId: 'ler_fantasia',
    nivel: 1,
    titulo: 'O que faz um mundo de fantasia parecer real',
    autor: 'Equipe Ikai',
    resumo:
        'Regras claras, história e detalhes fazem um mundo inventado '
        'parecer um lugar de verdade.',
    tags: ['worldbuilding', 'tolkien', 'fantasia'],
    paragrafos: [
      'Um mundo de fantasia convence quando segue regras. Se a magia pode '
          'tudo, nada tem peso. Se ela tem limites e custos, cada escolha dos '
          'personagens importa.',
      'J. R. R. Tolkien, autor de O Senhor dos Anéis, era filólogo, '
          'especialista em línguas. Ele criou idiomas inteiros antes de '
          'escrever as histórias, e isso deu à Terra Média uma sensação de '
          'passado e de cultura que poucos mundos inventados alcançam.',
    ],
  ),
  Artigo(
    id: 'a009',
    objetivoId: 'ler',
    categoriaId: 'ler_suspense',
    nivel: 1,
    titulo: 'Como o suspense prende o leitor',
    autor: 'Equipe Ikai',
    resumo:
        'O segredo está menos no que acontece e mais no que o autor decide '
        'não contar ainda.',
    tags: ['narrativa', 'mistério', 'técnica'],
    paragrafos: [
      'O suspense nasce de uma lacuna de informação. O leitor sabe que '
          'falta algo, e a vontade de preencher essa lacuna faz com que ele '
          'vire a página.',
      'Autores de romances policiais, como Agatha Christie, constroem '
          'pistas que parecem inocentes e só ganham sentido no final. Outro '
          'recurso comum é encerrar um capítulo com uma pergunta aberta. '
          'Quando você notar essas técnicas, vai ler com ainda mais prazer.',
    ],
  ),
  Artigo(
    id: 'a010',
    objetivoId: 'ler',
    categoriaId: 'ler_fc',
    nivel: 2,
    titulo: 'Frankenstein, a origem da ficção científica moderna',
    autor: 'Equipe Ikai',
    resumo:
        'Publicado em 1818, o livro de Mary Shelley já discutia os limites '
        'da ciência e a responsabilidade de quem cria.',
    tags: ['mary shelley', 'ficção científica', 'ética'],
    paragrafos: [
      'Frankenstein, de Mary Shelley, foi publicado em 1818 e é muitas '
          'vezes apontado como um dos primeiros romances de ficção '
          'científica. A autora começou a escrevê-lo ainda muito jovem.',
      'Na história, o cientista Victor Frankenstein dá vida a uma criatura '
          'e depois a abandona. O livro levanta uma pergunta que continua '
          'atual: quem cria uma tecnologia é responsável pelo que ela faz '
          'no mundo?',
    ],
  ),
  Artigo(
    id: 'a011',
    objetivoId: 'ler',
    categoriaId: 'ler_horror',
    nivel: 1,
    titulo: 'Por que gostamos de sentir medo lendo',
    autor: 'Equipe Ikai',
    resumo:
        'Uma história assustadora permite sentir medo com a segurança de '
        'quem sabe que está só lendo.',
    tags: ['horror', 'edgar allan poe', 'emoções'],
    paragrafos: [
      'A literatura de horror oferece algo curioso: o medo sem o perigo '
          'real. Dentro da história, tudo é ameaçador. Do lado de fora, você '
          'está seguro no sofá.',
      'Edgar Allan Poe explorou isso como poucos. Em contos como O Gato '
          'Preto, de 1843, o horror não vem de monstros, mas da mente '
          'perturbada do narrador, o que torna a leitura ainda mais '
          'inquietante.',
    ],
  ),
  Artigo(
    id: 'a012',
    objetivoId: 'ler',
    categoriaId: 'ler_terror',
    nivel: 2,
    titulo: 'Terror e horror: qual é a diferença',
    autor: 'Equipe Ikai',
    resumo:
        'Dois nomes parecidos para dois efeitos diferentes: sugerir e '
        'mostrar.',
    tags: ['terror', 'gótico', 'teoria literária'],
    paragrafos: [
      'A escritora inglesa Ann Radcliffe, autora de romances góticos do '
          'fim do século XVIII, é associada à distinção entre terror e '
          'horror. Para ela, o terror é a expectativa: a sombra, o ruído, '
          'a ameaça que se sugere e expande a imaginação.',
      'O horror, por sua vez, é o choque diante do que se mostra de forma '
          'explícita. Muitos leitores preferem o terror justamente porque '
          'a própria imaginação costuma ser mais assustadora do que '
          'qualquer descrição.',
    ],
  ),
  Artigo(
    id: 'a013',
    objetivoId: 'ler',
    categoriaId: 'ler_religioso',
    nivel: 2,
    titulo: 'Textos sagrados: um olhar de leitor',
    autor: 'Equipe Ikai',
    resumo:
        'Como ler um texto religioso com atenção ao gênero, à época e à '
        'língua em que foi escrito.',
    tags: ['religião', 'leitura', 'história'],
    paragrafos: [
      'Muitas tradições possuem textos sagrados, lidos por devoção, por '
          'estudo ou por interesse histórico e literário. Independentemente '
          'da crença de quem lê, vale prestar atenção ao contexto.',
      'Em um mesmo livro podem existir poesia, leis, narrativas e cartas, '
          'e cada gênero pede uma leitura diferente. Também importam a '
          'época em que o texto surgiu e a língua original, já que toda '
          'tradução envolve escolhas. Ler com essa atenção ajuda a '
          'respeitar o texto e a entender melhor quem o lê.',
    ],
  ),
  Artigo(
    id: 'a014',
    objetivoId: 'ler',
    categoriaId: 'ler_distopia',
    nivel: 3,
    titulo: '1984: a vigilância como tema',
    autor: 'Equipe Ikai',
    resumo:
        'O romance de George Orwell, de 1949, criou palavras e imagens que '
        'usamos até hoje para falar de controle.',
    tags: ['george orwell', 'distopia', 'vigilância'],
    paragrafos: [
      'Publicado em 1949, 1984 se passa em um país onde o Estado observa '
          'todos o tempo todo. A figura do Grande Irmão, os cartazes que '
          'dizem que ele está de olho em você, virou símbolo de vigilância.',
      'Orwell também mostra que controlar a linguagem é controlar o '
          'pensamento. Na história, a língua oficial, a novafala, reduz o '
          'vocabulário para que certas ideias nem possam ser formuladas. '
          'É um bom livro para quem quer refletir sobre informação e '
          'poder.',
    ],
  ),
  Artigo(
    id: 'a015',
    objetivoId: 'ler',
    categoriaId: 'ler_aventura',
    nivel: 1,
    titulo: 'A Ilha do Tesouro e o imaginário dos piratas',
    autor: 'Equipe Ikai',
    resumo:
        'O clássico de Robert Louis Stevenson ajudou a criar a imagem '
        'popular do pirata.',
    tags: ['robert louis stevenson', 'clássicos', 'piratas'],
    paragrafos: [
      'A Ilha do Tesouro, de Robert Louis Stevenson, foi publicada em livro '
          'em 1883. Conta a história do jovem Jim Hawkins, que encontra um '
          'mapa e embarca em uma viagem em busca de um tesouro.',
      'Muito do que imaginamos sobre piratas vem desse livro: o mapa do '
          'tesouro, a ilha misteriosa e o papagaio no ombro do carismático '
          'e perigoso Long John Silver. É aventura clássica, de leitura '
          'ágil.',
    ],
  ),
  Artigo(
    id: 'a016',
    objetivoId: 'ler',
    categoriaId: 'ler_dp',
    nivel: 1,
    titulo: 'Hábitos pequenos, mudança grande',
    autor: 'Equipe Ikai',
    resumo:
        'Começar pequeno costuma funcionar melhor do que tentar mudar '
        'tudo de uma vez.',
    tags: ['hábitos', 'desenvolvimento pessoal', 'rotina'],
    paragrafos: [
      'Muita gente tenta mudar de vida em um dia e desiste na semana '
          'seguinte. Uma alternativa é escolher um hábito tão pequeno que '
          'seja difícil recusar, como ler uma página por dia.',
      'O ganho de um dia é quase invisível, mas a repetição soma. Além '
          'disso, é mais fácil manter um hábito quando ele está ligado a '
          'algo que você já faz, como ler logo depois do café. Comece '
          'pequeno e aumente só quando ficar fácil.',
    ],
  ),
  Artigo(
    id: 'a017',
    objetivoId: 'ler',
    categoriaId: 'ler_tecnico',
    nivel: 2,
    titulo: 'Como ler um texto técnico sem se perder',
    autor: 'Equipe Ikai',
    resumo:
        'Uma estratégia em três passos para não travar diante de um texto '
        'denso.',
    tags: ['estudo', 'leitura técnica', 'método'],
    paragrafos: [
      'Textos técnicos não precisam ser lidos do começo ao fim de uma só '
          'vez. Primeiro, passe os olhos pelo resumo, pelos títulos e pelas '
          'conclusões para ter um mapa do que vem pela frente.',
      'Depois, leia com atenção as partes que interessam e pare nos '
          'exemplos: tente refazê-los sozinho. Por fim, explique o conteúdo '
          'com suas palavras, em voz alta ou por escrito. Se não conseguir, '
          'você sabe exatamente o que precisa reler.',
    ],
  ),
  Artigo(
    id: 'a018',
    objetivoId: 'ler',
    categoriaId: 'ler_biografia',
    nivel: 2,
    titulo: 'Quarto de Despejo e a voz de quem escreve a própria vida',
    autor: 'Equipe Ikai',
    resumo:
        'O diário de Carolina Maria de Jesus mostra a vida na favela pelos '
        'olhos de quem a viveu.',
    tags: ['carolina maria de jesus', 'diário', 'literatura brasileira'],
    paragrafos: [
      'Quarto de Despejo foi publicado em 1960 e reúne os diários de '
          'Carolina Maria de Jesus, moradora da favela do Canindé, em São '
          'Paulo. Catadora de papel, ela escrevia à noite, depois do '
          'trabalho.',
      'O livro é um relato em primeira pessoa sobre fome, trabalho e '
          'dignidade. Ele lembra que relatos de vida não são só de '
          'pessoas famosas: quem viveu a experiência tem uma perspectiva '
          'que nenhuma outra fonte consegue substituir.',
    ],
  ),

  // ------------------------------------------------------------
  // ESTUDAR
  // ------------------------------------------------------------
  Artigo(
    id: 'a019',
    objetivoId: 'estudar',
    categoriaId: 'estudar_matematica',
    nivel: 1,
    titulo: 'Problemas de matemática: leia duas vezes, resolva uma',
    autor: 'Equipe Ikai',
    resumo:
        'Um método simples para organizar um problema antes de fazer '
        'qualquer conta.',
    tags: ['método de estudo', 'resolução de problemas', 'matemática'],
    paragrafos: [
      'Muitos erros em matemática acontecem antes da primeira conta, na '
          'leitura do enunciado. Leia o problema duas vezes: na primeira, '
          'entenda a história; na segunda, sublinhe os dados e a pergunta.',
      'Em seguida, faça um desenho ou um esquema e estime a ordem de '
          'grandeza da resposta. Só então calcule. No final, volte à '
          'pergunta e veja se o resultado faz sentido. Uma resposta '
          'negativa para uma quantidade de pessoas, por exemplo, mostra '
          'que algo deu errado.',
    ],
  ),
  Artigo(
    id: 'a020',
    objetivoId: 'estudar',
    categoriaId: 'estudar_lp',
    nivel: 1,
    titulo: 'Crase sem medo: a regra do vou a, volto da',
    autor: 'Equipe Ikai',
    resumo: 'Um truque clássico para decidir quando usar o acento grave.',
    tags: ['gramática', 'crase', 'português'],
    paragrafos: [
      'A crase é a fusão da preposição a com o artigo a. Um truque famoso '
          'ajuda a decidir: troque o verbo por ir e vir. Se você diz "vou '
          'a" e "volto da", há crase: "Vou à escola, volto da escola".',
      'Se você diz "vou a" e "volto de", não há crase: "Vou a Roma, volto '
          'de Roma". Lembre também que não se usa crase antes de verbos nem '
          'antes de palavras masculinas, exceto em expressões como "à moda '
          'de".',
    ],
  ),
  Artigo(
    id: 'a021',
    objetivoId: 'estudar',
    categoriaId: 'estudar_ingles',
    nivel: 2,
    titulo: 'False friends: palavras que enganam',
    autor: 'Equipe Ikai',
    resumo:
        'Palavras do inglês que parecem português, mas significam outra '
        'coisa.',
    tags: ['vocabulário', 'inglês', 'false friends'],
    paragrafos: [
      'False friends são palavras parecidas entre dois idiomas, mas com '
          'sentidos diferentes. Em inglês, "pretend" não é pretender: '
          'significa fingir. "Actually" não é atualmente: quer dizer na '
          'verdade.',
      'Outros exemplos: "library" é biblioteca, não livraria (que é '
          '"bookstore"), e "parents" são os pais, não os parentes (que são '
          '"relatives"). Anote os que você já confundiu e revise de vez em '
          'quando.',
    ],
  ),
  Artigo(
    id: 'a022',
    objetivoId: 'estudar',
    categoriaId: 'estudar_artes',
    nivel: 1,
    titulo: 'Cores quentes e cores frias',
    autor: 'Equipe Ikai',
    resumo: 'Como a temperatura das cores muda a sensação de uma imagem.',
    tags: ['teoria das cores', 'artes visuais', 'composição'],
    paragrafos: [
      'Em artes visuais, vermelho, laranja e amarelo são chamados de cores '
          'quentes, enquanto azul, verde e violeta são as frias. Essa '
          'divisão não é de temperatura real, e sim de sensação.',
      'As cores quentes tendem a parecer próximas e energéticas, e as '
          'frias, distantes e calmas. Artistas usam isso para dar '
          'profundidade a uma pintura e guiar o olhar: um detalhe quente '
          'em uma paisagem fria chama atenção imediatamente.',
    ],
  ),
  Artigo(
    id: 'a023',
    objetivoId: 'estudar',
    categoriaId: 'estudar_historia',
    nivel: 2,
    titulo: 'Revolução Francesa: o que mudou em 1789',
    autor: 'Equipe Ikai',
    resumo:
        'Três ideias para entender o início de um processo que mudou o mundo.',
    tags: ['revolução francesa', 'idade contemporânea', 'direitos'],
    paragrafos: [
      'A Revolução Francesa começou em 1789, em um país com forte '
          'desigualdade e crise econômica. A tomada da Bastilha, em 14 de '
          'julho, tornou-se o símbolo do início do processo.',
      'Três ideias ajudam a entender seu impacto. A primeira é a de que o '
          'poder vem do povo, e não do rei por direito divino. A segunda é '
          'a Declaração dos Direitos do Homem e do Cidadão, de agosto de '
          '1789. A terceira é o lema liberdade, igualdade e fraternidade, '
          'que inspirou movimentos em muitos outros países.',
    ],
  ),
  Artigo(
    id: 'a024',
    objetivoId: 'estudar',
    categoriaId: 'estudar_geografia',
    nivel: 2,
    titulo: 'Latitude e longitude: como localizar qualquer ponto',
    autor: 'Equipe Ikai',
    resumo:
        'As duas medidas que formam o endereço de qualquer lugar do planeta.',
    tags: ['coordenadas', 'cartografia', 'geografia'],
    paragrafos: [
      'A latitude indica a distância ao norte ou ao sul da linha do '
          'Equador, que vale zero grau. Ela vai de 0 a 90 graus em cada '
          'direção, chegando aos polos.',
      'A longitude indica a distância a leste ou a oeste do meridiano de '
          'Greenwich, também de zero grau, e vai até 180 graus. Juntas, '
          'latitude e longitude formam as coordenadas geográficas, usadas '
          'por mapas e aplicativos de localização.',
    ],
  ),
  Artigo(
    id: 'a025',
    objetivoId: 'estudar',
    categoriaId: 'estudar_filosofia',
    nivel: 2,
    titulo: 'Sócrates e a arte de perguntar',
    autor: 'Equipe Ikai',
    resumo:
        'Um filósofo que quase não escreveu nada mudou a forma de '
        'investigar ideias.',
    tags: ['sócrates', 'filosofia antiga', 'método'],
    paragrafos: [
      'Sócrates viveu em Atenas, no século V a.C., e não deixou nada '
          'escrito. Conhecemos suas ideias principalmente pelos diálogos '
          'de seu discípulo Platão.',
      'Seu método consistia em fazer perguntas até que a pessoa percebesse '
          'contradições nas próprias respostas. A famosa ideia de que ele '
          'só sabia que nada sabia resume essa postura: reconhecer a '
          'própria ignorância é o primeiro passo para aprender.',
    ],
  ),
  Artigo(
    id: 'a026',
    objetivoId: 'estudar',
    categoriaId: 'estudar_sociologia',
    nivel: 3,
    titulo: 'Fato social, segundo Durkheim',
    autor: 'Equipe Ikai',
    resumo: 'O conceito que ajudou a transformar a sociologia em ciência.',
    tags: ['durkheim', 'sociologia clássica', 'conceitos'],
    paragrafos: [
      'Émile Durkheim, em As Regras do Método Sociológico, de 1895, '
          'definiu o fato social como maneiras de agir, pensar e sentir que '
          'existem fora do indivíduo e exercem sobre ele uma força de '
          'coerção.',
      'Exemplos são as leis, a língua que falamos e os costumes. Ninguém '
          'escolhe a língua em que nasce, mas ela molda o pensamento. Para '
          'Durkheim, a sociologia deve estudar esses fatos como coisas, '
          'com observação e método.',
    ],
  ),
  Artigo(
    id: 'a027',
    objetivoId: 'estudar',
    categoriaId: 'estudar_ef',
    nivel: 1,
    titulo: 'Aquecimento: por que cinco minutos importam',
    autor: 'Equipe Ikai',
    resumo:
        'O que acontece no corpo quando você se prepara antes de se exercitar.',
    tags: ['exercício', 'saúde', 'preparação'],
    paragrafos: [
      'O aquecimento aumenta gradualmente os batimentos cardíacos e a '
          'temperatura dos músculos, e prepara as articulações para o '
          'movimento. Em geral, ele ajuda o corpo a render melhor e a '
          'reduzir o risco de lesões.',
      'Um aquecimento simples pode ter cinco minutos de caminhada ou '
          'trote leve, círculos com braços e quadris, e repetições '
          'lentas do movimento que será feito depois. Se tiver dores '
          'persistentes, procure um profissional de saúde.',
    ],
  ),
  Artigo(
    id: 'a028',
    objetivoId: 'estudar',
    categoriaId: 'estudar_biologia',
    nivel: 1,
    titulo: 'Fotossíntese em poucas linhas',
    autor: 'Equipe Ikai',
    resumo: 'Como as plantas transformam luz em alimento e liberam oxigênio.',
    tags: ['plantas', 'energia', 'biologia celular'],
    paragrafos: [
      'A fotossíntese é o processo pelo qual plantas, algas e algumas '
          'bactérias usam a energia da luz para produzir açúcar a partir '
          'de gás carbônico e água.',
      'Nas plantas, ela ocorre nos cloroplastos, que contêm clorofila, o '
          'pigmento verde que absorve a luz. Como resultado, a planta '
          'produz glicose, que serve de alimento, e libera oxigênio para '
          'a atmosfera.',
    ],
  ),
  Artigo(
    id: 'a029',
    objetivoId: 'estudar',
    categoriaId: 'estudar_fisica',
    nivel: 2,
    titulo: 'Inércia: a primeira lei de Newton',
    autor: 'Equipe Ikai',
    resumo: 'Por que você é jogado para frente quando o carro freia.',
    tags: ['mecânica', 'newton', 'movimento'],
    paragrafos: [
      'A primeira lei de Newton diz que um corpo em repouso continua em '
          'repouso, e um corpo em movimento continua em movimento retilíneo '
          'e com velocidade constante, a menos que uma força resultante '
          'atue sobre ele. Essa tendência se chama inércia.',
      'Quando um carro freia bruscamente, seu corpo tende a continuar '
          'andando para frente. É por isso que o cinto de segurança é '
          'importante: ele aplica a força que impede o corpo de seguir '
          'em movimento.',
    ],
  ),
  Artigo(
    id: 'a030',
    objetivoId: 'estudar',
    categoriaId: 'estudar_quimica',
    nivel: 2,
    titulo: 'Tabela periódica: como ler',
    autor: 'Equipe Ikai',
    resumo: 'Linhas, colunas e o que a posição de um elemento revela.',
    tags: ['elementos químicos', 'mendeleev', 'tabela periódica'],
    paragrafos: [
      'O químico russo Dmitri Mendeleev propôs, em 1869, uma organização '
          'dos elementos que previa até a existência de elementos ainda '
          'desconhecidos. Hoje, a tabela é ordenada pelo número atômico, '
          'ou seja, pela quantidade de prótons.',
      'As linhas horizontais são chamadas de períodos, e as colunas, de '
          'grupos ou famílias. Elementos do mesmo grupo costumam ter '
          'comportamentos químicos parecidos. Por isso, a posição de um '
          'elemento já diz muito sobre ele.',
    ],
  ),
  // Conteúdos de estudo vindos do Explorar da equipe (assets/conteudos.json).
  Artigo(
    id: 'a031',
    objetivoId: 'estudar',
    categoriaId: 'estudar_geografia',
    nivel: 1,
    titulo: 'Conhecendo os continentes',
    autor: 'Equipe Ikai',
    resumo: 'Aprenda quais são os continentes e suas características.',
    tags: ['dica', 'geografia'],
    paragrafos: [
      'A Terra possui seis continentes tradicionalmente considerados no modelo geográfico mais utilizado no Brasil: América, África, Europa, Ásia, Oceania e Antártida.',
      'AMÉRICA: possui grande diversidade de paisagens, culturas e climas.',
      'ÁFRICA: é conhecida por sua diversidade cultural e por paisagens como o deserto do Saara.',
      'EUROPA: apresenta grande diversidade histórica, cultural e econômica.',
      'ÁSIA: é o maior continente em extensão territorial e população.',
      'OCEANIA: reúne a Austrália, a Nova Zelândia e diversas ilhas do Pacífico.',
      'ANTÁRTIDA: é o continente mais frio do planeta e possui grandes áreas cobertas de gelo.',
      'PARA REFLETIR: em qual continente está localizado o Brasil?',
    ],
  ),
  Artigo(
    id: 'a032',
    objetivoId: 'estudar',
    categoriaId: 'estudar_geografia',
    nivel: 1,
    titulo: 'O que é clima e tempo?',
    autor: 'Equipe Ikai',
    resumo:
        'Entenda a diferença entre as condições do dia e o clima de uma região.',
    tags: ['material de estudo', 'geografia'],
    paragrafos: [
      'TEMPO ATMOSFÉRICO: representa as condições da atmosfera em determinado momento. Por exemplo: hoje está chovendo, amanhã pode fazer sol.',
      'CLIMA: representa o comportamento habitual das condições atmosféricas de uma região observado durante longos períodos.',
      'ELEMENTOS DO CLIMA:',
      '1. Temperatura: indica o quanto o ar está quente ou frio.\n2. Umidade: quantidade de vapor de água presente no ar.\n3. Pressão atmosférica: força exercida pelo peso do ar.\n4. Ventos: movimentação do ar.\n5. Precipitação: água que cai da atmosfera, como chuva, neve ou granizo.',
      'EXEMPLO: dizer que hoje está fazendo 30 graus é falar sobre o tempo. Dizer que uma região possui clima tropical é falar sobre seu clima.',
    ],
  ),
  Artigo(
    id: 'a033',
    objetivoId: 'estudar',
    categoriaId: 'estudar_geografia',
    nivel: 1,
    titulo: 'Orientação e pontos cardeais',
    autor: 'Equipe Ikai',
    resumo: 'Aprenda a identificar as direções e se localizar no espaço.',
    tags: ['exercício', 'geografia'],
    paragrafos: [
      'Os pontos cardeais são utilizados para orientação geográfica.',
      'NORTE (N): direção de referência indicada nas partes superiores da maioria dos mapas.',
      'SUL (S): direção oposta ao norte.',
      'LESTE (L): direção em que o Sol nasce aproximadamente.',
      'OESTE (O): direção em que o Sol se põe aproximadamente.',
      'EXEMPLO PRÁTICO:\nImagine que você está olhando para o norte. O leste estará à sua direita e o oeste à sua esquerda.',
      'DESAFIO:\n1. Qual ponto cardeal é oposto ao norte?\n2. Em qual direção o Sol nasce aproximadamente?\n3. Qual direção fica à sua esquerda quando você olha para o norte?',
      'RESPOSTAS: 1. Sul. 2. Leste. 3. Oeste.',
    ],
  ),
  Artigo(
    id: 'a034',
    objetivoId: 'estudar',
    categoriaId: 'estudar_matematica',
    nivel: 1,
    titulo: 'Aprendendo a somar',
    autor: 'Equipe Ikai',
    resumo: 'Entenda a adição com exemplos simples do cotidiano.',
    tags: ['material de estudo', 'matemática'],
    paragrafos: [
      'A ADIÇÃO é uma operação matemática utilizada para juntar quantidades.',
      'SÍMBOLO: +',
      'EXEMPLO 1:\n3 + 2 = 5\nSe você tem 3 maçãs e recebe mais 2, passa a ter 5 maçãs.',
      'EXEMPLO 2:\n10 + 5 = 15',
      'EXEMPLO 3:\n24 + 13 = 37',
      'COMO FAZER:\n24 + 13\nPrimeiro somamos as unidades: 4 + 3 = 7.\nDepois somamos as dezenas: 2 + 1 = 3.\nResultado: 37.',
      'PRATIQUE:\n1. 5 + 4 = ?\n2. 12 + 8 = ?\n3. 25 + 15 = ?',
      'RESPOSTAS: 1. 9. 2. 20. 3. 40.',
    ],
  ),
  Artigo(
    id: 'a035',
    objetivoId: 'estudar',
    categoriaId: 'estudar_matematica',
    nivel: 1,
    titulo: 'Subtração sem complicação',
    autor: 'Equipe Ikai',
    resumo: 'Aprenda a retirar quantidades e calcular diferenças.',
    tags: ['material de estudo', 'matemática'],
    paragrafos: [
      'A SUBTRAÇÃO é utilizada quando queremos retirar uma quantidade ou descobrir a diferença entre dois valores.',
      'SÍMBOLO: -',
      'EXEMPLO 1:\n8 - 3 = 5\nSe você tem 8 balas e entrega 3, ficam 5 balas.',
      'EXEMPLO 2:\n15 - 7 = 8',
      'EXEMPLO 3:\n35 - 12 = 23',
      'COMO FAZER:\n35 - 12\nUnidades: 5 - 2 = 3.\nDezenas: 3 - 1 = 2.\nResultado: 23.',
      'PRATIQUE:\n1. 9 - 4 = ?\n2. 20 - 8 = ?\n3. 50 - 25 = ?',
      'RESPOSTAS: 1. 5. 2. 12. 3. 25.',
    ],
  ),
  Artigo(
    id: 'a036',
    objetivoId: 'estudar',
    categoriaId: 'estudar_matematica',
    nivel: 1,
    titulo: 'Multiplicação e divisão na prática',
    autor: 'Equipe Ikai',
    resumo: 'Aprenda a multiplicar e dividir com situações do cotidiano.',
    tags: ['exercício', 'matemática'],
    paragrafos: [
      'MULTIPLICAÇÃO:\nÉ uma forma de somar o mesmo número várias vezes.',
      'EXEMPLO:\n4 x 3 = 12\nIsso significa somar 4 três vezes: 4 + 4 + 4 = 12.',
      'OUTRO EXEMPLO:\n5 x 6 = 30.',
      'DIVISÃO:\nÉ utilizada para repartir uma quantidade em partes iguais.',
      'EXEMPLO:\n12 ÷ 3 = 4.\nSe você divide 12 balas igualmente entre 3 pessoas, cada uma recebe 4.',
      'OUTRO EXEMPLO:\n20 ÷ 5 = 4.',
      'PRATIQUE:\n1. 3 x 4 = ?\n2. 7 x 5 = ?\n3. 18 ÷ 3 = ?\n4. 24 ÷ 6 = ?',
      'RESPOSTAS: 1. 12. 2. 35. 3. 6. 4. 4.',
    ],
  ),
  Artigo(
    id: 'a037',
    objetivoId: 'estudar',
    categoriaId: 'estudar_ingles',
    nivel: 1,
    titulo: 'Primeira conversa em inglês',
    autor: 'Equipe Ikai',
    resumo: 'Aprenda a cumprimentar alguém e iniciar uma conversa.',
    tags: ['material de estudo', 'inglês'],
    paragrafos: [
      'EXPRESSÕES BÁSICAS:',
      'Hello! = Olá!\nHi! = Oi!\nGood morning! = Bom dia!\nGood afternoon! = Boa tarde!\nGood evening! = Boa noite! (cumprimento)\nHow are you? = Como você está?\nI\'m fine, thanks. = Estou bem, obrigado(a).\nAnd you? = E você?\nNice to meet you! = Prazer em conhecer você!',
      'EXEMPLO DE CONVERSA:',
      'Anna: Hello! How are you?\nTradução: Olá! Como você está?',
      'John: Hi! I\'m fine, thanks. And you?\nTradução: Oi! Estou bem, obrigado. E você?',
      'Anna: I\'m great! Nice to meet you!\nTradução: Estou ótima! Prazer em conhecer você!',
      'John: Nice to meet you too!\nTradução: Prazer em conhecer você também!',
      'DICA: pratique falando as frases em voz alta para desenvolver sua pronúncia.',
    ],
  ),
  Artigo(
    id: 'a038',
    objetivoId: 'estudar',
    categoriaId: 'estudar_ingles',
    nivel: 1,
    titulo: 'Inglês para situações do dia a dia',
    autor: 'Equipe Ikai',
    resumo: 'Conheça frases úteis para conversar em diferentes situações.',
    tags: ['material de estudo', 'inglês'],
    paragrafos: [
      'NO DIA A DIA:',
      'What\'s your name? = Qual é o seu nome?\nMy name is Lucas. = Meu nome é Lucas.\nWhere are you from? = De onde você é?\nI\'m from Brazil. = Eu sou do Brasil.\nHow old are you? = Quantos anos você tem?\nI\'m 20 years old. = Tenho 20 anos.\nWhat do you do? = O que você faz?\nI am a student. = Eu sou estudante.',
      'NA HORA DE PEDIR ALGO:',
      'Can I have some water, please? = Posso tomar um pouco de água, por favor?\nHow much is it? = Quanto custa?\nThank you! = Obrigado(a)!\nYou\'re welcome! = De nada!',
      'EXEMPLO DE CONVERSA:',
      'Customer: How much is this book?\nTradução: Quanto custa este livro?',
      'Seller: It is ten dollars.\nTradução: Custa dez dólares.',
      'Customer: Thank you!\nTradução: Obrigado(a)!',
      'Seller: You\'re welcome!\nTradução: De nada!',
    ],
  ),
  Artigo(
    id: 'a039',
    objetivoId: 'estudar',
    categoriaId: 'estudar_ingles',
    nivel: 1,
    titulo: 'Construindo frases em inglês',
    autor: 'Equipe Ikai',
    resumo: 'Aprenda a formar frases simples e pratique novas palavras.',
    tags: ['exercício', 'inglês'],
    paragrafos: [
      'ESTRUTURA BÁSICA:',
      'Em frases afirmativas simples, uma estrutura comum é:\nSUJEITO + VERBO + COMPLEMENTO.',
      'EXEMPLOS:',
      'I like music. = Eu gosto de música.\nI study English. = Eu estudo inglês.\nShe likes coffee. = Ela gosta de café.\nHe plays soccer. = Ele joga futebol.\nWe are friends. = Nós somos amigos.',
      'PERGUNTAS ÚTEIS:',
      'Do you like music? = Você gosta de música?\nWhere do you live? = Onde você mora?\nWhat is your favorite food? = Qual é sua comida favorita?',
      'MINI CONVERSA:',
      'Maria: Do you like music?\nTradução: Você gosta de música?',
      'Peter: Yes, I do. I love music!\nTradução: Sim. Eu adoro música!',
      'Maria: What is your favorite song?\nTradução: Qual é sua música favorita?',
      'Peter: I don\'t have a favorite song.\nTradução: Eu não tenho uma música favorita.',
      'DESAFIO: tente escrever em inglês: Eu estudo inglês todos os dias.',
      'RESPOSTA: I study English every day.',
    ],
  ),

  // ---------------------------------------------------------------
  // Segunda leva: ao menos dois artigos por categoria, com mais
  // conteúdo intermediário e avançado.
  // ---------------------------------------------------------------

  // ----- Ver conteúdo -----
  Artigo(
    id: 'a040',
    objetivoId: 'ver_conteudo',
    categoriaId: 'ver_cientifico',
    nivel: 2,
    titulo: 'Por que a Lua tem fases',
    autor: 'Equipe Ikai',
    resumo:
        'A Lua não muda de forma: o que muda é quanto da metade iluminada '
        'conseguimos ver daqui.',
    tags: ['astronomia', 'lua', 'luz'],
    paragrafos: [
      'A Lua não produz luz própria. Ela reflete a luz do Sol, e metade dela '
          'está sempre iluminada, como acontece com a Terra, onde é dia de um '
          'lado e noite do outro.',
      'Enquanto a Lua dá a volta na Terra, em cerca de 29 dias e meio, '
          'muda o ângulo de onde a enxergamos. Na lua nova, a face iluminada '
          'está voltada para o Sol e quase toda escondida de nós. Na lua '
          'cheia, ela está do lado oposto ao Sol e vemos a metade iluminada '
          'inteira.',
      'Entre esses dois extremos ficam o quarto crescente e o quarto '
          'minguante, quando vemos mais ou menos metade do disco iluminado. '
          'Um erro comum é achar que as fases são a sombra da Terra sobre a '
          'Lua. A sombra da Terra só aparece nos eclipses lunares, que são '
          'bem mais raros.',
    ],
  ),
  Artigo(
    id: 'a041',
    objetivoId: 'ver_conteudo',
    categoriaId: 'ver_cultura',
    nivel: 1,
    titulo: 'Literatura de cordel: poesia pendurada no barbante',
    autor: 'Equipe Ikai',
    resumo:
        'Folhetos baratos, rima, xilogravura na capa e muita história contada '
        'em voz alta nas feiras do Nordeste.',
    tags: ['cordel', 'nordeste', 'poesia'],
    paragrafos: [
      'O cordel é um tipo de poesia popular impressa em folhetos simples. O '
          'nome vem do costume de expor os livretos pendurados em cordões nas '
          'feiras, como roupa no varal.',
      'Os versos costumam ter rima e métrica marcadas, o que facilita '
          'decorar e recitar. Muitos poetas declamavam os folhetos em voz '
          'alta para atrair compradores, e o cordel servia também para '
          'espalhar notícias, causos e histórias de valentia.',
      'As capas muitas vezes trazem xilogravuras, imagens gravadas em '
          'madeira e depois carimbadas no papel. Em 2018, a literatura de '
          'cordel foi reconhecida pelo Iphan como patrimônio cultural '
          'imaterial do Brasil.',
    ],
  ),
  Artigo(
    id: 'a042',
    objetivoId: 'ver_conteudo',
    categoriaId: 'ver_jogos',
    nivel: 1,
    titulo: 'Tetris: o jogo que nasceu num laboratório',
    autor: 'Equipe Ikai',
    resumo:
        'Um pesquisador de Moscou, peças de quatro quadrados e uma ideia '
        'simples que virou um dos jogos mais conhecidos do mundo.',
    tags: ['videogame', 'história dos jogos', 'quebra-cabeça'],
    paragrafos: [
      'Tetris foi criado em 1984 por Alexey Pajitnov, que trabalhava num '
          'centro de computação da Academia de Ciências, em Moscou. Ele se '
          'inspirou num quebra-cabeça de peças formadas por quadrados '
          'encaixados.',
      'Todas as peças do jogo são formadas por quatro quadrados, e daí vem '
          'parte do nome: tetra, do grego, quer dizer quatro. A regra é '
          'curta: encaixar as peças que caem para completar linhas, que '
          'então desaparecem.',
      'O jogo mostra como uma regra simples pode gerar decisões difíceis. '
          'A cada peça é preciso pensar à frente, deixar espaço para a '
          'próxima e aceitar que nem todo encaixe sai perfeito.',
    ],
  ),
  Artigo(
    id: 'a043',
    objetivoId: 'ver_conteudo',
    categoriaId: 'ver_noticia',
    nivel: 2,
    titulo: 'Manchete, lide e corpo: como uma notícia se organiza',
    autor: 'Equipe Ikai',
    resumo:
        'Entender a pirâmide invertida ajuda a ler mais rápido e a perceber '
        'o que a manchete deixou de fora.',
    tags: ['jornalismo', 'leitura crítica', 'notícias'],
    paragrafos: [
      'A maior parte das notícias segue um modelo chamado pirâmide '
          'invertida: o mais importante vem primeiro e os detalhes vêm '
          'depois. Assim, quem lê só o começo já entende o principal.',
      'O primeiro parágrafo é o lide. Ele tenta responder o que aconteceu, '
          'quem participou, quando, onde, como e por quê. Depois vem o corpo '
          'da notícia, com contexto, números, falas de envolvidos e '
          'informações de apoio.',
      'Saber disso ajuda a ler melhor. A manchete precisa ser curta e '
          'chamar atenção, então às vezes simplifica demais. Antes de tirar '
          'conclusões, vale ler pelo menos o lide e procurar no corpo de onde '
          'vieram os dados.',
    ],
  ),
  Artigo(
    id: 'a044',
    objetivoId: 'ver_conteudo',
    categoriaId: 'ver_esporte',
    nivel: 2,
    titulo: 'Por que a maratona tem 42,195 km',
    autor: 'Equipe Ikai',
    resumo:
        'A distância quebrada tem origem num percurso olímpico de 1908 e só '
        'virou regra anos depois.',
    tags: ['atletismo', 'olimpíadas', 'corrida'],
    paragrafos: [
      'A maratona lembra a lenda do mensageiro grego que teria corrido da '
          'cidade de Maratona até Atenas para anunciar uma vitória. Nas '
          'primeiras Olimpíadas modernas, a distância da prova variava de '
          'uma edição para outra.',
      'Nos Jogos de Londres, em 1908, o percurso foi traçado com cerca de '
          '26,2 milhas, o equivalente a 42,195 km, terminando diante do '
          'camarote real no estádio. Essa medida acabou ficando famosa.',
      'Em 1921, a federação internacional de atletismo adotou oficialmente '
          'os 42,195 km. Desde então, toda maratona oficial tem exatamente '
          'essa distância, o que permite comparar tempos de provas '
          'diferentes.',
    ],
  ),
  Artigo(
    id: 'a045',
    objetivoId: 'ver_conteudo',
    categoriaId: 'ver_curiosidades',
    nivel: 1,
    titulo: 'O polvo tem três corações e sangue azul',
    autor: 'Equipe Ikai',
    resumo:
        'Dois corações cuidam das brânquias, um cuida do corpo, e o cobre '
        'deixa o sangue azulado.',
    tags: ['animais', 'oceano', 'biologia'],
    paragrafos: [
      'O polvo tem três corações. Dois deles bombeiam o sangue pelas '
          'brânquias, onde ele pega oxigênio da água. O terceiro leva esse '
          'sangue oxigenado para o resto do corpo.',
      'O sangue do polvo é azulado porque o oxigênio é transportado por '
          'uma proteína chamada hemocianina, que tem cobre. No sangue humano, '
          'esse papel é da hemoglobina, que tem ferro e deixa o sangue '
          'vermelho.',
      'Os polvos também chamam atenção pela inteligência: conseguem abrir '
          'potes, se esconder mudando de cor e textura e aprender observando. '
          'Boa parte dos neurônios deles fica espalhada pelos braços.',
    ],
  ),

  // ----- Estudar -----
  Artigo(
    id: 'a046',
    objetivoId: 'estudar',
    categoriaId: 'estudar_lp',
    nivel: 2,
    titulo: 'Os quatro porquês sem confusão',
    autor: 'Equipe Ikai',
    resumo:
        'Por que, porque, por quê e porquê: a posição na frase e o sentido '
        'resolvem quase todos os casos.',
    tags: ['ortografia', 'gramática', 'porquês'],
    paragrafos: [
      'POR QUE, separado e sem acento, aparece em perguntas e quando dá '
          'para trocar por "por qual motivo": Por que você chegou cedo? Não '
          'sei por que ele saiu.',
      'PORQUE, junto e sem acento, é usado nas respostas e explicações, '
          'com sentido de "pois": Cheguei cedo porque o ônibus passou antes.',
      'POR QUÊ, separado e com acento, aparece no fim da frase: Você saiu '
          'por quê? O acento existe porque a palavra fica tônica antes da '
          'pausa.',
      'PORQUÊ, junto e com acento, é um substantivo e vem com artigo: Quero '
          'entender o porquê da sua escolha. Um teste rápido: se der para '
          'trocar por "o motivo", é este.',
    ],
  ),
  Artigo(
    id: 'a047',
    objetivoId: 'estudar',
    categoriaId: 'estudar_artes',
    nivel: 2,
    titulo: 'Perspectiva: como o desenho ganha profundidade',
    autor: 'Equipe Ikai',
    resumo:
        'Linha do horizonte e ponto de fuga: a técnica do Renascimento que '
        'faz uma folha plana parecer ter fundo.',
    tags: ['desenho', 'renascimento', 'perspectiva'],
    paragrafos: [
      'A perspectiva linear é um jeito de desenhar que imita a forma como '
          'os olhos veem: o que está longe parece menor, e linhas paralelas, '
          'como trilhos de trem, parecem se encontrar no horizonte.',
      'O ponto onde essas linhas se encontram é o ponto de fuga, e ele fica '
          'sobre a linha do horizonte, que marca a altura dos olhos de quem '
          'observa. Com um ponto de fuga, dá para desenhar uma rua vista de '
          'frente; com dois, a quina de um prédio.',
      'A técnica foi sistematizada no início do século XV, em Florença, e '
          'costuma ser associada ao arquiteto Filippo Brunelleschi. Pintores '
          'do Renascimento a usaram para criar cenas com sensação de espaço '
          'real.',
      'Para praticar: desenhe uma linha horizontal, marque um ponto nela e '
          'trace retas saindo desse ponto. Use essas retas como guia para '
          'desenhar caixas e janelas, e veja a profundidade aparecer.',
    ],
  ),
  Artigo(
    id: 'a048',
    objetivoId: 'estudar',
    categoriaId: 'estudar_historia',
    nivel: 2,
    titulo: 'Independência do Brasil: além do grito',
    autor: 'Equipe Ikai',
    resumo:
        'O 7 de setembro de 1822 foi um marco, mas a separação de Portugal '
        'foi um processo com guerras e negociação.',
    tags: ['brasil império', 'independência', 'século xix'],
    paragrafos: [
      'A data lembrada é 7 de setembro de 1822, quando Dom Pedro, então '
          'príncipe regente, teria proclamado a separação às margens do '
          'riacho Ipiranga, em São Paulo. Em dezembro do mesmo ano, ele foi '
          'coroado imperador.',
      'O contexto vinha de antes. Em 1808, a família real portuguesa se '
          'mudou para o Brasil, e a colônia ganhou instituições, portos '
          'abertos e peso político. Quando as cortes de Lisboa tentaram '
          'reduzir essa autonomia, a elite brasileira reagiu.',
      'A independência não foi pacífica em todo o território. Houve '
          'combates em províncias como Bahia, Maranhão, Piauí e Pará, onde '
          'tropas leais a Portugal resistiram. O 2 de julho de 1823 é '
          'celebrado na Bahia justamente por isso.',
      'Portugal só reconheceu a independência em 1825, num tratado com '
          'mediação britânica que incluiu o pagamento de uma indenização. '
          'Por isso, muitos historiadores tratam a independência como um '
          'processo, e não como um único dia.',
    ],
  ),
  Artigo(
    id: 'a049',
    objetivoId: 'estudar',
    categoriaId: 'estudar_filosofia',
    nivel: 2,
    titulo: 'A alegoria da caverna, de Platão',
    autor: 'Equipe Ikai',
    resumo:
        'Prisioneiros que só conhecem sombras: uma imagem de mais de dois mil '
        'anos sobre conhecimento e aparência.',
    tags: ['platão', 'conhecimento', 'filosofia antiga'],
    paragrafos: [
      'No livro A República, Platão descreve pessoas presas desde sempre '
          'numa caverna, de costas para a entrada. Elas só veem sombras '
          'projetadas na parede e acreditam que aquilo é tudo o que existe.',
      'Um dos prisioneiros é solto e sai da caverna. No começo, a luz do '
          'sol o ofusca, mas aos poucos ele enxerga as coisas de verdade e '
          'entende que as sombras eram só cópias.',
      'Ao voltar para contar o que viu, ele é desacreditado pelos outros, '
          'acostumados às sombras. Platão usa a história para falar da '
          'diferença entre aparência e conhecimento, e do esforço que é '
          'deixar o que é confortável.',
      'Uma pergunta para levar: que "sombras" a gente aceita sem questionar '
          'hoje, e o que seria sair da caverna nesses casos?',
    ],
  ),
  Artigo(
    id: 'a050',
    objetivoId: 'estudar',
    categoriaId: 'estudar_sociologia',
    nivel: 3,
    titulo: 'Max Weber e os três tipos de dominação',
    autor: 'Equipe Ikai',
    resumo:
        'Por que as pessoas obedecem? Weber separou a autoridade da lei, a '
        'da tradição e a do carisma.',
    tags: ['weber', 'poder', 'autoridade'],
    paragrafos: [
      'O sociólogo alemão Max Weber, que viveu entre 1864 e 1920, quis '
          'entender por que as pessoas aceitam ordens de outras. Para ele, '
          'dominação é a chance de uma ordem ser obedecida porque é vista '
          'como legítima, e não só pela força.',
      'A dominação legal-racional se apoia em regras impessoais: obedecemos '
          'ao cargo e à lei, não à pessoa. É o caso da burocracia moderna, '
          'com concursos, hierarquia e normas escritas.',
      'A dominação tradicional se apoia no costume, no "sempre foi assim", '
          'como no poder de um patriarca ou de uma dinastia. Já a carismática '
          'se apoia nas qualidades extraordinárias atribuídas a um líder, e '
          'tende a ser instável quando ele sai de cena.',
      'Weber apresentou esses três como tipos ideais: modelos para '
          'comparar a realidade, que quase sempre mistura os três. Um bom '
          'exercício é pegar uma instituição que você conhece e perguntar '
          'qual tipo pesa mais nela.',
    ],
  ),
  Artigo(
    id: 'a051',
    objetivoId: 'estudar',
    categoriaId: 'estudar_ef',
    nivel: 2,
    titulo: 'Alongar antes ou depois do exercício?',
    autor: 'Equipe Ikai',
    resumo:
        'Movimento antes, alongamento parado com calma: um jeito simples de '
        'organizar o início e o fim do treino.',
    tags: ['alongamento', 'treino', 'saúde'],
    paragrafos: [
      'Existem dois tipos principais de alongamento. No estático, você '
          'segura uma posição por alguns segundos. No dinâmico, faz '
          'movimentos controlados, como balançar as pernas ou girar os '
          'braços.',
      'Antes de atividades que pedem força ou explosão, como saltos e '
          'corridas curtas, muitos estudos indicam que um aquecimento com '
          'movimentos dinâmicos prepara melhor o corpo do que segurar '
          'alongamentos longos parado.',
      'O alongamento estático combina melhor com o fim do treino ou com '
          'sessões separadas, quando o objetivo é ganhar flexibilidade com '
          'calma, sem pressa nem dor.',
      'Se você sente dor forte ou tem alguma lesão, a orientação de um '
          'professor de educação física ou de um profissional de saúde vale '
          'mais do que qualquer regra geral.',
    ],
  ),
  Artigo(
    id: 'a052',
    objetivoId: 'estudar',
    categoriaId: 'estudar_biologia',
    nivel: 3,
    titulo: 'Mitose e meiose: dividir para quê?',
    autor: 'Equipe Ikai',
    resumo:
        'Uma divisão copia a célula para crescer e reparar; a outra produz '
        'gametas e cria variedade.',
    tags: ['célula', 'genética', 'divisão celular'],
    paragrafos: [
      'A mitose produz duas células-filhas com o mesmo número de '
          'cromossomos da célula original. Ela serve para o corpo crescer, '
          'repor células que morrem e cicatrizar machucados.',
      'A meiose acontece nas células que formam os gametas, como '
          'espermatozoides e óvulos. Ela tem duas divisões seguidas e termina '
          'com quatro células, cada uma com metade dos cromossomos. Em '
          'humanos, as células do corpo têm 46 cromossomos e os gametas, 23.',
      'Na meiose existe a permutação, ou crossing-over: cromossomos '
          'parecidos trocam pedaços entre si. Junto com a forma aleatória '
          'como eles se separam, isso gera muita variedade genética.',
      'Resumo para revisar: mitose copia e mantém o número de cromossomos; '
          'meiose reduz o número pela metade e mistura. Quando um gameta de '
          'cada pai se junta na fecundação, o número completo volta.',
    ],
  ),
  Artigo(
    id: 'a053',
    objetivoId: 'estudar',
    categoriaId: 'estudar_fisica',
    nivel: 2,
    titulo: 'Velocidade média sem decoreba',
    autor: 'Equipe Ikai',
    resumo:
        'Distância dividida pelo tempo, e o cuidado que quase todo mundo '
        'esquece: as unidades.',
    tags: ['cinemática', 'velocidade', 'unidades'],
    paragrafos: [
      'A velocidade média diz quanto espaço foi percorrido em cada unidade '
          'de tempo. A conta é: velocidade média igual à distância percorrida '
          'dividida pelo tempo gasto.',
      'EXEMPLO: um ônibus percorre 120 km em 2 horas. A velocidade média é '
          '120 dividido por 2, ou seja, 60 km/h. Isso não quer dizer que ele '
          'andou sempre a 60 km/h: ele pode ter parado e acelerado no '
          'caminho.',
      'ATENÇÃO ÀS UNIDADES: para passar de km/h para m/s, divida por 3,6. '
          'Para passar de m/s para km/h, multiplique por 3,6. Assim, 72 km/h '
          'equivalem a 20 m/s.',
      'DESAFIO: uma pessoa caminha 3 km em 30 minutos. Qual a velocidade '
          'média em km/h? RESPOSTA: 30 minutos são meia hora, então 3 '
          'dividido por 0,5 dá 6 km/h.',
    ],
  ),
  Artigo(
    id: 'a054',
    objetivoId: 'estudar',
    categoriaId: 'estudar_quimica',
    nivel: 2,
    titulo: 'Ácidos, bases e a escala de pH',
    autor: 'Equipe Ikai',
    resumo:
        'Do limão ao sabão: uma régua de 0 a 14 que mede o quanto uma '
        'solução é ácida ou básica.',
    tags: ['ph', 'ácidos e bases', 'soluções'],
    paragrafos: [
      'O pH é uma escala que indica a acidez de uma solução aquosa. A 25 °C, '
          'ela costuma ir de 0 a 14: abaixo de 7 é ácido, 7 é neutro e acima '
          'de 7 é básico, também chamado de alcalino.',
      'Alguns exemplos aproximados: suco de limão fica perto de pH 2, a '
          'água pura fica em 7 e a água sanitária fica acima de 11. O vinagre '
          'e os refrigerantes também são ácidos.',
      'A escala não é linear. Cada número a menos significa uma solução '
          'dez vezes mais ácida. Por isso, pH 3 é dez vezes mais ácido que '
          'pH 4 e cem vezes mais ácido que pH 5.',
      'Em casa, dá para ver a diferença com um indicador natural: o caldo '
          'roxo do repolho-roxo cozido muda de cor, ficando avermelhado em '
          'meio ácido e esverdeado em meio básico. Faça só com a ajuda de um '
          'adulto e nunca misture produtos de limpeza.',
    ],
  ),

  // ----- Ler -----
  Artigo(
    id: 'a055',
    objetivoId: 'ler',
    categoriaId: 'ler_fantasia',
    nivel: 2,
    titulo: 'Tolkien e as línguas inventadas da Terra-média',
    autor: 'Equipe Ikai',
    resumo:
        'Antes das histórias vieram as línguas: como um professor de '
        'filologia construiu um mundo a partir de palavras.',
    tags: ['tolkien', 'terra-média', 'construção de mundo'],
    paragrafos: [
      'J. R. R. Tolkien, autor de O Hobbit e O Senhor dos Anéis, era '
          'professor de filologia em Oxford, a área que estuda a história '
          'das línguas. Desde jovem, ele inventava idiomas por prazer.',
      'Duas de suas línguas élficas, o quenya e o sindarin, têm gramática, '
          'vocabulário e até mudanças de som ao longo do tempo, como as '
          'línguas reais. Tolkien dizia que as histórias surgiram em parte '
          'para dar um mundo onde essas línguas pudessem existir.',
      'Isso ajuda a explicar a sensação de profundidade da Terra-média: '
          'nomes de lugares e personagens têm origem e sentido dentro do '
          'próprio mundo. Ao ler, repare como os nomes dos elfos, anões e '
          'hobbits soam diferentes entre si: é proposital.',
    ],
  ),
  Artigo(
    id: 'a056',
    objetivoId: 'ler',
    categoriaId: 'ler_suspense',
    nivel: 2,
    titulo: 'Agatha Christie e o jogo limpo com o leitor',
    autor: 'Equipe Ikai',
    resumo:
        'Pistas à vista, suspeitos fechados num lugar e a chance de o leitor '
        'resolver o caso antes do detetive.',
    tags: ['agatha christie', 'mistério', 'romance policial'],
    paragrafos: [
      'A escritora inglesa Agatha Christie publicou dezenas de romances '
          'policiais e criou detetives como Hercule Poirot e Miss Marple. '
          'Seus livros estão entre os mais vendidos da história.',
      'Uma marca do estilo dela é o chamado jogo limpo: as pistas '
          'importantes aparecem no texto, e o leitor tem, em tese, as mesmas '
          'informações que o detetive. A surpresa vem de como essas pistas '
          'foram escondidas no meio de detalhes comuns.',
      'Outro recurso frequente é o grupo fechado de suspeitos, como numa '
          'casa de campo, num trem ou numa ilha. Em E Não Sobrou Nenhum, dez '
          'pessoas isoladas numa ilha começam a desaparecer uma a uma.',
      'Uma forma divertida de ler: anote quem você acha que é o culpado na '
          'metade do livro e confira no final quais pistas você deixou '
          'passar.',
    ],
  ),
  Artigo(
    id: 'a057',
    objetivoId: 'ler',
    categoriaId: 'ler_fc',
    nivel: 2,
    titulo: 'Asimov e as Três Leis da Robótica',
    autor: 'Equipe Ikai',
    resumo:
        'Três regras para proteger as pessoas e muitas histórias sobre como '
        'elas podem falhar.',
    tags: ['asimov', 'robôs', 'ética'],
    paragrafos: [
      'O escritor Isaac Asimov apresentou as Três Leis da Robótica num '
          'conto publicado em 1942. Mais tarde, várias dessas histórias foram '
          'reunidas no livro Eu, Robô.',
      'Em resumo: um robô não pode ferir um ser humano nem deixar que ele '
          'se machuque por omissão; deve obedecer às ordens humanas, a não '
          'ser que contrariem a primeira lei; e deve proteger a si mesmo, '
          'desde que isso não contrarie as duas primeiras.',
      'O interessante é que as histórias raramente mostram as leis '
          'funcionando bem. Elas exploram brechas, conflitos entre as regras '
          'e situações que ninguém previu, quase como quebra-cabeças '
          'lógicos.',
      'Hoje, com assistentes e sistemas automáticos no dia a dia, as '
          'perguntas de Asimov continuam atuais: regras simples dão conta de '
          'decisões complicadas?',
    ],
  ),
  Artigo(
    id: 'a058',
    objetivoId: 'ler',
    categoriaId: 'ler_horror',
    nivel: 2,
    titulo: 'Drácula, um romance feito de cartas',
    autor: 'Equipe Ikai',
    resumo:
        'Diários, cartas e recortes de jornal: o formato que faz o leitor '
        'montar o horror aos poucos.',
    tags: ['drácula', 'bram stoker', 'romance epistolar'],
    paragrafos: [
      'Drácula, do irlandês Bram Stoker, foi publicado em 1897. O livro '
          'não tem um narrador único: é montado com diários, cartas, '
          'telegramas e notícias escritos por vários personagens.',
      'Esse formato se chama romance epistolar. Como cada personagem só '
          'sabe uma parte da história, o leitor acaba sabendo mais do que '
          'eles, e o medo cresce justamente por ver o perigo chegando antes.',
      'O conde quase nunca fala por si mesmo no livro. Ele é visto pelos '
          'olhos dos outros, o que o deixa mais misterioso. Muito do que se '
          'imagina hoje sobre vampiros, no cinema e nas séries, vem dessa '
          'obra.',
    ],
  ),
  Artigo(
    id: 'a059',
    objetivoId: 'ler',
    categoriaId: 'ler_terror',
    nivel: 3,
    titulo: 'O Gato Preto, de Poe: quando não dá para confiar no narrador',
    autor: 'Equipe Ikai',
    resumo:
        'Um narrador que jura estar são enquanto conta o inexplicável: o '
        'medo vem de quem conta a história.',
    tags: ['edgar allan poe', 'conto', 'narrador'],
    paragrafos: [
      'O Gato Preto é um conto do norte-americano Edgar Allan Poe, '
          'publicado em 1843. Logo no começo, o narrador diz que vai contar '
          'fatos estranhos e insiste que não está louco.',
      'Esse é um exemplo de narrador não confiável: quem conta a história '
          'tem motivos para distorcer os fatos, ou não percebe a própria '
          'situação. O leitor precisa ler nas entrelinhas e desconfiar das '
          'justificativas que ele dá.',
      'Poe usa a primeira pessoa para colocar o leitor dentro da cabeça do '
          'narrador. O terror não está só no que acontece, mas em perceber, '
          'aos poucos, o quanto aquela mente se perdeu.',
      'Para pensar depois da leitura: em que momento você deixou de '
          'acreditar no narrador? Que palavras dele mostram isso?',
    ],
  ),
  Artigo(
    id: 'a060',
    objetivoId: 'ler',
    categoriaId: 'ler_religioso',
    nivel: 1,
    titulo: 'Parábolas: histórias curtas que ensinam',
    autor: 'Equipe Ikai',
    resumo:
        'Personagens simples e situações do dia a dia usadas para transmitir '
        'uma ideia, em várias tradições.',
    tags: ['parábola', 'narrativa', 'tradições'],
    paragrafos: [
      'A parábola é uma narrativa curta que usa situações do cotidiano para '
          'transmitir uma lição. Em vez de explicar a ideia de forma direta, '
          'ela conta uma história e deixa o ouvinte chegar à conclusão.',
      'Nos Evangelhos cristãos, há parábolas conhecidas, como a do Bom '
          'Samaritano, sobre ajudar quem precisa, e a do Filho Pródigo, sobre '
          'perdão. Outras tradições religiosas e filosóficas também usam '
          'histórias curtas com a mesma função.',
      'Ler parábolas como leitor é perceber a força da forma: poucos '
          'personagens, um conflito claro e um final que provoca. É um bom '
          'exercício notar o que a história deixa sem dizer.',
    ],
  ),
  Artigo(
    id: 'a061',
    objetivoId: 'ler',
    categoriaId: 'ler_distopia',
    nivel: 2,
    titulo: 'Admirável Mundo Novo: controle pelo prazer',
    autor: 'Equipe Ikai',
    resumo:
        'Enquanto 1984 imagina o medo como ferramenta, Huxley imagina uma '
        'sociedade controlada pelo conforto.',
    tags: ['huxley', 'distopia', 'sociedade'],
    paragrafos: [
      'Admirável Mundo Novo, do inglês Aldous Huxley, foi publicado em 1932. '
          'No livro, as pessoas são produzidas em laboratório e divididas em '
          'castas desde antes de nascer.',
      'Ninguém ali vive com medo, como em 1984. O controle vem do prazer: '
          'diversão constante, consumo e uma droga chamada soma, que apaga '
          'qualquer tristeza. Quem está satisfeito o tempo todo não pergunta '
          'nada.',
      'Comparar as duas obras é uma boa forma de pensar: uma sociedade pode '
          'perder a liberdade tanto pela vigilância quanto pela distração. '
          'Qual das duas parece mais perto do nosso dia a dia?',
    ],
  ),
  Artigo(
    id: 'a062',
    objetivoId: 'ler',
    categoriaId: 'ler_aventura',
    nivel: 1,
    titulo: 'A Volta ao Mundo em 80 Dias e a corrida contra o relógio',
    autor: 'Equipe Ikai',
    resumo:
        'Uma aposta, trens, navios e um detalhe do fuso horário que muda o '
        'final da história.',
    tags: ['júlio verne', 'viagem', 'aposta'],
    paragrafos: [
      'No romance do francês Júlio Verne, publicado na década de 1870, o '
          'inglês Phileas Fogg aposta que consegue dar a volta ao mundo em '
          'oitenta dias, numa época sem aviões.',
      'Ao lado do criado Passepartout, ele atravessa continentes de trem, '
          'navio e até em cima de um elefante, enquanto um detetive o persegue '
          'achando que ele é um ladrão.',
      'Sem contar demais: o final depende de um detalhe sobre fusos '
          'horários. Viajando sempre para o leste, os viajantes ganham um dia '
          'sem perceber. Vale ler prestando atenção no calendário.',
    ],
  ),
  Artigo(
    id: 'a063',
    objetivoId: 'ler',
    categoriaId: 'ler_dp',
    nivel: 2,
    titulo: 'Blocos de tempo: dar endereço para as tarefas',
    autor: 'Equipe Ikai',
    resumo:
        'Em vez de uma lista infinita, cada tarefa ganha um horário. Um '
        'método simples para começar o que importa.',
    tags: ['organização', 'produtividade', 'rotina'],
    paragrafos: [
      'Listas de tarefas são úteis, mas não dizem quando cada coisa vai ser '
          'feita. O bloco de tempo resolve isso: você reserva um horário na '
          'agenda para cada atividade, como se fosse um compromisso.',
      'Comece pequeno. Escolha uma ou duas tarefas importantes do dia e '
          'reserve blocos de 25 a 50 minutos para elas, de preferência no '
          'horário em que você costuma ter mais energia.',
      'Deixe folga entre os blocos. Imprevistos acontecem, e um plano '
          'apertado demais quebra no primeiro atraso. No fim do dia, olhe o '
          'que funcionou e ajuste para o dia seguinte, sem culpa.',
    ],
  ),
  Artigo(
    id: 'a064',
    objetivoId: 'ler',
    categoriaId: 'ler_tecnico',
    nivel: 2,
    titulo: 'Glossário pessoal: aprendendo o vocabulário de uma área',
    autor: 'Equipe Ikai',
    resumo:
        'Boa parte da dificuldade de um texto técnico está nas palavras. Uma '
        'lista feita por você resolve muito.',
    tags: ['estudo', 'vocabulário', 'leitura técnica'],
    paragrafos: [
      'Quando um texto técnico parece difícil, muitas vezes o problema não '
          'é a ideia, e sim os termos. Cada área tem palavras próprias, e '
          'sem elas o resto da frase não faz sentido.',
      'Monte um glossário pessoal: um caderno ou arquivo onde você anota '
          'cada termo novo com uma explicação nas suas palavras e um exemplo. '
          'Escrever com as suas palavras é o que fixa o significado.',
      'Revise a lista antes de ler o próximo capítulo. Com o tempo, você '
          'vai perceber que os mesmos termos aparecem sempre, e a leitura '
          'fica muito mais rápida.',
    ],
  ),
  Artigo(
    id: 'a065',
    objetivoId: 'ler',
    categoriaId: 'ler_biografia',
    nivel: 1,
    titulo: 'Santos Dumont e o voo do 14-bis',
    autor: 'Equipe Ikai',
    resumo:
        'Paris, 1906: o inventor brasileiro decola diante de uma comissão '
        'oficial e entra para a história da aviação.',
    tags: ['santos dumont', 'aviação', 'invenção'],
    paragrafos: [
      'Alberto Santos Dumont nasceu em Minas Gerais, em 1873, e foi viver '
          'em Paris, onde construiu balões e dirigíveis. Ficou famoso por '
          'voar pela cidade com eles.',
      'Em 23 de outubro de 1906, no campo de Bagatelle, em Paris, ele voou '
          'cerca de 60 metros com o 14-bis, um avião que decolou pelos '
          'próprios meios, diante de público e de uma comissão do Aeroclube '
          'da França. Semanas depois, voou mais de 200 metros.',
      'Santos Dumont também ficou conhecido por não patentear muitas de '
          'suas invenções, preferindo que outros pudessem usá-las. A '
          'discussão sobre quem voou primeiro, ele ou os irmãos Wright, '
          'continua até hoje e depende muito de como se define o primeiro '
          'voo.',
    ],
  ),
  Artigo(
    id: 'a066',
    objetivoId: 'ler',
    categoriaId: 'ler_romance',
    nivel: 2,
    titulo: 'Orgulho e Preconceito e o perigo da primeira impressão',
    autor: 'Equipe Ikai',
    resumo:
        'Elizabeth e Darcy se julgam mal logo no começo. O romance é sobre '
        'aprender a rever a própria opinião.',
    tags: ['jane austen', 'romance', 'clássico'],
    paragrafos: [
      'Orgulho e Preconceito, da inglesa Jane Austen, foi publicado em 1813. '
          'Antes de ganhar esse título, o livro se chamava Primeiras '
          'Impressões, e o nome antigo já entrega o assunto.',
      'Elizabeth Bennet e o senhor Darcy se conhecem num baile e saem dali '
          'com a pior opinião um do outro: ela o acha arrogante, e ele acha '
          'a família dela inadequada. Ao longo do livro, os dois descobrem '
          'que se apressaram.',
      'Além da história de amor, o romance mostra com humor a pressão sobre '
          'as mulheres da época para casar bem, numa sociedade em que a '
          'herança e a posição social pesavam muito.',
      'Uma pergunta para ler o livro: qual dos dois é o orgulhoso, e qual é '
          'o preconceituoso? A resposta muda conforme a leitura avança.',
    ],
  ),
];
