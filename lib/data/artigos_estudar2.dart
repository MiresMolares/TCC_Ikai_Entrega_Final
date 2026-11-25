import 'artigo.dart';

/// Mais artigos de "Estudar", parte 2 (a194 a a213), escritos para o Ikai.
/// Entram no acervo por `artigosDados` (artigos_dados.dart).
const List<Artigo> artigosEstudar2 = [
  // ---------------- Sociologia ----------------
  Artigo(
    id: 'a194',
    objetivoId: 'estudar',
    categoriaId: 'estudar_sociologia',
    nivel: 2,
    titulo: 'Karl Marx e a luta de classes',
    autor: 'Equipe Ikai',
    resumo:
        'Para Marx, a história das sociedades é marcada pelo conflito entre '
        'quem é dono dos meios de produção e quem vende a força de trabalho.',
    tags: ['Marx', 'trabalho', 'classes sociais'],
    paragrafos: [
      'Karl Marx foi um pensador alemão do século 19. Ele observou as cidades '
          'industriais da Europa e escreveu sobre a relação entre patrões e '
          'operários.',
      'Segundo Marx, a burguesia é dona dos meios de produção, como fábricas '
          'e máquinas, e o proletariado vende sua força de trabalho em troca '
          'de salário. Essa relação desigual gera conflito, a luta de classes.',
      'Concordando ou não com suas conclusões, conceitos de Marx como '
          'classe social e mais-valia continuam sendo estudados na sociologia, '
          'na economia e na história.',
    ],
  ),
  Artigo(
    id: 'a195',
    objetivoId: 'estudar',
    categoriaId: 'estudar_sociologia',
    nivel: 1,
    titulo: 'Etnocentrismo: medir os outros pela própria régua',
    autor: 'Equipe Ikai',
    resumo:
        'Achar que os costumes do seu grupo são os únicos certos é uma '
        'atitude comum, e a antropologia ensina a questioná-la.',
    tags: ['cultura', 'antropologia', 'diversidade'],
    paragrafos: [
      'Etnocentrismo é julgar outras culturas a partir dos valores da sua, '
          'considerando-a o centro e o modelo de tudo. Comidas, roupas e '
          'rituais diferentes passam a ser vistos como estranhos ou errados.',
      'A antropologia propõe o relativismo cultural: entender cada costume '
          'dentro do contexto do grupo que o pratica, antes de julgar.',
      'Isso não significa aceitar qualquer violência em nome da cultura, mas '
          'sim aprender a observar com curiosidade e respeito antes de tirar '
          'conclusões.',
    ],
  ),
  Artigo(
    id: 'a196',
    objetivoId: 'estudar',
    categoriaId: 'estudar_sociologia',
    nivel: 1,
    titulo: 'Socialização: como aprendemos a viver em sociedade',
    autor: 'Equipe Ikai',
    resumo:
        'Família, escola, amigos e meios de comunicação ensinam regras, '
        'valores e comportamentos ao longo de toda a vida.',
    tags: ['socialização', 'família', 'escola'],
    paragrafos: [
      'Socialização é o processo pelo qual as pessoas aprendem as regras, '
          'os valores e os comportamentos do grupo em que vivem. Ele começa no '
          'nascimento e não termina nunca.',
      'A socialização primária acontece na infância, principalmente na '
          'família. A secundária vem depois, na escola, no trabalho, entre os '
          'amigos e também pela internet e pela televisão.',
      'Perceber esse processo ajuda a entender por que pensamos como pensamos '
          'e por que pessoas criadas em ambientes diferentes veem o mundo de '
          'formas diferentes.',
    ],
  ),
  Artigo(
    id: 'a197',
    objetivoId: 'estudar',
    categoriaId: 'estudar_sociologia',
    nivel: 2,
    titulo: 'Desigualdade social não é só de renda',
    autor: 'Equipe Ikai',
    resumo:
        'Acesso a escola, saúde, moradia e segurança também separa as '
        'pessoas. A sociologia estuda como essas diferenças se acumulam.',
    tags: ['desigualdade', 'direitos', 'sociedade'],
    paragrafos: [
      'Quando se fala em desigualdade, o primeiro pensamento costuma ser o '
          'dinheiro. Mas ela aparece também no acesso à educação, à saúde, ao '
          'saneamento, ao transporte e à cultura.',
      'Essas diferenças se somam: quem mora longe do trabalho gasta mais tempo '
          'no transporte, tem menos tempo para estudar e menos chances de '
          'melhorar de vida. Fatores como raça e gênero também influenciam.',
      'Para medir a desigualdade, pesquisadores usam indicadores como o '
          'coeficiente de Gini e o Índice de Desenvolvimento Humano. Políticas '
          'públicas tentam reduzir essas distâncias.',
    ],
  ),

  // ---------------- Educação Física ----------------
  Artigo(
    id: 'a198',
    objetivoId: 'estudar',
    categoriaId: 'estudar_ef',
    nivel: 1,
    titulo: 'Quanto exercício por semana?',
    autor: 'Equipe Ikai',
    resumo:
        'A Organização Mundial da Saúde recomenda pelo menos 150 minutos '
        'de atividade moderada por semana para adultos.',
    tags: ['saúde', 'atividade física', 'recomendações'],
    paragrafos: [
      'Para adultos, a Organização Mundial da Saúde recomenda de 150 a 300 '
          'minutos de atividade física moderada por semana, ou de 75 a 150 '
          'minutos de atividade intensa.',
      'Atividade moderada é aquela que acelera a respiração, mas ainda '
          'permite conversar, como uma caminhada rápida. Para crianças e '
          'adolescentes, a recomendação é de uma hora por dia, em média.',
      'Não precisa ser tudo de uma vez: subir escadas, andar de bicicleta e '
          'brincar também contam. O importante é se mexer mais e passar menos '
          'tempo sentado.',
    ],
  ),
  Artigo(
    id: 'a199',
    objetivoId: 'estudar',
    categoriaId: 'estudar_ef',
    nivel: 1,
    titulo: 'Hidratação: beber água antes de sentir sede',
    autor: 'Equipe Ikai',
    resumo:
        'Durante o exercício, o corpo perde água pelo suor. Repor aos poucos '
        'ajuda o desempenho e evita mal-estar.',
    tags: ['hidratação', 'saúde', 'exercício'],
    paragrafos: [
      'O suor ajuda a controlar a temperatura do corpo durante o exercício, '
          'mas leva junto água e sais minerais. Em dias quentes, a perda é '
          'ainda maior.',
      'A sede é um sinal de que a reposição já está atrasada. Uma boa prática '
          'é beber água antes da atividade e em pequenos goles durante, '
          'principalmente se ela durar mais de meia hora.',
      'A cor da urina é um indicador simples: clara indica boa hidratação; '
          'escura sugere que é preciso beber mais água.',
    ],
  ),
  Artigo(
    id: 'a200',
    objetivoId: 'estudar',
    categoriaId: 'estudar_ef',
    nivel: 2,
    titulo: 'Frequência cardíaca: o ritmo do treino',
    autor: 'Equipe Ikai',
    resumo:
        'Contar os batimentos ajuda a saber se o exercício está leve, '
        'moderado ou intenso.',
    tags: ['coração', 'treino', 'fisiologia'],
    paragrafos: [
      'A frequência cardíaca é o número de batimentos do coração por minuto. '
          'Em repouso, na maioria dos adultos, fica entre 60 e 100.',
      'Para medir, coloque dois dedos no pulso ou no pescoço, conte os '
          'batimentos por 15 segundos e multiplique por 4. Relógios e '
          'aplicativos também fazem essa conta.',
      'Uma estimativa comum da frequência máxima é 220 menos a idade. '
          'Exercícios moderados costumam ficar entre 50% e 70% desse valor. '
          'Quem tem problemas de saúde deve procurar orientação médica antes de '
          'treinar.',
    ],
  ),
  Artigo(
    id: 'a201',
    objetivoId: 'estudar',
    categoriaId: 'estudar_ef',
    nivel: 1,
    titulo: 'Fair play: o jogo limpo',
    autor: 'Equipe Ikai',
    resumo:
        'Respeitar regras, adversários e árbitros faz parte do esporte, '
        'ganhando ou perdendo.',
    tags: ['valores', 'esporte', 'respeito'],
    paragrafos: [
      'Fair play, ou jogo limpo, é a atitude de competir respeitando as '
          'regras, os adversários, os colegas de equipe e a arbitragem.',
      'Exemplos de fair play são devolver a bola ao adversário depois de '
          'uma parada por lesão, cumprimentar o time rival no fim da partida e '
          'admitir uma falta que o juiz não viu.',
      'Nas aulas de educação física, o fair play ensina a lidar com vitórias '
          'e derrotas e lembra que o objetivo principal do jogo é participar e '
          'se divertir.',
    ],
  ),

  // ---------------- Biologia ----------------
  Artigo(
    id: 'a202',
    objetivoId: 'estudar',
    categoriaId: 'estudar_biologia',
    nivel: 1,
    titulo: 'A célula, a menor unidade da vida',
    autor: 'Equipe Ikai',
    resumo:
        'Todos os seres vivos são formados por células. Algumas têm núcleo, '
        'outras não, e essa diferença divide a vida em dois grandes grupos.',
    tags: ['citologia', 'célula', 'seres vivos'],
    paragrafos: [
      'A célula é a menor estrutura capaz de realizar as funções da vida, '
          'como se alimentar, produzir energia e se reproduzir. Alguns seres, '
          'como as bactérias, têm uma única célula.',
      'As células procariontes, como as das bactérias, não têm núcleo '
          'organizado. As eucariontes, de animais, plantas e fungos, têm um '
          'núcleo que guarda o material genético.',
      'Células vegetais têm parede celular e cloroplastos, onde acontece a '
          'fotossíntese. Células animais não têm essas estruturas.',
    ],
  ),
  Artigo(
    id: 'a203',
    objetivoId: 'estudar',
    categoriaId: 'estudar_biologia',
    nivel: 2,
    titulo: 'DNA: a receita de cada ser vivo',
    autor: 'Equipe Ikai',
    resumo:
        'A molécula em forma de dupla hélice guarda as instruções para o '
        'funcionamento das células e passa de pais para filhos.',
    tags: ['genética', 'DNA', 'hereditariedade'],
    paragrafos: [
      'O DNA, ou ácido desoxirribonucleico, é a molécula que guarda as '
          'informações genéticas. Sua estrutura em dupla hélice foi descrita em '
          '1953 por James Watson e Francis Crick, com base em imagens obtidas '
          'por Rosalind Franklin.',
      'O DNA é formado por quatro bases: adenina, timina, citosina e '
          'guanina. A ordem dessas bases funciona como um código para produzir '
          'proteínas.',
      'Os trechos de DNA que carregam instruções são chamados de genes. '
          'Metade do nosso DNA vem da mãe e metade do pai, o que explica as '
          'semelhanças entre familiares.',
    ],
  ),
  Artigo(
    id: 'a204',
    objetivoId: 'estudar',
    categoriaId: 'estudar_biologia',
    nivel: 1,
    titulo: 'Cadeia alimentar: quem come quem',
    autor: 'Equipe Ikai',
    resumo:
        'A energia passa das plantas para os herbívoros e deles para os '
        'carnívoros. Os decompositores fecham o ciclo.',
    tags: ['ecologia', 'cadeia alimentar', 'meio ambiente'],
    paragrafos: [
      'A cadeia alimentar mostra o caminho da energia num ambiente. Começa '
          'com os produtores, como as plantas, que fazem fotossíntese e '
          'produzem o próprio alimento.',
      'Depois vêm os consumidores: herbívoros comem plantas, e carnívoros '
          'comem outros animais. Um exemplo: capim, gafanhoto, sapo e cobra.',
      'Fungos e bactérias são decompositores: transformam restos de seres '
          'vivos em nutrientes que voltam ao solo. Se um elo da cadeia some, '
          'todos os outros são afetados.',
    ],
  ),
  Artigo(
    id: 'a205',
    objetivoId: 'estudar',
    categoriaId: 'estudar_biologia',
    nivel: 2,
    titulo: 'Como as vacinas treinam o sistema imunológico',
    autor: 'Equipe Ikai',
    resumo:
        'A vacina apresenta ao corpo uma versão inofensiva do invasor, e '
        'ele aprende a se defender antes de encontrar a doença de verdade.',
    tags: ['imunologia', 'vacinas', 'saúde'],
    paragrafos: [
      'O sistema imunológico defende o corpo contra vírus, bactérias e outros '
          'invasores. Quando encontra um invasor novo, ele produz anticorpos e '
          'células de defesa específicos.',
      'As vacinas mostram ao organismo uma parte do invasor, ou uma versão '
          'enfraquecida ou inativada dele. O corpo reage e guarda uma memória '
          'imunológica.',
      'Se a pessoa entrar em contato com a doença depois, a defesa é mais '
          'rápida e forte. Quando muita gente se vacina, o agente circula menos '
          'e protege também quem não pode tomar a vacina.',
    ],
  ),

  // ---------------- Física ----------------
  Artigo(
    id: 'a206',
    objetivoId: 'estudar',
    categoriaId: 'estudar_fisica',
    nivel: 2,
    titulo: 'Segunda lei de Newton: força é massa vezes aceleração',
    autor: 'Equipe Ikai',
    resumo:
        'Empurrar um carrinho vazio é mais fácil do que um cheio. A fórmula '
        'F = m . a explica por quê.',
    tags: ['Newton', 'dinâmica', 'força'],
    paragrafos: [
      'A segunda lei de Newton diz que a força resultante sobre um corpo é '
          'igual à sua massa multiplicada pela aceleração: F = m . a. A força é '
          'medida em newtons (N).',
      'Com a mesma força, um objeto de massa maior acelera menos. Por isso '
          'empurrar um carrinho de supermercado cheio exige mais esforço do que '
          'um vazio.',
      'Exemplo: para acelerar um objeto de 10 kg a 2 metros por segundo ao '
          'quadrado, é preciso uma força resultante de 20 N.',
    ],
  ),
  Artigo(
    id: 'a207',
    objetivoId: 'estudar',
    categoriaId: 'estudar_fisica',
    nivel: 1,
    titulo: 'Ação e reação: a terceira lei de Newton',
    autor: 'Equipe Ikai',
    resumo:
        'Quando você empurra uma parede, ela empurra você de volta com a '
        'mesma intensidade.',
    tags: ['Newton', 'forças', 'movimento'],
    paragrafos: [
      'A terceira lei de Newton diz que, para toda ação, existe uma reação '
          'de mesma intensidade, mesma direção e sentido contrário.',
      'Ao nadar, empurramos a água para trás, e a água nos empurra para a '
          'frente. Um foguete expele gases para baixo, e os gases empurram o '
          'foguete para cima.',
      'Um detalhe importante: ação e reação atuam em corpos diferentes. Por '
          'isso elas não se anulam, e o movimento acontece.',
    ],
  ),
  Artigo(
    id: 'a208',
    objetivoId: 'estudar',
    categoriaId: 'estudar_fisica',
    nivel: 2,
    titulo: 'Energia cinética e potencial na montanha-russa',
    autor: 'Equipe Ikai',
    resumo:
        'No alto, o carrinho acumula energia de altura; na descida, ela vira '
        'velocidade. A energia muda de forma, mas não some.',
    tags: ['energia', 'conservação', 'mecânica'],
    paragrafos: [
      'Energia potencial gravitacional é a energia guardada por causa da '
          'altura. Quanto mais alto e mais pesado o objeto, maior ela é.',
      'Energia cinética é a energia do movimento: quanto maior a velocidade, '
          'maior ela é. Na montanha-russa, o carrinho troca uma pela outra o '
          'tempo todo.',
      'Pelo princípio da conservação de energia, a soma das duas se mantém, '
          'descontadas as perdas por atrito. Por isso nenhuma subida pode ser '
          'mais alta que a primeira sem um motor ajudando.',
    ],
  ),
  Artigo(
    id: 'a209',
    objetivoId: 'estudar',
    categoriaId: 'estudar_fisica',
    nivel: 1,
    titulo: 'O som precisa de um meio para viajar',
    autor: 'Equipe Ikai',
    resumo:
        'O som é uma onda que faz o ar vibrar. No vácuo do espaço, não há '
        'nada para vibrar, e por isso não há som.',
    tags: ['ondas', 'som', 'acústica'],
    paragrafos: [
      'O som é uma onda mecânica: ele precisa de um meio material, como o ar, '
          'a água ou um sólido, para se propagar. As partículas do meio vibram '
          'e passam a vibração adiante.',
      'No ar, o som viaja a cerca de 340 metros por segundo. Na água, é mais '
          'rápido, perto de 1.500 metros por segundo, e nos sólidos pode ser '
          'ainda mais.',
      'É por isso que, numa tempestade, vemos o relâmpago antes de ouvir o '
          'trovão: a luz chega quase na hora, e o som demora. Contar os segundos '
          'entre os dois dá uma ideia da distância.',
    ],
  ),

  // ---------------- Química ----------------
  Artigo(
    id: 'a210',
    objetivoId: 'estudar',
    categoriaId: 'estudar_quimica',
    nivel: 1,
    titulo: 'O átomo: prótons, nêutrons e elétrons',
    autor: 'Equipe Ikai',
    resumo:
        'Tudo à nossa volta é feito de átomos. O número de prótons no núcleo '
        'define qual elemento químico ele é.',
    tags: ['átomo', 'modelos atômicos', 'elementos'],
    paragrafos: [
      'O átomo tem um núcleo, onde ficam os prótons, de carga positiva, e os '
          'nêutrons, sem carga. Em volta do núcleo ficam os elétrons, de carga '
          'negativa.',
      'O número de prótons é o número atômico e define o elemento: todo '
          'átomo com 1 próton é hidrogênio, todo átomo com 6 prótons é '
          'carbono, e assim por diante.',
      'Os modelos do átomo mudaram ao longo do tempo, com cientistas como '
          'Dalton, Thomson, Rutherford e Bohr. Cada um corrigiu o anterior com '
          'base em novos experimentos.',
    ],
  ),
  Artigo(
    id: 'a211',
    objetivoId: 'estudar',
    categoriaId: 'estudar_quimica',
    nivel: 1,
    titulo: 'Mudanças de estado físico',
    autor: 'Equipe Ikai',
    resumo:
        'Fusão, vaporização, condensação e solidificação: a água passa por '
        'todas elas na cozinha e na natureza.',
    tags: ['estados físicos', 'água', 'temperatura'],
    paragrafos: [
      'A matéria pode estar nos estados sólido, líquido ou gasoso. A '
          'mudança entre eles depende principalmente da temperatura e da '
          'pressão.',
      'Do sólido para o líquido é fusão, como o gelo derretendo. Do líquido '
          'para o gasoso é vaporização, como a água fervendo. O caminho de volta '
          'se chama condensação e solidificação.',
      'Ao nível do mar, a água pura ferve a 100 °C. Em lugares altos, onde a '
          'pressão do ar é menor, ela ferve a uma temperatura mais baixa.',
    ],
  ),
  Artigo(
    id: 'a212',
    objetivoId: 'estudar',
    categoriaId: 'estudar_quimica',
    nivel: 1,
    titulo: 'Misturas homogêneas e heterogêneas',
    autor: 'Equipe Ikai',
    resumo:
        'Água com açúcar parece uma coisa só; água com óleo mostra duas '
        'partes. Essa diferença classifica as misturas.',
    tags: ['misturas', 'separação', 'química do dia a dia'],
    paragrafos: [
      'Uma mistura homogênea tem aspecto uniforme, com uma única fase visível, '
          'como água com sal dissolvido ou o ar que respiramos.',
      'Uma mistura heterogênea tem duas ou mais fases visíveis, como água e '
          'óleo, ou areia e água. Dá para ver onde termina uma substância e '
          'começa a outra.',
      'Para separar misturas, usam-se métodos como filtração, decantação e '
          'destilação. Coar o café é uma filtração: o pó fica no filtro e o '
          'líquido passa.',
    ],
  ),
  Artigo(
    id: 'a213',
    objetivoId: 'estudar',
    categoriaId: 'estudar_quimica',
    nivel: 2,
    titulo: 'A ferrugem é uma reação química',
    autor: 'Equipe Ikai',
    resumo:
        'Ferro, oxigênio e umidade formam uma substância nova. Reconhecer '
        'sinais de reação ajuda a entender a química do cotidiano.',
    tags: ['reações químicas', 'oxidação', 'cotidiano'],
    paragrafos: [
      'Numa reação química, substâncias se transformam em outras com '
          'propriedades diferentes. A ferrugem se forma quando o ferro reage com '
          'o oxigênio do ar na presença de água.',
      'Alguns sinais indicam que uma reação aconteceu: mudança de cor, '
          'liberação de gás, formação de sólido ou variação de temperatura. O '
          'bolo crescendo no forno e a madeira queimando são outros exemplos.',
      'Para evitar a ferrugem, o ferro pode ser pintado, coberto com outro '
          'metal ou mantido seco. Essas técnicas impedem o contato com o '
          'oxigênio e a umidade.',
    ],
  ),
];
