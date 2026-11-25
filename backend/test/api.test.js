// Testes da API contra um MongoDB de verdade.
// Rode:  MONGODB_URI=mongodb://127.0.0.1:27017 npm test
// (cada execução usa um banco novo, que é apagado no fim)
import { test, before, after, describe } from 'node:test';
import assert from 'node:assert/strict';
import { criarApp } from '../src/app.js';
import { lerConfig } from '../src/config.js';
import { conectar } from '../src/db.js';

let db, servidor, base;
async function chamar(metodo, caminho, corpo, token) {
  const r = await fetch(base + caminho, {
    method: metodo,
    headers: {
      'content-type': 'application/json',
      ...(token ? { authorization: `Bearer ${token}` } : {}),
    },
    body: corpo === undefined ? undefined : JSON.stringify(corpo),
  });
  const texto = await r.text();
  let json = null;
  try { json = texto ? JSON.parse(texto) : null; } catch { /* sem corpo */ }
  return { status: r.status, json };
}

async function novaConta(nome, email, senha = 'Senha-forte-1') {
  const r = await chamar('POST', '/auth/cadastro', { nome, email, senha });
  assert.equal(r.status, 201, JSON.stringify(r.json));
  return r.json.token;
}

const artigoValido = (extra = {}) => ({
  objetivo: 'ler',
  categoria: 'ler_romance',
  nivel: 2,
  titulo: 'Capitães da Areia em poucas linhas',
  resumo: 'Um resumo curto sobre o romance de Jorge Amado.',
  tags: ['romance', 'brasil'],
  paragrafos: [
    'O livro acompanha um grupo de meninos que vive nas ruas de Salvador, nos anos trinta.',
    'Jorge Amado mostra a cidade pelos olhos de quem não tem lugar nela, sem pieguice.',
  ],
  ...extra,
});

const comunidadeValida = (extra = {}) => ({
  nome: 'Leitores de sábado',
  descricao: 'Encontro tranquilo para falar de livros.',
  icone: 'livro',
  categorias: ['ler_romance'],
  regras: ['Respeite as pessoas; debata ideias.'],
  ...extra,
});

before(async () => {
  const config = {
    ...lerConfig({}),
    mongoUri: process.env.MONGODB_URI || 'mongodb://127.0.0.1:27017',
    mongoDb: `ikai_teste_${Date.now()}`,
    jwtSecret: 'segredo-de-teste-bem-longo',
    bcryptCusto: 4,
    limitarLogin: false,
  };
  db = await conectar(config);
  const app = criarApp({ db, config });
  await new Promise((ok) => { servidor = app.listen(0, '127.0.0.1', ok); });
  base = `http://127.0.0.1:${servidor.address().port}`;
});

after(async () => {
  await new Promise((ok) => servidor.close(ok));
  await db.base.dropDatabase();
  await db.cliente.close();
});

describe('saúde e erros gerais', () => {
  test('GET /saude responde', async () => {
    const r = await chamar('GET', '/saude');
    assert.deepEqual(r.json, { ok: true });
  });
  test('rota desconhecida dá 404 em JSON', async () => {
    const r = await chamar('GET', '/nada');
    assert.equal(r.status, 404);
    assert.ok(r.json.erro);
  });
  test('sem token, conteúdo é negado', async () => {
    assert.equal((await chamar('GET', '/artigos')).status, 401);
    assert.equal((await chamar('POST', '/ia/gemini', {})).status, 404); // a IA saiu do Ikai
  });
  test('token inválido é negado', async () => {
    assert.equal((await chamar('GET', '/artigos', undefined, 'lixo')).status, 401);
  });
});

