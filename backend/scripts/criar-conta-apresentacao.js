// Cria (ou repõe) a CONTA DE APRESENTAÇÃO no banco, já com uso salvo:
// duas semanas de tempo de uso, resumos do dia, artigos lidos e salvos em
// pastas, um artigo escrito por ela, comentários, respostas, notificações e
// mensagens em comunidades. Serve para mostrar como fica uma conta usada.
//   npm run db:apresentacao        (usa o banco do backend/.env)
//
// Pode rodar de novo quando quiser: apaga o que a conta tinha e grava tudo
// outra vez, com as datas contadas a partir de hoje.
import bcrypt from 'bcryptjs';
import { ObjectId } from 'mongodb';
import { lerConfig } from '../src/config.js';
import { conectar } from '../src/db.js';

export const EMAIL = 'apresentacao@ikai.app';
export const SENHA = 'Banca@Ikai2026';
const NOME = 'Visitante Ikai';

const config = lerConfig();
const db = await conectar(config);

const DIA = 24 * 3600e3;
const agora = Date.now();
const doisDig = (n) => String(n).padStart(2, '0');
const chaveDoDia = (ms) => {
  const d = new Date(ms);
  return `${d.getFullYear()}-${doisDig(d.getMonth() + 1)}-${doisDig(d.getDate())}`;
};
const diasAtras = (n, hora = 19) => {
  const d = new Date(agora - n * DIA);
  d.setHours(hora, 15, 0, 0);
  return d.getTime();
};
const id = (prefixo) => prefixo + new ObjectId().toHexString();

// ---------- Conta ----------
await db.usuarios.updateOne(
  { email: EMAIL },
  {
    $set: { nome: NOME, senhaHash: await bcrypt.hash(SENHA, config.bcryptCusto) },
    $setOnInsert: { email: EMAIL, criadoEm: new Date(diasAtras(20)) },
  },
  { upsert: true },
);
const conta = await db.usuarios.findOne({ email: EMAIL });
const uid = conta._id;

// Outra pessoa para comentar e receber respostas: a conta adm.
const adm = await db.usuarios.findOne({ email: 'adm@email.com' });

// Limpa o que a conta tinha (para poder rodar de novo).
const meusArtigos = await db.artigos.find({ autorId: uid }, { projection: { _id: 1 } }).toArray();
await db.comentarios.deleteMany({
  $or: [{ autorId: uid }, { artigoId: { $in: meusArtigos.map((a) => a._id) } }],
});
await db.artigos.deleteMany({ autorId: uid });
await db.posts.deleteMany({ autorId: uid });
await db.notificacoes.deleteMany({ usuarioId: uid });

// ---------- Tempo de uso (13 dias antes de hoje) ----------
// Minutos por dia, do mais antigo (13 dias atrás) ao mais recente (ontem).
const minutosPorDia = [38, 25, 0, 31, 22, 45, 28, 0, 19, 27, 33, 24, 18];
const uso = {};
minutosPorDia.forEach((min, i) => {
  if (min > 0) uso[chaveDoDia(diasAtras(13 - i))] = min * 60 + 17;
});

const resumos = [
  [12, 'Li sobre por que o céu é azul: a luz azul se espalha mais na atmosfera.'],
  [10, 'Estudei latitude e longitude e entendi como o GPS acha um ponto no mapa.'],
  [8, 'Revisei crase com a regra do vou a, volto da. Ficou bem mais fácil.'],
  [6, 'Li sobre hábitos pequenos e decidi ler dez páginas antes de dormir.'],
  [4, 'Aprendi que o polvo tem três corações e que a maratona tem 42,195 km por causa de uma olimpíada.'],
  [2, 'Li sobre a Revolução Francesa e o que mudou em 1789.'],
  [1, 'Fotossíntese: a planta usa luz, água e gás carbônico para produzir açúcar e liberar oxigênio.'],
];
const sugestoesEscolhidas = [
  [10, 'Caminhada sem fone'],
  [6, 'Um capítulo no papel'],
  [4, 'Respiração 4-4-6'],
  [1, 'Resumo à mão'],
];
const refl = [
  ...resumos.map(([n, x]) => ({ d: chaveDoDia(diasAtras(n)), t: 'aprendi', x, m: diasAtras(n, 20) })),
  ...sugestoesEscolhidas.map(([n, x]) => ({ d: chaveDoDia(diasAtras(n)), t: 'sugestao', x, m: diasAtras(n, 20) + 60e3 })),
  { d: chaveDoDia(diasAtras(8)), t: 'continuar', x: 'Quero terminar o artigo sobre crase antes de parar.', m: diasAtras(8, 20) - 60e3 },
].sort((a, b) => a.m - b.m);

const segunda = (ms) => {
  const d = new Date(ms);
  const dia = (d.getDay() + 6) % 7; // segunda = 0
  return chaveDoDia(ms - dia * DIA);
};
const tempo = {
  meta: 30,
  amanha: null,
  adv: false,
  uso,
  refl,
  bal: [{ s: segunda(diasAtras(7)), r: 0, x: 'Estou lendo mais e rolando menos a tela.', m: diasAtras(7, 21) }],
};

