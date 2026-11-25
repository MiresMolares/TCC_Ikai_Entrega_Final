import 'artigo.dart';

/// Mais artigos de "Estudar", parte 1 (a172 a a193), escritos para o Ikai.
/// Entram no acervo por `artigosDados` (artigos_dados.dart).
const List<Artigo> artigosEstudar = [
  // ---------------- Matemática ----------------
  Artigo(
    id: 'a172',
    objetivoId: 'estudar',
    categoriaId: 'estudar_matematica',
    nivel: 1,
    titulo: 'Frações na cozinha e na pizza',
    autor: 'Equipe Ikai',
    resumo:
        'Meia xícara, um terço da pizza, três quartos do tanque: frações '
        'aparecem o tempo todo no dia a dia.',
    tags: ['frações', 'matemática básica', 'cotidiano'],
    paragrafos: [
      'Uma fração representa partes de um inteiro. Em 3/4, o número de baixo, '
          'o denominador, diz em quantas partes iguais o inteiro foi dividido. '
          'O de cima, o numerador, diz quantas partes foram tomadas.',
      'Se uma pizza tem 8 fatias e você come 2, comeu 2/8 da pizza, que é o '
          'mesmo que 1/4. Dividir o numerador e o denominador pelo mesmo '
          'número simplifica a fração sem mudar o valor.',
      'Para somar frações com denominadores diferentes, primeiro deixe os '
          'denominadores iguais. Por exemplo, 1/2 + 1/4 vira 2/4 + 1/4, que dá '
          '3/4.',
    ],
  ),
  Artigo(
    id: 'a173',
    objetivoId: 'estudar',
    categoriaId: 'estudar_matematica',
    nivel: 2,
    titulo: 'Porcentagem sem mistério',
    autor: 'Equipe Ikai',
    resumo:
        'Por cento quer dizer "a cada cem". Com esse olhar, descontos e '
        'aumentos ficam fáceis de calcular.',
    tags: ['porcentagem', 'matemática financeira', 'cotidiano'],
    paragrafos: [
      'Porcentagem é uma fração com denominador 100. Dizer 25% é o mesmo que '
          'dizer 25 de cada 100, ou 25/100, ou 0,25.',
      'Para calcular 20% de 150, multiplique 150 por 0,20: o resultado é 30. '
          'Um atalho útil: 10% de qualquer valor é só andar a vírgula uma casa '
          'para a esquerda.',
      'Cuidado com aumentos e descontos seguidos. Um produto de 100 reais que '
          'sobe 10% vai a 110; se depois cair 10%, vai a 99, e não volta a '
          '100.',
    ],
  ),

  // ---------------- Língua Portuguesa ----------------
  Artigo(
    id: 'a174',
    objetivoId: 'estudar',
    categoriaId: 'estudar_lp',
    nivel: 1,
    titulo: 'Mas ou mais?',
    autor: 'Equipe Ikai',
    resumo:
        'Uma letra muda tudo: "mas" indica oposição, "mais" indica '
        'quantidade. Um teste rápido resolve a dúvida.',
    tags: ['gramática', 'ortografia', 'dúvidas comuns'],
    paragrafos: [
      '"Mas" é uma conjunção que indica oposição, com o mesmo sentido de '
          '"porém" ou "contudo". Exemplo: "Estudei muito, mas a prova estava '
          'difícil."',
      '"Mais" indica quantidade ou intensidade, o contrário de "menos". '
          'Exemplo: "Quero mais tempo para ler."',
      'O teste: troque a palavra por "porém". Se a frase continuar fazendo '
          'sentido, o certo é "mas". Se ficar estranha, tente "menos": se '
          'funcionar como oposto, use "mais".',
    ],
  ),
  Artigo(
    id: 'a175',
    objetivoId: 'estudar',
    categoriaId: 'estudar_lp',
    nivel: 1,
    titulo: 'Sujeito e predicado: quem faz e o que se diz',
    autor: 'Equipe Ikai',
    resumo:
        'Toda oração gira em torno de um verbo. Perguntar "quem?" para esse '
        'verbo ajuda a encontrar o sujeito.',
    tags: ['sintaxe', 'gramática', 'análise sintática'],
    paragrafos: [
      'O sujeito é o termo sobre o qual se fala na oração. O predicado é '
          'aquilo que se diz sobre o sujeito, e sempre contém um verbo.',
      'Na frase "Os alunos leram o livro", pergunte ao verbo: quem leu? "Os '
          'alunos" é o sujeito. "Leram o livro" é o predicado.',
      'O sujeito nem sempre aparece no começo: em "Chegaram as encomendas", '
          'quem chegou? As encomendas. E às vezes ele está escondido, como em '
          '"Saímos cedo", em que o sujeito é "nós".',
    ],
  ),
  Artigo(
    id: 'a176',
    objetivoId: 'estudar',
    categoriaId: 'estudar_lp',
    nivel: 2,
    titulo: 'Acentuação das oxítonas',
    autor: 'Equipe Ikai',
    resumo:
        'Café, você, cipó, também: as oxítonas terminadas em a, e, o e em '
        'levam acento. Entenda a regra.',
    tags: ['acentuação', 'ortografia', 'regras'],
    paragrafos: [
      'Oxítonas são palavras cuja sílaba mais forte é a última, como '
          '"café" e "jacaré". Em "parede", por exemplo, a sílaba forte é a '
          'penúltima, então ela não é oxítona. Achar a sílaba tônica é o '
          'primeiro passo.',
      'Levam acento as oxítonas terminadas em a, e, o, seguidas ou não de s, '
          'e em em ou ens: sofá, você, avós, também, parabéns.',
      'Já as terminadas em i e u não levam acento, como "caqui" e "urubu", '
          'a não ser em casos especiais de hiato, como "Piauí" e "baú".',
    ],
  ),
  Artigo(
    id: 'a177',
    objetivoId: 'estudar',
    categoriaId: 'estudar_lp',
    nivel: 2,
    titulo: 'Coesão: as palavras que costuram o texto',
    autor: 'Equipe Ikai',
    resumo:
        'Conectivos como "portanto", "além disso" e "no entanto" mostram a '
        'relação entre as ideias e deixam a redação mais clara.',
    tags: ['redação', 'conectivos', 'texto'],
    paragrafos: [
      'Coesão é a ligação entre as partes de um texto. Ela é feita por '
          'conectivos e por palavras que retomam o que já foi dito, evitando '
          'repetições.',
      'Cada conectivo tem uma função: "além disso" acrescenta, "no entanto" '
          'opõe, "portanto" conclui, "por exemplo" ilustra. Usar o conectivo '
          'errado confunde o leitor.',
      'Para retomar ideias, use pronomes e sinônimos: em vez de repetir "o '
          'livro", escreva "a obra" ou "ele". Uma releitura em voz alta ajuda a '
          'perceber onde o texto tropeça.',
    ],
  ),

  // ---------------- Inglês ----------------
  Artigo(
    id: 'a178',
    objetivoId: 'estudar',
    categoriaId: 'estudar_ingles',
    nivel: 1,
    titulo: 'Simple past: contando o que aconteceu',
    autor: 'Equipe Ikai',
    resumo:
        'Para falar do passado em inglês, muitos verbos só ganham -ed no '
        'final. Os irregulares precisam ser memorizados.',
    tags: ['inglês', 'gramática', 'verbos'],
    paragrafos: [
      'O simple past é usado para ações terminadas no passado. Nos verbos '
          'regulares, basta acrescentar -ed: "I played soccer yesterday", eu '
          'joguei futebol ontem.',
      'Os verbos irregulares têm formas próprias: go vira went, eat vira '
          'ate, see vira saw. A boa notícia é que eles são iguais para todas '
          'as pessoas: I went, she went, they went.',
      'Nas perguntas e negativas, usa-se "did", e o verbo volta à forma '
          'básica: "Did you see the movie?" e "I did not see it".',
    ],
  ),
  Artigo(
    id: 'a179',
    objetivoId: 'estudar',
    categoriaId: 'estudar_ingles',
    nivel: 2,
    titulo: 'Present continuous: o que está acontecendo agora',
    autor: 'Equipe Ikai',
    resumo:
        'Verbo to be mais -ing: é assim que o inglês fala de ações em '
        'andamento, como o nosso gerúndio.',
    tags: ['inglês', 'gramática', 'tempos verbais'],
    paragrafos: [
      'O present continuous indica uma ação em andamento. Ele é formado pelo '
          'verbo to be (am, is, are) mais o verbo com -ing: "I am reading", '
          'estou lendo.',
      'Ele também serve para planos próximos: "We are traveling tomorrow", '
          'vamos viajar amanhã.',
      'Atenção a alguns ajustes na escrita: em verbos terminados em -e, o e '
          'cai (make, making); em alguns verbos curtos, a última consoante '
          'dobra (run, running; swim, swimming).',
    ],
  ),

  // ---------------- Artes ----------------
  Artigo(
    id: 'a180',
    objetivoId: 'estudar',
    categoriaId: 'estudar_artes',
    nivel: 1,
    titulo: 'Tarsila do Amaral e o Abaporu',
    autor: 'Equipe Ikai',
    resumo:
        'Pintado em 1928, o quadro de uma figura de pés enormes deu origem '
        'ao movimento antropofágico.',
    tags: ['Tarsila do Amaral', 'modernismo', 'pintura brasileira'],
    paragrafos: [
      'Tarsila do Amaral pintou o Abaporu em 1928 e deu o quadro de presente '
          'ao escritor Oswald de Andrade, com quem era casada. A obra mostra '
          'uma figura de pés e mãos enormes e cabeça pequena, ao lado de um '
          'cacto.',
      'O nome vem do tupi e significa algo como "homem que come gente". O '
          'quadro inspirou o Manifesto Antropófago, que propunha "devorar" a '
          'cultura estrangeira e transformá-la em algo brasileiro.',
      'Hoje o Abaporu está no Museu de Arte Latino-Americana de Buenos Aires, '
          'o Malba. As cores fortes e as formas simplificadas são marcas da '
          'pintora.',
    ],
  ),
  Artigo(
    id: 'a181',
    objetivoId: 'estudar',
    categoriaId: 'estudar_artes',
    nivel: 2,
    titulo: 'Semana de Arte Moderna de 1922',
    autor: 'Equipe Ikai',
    resumo:
        'Três noites no Theatro Municipal de São Paulo marcaram a ruptura '
        'com a arte acadêmica no Brasil.',
    tags: ['modernismo', 'história da arte', 'São Paulo'],
    paragrafos: [
      'A Semana de Arte Moderna aconteceu em fevereiro de 1922, no Theatro '
          'Municipal de São Paulo, no ano do centenário da Independência. '
          'Houve exposições, leituras de poemas e concertos.',
      'Participaram nomes como Anita Malfatti, Di Cavalcanti, Mário de '
          'Andrade, Oswald de Andrade e Heitor Villa-Lobos. Tarsila do Amaral '
          'estava em Paris e se juntou ao grupo pouco depois.',
      'O público vaiou parte das apresentações. Mesmo assim, a Semana se '
          'tornou um marco: os modernistas queriam uma arte livre das regras '
          'acadêmicas e atenta à cultura brasileira.',
    ],
  ),
  Artigo(
    id: 'a182',
    objetivoId: 'estudar',
    categoriaId: 'estudar_artes',
    nivel: 1,
    titulo: 'Cores primárias e secundárias',
    autor: 'Equipe Ikai',
    resumo:
        'Misturando poucas cores, dá para chegar a quase todas as outras. '
        'Mas o resultado depende de usar tinta ou luz.',
    tags: ['cores', 'pintura', 'teoria da cor'],
    paragrafos: [
      'Na pintura tradicional, as cores primárias são vermelho, amarelo e '
          'azul. Misturadas duas a duas, formam as secundárias: laranja, verde '
          'e roxo.',
      'Nas impressoras, as primárias usadas são ciano, magenta e amarelo, '
          'que reproduzem mais tons. Já nas telas, que trabalham com luz, as '
          'primárias são vermelho, verde e azul.',
      'Na luz, misturar as três primárias resulta em branco; na tinta, '
          'misturar muitas cores tende ao marrom ou ao cinza escuro. Por isso '
          'a mesma imagem pode mudar entre a tela e o papel.',
    ],
  ),
  Artigo(
    id: 'a183',
    objetivoId: 'estudar',
    categoriaId: 'estudar_artes',
    nivel: 2,
    titulo: 'Aleijadinho e o barroco mineiro',
    autor: 'Equipe Ikai',
    resumo:
        'Nas igrejas de Minas Gerais, Antônio Francisco Lisboa esculpiu '
        'profetas em pedra-sabão que impressionam até hoje.',
    tags: ['barroco', 'escultura', 'Minas Gerais'],
    paragrafos: [
      'Antônio Francisco Lisboa, o Aleijadinho, viveu em Minas Gerais no '
          'século 18, durante o ciclo do ouro. Era filho de um arquiteto '
          'português e de uma mulher escravizada.',
      'Ele trabalhou como escultor e arquiteto em igrejas de cidades como Ouro '
          'Preto e Congonhas. Em Congonhas, esculpiu doze profetas em pedra-'
          'sabão e cenas da Paixão de Cristo em madeira.',
      'O apelido se refere a uma doença que deformou seu corpo. Mesmo com '
          'dificuldades para trabalhar, ele produziu obras que fazem parte do '
          'patrimônio cultural do Brasil.',
    ],
  ),

  // ---------------- História ----------------
  Artigo(
    id: 'a184',
    objetivoId: 'estudar',
    categoriaId: 'estudar_historia',
    nivel: 1,
    titulo: 'Revolução Industrial: quando as máquinas mudaram o trabalho',
    autor: 'Equipe Ikai',
    resumo:
        'Começando na Inglaterra do século 18, as fábricas e a máquina a '
        'vapor transformaram cidades, trabalho e consumo.',
    tags: ['Revolução Industrial', 'trabalho', 'tecnologia'],
    paragrafos: [
      'A Revolução Industrial começou na Inglaterra, na segunda metade do '
          'século 18. A produção de tecidos, antes feita à mão, passou a ser '
          'feita em fábricas com máquinas.',
      'A máquina a vapor, aperfeiçoada por James Watt, movimentou fábricas, '
          'trens e navios. Muitas pessoas deixaram o campo para trabalhar nas '
          'cidades.',
      'As jornadas eram longas, inclusive para crianças, e as condições '
          'muito duras. Isso deu origem aos primeiros sindicatos e às lutas por '
          'direitos trabalhistas.',
    ],
  ),
  Artigo(
    id: 'a185',
    objetivoId: 'estudar',
    categoriaId: 'estudar_historia',
    nivel: 1,
    titulo: 'Lei Áurea: o fim oficial da escravidão',
    autor: 'Equipe Ikai',
    resumo:
        'Em 13 de maio de 1888, o Brasil foi o último país das Américas a '
        'abolir a escravidão, sem garantir direitos aos libertos.',
    tags: ['abolição', 'Brasil Império', 'escravidão'],
    paragrafos: [
      'A Lei Áurea foi assinada pela princesa Isabel em 13 de maio de 1888 e '
          'declarou extinta a escravidão no Brasil. O país foi o último das '
          'Américas a dar esse passo.',
      'A abolição foi resultado de décadas de pressão: fugas, quilombos, '
          'revoltas de pessoas escravizadas e campanhas de abolicionistas como '
          'Luiz Gama, André Rebouças e José do Patrocínio.',
      'A lei não previu terra, trabalho ou educação para os libertos. Por '
          'isso, muitos historiadores lembram que as consequências da '
          'escravidão continuam presentes na desigualdade brasileira.',
    ],
  ),
  Artigo(
    id: 'a186',
    objetivoId: 'estudar',
    categoriaId: 'estudar_historia',
    nivel: 2,
    titulo: 'As Grandes Navegações',
    autor: 'Equipe Ikai',
    resumo:
        'Nos séculos 15 e 16, portugueses e espanhóis se lançaram ao '
        'oceano em busca de rotas para as especiarias do Oriente.',
    tags: ['navegações', 'Portugal', 'colonização'],
    paragrafos: [
      'No século 15, as especiarias do Oriente, como pimenta e canela, valiam '
          'muito na Europa. Portugal e Espanha buscaram novas rotas marítimas '
          'para chegar até elas sem intermediários.',
      'Em 1492, Cristóvão Colombo, a serviço da Espanha, chegou à América. Em '
          '1498, Vasco da Gama chegou à Índia contornando a África. Em 1500, a '
          'frota de Pedro Álvares Cabral chegou ao território que hoje é o '
          'Brasil.',
      'As navegações foram possíveis graças a instrumentos como a bússola e o '
          'astrolábio e a embarcações como a caravela. Para os povos da '
          'América e da África, porém, elas significaram conquista e '
          'violência.',
    ],
  ),
  Artigo(
    id: 'a187',
    objetivoId: 'estudar',
    categoriaId: 'estudar_historia',
    nivel: 2,
    titulo: 'Era Vargas: quinze anos que mudaram o Brasil',
    autor: 'Equipe Ikai',
    resumo:
        'De 1930 a 1945, Getúlio Vargas governou o país, criou leis '
        'trabalhistas e também comandou uma ditadura.',
    tags: ['Era Vargas', 'República', 'direitos trabalhistas'],
    paragrafos: [
      'Getúlio Vargas chegou ao poder com a Revolução de 1930 e governou até '
          '1945. Em 1937, deu um golpe e instaurou o Estado Novo, uma ditadura '
          'com censura e perseguição a opositores.',
      'No mesmo período, foram criados o salário mínimo e a Consolidação das '
          'Leis do Trabalho, a CLT, de 1943. Também houve forte investimento '
          'em indústrias, como a siderurgia.',
      'Vargas voltou à presidência eleito em 1950 e morreu em 1954, no '
          'exercício do cargo. Sua trajetória mostra como direitos sociais e '
          'autoritarismo conviveram no mesmo governo.',
    ],
  ),

  // ---------------- Geografia ----------------
  Artigo(
    id: 'a188',
    objetivoId: 'estudar',
    categoriaId: 'estudar_geografia',
    nivel: 1,
    titulo: 'Os seis biomas do Brasil',
    autor: 'Equipe Ikai',
    resumo:
        'Amazônia, Cerrado, Caatinga, Mata Atlântica, Pampa e Pantanal: cada '
        'bioma tem clima, vegetação e animais próprios.',
    tags: ['biomas', 'meio ambiente', 'Brasil'],
    paragrafos: [
      'Bioma é um conjunto de ecossistemas com clima, solo e vegetação '
          'parecidos. O Brasil tem seis: Amazônia, Cerrado, Caatinga, Mata '
          'Atlântica, Pampa e Pantanal.',
      'A Amazônia é o maior deles e abriga a maior floresta tropical do '
          'mundo. O Cerrado, no centro do país, é chamado de berço das águas, '
          'porque nele nascem rios importantes. A Caatinga existe só no Brasil.',
      'A Mata Atlântica, no litoral, foi o bioma mais devastado desde a '
          'colonização. O Pantanal é uma das maiores planícies alagáveis do '
          'planeta, e o Pampa tem campos abertos no Rio Grande do Sul.',
    ],
  ),
  Artigo(
    id: 'a189',
    objetivoId: 'estudar',
    categoriaId: 'estudar_geografia',
    nivel: 2,
    titulo: 'Escala cartográfica: o mundo em miniatura',
    autor: 'Equipe Ikai',
    resumo:
        'Uma escala de 1:100.000 quer dizer que 1 centímetro no mapa vale '
        '1 quilômetro no terreno.',
    tags: ['cartografia', 'mapas', 'cálculo'],
    paragrafos: [
      'A escala mostra quantas vezes a realidade foi reduzida para caber no '
          'mapa. Na escala numérica 1:100.000, cada centímetro no papel '
          'corresponde a 100.000 centímetros no terreno, ou seja, 1 km.',
      'Para calcular uma distância real, meça no mapa e multiplique pelo '
          'número da escala. Se duas cidades estão a 5 cm num mapa de '
          '1:100.000, a distância é de 5 km em linha reta.',
      'Escala grande mostra uma área pequena com muitos detalhes, como a '
          'planta de um bairro. Escala pequena mostra áreas grandes com poucos '
          'detalhes, como um mapa-múndi.',
    ],
  ),

  // ---------------- Filosofia ----------------
  Artigo(
    id: 'a190',
    objetivoId: 'estudar',
    categoriaId: 'estudar_filosofia',
    nivel: 1,
    titulo: 'Aristóteles e a virtude do meio-termo',
    autor: 'Equipe Ikai',
    resumo:
        'Para o filósofo grego, a coragem fica entre a covardia e a '
        'imprudência. A virtude está no equilíbrio.',
    tags: ['Aristóteles', 'ética', 'Grécia antiga'],
    paragrafos: [
      'Aristóteles viveu no século 4 antes de Cristo e foi aluno de Platão. '
          'Na obra "Ética a Nicômaco", ele pergunta o que é uma vida boa.',
      'Para ele, a virtude é um meio-termo entre dois excessos. A coragem, '
          'por exemplo, fica entre a covardia, que é medo demais, e a '
          'imprudência, que é medo de menos.',
      'Aristóteles dizia que a virtude se aprende com a prática: ninguém nasce '
          'corajoso ou justo, mas se torna assim repetindo ações corajosas e '
          'justas.',
    ],
  ),
  Artigo(
    id: 'a191',
    objetivoId: 'estudar',
    categoriaId: 'estudar_filosofia',
    nivel: 2,
    titulo: 'Descartes: penso, logo existo',
    autor: 'Equipe Ikai',
    resumo:
        'Ao duvidar de tudo, o filósofo francês encontrou uma certeza: se '
        'estou duvidando, estou pensando, e portanto existo.',
    tags: ['Descartes', 'dúvida', 'filosofia moderna'],
    paragrafos: [
      'René Descartes, filósofo francês do século 17, queria encontrar uma '
          'base segura para o conhecimento. Para isso, decidiu duvidar de tudo '
          'o que pudesse ser posto em dúvida.',
      'Os sentidos às vezes enganam, e os sonhos parecem reais. Mas, mesmo '
          'duvidando de tudo, Descartes percebeu que não podia duvidar de que '
          'estava pensando.',
      'Daí veio a frase "penso, logo existo", publicada no "Discurso do '
          'Método", em 1637. A dúvida metódica influenciou a filosofia e a '
          'ciência modernas.',
    ],
  ),
  Artigo(
    id: 'a192',
    objetivoId: 'estudar',
    categoriaId: 'estudar_filosofia',
    nivel: 1,
    titulo: 'Ética e moral: qual é a diferença',
    autor: 'Equipe Ikai',
    resumo:
        'Moral são os costumes e regras de um grupo; ética é a reflexão '
        'sobre essas regras.',
    tags: ['ética', 'moral', 'conceitos'],
    paragrafos: [
      'As palavras ética e moral são usadas como sinônimos no dia a dia, mas '
          'a filosofia costuma diferenciá-las.',
      'Moral é o conjunto de valores e regras de comportamento de uma '
          'sociedade ou grupo, como não mentir ou respeitar os mais velhos. '
          'Ela muda conforme a época e o lugar.',
      'Ética é a reflexão crítica sobre essas regras: por que devemos segui-'
          'las? Elas são justas? Fazer essas perguntas é exatamente o trabalho '
          'da ética.',
    ],
  ),
  Artigo(
    id: 'a193',
    objetivoId: 'estudar',
    categoriaId: 'estudar_filosofia',
    nivel: 2,
    titulo: 'Kant e o imperativo categórico',
    autor: 'Equipe Ikai',
    resumo:
        'Para Kant, uma ação é correta se você puder querer que todos '
        'agissem da mesma forma.',
    tags: ['Kant', 'ética', 'dever'],
    paragrafos: [
      'Immanuel Kant foi um filósofo alemão do século 18. Ele buscou um '
          'princípio moral que valesse para todas as pessoas, independentemente '
          'dos desejos de cada uma.',
      'Uma das formulações do imperativo categórico diz: aja apenas segundo '
          'uma regra que você possa querer que se torne lei universal. Mentir '
          'para se livrar de um problema, por exemplo, não passaria no teste.',
      'Outra formulação pede que tratemos as pessoas sempre como fins, e nunca '
          'apenas como meios. Ou seja, ninguém deve ser usado só como '
          'instrumento para os objetivos dos outros.',
    ],
  ),
];