describe('login', () => {
  test('cadastro cria conta, guarda hash e nunca devolve a senha', async () => {
    const r = await chamar('POST', '/auth/cadastro', {
      nome: 'Ana Souza', email: ' ANA@Teste.com ', senha: 'Senha-forte-1',
    });
    assert.equal(r.status, 201);
    assert.equal(r.json.usuario.email, 'ana@teste.com');
    assert.equal(r.json.ia, undefined);
    assert.equal(r.json.usuario.foto, null);
    assert.ok(r.json.token);
    assert.equal(JSON.stringify(r.json).includes('Senha-forte-1'), false);
    const doc = await db.usuarios.findOne({ email: 'ana@teste.com' });
    assert.notEqual(doc.senhaHash, 'Senha-forte-1');
    assert.ok(doc.senhaHash.startsWith('$2'));
  });

  test('valida nome, e-mail e senha', async () => {
    const base = { nome: 'Bia Lima', email: 'bia@teste.com', senha: 'Senha-forte-1' };
    for (const ruim of [
      { nome: 'A' }, { email: 'sem-arroba' }, { senha: '1234567' },
      { senha: 'x'.repeat(73) },
      // Senha fraca: só números, sem maiúscula, sem especial, sem número.
      { senha: '12345678' }, { senha: 'senha-forte-1' }, { senha: 'SenhaForte1' },
      { senha: 'Senha-forte' },
    ]) {
      const r = await chamar('POST', '/auth/cadastro', { ...base, ...ruim });
      assert.equal(r.status, 400, JSON.stringify(ruim));
    }
  });

  test('e-mail repetido (qualquer caixa) dá 409', async () => {
    await novaConta('Caio Dois', 'dup@teste.com');
    const r = await chamar('POST', '/auth/cadastro', {
      nome: 'Outro', email: 'DUP@teste.com', senha: 'Senha-forte-1',
    });
    assert.equal(r.status, 409);
  });

  test('login certo e errado', async () => {
    await novaConta('Dani Cruz', 'dani@teste.com');
    const ok = await chamar('POST', '/auth/login', { email: 'DANI@teste.com', senha: 'Senha-forte-1' });
    assert.equal(ok.status, 200);
    assert.equal(ok.json.usuario.nome, 'Dani Cruz');
    const errada = await chamar('POST', '/auth/login', { email: 'dani@teste.com', senha: 'errada-errada' });
    assert.equal(errada.status, 401);
    const inexistente = await chamar('POST', '/auth/login', { email: 'nao@teste.com', senha: 'Senha-forte-1' });
    assert.equal(inexistente.status, 401);
    assert.equal(inexistente.json.erro, errada.json.erro); // não revela se o e-mail existe
    assert.equal((await chamar('POST', '/auth/login', { email: '', senha: '' })).status, 400);
  });

  test('eu, trocar nome, trocar senha', async () => {
    const t = await novaConta('Eva Lima', 'eva@teste.com');
    assert.equal((await chamar('GET', '/auth/eu', undefined, t)).json.usuario.email, 'eva@teste.com');
    const p = await chamar('PATCH', '/auth/eu', { nome: 'Eva Souza', email: 'outro@x.com' }, t);
    assert.equal(p.json.usuario.nome, 'Eva Souza');
    assert.equal(p.json.usuario.email, 'eva@teste.com'); // e-mail não muda por aqui
    assert.equal((await chamar('PATCH', '/auth/eu', { nome: 'E' }, t)).status, 400);

    assert.equal((await chamar('POST', '/auth/senha', { atual: 'x', nova: 'Nova-senha-1' }, t)).status, 400);
    assert.equal((await chamar('POST', '/auth/senha', { atual: 'Senha-forte-1', nova: '123' }, t)).status, 400);
    assert.equal((await chamar('POST', '/auth/senha', { atual: 'Senha-forte-1', nova: '87654321' }, t)).status, 400);
    assert.equal((await chamar('POST', '/auth/senha', { atual: 'Senha-forte-1', nova: 'Nova-senha-1' }, t)).status, 204);
    assert.equal((await chamar('POST', '/auth/login', { email: 'eva@teste.com', senha: 'Senha-forte-1' })).status, 401);
    assert.equal((await chamar('POST', '/auth/login', { email: 'eva@teste.com', senha: 'Nova-senha-1' })).status, 200);
  });
});

