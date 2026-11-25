import { Router } from 'express';
import { ObjectId } from 'mongodb';
import { exigirLogin, primeiroNome } from '../auth.js';
import {
  CATEGORIAS, COMUNIDADES_FIXAS, ICONES, LIMITES as L, OBJETIVOS,
} from '../catalogo.js';
import {
  conflito, naoEncontrado, proibido, ruim, ErroHttp,
} from '../erros.js';
import { dia, limpo, normalizar, removerEmojis } from '../texto.js';
import { notificar } from './notificacoes.js';
import { fotoUrl } from './perfil.js';

const FORMATO_ID = /^[a-z][a-z0-9]{8,40}$/;

const novoId = (prefixo) => prefixo + new ObjectId().toHexString();

/** Aceita o id gerado pelo app (se for bem formado); senão cria um. */
function escolherId(bruto, prefixo) {
  const s = typeof bruto === 'string' ? bruto : '';
  return FORMATO_ID.test(s) && s.startsWith(prefixo) ? s : novoId(prefixo);
}

async function limitarFrequencia(colecao, filtro, max, janelaMs, mensagem) {
  const desde = new Date(Date.now() - janelaMs);
  const n = await colecao.countDocuments({ ...filtro, criadoEm: { $gt: desde } });
  if (n >= max) throw new ErroHttp(429, mensagem);
}

function listaDeTexto(valor, nomeDoCampo) {
  if (!Array.isArray(valor)) throw ruim(`Campo inválido: ${nomeDoCampo}.`);
  return valor.map((x) => {
    if (typeof x !== 'string') throw ruim(`Campo inválido: ${nomeDoCampo}.`);
    return x;
  });
}

const BASE64 = /^[A-Za-z0-9+/]+={0,2}$/;

/** Tipo da imagem pelos primeiros bytes (não confia no que o app diz). */
function tipoDaImagem(b) {
  if (b.length > 3 && b[0] === 0xff && b[1] === 0xd8 && b[2] === 0xff) return 'image/jpeg';
  if (b.length > 8 && b.subarray(0, 8).equals(Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]))) return 'image/png';
  if (b.length > 12 && b.toString('ascii', 0, 4) === 'RIFF' && b.toString('ascii', 8, 12) === 'WEBP') return 'image/webp';
  return null;
}

/** Capa opcional, em base64. Devolve null se não veio; lança 400 se for inválida. */
function lerCapa(bruto) {
  if (bruto === undefined || bruto === null || bruto === '') return null;
  if (typeof bruto !== 'string' || !BASE64.test(bruto)) throw ruim('Capa inválida.');
  const dados = Buffer.from(bruto, 'base64');
  if (dados.length > L.capaBytesMax) {
    throw ruim(`A capa é grande demais (máximo de ${Math.round(L.capaBytesMax / 1024)} KB).`);
  }
  const tipo = tipoDaImagem(dados);
  if (!tipo) throw ruim('A capa precisa ser uma imagem JPEG, PNG ou WebP.');
  return { tipo, dados };
}

function criarId(duplicado) {
  return (e) => {
    if (e?.code === 11000) throw conflito(duplicado);
    throw e;
  };
}

