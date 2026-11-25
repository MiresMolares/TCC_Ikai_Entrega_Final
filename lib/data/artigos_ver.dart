import 'artigo.dart';

/// Mais artigos de "Ver conteúdo" (a101 a a124), escritos para o Ikai.
/// Entram no acervo por `artigosDados` (artigos_dados.dart).
const List<Artigo> artigosVer = [
  // ---------------- Científico ----------------
  Artigo(
    id: 'a101',
    objetivoId: 'ver_conteudo',
    categoriaId: 'ver_cientifico',
    nivel: 1,
    titulo: 'O cheiro de chuva tem nome: petricor',
    autor: 'Equipe Ikai',
    resumo:
        'Aquele cheiro de terra molhada não é imaginação: vem de óleos de '
        'plantas e de uma substância produzida por bactérias do solo.',
    tags: ['química', 'natureza', 'chuva'],
    paragrafos: [
      'Em 1964, dois pesquisadores australianos deram nome ao cheiro que '
          'sobe do chão quando começa a chover: petricor. A palavra junta o '
          'grego "petra", pedra, com "icor", o fluido que corria nas veias '
          'dos deuses gregos.',
      'Durante a seca, plantas soltam óleos que ficam presos em rochas e na '
          'terra. Bactérias do solo também produzem a geosmina, uma '
          'substância que o nariz humano percebe mesmo em quantidades '
          'mínimas.',
      'Quando as primeiras gotas batem no chão, formam pequenas bolhas que '
          'estouram e lançam esses compostos no ar. É por isso que o cheiro '
          'é mais forte no começo da chuva, principalmente depois de dias '
          'secos.',
    ],
  ),
  Artigo(
    id: 'a102',
    objetivoId: 'ver_conteudo',
    categoriaId: 'ver_cientifico',
    nivel: 1,
    titulo: 'Como nasce um arco-íris',
    autor: 'Equipe Ikai',
    resumo:
        'Gotas de chuva funcionam como pequenos prismas: desviam a luz do '
        'Sol e separam as cores que ela carrega.',
    tags: ['física', 'luz', 'óptica'],
    paragrafos: [
      'A luz branca do Sol é feita de várias cores. Quando ela entra numa '
          'gota de água, muda de direção, porque passa do ar para a água. '
          'Esse desvio se chama refração.',
      'Cada cor se desvia um pouco diferente: o violeta mais, o vermelho '
          'menos. Dentro da gota, a luz ainda bate no fundo e volta, e ao '
          'sair as cores já estão separadas, formando o arco.',
      'Para ver um arco-íris, o Sol precisa estar atrás de você e a chuva '
          'na sua frente. Por isso eles aparecem mais no fim da tarde ou no '
          'começo da manhã, quando o Sol está baixo.',
    ],
  ),
  Artigo(
    id: 'a103',
    objetivoId: 'ver_conteudo',
    categoriaId: 'ver_cientifico',
    nivel: 2,
    titulo: 'Por que o gelo flutua',
    autor: 'Equipe Ikai',
    resumo:
        'A água é uma exceção curiosa: no estado sólido, ela ocupa mais '
        'espaço do que no líquido.',
    tags: ['física', 'água', 'densidade'],
    paragrafos: [
      'Na maioria das substâncias, o sólido é mais denso que o líquido e '
          'afunda. Com a água acontece o contrário: o gelo é cerca de 9% '
          'menos denso que a água líquida, e por isso boia.',
      'Ao congelar, as moléculas de água se organizam numa estrutura '
          'cheia de espaços, presa por ligações de hidrogênio. Essa '
          'arrumação ocupa mais volume do que as moléculas soltas do '
          'líquido.',
      'Essa exceção é importante para a vida. Em lagos de lugares frios, o '
          'gelo fica na superfície e funciona como uma tampa que protege a '
          'água de baixo, onde peixes e plantas conseguem sobreviver ao '
          'inverno.',
    ],
  ),
  Artigo(
    id: 'a104',
    objetivoId: 'ver_conteudo',
    categoriaId: 'ver_cientifico',
    nivel: 2,
    titulo: 'Estrela cadente não é estrela',
    autor: 'Equipe Ikai',
    resumo:
        'O risco de luz no céu é um pedacinho de rocha ou poeira que '
        'pega fogo ao entrar na atmosfera.',
    tags: ['astronomia', 'meteoros', 'céu'],
    paragrafos: [
      'O nome popular engana: a "estrela cadente" é um meteoro. Fragmentos '
          'do espaço, muitas vezes menores que um grão de areia, entram na '
          'atmosfera da Terra em velocidades enormes.',
      'O atrito e a compressão do ar aquecem tanto o fragmento que ele '
          'brilha e se desfaz em segundos, muitos quilômetros acima do '
          'chão. Se um pedaço sobrevive e chega ao solo, ele passa a se '
          'chamar meteorito.',
      'Em certas épocas do ano, a Terra atravessa rastros de poeira '
          'deixados por cometas, e aparecem as chuvas de meteoros. As '
          'Perseidas, em agosto, são uma das mais conhecidas.',
    ],
  ),

  // ---------------- Cultura ----------------
  Artigo(
    id: 'a105',
    objetivoId: 'ver_conteudo',
    categoriaId: 'ver_cultura',
    nivel: 1,
    titulo: 'Frevo: o passo que ferve em Pernambuco',
    autor: 'Equipe Ikai',
    resumo:
        'Nascido nas ruas do Recife no fim do século 19, o frevo junta '
        'música acelerada, sombrinhas coloridas e muita acrobacia.',
    tags: ['dança', 'carnaval', 'Pernambuco'],
    paragrafos: [
      'O frevo surgiu no Recife, no fim do século 19, misturando marchas, '
          'maxixe e músicas de bandas militares. O nome vem de "ferver", '
          'pela agitação das pessoas dançando nas ruas.',
      'Os passistas fazem movimentos rápidos, agachamentos e saltos, '
          'segurando pequenas sombrinhas coloridas que ajudam no '
          'equilíbrio. Há centenas de passos com nomes próprios.',
      'Em 2012, a Unesco reconheceu o frevo como Patrimônio Cultural '
          'Imaterial da Humanidade. Ele é a trilha sonora do carnaval de '
          'Recife e Olinda.',
    ],
  ),
  Artigo(
    id: 'a106',
    objetivoId: 'ver_conteudo',
    categoriaId: 'ver_cultura',
    nivel: 1,
    titulo: 'Festa junina: de onde vem a quadrilha',
    autor: 'Equipe Ikai',
    resumo:
        'As festas de junho chegaram com os portugueses e ganharam no '
        'Brasil comidas de milho, fogueiras e uma dança de origem francesa.',
    tags: ['festas', 'tradição', 'cultura popular'],
    paragrafos: [
      'As festas juninas homenageiam santos católicos como Santo Antônio, '
          'São João e São Pedro. Elas vieram com os colonizadores '
          'portugueses e coincidiam com a época de colheita do milho.',
      'A quadrilha tem origem numa dança de salão francesa, a "quadrille", '
          'popular nas cortes europeias. No Brasil, ela foi se misturando a '
          'costumes do campo e ganhou o marcador, que anuncia os passos.',
      'No Nordeste, as festas de São João são das maiores do país, com '
          'destaque para Campina Grande, na Paraíba, e Caruaru, em '
          'Pernambuco.',
    ],
  ),
  Artigo(
    id: 'a107',
    objetivoId: 'ver_conteudo',
    categoriaId: 'ver_cultura',
    nivel: 2,
    titulo: 'Bumba meu boi: um auto que atravessa o Brasil',
    autor: 'Equipe Ikai',
    resumo:
        'Teatro, dança e música se juntam numa história sobre a morte e a '
        'ressurreição de um boi, contada de jeitos diferentes em cada região.',
    tags: ['folclore', 'Maranhão', 'teatro popular'],
    paragrafos: [
      'O bumba meu boi conta, em geral, a história de um boi que morre e '
          'volta à vida. Personagens como o dono da fazenda, o vaqueiro e '
          'figuras encantadas participam da trama.',
      'A brincadeira mistura heranças indígenas, africanas e europeias. '
          'No Maranhão, ela tem vários "sotaques", estilos com instrumentos '
          'e ritmos próprios.',
      'Em 2019, o Complexo Cultural do Bumba meu boi do Maranhão foi '
          'reconhecido pela Unesco como Patrimônio Cultural Imaterial da '
          'Humanidade. No Amazonas, a tradição deu origem ao Festival de '
          'Parintins.',
    ],
  ),
  Artigo(
    id: 'a108',
    objetivoId: 'ver_conteudo',
    categoriaId: 'ver_cultura',
    nivel: 2,
    titulo: 'Samba de roda do Recôncavo Baiano',
    autor: 'Equipe Ikai',
    resumo:
        'Antes do samba das escolas, havia rodas de palmas, viola e '
        'sapateado no interior da Bahia.',
    tags: ['música', 'Bahia', 'samba'],
    paragrafos: [
      'O samba de roda nasceu no Recôncavo Baiano, região em volta da Baía '
          'de Todos-os-Santos, a partir de tradições trazidas por africanos '
          'escravizados. Ele é uma das raízes do samba carioca.',
      'As pessoas formam uma roda, batem palmas e cantam, enquanto alguém '
          'dança no centro com passos miúdos, o chamado miudinho. Viola, '
          'pandeiro e prato e faca são instrumentos comuns.',
      'Em 2005, o samba de roda foi uma das primeiras expressões '
          'brasileiras reconhecidas pela Unesco como Patrimônio Cultural '
          'Imaterial da Humanidade.',
    ],
  ),

  // ---------------- Jogos ----------------
  Artigo(
    id: 'a109',
    objetivoId: 'ver_conteudo',
    categoriaId: 'ver_jogos',
    nivel: 1,
    titulo: 'O primeiro videogame cabia num osciloscópio',
    autor: 'Equipe Ikai',
    resumo:
        'Em 1958, um físico criou um jogo de tênis numa tela de laboratório '
        'para animar a visita do público.',
    tags: ['videogame', 'história', 'tecnologia'],
    paragrafos: [
      'Em 1958, o físico William Higinbotham montou o "Tennis for Two" no '
          'Laboratório Nacional de Brookhaven, nos Estados Unidos. O jogo '
          'aparecia na tela de um osciloscópio, um aparelho de medição.',
      'Dois jogadores usavam controles com um botão e um botão giratório '
          'para rebater uma bolinha de luz sobre uma rede, vista de lado. '
          'A fila de visitantes para jogar foi enorme.',
      'Anos depois, em 1972, o Pong levou a mesma ideia para os fliperamas '
          'e ajudou a criar a indústria dos videogames.',
    ],
  ),
  Artigo(
    id: 'a110',
    objetivoId: 'ver_conteudo',
    categoriaId: 'ver_jogos',
    nivel: 1,
    titulo: 'Sudoku: números sem fazer conta',
    autor: 'Equipe Ikai',
    resumo:
        'Apesar dos números, o sudoku é um jogo de lógica: dava para jogar '
        'com letras ou cores.',
    tags: ['lógica', 'quebra-cabeça', 'raciocínio'],
    paragrafos: [
      'O objetivo do sudoku é preencher uma grade de 9 por 9 casas de modo '
          'que cada linha, cada coluna e cada quadrado de 3 por 3 tenha os '
          'números de 1 a 9 sem repetição.',
      'Uma versão parecida apareceu nos Estados Unidos no fim dos anos '
          '1970. O nome que pegou veio do Japão, onde o jogo ficou popular '
          'nos anos 1980.',
      'Nenhuma soma é necessária. Os números são só símbolos: o que conta '
          'é eliminar possibilidades. Por isso o sudoku é um bom exercício '
          'de atenção e paciência.',
    ],
  ),
  Artigo(
    id: 'a111',
    objetivoId: 'ver_conteudo',
    categoriaId: 'ver_jogos',
    nivel: 2,
    titulo: 'Jogos cooperativos: todo mundo ganha ou perde junto',
    autor: 'Equipe Ikai',
    resumo:
        'Em vez de vencer os colegas, os jogadores se unem contra o próprio '
        'jogo, e isso muda a forma de conversar na mesa.',
    tags: ['tabuleiro', 'cooperação', 'convivência'],
    paragrafos: [
      'Nos jogos cooperativos, o grupo enfrenta um desafio comum: conter '
          'uma epidemia, escapar de uma ilha ou apagar incêndios. Ou todos '
          'vencem, ou todos perdem.',
      'Como ninguém precisa esconder informação dos outros, a partida vira '
          'uma conversa sobre estratégia. Cada jogador costuma ter uma '
          'habilidade diferente, o que obriga o grupo a se ouvir.',
      'Esse formato é muito usado em escolas e famílias, porque reduz a '
          'frustração de quem perde e incentiva a decisão em conjunto.',
    ],
  ),
  Artigo(
    id: 'a112',
    objetivoId: 'ver_conteudo',
    categoriaId: 'ver_jogos',
    nivel: 1,
    titulo: 'Damas: um jogo antigo de regras simples',
    autor: 'Equipe Ikai',
    resumo:
        'Peças que andam na diagonal, capturas por salto e a promoção a '
        'dama: poucas regras, muitas estratégias.',
    tags: ['tabuleiro', 'estratégia', 'clássicos'],
    paragrafos: [
      'Jogos parecidos com as damas existem há séculos. A versão mais '
          'jogada no Brasil usa um tabuleiro de 64 casas e 12 peças para '
          'cada jogador, sempre nas casas escuras.',
      'As peças andam uma casa na diagonal, para a frente, e capturam '
          'saltando sobre a peça adversária. Quando chegam à última fileira, '
          'viram damas e ganham mais liberdade de movimento.',
      'Uma boa dica para iniciantes é não espalhar as peças cedo demais. '
          'Peças juntas se protegem, e a obrigação de capturar pode virar '
          'uma armadilha para o adversário.',
    ],
  ),

  // ---------------- Notícias ----------------
  Artigo(
    id: 'a113',
    objetivoId: 'ver_conteudo',
    categoriaId: 'ver_noticia',
    nivel: 1,
    titulo: 'Notícia e opinião não são a mesma coisa',
    autor: 'Equipe Ikai',
    resumo:
        'A notícia conta o que aconteceu; o artigo de opinião defende um '
        'ponto de vista. Saber a diferença evita confusão.',
    tags: ['jornalismo', 'leitura crítica', 'mídia'],
    paragrafos: [
      'A notícia relata fatos: o que aconteceu, onde, quando, com quem e '
          'por quê. O ideal é que ela ouça os lados envolvidos e deixe o '
          'leitor tirar as próprias conclusões.',
      'Colunas, editoriais e artigos de opinião são diferentes: neles, o '
          'autor interpreta os fatos e defende uma posição. Isso é legítimo, '
          'desde que esteja claro para quem lê.',
      'Para identificar, repare em palavras como "acredito" e "defendo", '
          'na seção do jornal e no nome do autor no topo. Bons veículos '
          'separam essas duas coisas de forma visível.',
    ],
  ),
  Artigo(
    id: 'a114',
    objetivoId: 'ver_conteudo',
    categoriaId: 'ver_noticia',
    nivel: 2,
    titulo: 'Fonte primária: ir direto à origem',
    autor: 'Equipe Ikai',
    resumo:
        'Antes de confiar num dado, vale perguntar de onde ele veio. A '
        'fonte primária é a origem da informação.',
    tags: ['jornalismo', 'pesquisa', 'checagem'],
    paragrafos: [
      'Fonte primária é a origem da informação: o documento oficial, a '
          'pesquisa publicada, a pessoa que presenciou o fato. Fonte '
          'secundária é quem reconta essa origem, como uma reportagem.',
      'Quando uma notícia cita um estudo, um bom hábito é procurar o '
          'próprio estudo, ou pelo menos o resumo dele. Às vezes o título da '
          'reportagem exagera o que a pesquisa realmente concluiu.',
      'Órgãos públicos, universidades e institutos de pesquisa costumam '
          'publicar seus dados na internet. Consultar a origem leva poucos '
          'minutos e evita muitos enganos.',
    ],
  ),
  Artigo(
    id: 'a115',
    objetivoId: 'ver_conteudo',
    categoriaId: 'ver_noticia',
    nivel: 2,
    titulo: 'Como ler um gráfico sem cair em truques',
    autor: 'Equipe Ikai',
    resumo:
        'Um eixo que não começa no zero pode transformar uma diferença '
        'pequena num abismo. Saiba o que olhar primeiro.',
    tags: ['dados', 'gráficos', 'leitura crítica'],
    paragrafos: [
      'Antes de olhar as barras ou linhas, leia o título, a unidade e a '
          'fonte do gráfico. Saber se os números são em mil, em milhões ou '
          'em porcentagem muda tudo.',
      'Depois, confira onde começa o eixo vertical. Se ele começa em 90 e '
          'não em 0, uma diferença de 2 pontos pode parecer enorme. Nem '
          'sempre é má-fé, mas é preciso perceber.',
      'Por fim, veja o período mostrado. Recortar só alguns meses pode '
          'esconder a tendência de anos. Um gráfico honesto deixa claro o '
          'que está mostrando e o que ficou de fora.',
    ],
  ),
  Artigo(
    id: 'a116',
    objetivoId: 'ver_conteudo',
    categoriaId: 'ver_noticia',
    nivel: 1,
    titulo: 'Imagem fora de contexto: a notícia falsa mais simples',
    autor: 'Equipe Ikai',
    resumo:
        'Uma foto verdadeira com a legenda errada engana tanto quanto uma '
        'montagem. A busca reversa de imagens ajuda a descobrir a origem.',
    tags: ['desinformação', 'checagem', 'imagens'],
    paragrafos: [
      'Muita desinformação não usa montagem: pega uma foto real, de outro '
          'lugar ou de outro ano, e coloca uma legenda nova. Uma enchente '
          'antiga vira "a enchente de hoje", por exemplo.',
      'Uma forma de checar é a busca reversa de imagens, oferecida por '
          'buscadores na internet. Ela mostra onde a mesma foto já apareceu '
          'antes e, muitas vezes, a data e o contexto originais.',
      'Também ajuda reparar em detalhes: placas, roupas, clima e idioma '
          'combinam com o lugar que a legenda diz? Se a imagem provoca '
          'raiva imediata, vale ainda mais desconfiar antes de compartilhar.',
    ],
  ),

  // ---------------- Esporte ----------------
  Artigo(
    id: 'a117',
    objetivoId: 'ver_conteudo',
    categoriaId: 'ver_esporte',
    nivel: 1,
    titulo: 'O vôlei nasceu para ser um esporte leve',
    autor: 'Equipe Ikai',
    resumo:
        'Em 1895, um professor criou um jogo com menos contato físico que o '
        'basquete, pensado para adultos.',
    tags: ['vôlei', 'história', 'esportes'],
    paragrafos: [
      'O vôlei foi criado em 1895 por William Morgan, professor de '
          'educação física nos Estados Unidos. Ele queria uma atividade '
          'coletiva menos intensa que o basquete para os alunos mais velhos.',
      'No começo, o jogo se chamava "mintonette" e usava uma rede de tênis '
          'levantada. O nome mudou para volleyball, porque a bola era '
          'rebatida no ar, sem tocar o chão.',
      'O esporte entrou nos Jogos Olímpicos em 1964, em Tóquio. O Brasil '
          'se tornou uma das grandes potências do vôlei, na quadra e na '
          'praia.',
    ],
  ),
  Artigo(
    id: 'a118',
    objetivoId: 'ver_conteudo',
    categoriaId: 'ver_esporte',
    nivel: 2,
    titulo: 'Quando o futebol feminino foi proibido no Brasil',
    autor: 'Equipe Ikai',
    resumo:
        'Por quase quatro décadas, uma lei impediu as mulheres de jogar '
        'futebol oficialmente no país.',
    tags: ['futebol', 'mulheres no esporte', 'história'],
    paragrafos: [
      'Em 1941, um decreto proibiu as mulheres de praticar esportes '
          'considerados "incompatíveis com a sua natureza". Na prática, o '
          'futebol feminino ficou fora da lei no Brasil.',
      'Mesmo assim, muitas mulheres continuaram jogando em campos de '
          'várzea. A proibição só caiu em 1979, e a modalidade foi '
          'regulamentada no começo dos anos 1980.',
      'Esse atraso ajuda a entender por que o futebol feminino ainda luta '
          'por estrutura e visibilidade. Jogadoras como Marta, eleita várias '
          'vezes a melhor do mundo, mudaram essa história.',
    ],
  ),
  Artigo(
    id: 'a119',
    objetivoId: 'ver_conteudo',
    categoriaId: 'ver_esporte',
    nivel: 1,
    titulo: 'Paralimpíadas: do hospital ao estádio',
    autor: 'Equipe Ikai',
    resumo:
        'Os Jogos Paralímpicos começaram como uma competição entre '
        'veteranos de guerra num hospital inglês.',
    tags: ['paralimpíadas', 'inclusão', 'esportes'],
    paragrafos: [
      'Em 1948, o médico Ludwig Guttmann organizou uma competição de tiro '
          'com arco entre pacientes em cadeira de rodas no hospital de Stoke '
          'Mandeville, na Inglaterra.',
      'A ideia cresceu, e em 1960, em Roma, aconteceram os primeiros Jogos '
          'Paralímpicos, com atletas de vários países. Hoje eles são '
          'realizados logo depois dos Jogos Olímpicos, na mesma cidade.',
      'O Brasil tem uma das delegações paralímpicas mais vitoriosas do '
          'mundo, com destaque para a natação, o atletismo e o futebol de '
          'cegos.',
    ],
  ),
  Artigo(
    id: 'a120',
    objetivoId: 'ver_conteudo',
    categoriaId: 'ver_esporte',
    nivel: 2,
    titulo: 'Por que a cesta de basquete fica a 3,05 metros',
    autor: 'Equipe Ikai',
    resumo:
        'A altura da cesta vem de um acaso: era a altura da sacada do '
        'ginásio onde o jogo foi inventado.',
    tags: ['basquete', 'história', 'curiosidades'],
    paragrafos: [
      'O basquete foi inventado em 1891 por James Naismith, professor no '
          'Canadá que trabalhava nos Estados Unidos. Ele precisava de um '
          'jogo coletivo para os alunos praticarem dentro do ginásio no '
          'inverno.',
      'Naismith pendurou dois cestos de pêssego na sacada do ginásio, que '
          'ficava a 10 pés do chão, cerca de 3,05 metros. A altura foi '
          'mantida até hoje.',
      'No começo, os cestos tinham fundo, e alguém precisava subir para '
          'tirar a bola a cada ponto. O aro vazado só apareceu alguns anos '
          'depois.',
    ],
  ),

  // ---------------- Curiosidades ----------------
  Artigo(
    id: 'a121',
    objetivoId: 'ver_conteudo',
    categoriaId: 'ver_curiosidades',
    nivel: 1,
    titulo: 'Por que o bocejo é contagioso',
    autor: 'Equipe Ikai',
    resumo:
        'Ver alguém bocejar dá vontade de bocejar também. A ciência ainda '
        'investiga o motivo, mas há boas pistas.',
    tags: ['corpo humano', 'comportamento', 'ciência'],
    paragrafos: [
      'Bocejar quando outra pessoa boceja é muito comum em humanos e '
          'também acontece em outros animais, como chimpanzés e cães. Às '
          'vezes basta ler sobre bocejos para sentir vontade.',
      'Uma das hipóteses liga o bocejo contagioso à empatia: estudos '
          'indicam que ele acontece mais entre pessoas próximas, como '
          'amigos e familiares, do que entre desconhecidos.',
      'Outra hipótese é que o bocejo ajuda a regular a temperatura do '
          'cérebro e a manter o grupo alerta ao mesmo tempo. Provavelmente '
          'mais de um motivo atua junto.',
    ],
  ),
  Artigo(
    id: 'a122',
    objetivoId: 'ver_conteudo',
    categoriaId: 'ver_curiosidades',
    nivel: 1,
    titulo: 'A dança das abelhas',
    autor: 'Equipe Ikai',
    resumo:
        'Abelhas contam umas às outras onde há flores dançando dentro da '
        'colmeia. A descoberta rendeu um Prêmio Nobel.',
    tags: ['animais', 'abelhas', 'comunicação'],
    paragrafos: [
      'Quando uma abelha operária encontra uma boa fonte de néctar, ela '
          'volta à colmeia e faz uma espécie de dança, andando em forma de '
          'oito e balançando o corpo na parte reta do caminho.',
      'A direção da parte reta indica para onde ir, em relação ao Sol, e '
          'a duração do balanço indica a distância. As outras abelhas '
          'acompanham os movimentos e saem para buscar as flores.',
      'O austríaco Karl von Frisch decifrou essa linguagem e dividiu o '
          'Prêmio Nobel de Fisiologia ou Medicina de 1973 com outros dois '
          'pesquisadores do comportamento animal.',
    ],
  ),
  Artigo(
    id: 'a123',
    objetivoId: 'ver_conteudo',
    categoriaId: 'ver_curiosidades',
    nivel: 1,
    titulo: 'O flamingo é rosa por causa do que come',
    autor: 'Equipe Ikai',
    resumo:
        'Os filhotes nascem acinzentados. A cor vem de pigmentos de algas e '
        'pequenos crustáceos da alimentação.',
    tags: ['animais', 'aves', 'alimentação'],
    paragrafos: [
      'Os flamingos nascem com penas cinzentas ou brancas. O rosa aparece '
          'aos poucos, conforme eles se alimentam de algas, larvas e '
          'pequenos crustáceos.',
      'Esses alimentos têm carotenoides, os mesmos pigmentos que dão cor à '
          'cenoura. O corpo do flamingo processa essas substâncias e as '
          'deposita nas penas, na pele e no bico.',
      'Quanto mais carotenoides na dieta, mais forte a cor. Em zoológicos, '
          'a alimentação precisa ser planejada para que as aves mantenham o '
          'tom rosado.',
    ],
  ),
  Artigo(
    id: 'a124',
    objetivoId: 'ver_conteudo',
    categoriaId: 'ver_curiosidades',
    nivel: 2,
    titulo: 'A banana é levemente radioativa (e tudo bem)',
    autor: 'Equipe Ikai',
    resumo:
        'O potássio da banana tem uma pequena parte radioativa, mas seria '
        'preciso comer quantidades impossíveis para fazer mal.',
    tags: ['química', 'radioatividade', 'alimentação'],
    paragrafos: [
      'A banana é rica em potássio, e uma fração minúscula de todo potássio '
          'da natureza é o potássio-40, um tipo radioativo. Por isso a fruta '
          'emite uma radiação bem pequena.',
      'Nosso próprio corpo também tem potássio-40, e o organismo mantém a '
          'quantidade de potássio estável, eliminando o excesso. Comer '
          'bananas não acumula radiação.',
      'A comparação serve para mostrar que radiação existe em todo lugar, '
          'em níveis naturais e inofensivos. O que importa é a dose, e a '
          'de uma banana é muito, muito baixa.',
    ],
  ),
];