describe('artigos', () => {
  test('publica, lista e devolve o e-mail só para o autor', async () => {
    const a = await novaConta('Gus Lima', 'gus@teste.com');
    const b = await novaConta('Hana Dias', 'hana@teste.com');
    const novo = await chamar('POST', '/artigos', artigoValido(), a);
    assert.equal(novo.status, 201, JSON.stringify(novo.json));
    assert.equal(novo.json.autor, 'Gus'); // só o primeiro nome
    assert.equal(novo.json.email, 'gus@teste.com');
    assert.equal(novo.json.usuario, true);
    assert.match(novo.json.em, /^\d{4}-\d{2}-\d{2}$/);

    const paraB = (await chamar('GET', '/artigos', undefined, b)).json;
    const visto = paraB.find((x) => x.id === novo.json.id);
    assert.ok(visto);
    assert.equal(visto.email, ''); // outro usuário nunca vê o e-mail
    const paraA = (await chamar('GET', '/artigos', undefined, a)).json;
    assert.equal(paraA.find((x) => x.id === novo.json.id).email, 'gus@teste.com');
  });

  test('aceita o id do app, rejeita id repetido e ignora id malformado', async () => {
    const t = await novaConta('Ivo Dias', 'ivo@teste.com');
    const ok = await chamar('POST', '/artigos', artigoValido({ id: 'u17000000000000' }), t);
    assert.equal(ok.json.id, 'u17000000000000');
    const dup = await chamar('POST', '/artigos', artigoValido({ id: 'u17000000000000' }), t);
    assert.equal(dup.status, 409);
    const ruim = await chamar('POST', '/artigos', artigoValido({ id: 'a001' }), t);
    assert.notEqual(ruim.json.id, 'a001');
    assert.ok(ruim.json.id.startsWith('u'));
  });

  test('valida categoria, nível, tamanhos, tags e remove emojis', async () => {
    const t = await novaConta('Jade Lima', 'jade@teste.com');
    const falha = async (extra, status = 400) =>
      assert.equal((await chamar('POST', '/artigos', artigoValido(extra), t)).status, status, JSON.stringify(extra).slice(0, 80));
    await falha({ categoria: 'ler_inexistente' });
    await falha({ objetivo: 'estudar' }); // categoria de outro objetivo
    await falha({ nivel: 0 });
    await falha({ nivel: 4 });
    await falha({ nivel: '2' });
    await falha({ titulo: 'Oi' });
    await falha({ resumo: 'curto' });
    await falha({ paragrafos: ['curto demais'] });
    await falha({ paragrafos: ['x'.repeat(2001)] });
    await falha({ paragrafos: 'não é lista' });
    await falha({ tags: ['a'] });
    await falha({ tags: ['um', 'dois', 'tres', 'quatro', 'cinco', 'seis'] });
    await falha({ tags: [1] });

    const r = await chamar('POST', '/artigos', artigoValido({
      titulo: 'Título com emoji \u{1F600} aqui', tags: ['Romance', 'romance', ' Brasil '],
    }), t);
    assert.equal(r.status, 201);
    assert.equal(r.json.titulo, 'Título com emoji aqui');
    assert.deepEqual(r.json.tags, ['romance', 'brasil']);
  });

  test('capa opcional: aceita imagem, serve por endereço e recusa o que não é imagem', async () => {
    const t = await novaConta('Nina Capa', 'nina.capa@teste.com');
    // PNG de 1x1 pixel.
    const png = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==';
    const r = await chamar('POST', '/artigos', artigoValido({ capa: png }), t);
    assert.equal(r.status, 201, JSON.stringify(r.json));
    assert.match(r.json.capa, /^\/artigos\/u[a-z0-9]+\/capa\?v=\d+$/);

    const lista = (await chamar('GET', '/artigos', undefined, t)).json;
    assert.equal(lista.find((a) => a.id === r.json.id).capa, r.json.capa);

    // A imagem é servida sem login, com o tipo certo e liberada para outro endereço.
    const img = await fetch(base + r.json.capa);
    assert.equal(img.status, 200);
    assert.equal(img.headers.get('content-type'), 'image/png');
    assert.equal(img.headers.get('cross-origin-resource-policy'), 'cross-origin');
    assert.deepEqual(Buffer.from(await img.arrayBuffer()), Buffer.from(png, 'base64'));

    // Sem capa: o campo não aparece e o endereço dá 404.
    const sem = await chamar('POST', '/artigos', artigoValido(), t);
    assert.equal(sem.json.capa, undefined);
    assert.equal((await fetch(`${base}/artigos/${sem.json.id}/capa`)).status, 404);

    const falha = async (capa) =>
      assert.equal((await chamar('POST', '/artigos', artigoValido({ capa }), t)).status, 400, String(capa).slice(0, 40));
    await falha('isto não é base64!');
    await falha(Buffer.from('só um texto qualquer, não uma imagem').toString('base64'));
    await falha(Buffer.alloc(351 * 1024, 0xff).toString('base64')); // grande demais
    await falha(123);
  });

  test('só o autor apaga', async () => {
    const a = await novaConta('Kai Dias', 'kai@teste.com');
    const b = await novaConta('Lia Dias', 'lia@teste.com');
    const { json } = await chamar('POST', '/artigos', artigoValido(), a);
    assert.equal((await chamar('DELETE', `/artigos/${json.id}`, undefined, b)).status, 403);
    assert.equal((await chamar('DELETE', `/artigos/${json.id}`, undefined, a)).status, 204);
    assert.equal((await chamar('DELETE', `/artigos/${json.id}`, undefined, a)).status, 404);
  });

  test('limite de artigos por dia', async () => {
    const t = await novaConta('Mel Dias', 'mel@teste.com');
    for (let i = 0; i < 10; i++) {
      assert.equal((await chamar('POST', '/artigos', artigoValido(), t)).status, 201);
    }
    assert.equal((await chamar('POST', '/artigos', artigoValido(), t)).status, 429);
  });

  test('editar: só o autor, com as mesmas regras; capa troca, mantém ou sai', async () => {
    const a = await novaConta('Edu Lima', 'edu@teste.com');
    const b = await novaConta('Bia Lima', 'bia.lima@teste.com');
    const png = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==';
    const { json: criado } = await chamar('POST', '/artigos', artigoValido({ capa: png }), a);

    const novo = artigoValido({ titulo: 'Título revisado pelo autor', nivel: 3 });
    assert.equal((await chamar('PATCH', `/artigos/${criado.id}`, novo, b)).status, 403);
    assert.equal((await chamar('PATCH', '/artigos/u000inexistente0', novo, a)).status, 404);
    assert.equal((await chamar('PATCH', `/artigos/${criado.id}`, artigoValido({ titulo: 'Oi' }), a)).status, 400);

    // Sem "capa" no corpo: a capa continua.
    const ed = await chamar('PATCH', `/artigos/${criado.id}`, novo, a);
    assert.equal(ed.status, 200, JSON.stringify(ed.json));
    assert.equal(ed.json.titulo, 'Título revisado pelo autor');
    assert.equal(ed.json.nivel, 3);
    assert.ok(ed.json.capa, 'capa deveria continuar');
    assert.notEqual(ed.json.capa, criado.capa, 'o endereço da capa muda a cada edição');
    assert.equal((await fetch(base + ed.json.capa)).status, 200);

    // capa: null remove.
    const sem = await chamar('PATCH', `/artigos/${criado.id}`, { ...novo, capa: null }, a);
    assert.equal(sem.json.capa, undefined);
    assert.equal((await fetch(`${base}/artigos/${criado.id}/capa`)).status, 404);

    const lista = (await chamar('GET', '/artigos', undefined, b)).json;
    assert.equal(lista.find((x) => x.id === criado.id).titulo, 'Título revisado pelo autor');
  });
});