export function rotasConteudo({ db, config }) {
  const r = Router();
  const login = exigirLogin({ db, config });

  // O e-mail só volta para quem é o autor (o app usa para saber "é meu?").
  const eMeu = (req, id) => id.equals(req.usuario._id);

  const artigoSaida = (req, a) => ({
    id: a._id,
    objetivo: a.objetivo,
    categoria: a.categoria,
    titulo: a.titulo,
    autor: a.autorNome,
    resumo: a.resumo,
    nivel: a.nivel,
    tags: a.tags,
    paragrafos: a.paragrafos,
    usuario: true,
    email: eMeu(req, a.autorId) ? req.usuario.email : '',
    em: dia(a.criadoEm),
    // A imagem não vai na lista: o app busca pelo endereço (com cache). O
    // "v" muda quando o artigo é editado, para a capa nova não vir do cache.
    ...(a.capa
      ? { capa: `/artigos/${a._id}/capa?v=${(a.editadoEm ?? a.criadoEm).getTime()}` }
      : {}),
  });

  const comunidadeSaida = (req, c) => ({
    id: c._id,
    nome: c.nome,
    descricao: c.descricao,
    icone: c.icone,
    categorias: c.categorias,
    regras: c.regras,
    usuario: true,
    por: eMeu(req, c.criadorId) ? req.usuario.email : '',
    em: dia(c.criadoEm),
  });

  const postSaida = (req, p) => ({
    id: p._id,
    comunidade: p.comunidadeId,
    nome: p.autorNome,
    email: eMeu(req, p.autorId) ? req.usuario.email : '',
    texto: p.texto,
    ms: p.criadoEm.getTime(),
  });

  // ---------------- Artigos ----------------

  r.get('/artigos', login, async (req, res) => {
    const lista = await db.artigos
      .find({}, { projection: { 'capa.dados': 0 } })
      .sort({ criadoEm: -1 })
      .limit(500)
      .toArray();
    res.json(lista.map((a) => artigoSaida(req, a)));
  });

  // A capa é pública pelo endereço (o id do artigo é longo e aleatório), para
  // o app conseguir mostrá-la como imagem comum, com cache. Cada versão da
  // capa tem um endereço próprio (veja o "v" em artigoSaida).
  r.get('/artigos/:id/capa', async (req, res) => {
    const a = await db.artigos.findOne({ _id: req.params.id }, { projection: { capa: 1 } });
    if (!a?.capa) throw naoEncontrado('Este artigo não tem capa.');
    const bin = a.capa.dados;
    res.set({
      'Content-Type': a.capa.tipo,
      'Cache-Control': 'public, max-age=31536000, immutable',
      // O app (no navegador) roda em outro endereço: sem isto o helmet bloqueia.
      'Cross-Origin-Resource-Policy': 'cross-origin',
    });
    res.send(Buffer.from(bin.buffer ?? bin));
  });

  /** Mesmas regras para criar e para editar. Lança 400 com a mensagem. */
  function validarArtigo(b) {
    const objetivo = String(b.objetivo ?? '');
    const categoria = String(b.categoria ?? '');
    if (!OBJETIVOS[objetivo]?.includes(categoria)) {
      throw ruim('Escolha o objetivo e a categoria.');
    }
    const nivel = b.nivel;
    if (!Number.isInteger(nivel) || nivel < 1 || nivel > 3) {
      throw ruim('Escolha o nível de dificuldade.');
    }
    const titulo = limpo(b.titulo);
    if (titulo.length < L.tituloMin || titulo.length > L.tituloMax) {
      throw ruim(`O título precisa ter de ${L.tituloMin} a ${L.tituloMax} caracteres.`);
    }
    const resumo = limpo(b.resumo);
    if (resumo.length < L.resumoMin || resumo.length > L.resumoMax) {
      throw ruim(`O resumo precisa ter de ${L.resumoMin} a ${L.resumoMax} caracteres.`);
    }
    const paragrafos = listaDeTexto(b.paragrafos, 'paragrafos')
      .map((p) => removerEmojis(p).replace(/\s+/g, ' ').trim())
      .filter(Boolean);
    const total = paragrafos.reduce((n, p) => n + p.length, 0);
    if (total < L.corpoMin) {
      throw ruim(`O texto está curto: escreva pelo menos ${L.corpoMin} caracteres.`);
    }
    if (total > L.corpoMax || paragrafos.some((p) => p.length > L.paragrafoMax)) {
      throw ruim(
        `O texto está longo demais. Separe em parágrafos de até ${L.paragrafoMax} ` +
          `caracteres, no máximo ${L.corpoMax} no total.`,
      );
    }
    const vistos = new Set();
    const tags = [];
    for (const t of listaDeTexto(b.tags ?? [], 'tags')) {
      const x = limpo(t).toLowerCase();
      if (x && !vistos.has(x)) { vistos.add(x); tags.push(x); }
    }
    if (tags.some((x) => x.length < L.tagMin || x.length > L.tagMax)) {
      throw ruim(`Cada assunto precisa ter de ${L.tagMin} a ${L.tagMax} caracteres.`);
    }
    if (tags.length > L.maxTags) throw ruim(`Use no máximo ${L.maxTags} assuntos.`);
    return { objetivo, categoria, nivel, titulo, resumo, tags, paragrafos };
  }

  r.post('/artigos', login, async (req, res) => {
    const b = req.body ?? {};
    const campos = validarArtigo(b);
    const capa = lerCapa(b.capa);

    await limitarFrequencia(
      db.artigos, { autorId: req.usuario._id }, L.artigosPorDia, 24 * 3600e3,
      'Você publicou artigos demais hoje. Tente amanhã.',
    );

    const doc = {
      _id: escolherId(b.id, 'u'),
      autorId: req.usuario._id,
      autorNome: primeiroNome(req.usuario.nome),
      ...campos,
      ...(capa ? { capa } : {}),
      criadoEm: new Date(),
    };
    await db.artigos.insertOne(doc).catch(criarId('Este artigo já existe.'));
    res.status(201).json(artigoSaida(req, doc));
  });

  // Editar: só quem escreveu. Manda o artigo inteiro de novo (mesmas regras
  // de criar). Capa: ausente = mantém; null ou '' = remove; base64 = troca.
  r.patch('/artigos/:id', login, async (req, res) => {
    const a = await db.artigos.findOne({ _id: req.params.id }, { projection: { autorId: 1 } });
    if (!a) throw naoEncontrado('Artigo não encontrado.');
    if (!eMeu(req, a.autorId)) throw proibido('Só quem escreveu pode editar.');
    const b = req.body ?? {};
    const campos = validarArtigo(b);
    const mudanca = { $set: { ...campos, editadoEm: new Date() } };
    if ('capa' in b) {
      const capa = lerCapa(b.capa);
      if (capa) mudanca.$set.capa = capa;
      else mudanca.$unset = { capa: '' };
    }
    await db.artigos.updateOne({ _id: a._id }, mudanca);
    const atualizado = await db.artigos.findOne(
      { _id: a._id },
      { projection: { 'capa.dados': 0 } },
    );
    res.json(artigoSaida(req, atualizado));
  });

  r.delete('/artigos/:id', login, async (req, res) => {
    const a = await db.artigos.findOne({ _id: req.params.id });
    if (!a) throw naoEncontrado('Artigo não encontrado.');
    if (!eMeu(req, a.autorId)) throw proibido('Só quem escreveu pode apagar.');
    await db.comentarios.deleteMany({ artigoId: a._id });
    await db.artigos.deleteOne({ _id: a._id });
    res.status(204).end();
  });

  // ---------------- Comentários ----------------
  // Valem para os artigos do acervo do app (ids 'a001'...) e para os escritos
  // por usuários (que estão no banco).

  const ID_ACERVO = /^a\d{3,4}$/;

  /** Devolve o artigo do banco (ou {acervo: true}); 404 se não existe. */
  async function artigoDoComentario(id) {
    if (ID_ACERVO.test(id)) return { acervo: true };
    const a = await db.artigos.findOne({ _id: id }, { projection: { autorId: 1, titulo: 1 } });
    if (!a) throw naoEncontrado('Artigo não encontrado.');
    return a;
  }

  /** Endereço da foto de cada autor (só de quem tem foto). */
  async function fotosDe(autorIds) {
    const ids = [...new Map(autorIds.map((i) => [String(i), i])).values()];
    if (!ids.length) return new Map();
    const us = await db.usuarios
      .find({ _id: { $in: ids }, fotoEm: { $exists: true } }, { projection: { fotoEm: 1 } })
      .toArray();
    return new Map(us.map((u) => [String(u._id), fotoUrl(u)]));
  }

  const comentarioSaida = (req, c, fotos) => ({
    id: c._id,
    artigo: c.artigoId,
    nome: c.autorNome,
    email: eMeu(req, c.autorId) ? req.usuario.email : '',
    texto: c.texto,
    ms: c.criadoEm.getTime(),
    resposta: c.respostaA ?? null,
    foto: fotos?.get(String(c.autorId)) ?? null,
  });

  r.get('/artigos/:id/comentarios', login, async (req, res) => {
    await artigoDoComentario(req.params.id);
    const lista = await db.comentarios
      .find({ artigoId: req.params.id })
      .sort({ criadoEm: 1 })
      .limit(300)
      .toArray();
    const fotos = await fotosDe(lista.map((c) => c.autorId));
    res.json(lista.map((c) => comentarioSaida(req, c, fotos)));
  });

  r.post('/artigos/:id/comentarios', login, async (req, res) => {
    const artigo = await artigoDoComentario(req.params.id);
    const texto = removerEmojis(req.body?.texto).replace(/[ \t]+/g, ' ').trim();
    if (texto.length < L.comentarioMin || texto.length > L.comentarioMax) {
      throw ruim(`O comentário precisa ter de ${L.comentarioMin} a ${L.comentarioMax} caracteres.`);
    }
    await limitarFrequencia(
      db.comentarios, { autorId: req.usuario._id }, L.comentariosPorHora, 3600e3,
      'Você comentou demais nesta hora. Tente daqui a pouco.',
    );
    // Resposta: só um nível. Responder a uma resposta vira resposta ao
    // comentário principal (a conversa continua no mesmo lugar).
    let pai = null;
    const respostaA = req.body?.resposta;
    if (respostaA !== undefined && respostaA !== null && respostaA !== '') {
      if (typeof respostaA !== 'string') throw ruim('Comentário respondido inválido.');
      pai = await db.comentarios.findOne({ _id: respostaA, artigoId: req.params.id });
      if (!pai) throw naoEncontrado('O comentário que você quer responder não existe mais.');
      if (pai.respostaA) {
        pai = (await db.comentarios.findOne({ _id: pai.respostaA, artigoId: req.params.id })) ?? pai;
      }
    }
    const doc = {
      _id: escolherId(req.body?.id, 'k'),
      artigoId: req.params.id,
      autorId: req.usuario._id,
      autorNome: primeiroNome(req.usuario.nome),
      texto,
      criadoEm: new Date(),
      ...(pai ? { respostaA: pai._id } : {}),
    };
    await db.comentarios.insertOne(doc).catch(criarId('Este comentário já existe.'));

    // Avisa quem foi respondido e quem escreveu o artigo (nunca a si mesmo,
    // nem duas vezes a mesma pessoa).
    const titulo = artigo.acervo
      ? limpo(req.body?.titulo ?? '').slice(0, 100) || 'um artigo'
      : artigo.titulo;
    const quem = doc.autorNome;
    const trecho = texto.length > 120 ? `${texto.slice(0, 117)}...` : texto;
    const avisados = new Set([String(req.usuario._id)]);
    if (pai && !avisados.has(String(pai.autorId))) {
      avisados.add(String(pai.autorId));
      await notificar(db, pai.autorId, {
        tipo: 'resposta',
        titulo: `${quem} respondeu ao seu comentário`,
        descricao: `Em "${titulo}": ${trecho}`,
        artigoId: req.params.id,
      });
    }
    if (!artigo.acervo && !avisados.has(String(artigo.autorId))) {
      await notificar(db, artigo.autorId, {
        tipo: 'comentario',
        titulo: `${quem} comentou no seu artigo`,
        descricao: `Em "${titulo}": ${trecho}`,
        artigoId: req.params.id,
      });
    }

    const fotos = await fotosDe([req.usuario._id]);
    res.status(201).json(comentarioSaida(req, doc, fotos));
  });

  // Apaga quem comentou, ou quem escreveu o artigo (no próprio artigo).
  r.delete('/artigos/:id/comentarios/:comentarioId', login, async (req, res) => {
    const a = await artigoDoComentario(req.params.id);
    const c = await db.comentarios.findOne({ _id: req.params.comentarioId, artigoId: req.params.id });
    if (!c) throw naoEncontrado('Comentário não encontrado.');
    const donoDoArtigo = !a.acervo && eMeu(req, a.autorId);
    if (!eMeu(req, c.autorId) && !donoDoArtigo) throw proibido();
    // Apagar um comentário apaga também as respostas a ele.
    await db.comentarios.deleteMany({ $or: [{ _id: c._id }, { respostaA: c._id }] });
    res.status(204).end();
  });

  // ---------------- Comunidades ----------------

  // Só as criadas por usuários: as fixas moram no app.
  r.get('/comunidades', login, async (req, res) => {
    const lista = await db.comunidades.find().sort({ criadoEm: 1 }).limit(500).toArray();
    res.json(lista.map((c) => comunidadeSaida(req, c)));
  });

  r.post('/comunidades', login, async (req, res) => {
    const b = req.body ?? {};
    const nome = limpo(b.nome);
    if (nome.length < L.nomeMin || nome.length > L.nomeMax) {
      throw ruim(`O nome precisa ter de ${L.nomeMin} a ${L.nomeMax} caracteres.`);
    }
    const descricao = limpo(b.descricao);
    if (descricao.length < L.descricaoMin || descricao.length > L.descricaoMax) {
      throw ruim(`A descrição precisa ter de ${L.descricaoMin} a ${L.descricaoMax} caracteres.`);
    }
    const icone = String(b.icone ?? '');
    if (!ICONES.has(icone)) throw ruim('Escolha um ícone da lista.');
    const categorias = [...new Set(listaDeTexto(b.categorias, 'categorias'))];
    if (categorias.length < 1 || categorias.length > L.maxCategoriasComunidade) {
      throw ruim(`Escolha de 1 a ${L.maxCategoriasComunidade} categorias.`);
    }
    if (!categorias.every((c) => CATEGORIAS.has(c))) throw ruim('Há uma categoria inválida.');
    const regras = listaDeTexto(b.regras ?? [], 'regras').map(limpo).filter(Boolean);
    if (regras.length > L.maxRegras || regras.some((x) => x.length > L.regraMax)) {
      throw ruim(`Use no máximo ${L.maxRegras} regras, de até ${L.regraMax} caracteres.`);
    }

    const nomeChave = normalizar(nome);
    // Nomes das comunidades fixas do app (lib/data/comunidades_dados.dart).
    const nomesFixos = [
      'historia em pauta', 'clube de leitores', 'curiosos da ciencia', 'filosofia e sociedade',
      'mundos imaginados', 'clube do misterio', 'tabuleiro e controle', 'corpo em movimento',
      'palavras e idiomas', 'numeros sem medo', 'atelie aberto', 'vida e planeta',
      'crescer aos poucos', 'noticias com calma',
    ];
    if (nomesFixos.includes(nomeChave)) throw conflito('Já existe uma comunidade com esse nome.');

    await limitarFrequencia(
      db.comunidades, { criadorId: req.usuario._id }, L.comunidadesPorDia, 24 * 3600e3,
      'Você criou comunidades demais hoje. Tente amanhã.',
    );

    const doc = {
      _id: escolherId(b.id, 'c'),
      criadorId: req.usuario._id,
      nome, nomeChave, descricao, icone, categorias, regras,
      criadoEm: new Date(),
    };
    await db.comunidades.insertOne(doc).catch(
      criarId('Já existe uma comunidade com esse nome.'),
    );
    res.status(201).json(comunidadeSaida(req, doc));
  });

  r.delete('/comunidades/:id', login, async (req, res) => {
    const c = await db.comunidades.findOne({ _id: req.params.id });
    if (!c) throw naoEncontrado('Comunidade não encontrada.');
    if (!eMeu(req, c.criadorId)) throw proibido('Só quem criou pode apagar.');
    await db.posts.deleteMany({ comunidadeId: c._id });
    await db.comunidades.deleteOne({ _id: c._id });
    res.status(204).end();
  });

  // ---------------- Mensagens (posts) ----------------

  async function comunidadeDoPost(id) {
    if (COMUNIDADES_FIXAS.has(id)) return { fixa: true };
    const c = await db.comunidades.findOne({ _id: id });
    if (!c) throw naoEncontrado('Comunidade não encontrada.');
    return c;
  }

  r.get('/comunidades/:id/posts', login, async (req, res) => {
    await comunidadeDoPost(req.params.id);
    const lista = await db.posts
      .find({ comunidadeId: req.params.id })
      .sort({ criadoEm: -1 })
      .limit(200)
      .toArray();
    res.json(lista.map((p) => postSaida(req, p)));
  });

  r.post('/comunidades/:id/posts', login, async (req, res) => {
    await comunidadeDoPost(req.params.id);
    const texto = removerEmojis(req.body?.texto).replace(/[ \t]+/g, ' ').trim();
    if (texto.length < L.postMin || texto.length > L.postMax) {
      throw ruim(`A mensagem precisa ter de ${L.postMin} a ${L.postMax} caracteres.`);
    }
    await limitarFrequencia(
      db.posts, { autorId: req.usuario._id }, L.postsPorHora, 3600e3,
      'Você enviou mensagens demais. Respire e tente daqui a pouco.',
    );
    const doc = {
      _id: escolherId(req.body?.id, 'p'),
      comunidadeId: req.params.id,
      autorId: req.usuario._id,
      autorNome: primeiroNome(req.usuario.nome),
      texto,
      criadoEm: new Date(),
    };
    await db.posts.insertOne(doc).catch(criarId('Esta mensagem já existe.'));
    res.status(201).json(postSaida(req, doc));
  });

  r.delete('/comunidades/:id/posts/:postId', login, async (req, res) => {
    const com = await comunidadeDoPost(req.params.id);
    const p = await db.posts.findOne({ _id: req.params.postId, comunidadeId: req.params.id });
    if (!p) throw naoEncontrado('Mensagem não encontrada.');
    const dono = !com.fixa && eMeu(req, com.criadorId);
    if (!eMeu(req, p.autorId) && !dono) throw proibido();
    await db.posts.deleteOne({ _id: p._id });
    res.status(204).end();
  });

  return r;
}