// ---------- Progresso: artigos concluídos ----------
const lidos = {
  a001: diasAtras(12), a024: diasAtras(10), a006: diasAtras(10, 20),
  a020: diasAtras(8), a016: diasAtras(6), a045: diasAtras(4),
  a044: diasAtras(4, 20), a023: diasAtras(2), a028: diasAtras(1),
  a063: diasAtras(1, 20),
};
const progresso = {
  lidos,
  dias: [...new Set(Object.values(lidos).map(chaveDoDia))].sort(),
  sessoes: 11,
  segundos: Object.values(uso).reduce((a, b) => a + b, 0),
};

// ---------- Biblioteca: pastas com artigos salvos ----------
const biblioteca = {
  pastas: [
    { id: 'p_salvos', nome: 'Salvos', artigos: ['a001', 'a045', 'a016', 'a063'] },
    { id: 'p_estudar', nome: 'Para estudar', artigos: ['a024', 'a020', 'a023', 'a028', 'a029'] },
    { id: 'p_fim_de_semana', nome: 'Ler no fim de semana', artigos: ['a007', 'a015', 'a057'] },
  ],
};

await db.dadosapp.updateOne(
  { _id: uid },
  {
    $set: {
      biblioteca: JSON.stringify(biblioteca),
      progresso: JSON.stringify(progresso),
      tempo: JSON.stringify(tempo),
      atualizadoEm: new Date(),
    },
  },
  { upsert: true },
);

// ---------- Um artigo escrito pela conta ----------
const artigoId = id('u');
await db.artigos.insertOne({
  _id: artigoId,
  autorId: uid,
  autorNome: 'Visitante',
  objetivo: 'ler',
  categoria: 'ler_dp',
  nivel: 1,
  titulo: 'Dez páginas antes de dormir',
  resumo: 'Como troquei meia hora de tela à noite por um livro de papel, e o que mudou em duas semanas.',
  tags: ['leitura', 'hábitos', 'sono'],
  paragrafos: [
    'Eu tinha o costume de pegar o celular na cama e só largar meia hora depois. Resolvi testar uma troca simples: deixar o celular carregando longe da cama e ler dez páginas de um livro de papel.',
    'Nos primeiros dias foi estranho, porque a mão procurava a tela. Depois de uma semana, as dez páginas viraram vinte, e eu passei a dormir mais cedo sem perceber.',
    'O segredo não foi força de vontade, e sim deixar o caminho fácil: o livro ficava em cima do travesseiro e o carregador ficava na sala. Se quiser testar, comece pequeno.',
  ],
  criadoEm: new Date(diasAtras(5)),
});

// ---------- Comentários, respostas e notificações ----------
if (adm) {
  const c1 = id('k');
  await db.comentarios.insertOne({
    _id: c1, artigoId, autorId: adm._id, autorNome: 'Administrador',
    texto: 'Gostei da ideia de deixar o carregador na sala. Vou testar esta semana.',
    criadoEm: new Date(diasAtras(3)),
  });
  await db.comentarios.insertOne({
    _id: id('k'), artigoId, autorId: uid, autorNome: 'Visitante', respostaA: c1,
    texto: 'Depois me conta como foi! Para mim, a primeira semana foi a mais difícil.',
    criadoEm: new Date(diasAtras(3, 21)),
  });
  await db.notificacoes.insertOne({
    usuarioId: uid, tipo: 'comentario', titulo: 'Administrador comentou no seu artigo',
    descricao: 'Em "Dez páginas antes de dormir": Gostei da ideia de deixar o carregador na sala. Vou testar esta semana.',
    artigoId, criadaEm: new Date(diasAtras(3)), lida: false,
  });

  // A conta comentou num artigo do acervo e recebeu uma resposta.
  const c2 = id('k');
  await db.comentarios.insertOne({
    _id: c2, artigoId: 'a001', autorId: uid, autorNome: 'Visitante',
    texto: 'Nunca tinha pensado que o pôr do sol é laranja pelo mesmo motivo.',
    criadoEm: new Date(diasAtras(12, 20)),
  });
  await db.comentarios.insertOne({
    _id: id('k'), artigoId: 'a001', autorId: adm._id, autorNome: 'Administrador', respostaA: c2,
    texto: 'Pois é! A luz atravessa mais atmosfera e o azul se perde no caminho.',
    criadoEm: new Date(diasAtras(1, 10)),
  });
  await db.notificacoes.insertOne({
    usuarioId: uid, tipo: 'resposta', titulo: 'Administrador respondeu ao seu comentário',
    descricao: 'Em "Por que o céu é azul": Pois é! A luz atravessa mais atmosfera e o azul se perde no caminho.',
    artigoId: 'a001', criadaEm: new Date(diasAtras(1, 10)), lida: false,
  });
}

// ---------- Mensagens em comunidades ----------
const posts = [
  ['leitores', 'Alguém aqui já leu Dom Casmurro? Fiquei pensando em Capitu a semana toda.', 9],
  ['crescer', 'Testei ler dez páginas antes de dormir por duas semanas. Recomendo começar pequeno.', 5],
  ['ciencia', 'Curiosidade do dia: o polvo tem três corações e sangue azul.', 4],
  ['idiomas', 'Dica que me ajudou com crase: vou a, volto da, crase há.', 7],
];
for (const [comunidadeId, texto, n] of posts) {
  await db.posts.insertOne({
    _id: id('p'), comunidadeId, autorId: uid, autorNome: 'Visitante', texto, criadoEm: new Date(diasAtras(n, 18)),
  });
}

console.log(`Conta de apresentação pronta no banco "${config.mongoDb}": ${EMAIL}`);
await db.cliente.close();