describe('comentários', () => {
  test('comenta em artigo do acervo e de usuário; lista em ordem; tira emojis', async () => {
    const a = await novaConta('Ana Souza', 'ana.souza@teste.com');
    const b = await novaConta('Rui Souza', 'rui.souza@teste.com');
    assert.equal((await chamar('GET', '/artigos/a001/comentarios')).status, 401);

    const c1 = await chamar('POST', '/artigos/a001/comentarios', { texto: 'Gostei muito \u{1F600} do texto' }, a);
    assert.equal(c1.status, 201, JSON.stringify(c1.json));
    assert.equal(c1.json.texto, 'Gostei muito do texto');
    assert.equal(c1.json.nome, 'Ana');
    await chamar('POST', '/artigos/a001/comentarios', { texto: 'Concordo com a Ana.' }, b);

    const paraB = (await chamar('GET', '/artigos/a001/comentarios', undefined, b)).json;
    assert.deepEqual(paraB.map((c) => c.nome), ['Ana', 'Rui']);
    assert.equal(paraB[0].email, '', 'o e-mail dos outros nunca volta');
    assert.equal(paraB[1].email, 'rui.souza@teste.com');

    const { json: art } = await chamar('POST', '/artigos', artigoValido(), a);
    assert.equal((await chamar('POST', `/artigos/${art.id}/comentarios`, { texto: 'Boa!' }, b)).status, 201);
    assert.equal((await chamar('GET', `/artigos/${art.id}/comentarios`, undefined, a)).json.length, 1);
  });

  test('valida o texto e o artigo', async () => {
    const t = await novaConta('Gil Souza', 'gil.souza@teste.com');
    assert.equal((await chamar('POST', '/artigos/a001/comentarios', { texto: 'x' }, t)).status, 400);
    assert.equal((await chamar('POST', '/artigos/a001/comentarios', { texto: 'y'.repeat(501) }, t)).status, 400);
    assert.equal((await chamar('POST', '/artigos/u000inexistente0/comentarios', { texto: 'Olá!' }, t)).status, 404);
    assert.equal((await chamar('GET', '/artigos/u000inexistente0/comentarios', undefined, t)).status, 404);
  });

  test('apagar: quem comentou ou o autor do artigo; o artigo leva os comentários junto', async () => {
    const autor = await novaConta('Ivo Reis', 'ivo.reis@teste.com');
    const leitor = await novaConta('Lu Reis', 'lu.reis@teste.com');
    const outro = await novaConta('Teo Reis', 'teo.reis@teste.com');
    const { json: art } = await chamar('POST', '/artigos', artigoValido(), autor);
    const { json: c1 } = await chamar('POST', `/artigos/${art.id}/comentarios`, { texto: 'Primeiro!' }, leitor);
    const { json: c2 } = await chamar('POST', `/artigos/${art.id}/comentarios`, { texto: 'Segundo.' }, leitor);

    assert.equal((await chamar('DELETE', `/artigos/${art.id}/comentarios/${c1.id}`, undefined, outro)).status, 403);
    assert.equal((await chamar('DELETE', `/artigos/${art.id}/comentarios/${c1.id}`, undefined, leitor)).status, 204);
    assert.equal((await chamar('DELETE', `/artigos/${art.id}/comentarios/${c2.id}`, undefined, autor)).status, 204);

    // No acervo, só quem comentou apaga.
    const { json: c3 } = await chamar('POST', '/artigos/a002/comentarios', { texto: 'No acervo.' }, leitor);
    assert.equal((await chamar('DELETE', `/artigos/a002/comentarios/${c3.id}`, undefined, autor)).status, 403);

    await chamar('POST', `/artigos/${art.id}/comentarios`, { texto: 'Vai sumir.' }, leitor);
    await chamar('DELETE', `/artigos/${art.id}`, undefined, autor);
    assert.equal(await db.comentarios.countDocuments({ artigoId: art.id }), 0);
  });

  test('excluir a conta apaga os comentários dela e os feitos nos artigos dela', async () => {
    const quem = await novaConta('Zeca Reis', 'zeca.reis@teste.com');
    const leitor = await novaConta('Bel Reis', 'bel.reis@teste.com');
    const { json: art } = await chamar('POST', '/artigos', artigoValido(), quem);
    await chamar('POST', `/artigos/${art.id}/comentarios`, { texto: 'Comentário da Bel.' }, leitor);
    await chamar('POST', '/artigos/a003/comentarios', { texto: 'Comentário do Zeca.' }, quem);
    assert.equal((await chamar('DELETE', '/meus-dados', undefined, quem)).status, 204);
    assert.equal(await db.comentarios.countDocuments({ artigoId: art.id }), 0);
    assert.equal(await db.comentarios.countDocuments({ texto: 'Comentário do Zeca.' }), 0);
  });
});

describe('respostas e notificações', () => {
  test('responder fica em um nível só e avisa o autor do comentário e do artigo', async () => {
    const autor = await novaConta('Ada Lima', 'ada.lima@teste.com');
    const leitor = await novaConta('Bento Lima', 'bento.lima@teste.com');
    const outro = await novaConta('Caio Lima', 'caio.lima@teste.com');
    const { json: art } = await chamar('POST', '/artigos', artigoValido(), autor);

    // Comentário no artigo: avisa só o autor do artigo.
    const { json: c1 } = await chamar('POST', `/artigos/${art.id}/comentarios`, { texto: 'Gostei do texto!' }, leitor);
    let caixa = (await chamar('GET', '/notificacoes', undefined, autor)).json;
    assert.equal(caixa.naoLidas, 1);
    assert.equal(caixa.itens[0].tipo, 'comentario');
    assert.equal(caixa.itens[0].titulo, 'Bento comentou no seu artigo');
    assert.equal(caixa.itens[0].artigo, art.id);
    assert.equal((await chamar('GET', '/notificacoes', undefined, leitor)).json.naoLidas, 0);

    // Resposta: avisa quem comentou e o autor do artigo.
    const r1 = await chamar('POST', `/artigos/${art.id}/comentarios`, { texto: 'Concordo!', resposta: c1.id }, outro);
    assert.equal(r1.status, 201, JSON.stringify(r1.json));
    assert.equal(r1.json.resposta, c1.id);
    const doLeitor = (await chamar('GET', '/notificacoes', undefined, leitor)).json;
    assert.equal(doLeitor.itens[0].tipo, 'resposta');
    assert.equal(doLeitor.itens[0].titulo, 'Caio respondeu ao seu comentário');
    assert.equal((await chamar('GET', '/notificacoes', undefined, autor)).json.naoLidas, 2);

    // Resposta a uma resposta vira resposta ao comentário principal.
    const r2 = await chamar('POST', `/artigos/${art.id}/comentarios`, { texto: 'Eu também.', resposta: r1.json.id }, leitor);
    assert.equal(r2.json.resposta, c1.id);

    // O autor respondendo no próprio artigo não avisa a si mesmo.
    await chamar('POST', `/artigos/${art.id}/comentarios`, { texto: 'Obrigada!', resposta: c1.id }, autor);
    assert.equal((await chamar('GET', '/notificacoes', undefined, autor)).json.naoLidas, 3);

    // Responder a algo que não existe dá 404.
    const nao = await chamar('POST', `/artigos/${art.id}/comentarios`, { texto: 'Oi?', resposta: 'k000000000' }, outro);
    assert.equal(nao.status, 404);

    // Apagar o comentário principal leva as respostas junto.
    assert.equal((await chamar('DELETE', `/artigos/${art.id}/comentarios/${c1.id}`, undefined, leitor)).status, 204);
    assert.equal(await db.comentarios.countDocuments({ artigoId: art.id }), 0);
  });

  test('no acervo, a resposta avisa quem comentou com o título enviado pelo app', async () => {
    const a = await novaConta('Dora Lima', 'dora.lima@teste.com');
    const b = await novaConta('Edu Lima', 'edu.lima@teste.com');
    const { json: c } = await chamar('POST', '/artigos/a010/comentarios', { texto: 'Muito bom.' }, a);
    await chamar('POST', '/artigos/a010/comentarios', { texto: 'Verdade.', resposta: c.id, titulo: 'Um título' }, b);
    const caixa = (await chamar('GET', '/notificacoes', undefined, a)).json;
    assert.equal(caixa.itens[0].descricao, 'Em "Um título": Verdade.');
  });
});

describe('sugestões e dados do aparelho', () => {
  test('sugestões do fim do tempo: todas, ou filtradas por objetivo', async () => {
    const t = await novaConta('Gui Lima', 'gui.lima@teste.com');
    assert.equal((await chamar('GET', '/sugestoes')).status, 401);
    const todas = (await chamar('GET', '/sugestoes', undefined, t)).json;
    assert.ok(todas.length >= 20);
    assert.ok(todas.every((x) => x.titulo && x.como && x.minutos > 0));
    assert.ok(todas.some((x) => x.tipo === 'meditacao'));
    const ler = (await chamar('GET', '/sugestoes?objetivos=ler', undefined, t)).json;
    assert.ok(ler.length < todas.length);
    assert.ok(ler.every((x) => x.objetivos.length === 0 || x.objetivos.includes('ler')));
  });

  test('cópia da biblioteca, progresso e tempo: guarda, devolve e valida', async () => {
    const t = await novaConta('Hel Lima', 'hel.lima@teste.com');
    const vazio = (await chamar('GET', '/meus-dados-app', undefined, t)).json;
    assert.equal(vazio.biblioteca, null);
    const biblioteca = JSON.stringify({ pastas: [{ id: 'p1', nome: 'Salvos', artigos: ['a001'] }] });
    const tempo = JSON.stringify({ meta: 30, uso: { '2026-11-20': 600 } });
    assert.equal((await chamar('PUT', '/meus-dados-app', { biblioteca, tempo }, t)).status, 200);
    const d = (await chamar('GET', '/meus-dados-app', undefined, t)).json;
    assert.equal(d.biblioteca, biblioteca);
    assert.equal(d.tempo, tempo);
    assert.equal(d.progresso, null);
    assert.equal((await chamar('PUT', '/meus-dados-app', { tempo: 'não é json' }, t)).status, 400);
    assert.equal((await chamar('PUT', '/meus-dados-app', {}, t)).status, 400);
    // Cada conta vê só a sua cópia.
    const outra = await novaConta('Ivo Lima', 'ivo.lima@teste.com');
    assert.equal((await chamar('GET', '/meus-dados-app', undefined, outra)).json.biblioteca, null);
    // Excluir a conta apaga a cópia.
    await chamar('DELETE', '/meus-dados', undefined, t);
    assert.equal(await db.dadosapp.countDocuments({}), 0);
  });
});

describe('foto de perfil', () => {
  // PNG de 1x1 pixel.
  const PNG = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==';

  test('coloca, aparece no login e nos comentários, troca e remove', async () => {
    const t = await novaConta('Fia Lima', 'fia.lima@teste.com');
    assert.equal((await chamar('PUT', '/auth/eu/foto', { foto: PNG })).status, 401);
    assert.equal((await chamar('PUT', '/auth/eu/foto', { foto: 'não é base64' }, t)).status, 400);
    assert.equal((await chamar('PUT', '/auth/eu/foto', { foto: Buffer.from('texto').toString('base64') }, t)).status, 400);

    const r = await chamar('PUT', '/auth/eu/foto', { foto: PNG }, t);
    assert.equal(r.status, 200);
    assert.match(r.json.foto, /^\/usuarios\/[0-9a-f]{24}\/foto\?v=\d+$/);

    const img = await fetch(base + r.json.foto);
    assert.equal(img.status, 200);
    assert.equal(img.headers.get('content-type'), 'image/png');

    assert.equal((await chamar('GET', '/auth/eu', undefined, t)).json.usuario.foto, r.json.foto);
    const login = await chamar('POST', '/auth/login', { email: 'fia.lima@teste.com', senha: 'Senha-forte-1' });
    assert.equal(login.json.usuario.foto, r.json.foto);

    await chamar('POST', '/artigos/a011/comentarios', { texto: 'Com foto.' }, t);
    const lista = (await chamar('GET', '/artigos/a011/comentarios', undefined, t)).json;
    assert.equal(lista.at(-1).foto, r.json.foto);

    assert.equal((await chamar('DELETE', '/auth/eu/foto', undefined, t)).status, 204);
    assert.equal((await chamar('GET', '/auth/eu', undefined, t)).json.usuario.foto, null);
    assert.equal((await fetch(base + r.json.foto)).status, 404);
  });
});

describe('comunidades e mensagens', () => {
  test('cria, lista e não deixa nome repetido (sem acento/caixa) nem usar nome de fixa', async () => {
    const a = await novaConta('Noa Dias', 'noa@teste.com');
    const r = await chamar('POST', '/comunidades', comunidadeValida({ nome: 'Poesia à tarde' }), a);
    assert.equal(r.status, 201, JSON.stringify(r.json));
    assert.equal(r.json.por, 'noa@teste.com');
    assert.equal(r.json.usuario, true);
    const dup = await chamar('POST', '/comunidades', comunidadeValida({ nome: 'POESIA A TARDE' }), a);
    assert.equal(dup.status, 409);
    const fixa = await chamar('POST', '/comunidades', comunidadeValida({ nome: 'Clube de Leitores' }), a);
    assert.equal(fixa.status, 409);
    const lista = (await chamar('GET', '/comunidades', undefined, a)).json;
    assert.ok(lista.some((c) => c.id === r.json.id));
  });

  test('valida os campos', async () => {
    const t = await novaConta('Ota Dias', 'ota@teste.com');
    const falha = async (extra) =>
      assert.equal((await chamar('POST', '/comunidades', comunidadeValida({ nome: `Nome ${Math.random()}`.slice(0, 20), ...extra }), t)).status, 400, JSON.stringify(extra));
    await falha({ nome: 'ab' });
    await falha({ nome: 'x'.repeat(41) });
    await falha({ descricao: 'curta' });
    await falha({ icone: 'inexistente' });
    await falha({ categorias: [] });
    await falha({ categorias: ['nao_existe'] });
    await falha({ categorias: ['ler_romance', 'ler_fc', 'ler_dp', 'ler_horror', 'ler_terror', 'ler_aventura'] });
    await falha({ regras: ['x'.repeat(121)] });
    await falha({ regras: ['1', '2', '3', '4', '5', '6', '7'] });
  });

  test('mensagens: criar, listar (mais novas primeiro), e-mail só para o autor', async () => {
    const a = await novaConta('Pia Dias', 'pia@teste.com');
    const b = await novaConta('Rui Dias', 'rui@teste.com');
    const c = (await chamar('POST', '/comunidades', comunidadeValida({ nome: 'Mensagens boas' }), a)).json;
    const p1 = await chamar('POST', `/comunidades/${c.id}/posts`, { texto: 'Primeira mensagem' }, a);
    assert.equal(p1.status, 201, JSON.stringify(p1.json));
    await new Promise((ok) => setTimeout(ok, 5));
    await chamar('POST', `/comunidades/${c.id}/posts`, { texto: 'Segunda mensagem \u{1F600}' }, b);
    const lista = (await chamar('GET', `/comunidades/${c.id}/posts`, undefined, b)).json;
    assert.deepEqual(lista.map((p) => p.texto), ['Segunda mensagem', 'Primeira mensagem']);
    assert.equal(lista[0].email, 'rui@teste.com');
    assert.equal(lista[1].email, ''); // da Pia: o Rui não vê
    assert.equal(lista[1].nome, 'Pia');
    assert.equal(typeof lista[0].ms, 'number');
  });

  test('comunidades fixas aceitam mensagens; id inexistente dá 404', async () => {
    const t = await novaConta('Sol Dias', 'sol@teste.com');
    assert.equal((await chamar('POST', '/comunidades/historia/posts', { texto: 'Olá, pessoal' }, t)).status, 201);
    assert.equal((await chamar('GET', '/comunidades/historia/posts', undefined, t)).json.length >= 1, true);
    assert.equal((await chamar('POST', '/comunidades/nada/posts', { texto: 'Olá, pessoal' }, t)).status, 404);
  });

  test('valida o texto e limita a frequência', async () => {
    const t = await novaConta('Tom Dias', 'tom@teste.com');
    assert.equal((await chamar('POST', '/comunidades/ideias/posts', { texto: 'ab' }, t)).status, 400);
    assert.equal((await chamar('POST', '/comunidades/ideias/posts', { texto: 'x'.repeat(501) }, t)).status, 400);
    for (let i = 0; i < 20; i++) {
      assert.equal((await chamar('POST', '/comunidades/ideias/posts', { texto: `mensagem ${i}` }, t)).status, 201);
    }
    assert.equal((await chamar('POST', '/comunidades/ideias/posts', { texto: 'mais uma' }, t)).status, 429);
  });

  test('apagar: autor da mensagem ou criador da comunidade; fixa só o autor', async () => {
    const dono = await novaConta('Uma Dias', 'uma@teste.com');
    const outro = await novaConta('Vic Dias', 'vic@teste.com');
    const terceiro = await novaConta('Wal Dias', 'wal@teste.com');
    const c = (await chamar('POST', '/comunidades', comunidadeValida({ nome: 'Regras de apagar' }), dono)).json;
    const p = (await chamar('POST', `/comunidades/${c.id}/posts`, { texto: 'mensagem do outro' }, outro)).json;
    assert.equal((await chamar('DELETE', `/comunidades/${c.id}/posts/${p.id}`, undefined, terceiro)).status, 403);
    assert.equal((await chamar('DELETE', `/comunidades/${c.id}/posts/${p.id}`, undefined, dono)).status, 204);
    const q = (await chamar('POST', `/comunidades/${c.id}/posts`, { texto: 'outra mensagem' }, outro)).json;
    assert.equal((await chamar('DELETE', `/comunidades/${c.id}/posts/${q.id}`, undefined, outro)).status, 204);

    const f = (await chamar('POST', '/comunidades/ciencia/posts', { texto: 'mensagem fixa' }, outro)).json;
    assert.equal((await chamar('DELETE', `/comunidades/ciencia/posts/${f.id}`, undefined, dono)).status, 403);
    assert.equal((await chamar('DELETE', `/comunidades/ciencia/posts/${f.id}`, undefined, outro)).status, 204);
  });

  test('apagar comunidade: só o criador, e as mensagens vão junto', async () => {
    const dono = await novaConta('Xis Dias', 'xis@teste.com');
    const outro = await novaConta('Yan Dias', 'yan@teste.com');
    const c = (await chamar('POST', '/comunidades', comunidadeValida({ nome: 'Para apagar' }), dono)).json;
    await chamar('POST', `/comunidades/${c.id}/posts`, { texto: 'vai embora junto' }, outro);
    assert.equal((await chamar('DELETE', `/comunidades/${c.id}`, undefined, outro)).status, 403);
    assert.equal((await chamar('DELETE', `/comunidades/${c.id}`, undefined, dono)).status, 204);
    assert.equal(await db.posts.countDocuments({ comunidadeId: c.id }), 0);
    assert.equal((await chamar('GET', `/comunidades/${c.id}/posts`, undefined, dono)).status, 404);
  });
});

describe('exclusão de conta', () => {
  test('apaga a conta e tudo o que ela escreveu, inclusive mensagens nas comunidades dela', async () => {
    const zed = await novaConta('Zed Dias', 'zed@teste.com');
    const amigo = await novaConta('Amigo Dias', 'amigo@teste.com');
    const art = (await chamar('POST', '/artigos', artigoValido(), zed)).json;
    const com = (await chamar('POST', '/comunidades', comunidadeValida({ nome: 'Do Zed' }), zed)).json;
    await chamar('POST', `/comunidades/${com.id}/posts`, { texto: 'mensagem do amigo' }, amigo);
    await chamar('POST', '/comunidades/historia/posts', { texto: 'mensagem do Zed' }, zed);

    assert.equal((await chamar('DELETE', '/meus-dados', undefined, zed)).status, 204);
    assert.equal(await db.usuarios.countDocuments({ email: 'zed@teste.com' }), 0);
    assert.equal(await db.artigos.countDocuments({ _id: art.id }), 0);
    assert.equal(await db.comunidades.countDocuments({ _id: com.id }), 0);
    assert.equal(await db.posts.countDocuments({ comunidadeId: com.id }), 0);
    assert.equal(await db.posts.countDocuments({ autorNome: 'Zed' }), 0);
    // o token antigo deixa de valer
    assert.equal((await chamar('GET', '/auth/eu', undefined, zed)).status, 401);
    // o amigo continua existindo
    assert.equal((await chamar('GET', '/auth/eu', undefined, amigo)).status, 200);
  });
});

