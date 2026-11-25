import { Router } from 'express';
import { ObjectId } from 'mongodb';
import { exigirLogin } from '../auth.js';
import { ErroHttp, naoEncontrado, ruim } from '../erros.js';
import { limpo } from '../texto.js';

// Tipos que a própria pessoa pode criar pela API.
const TIPOS = ['lembrete', 'conquista', 'comunidade', 'sistema'];
const MAX_GUARDADAS = 200;

/**
 * Notificação criada pelo servidor quando alguém interage com a pessoa
 * (comentário no artigo dela, resposta a um comentário dela). Nunca falha
 * o pedido principal: se a caixa estiver cheia, a mais antiga sai.
 */
export async function notificar(db, usuarioId, { tipo, titulo, descricao, artigoId }) {
  try {
    const total = await db.notificacoes.countDocuments({ usuarioId });
    if (total >= MAX_GUARDADAS) {
      const velhas = await db.notificacoes
        .find({ usuarioId }, { projection: { _id: 1 } })
        .sort({ criadaEm: 1 })
        .limit(total - MAX_GUARDADAS + 1)
        .toArray();
      await db.notificacoes.deleteMany({ _id: { $in: velhas.map((n) => n._id) } });
    }
    await db.notificacoes.insertOne({
      usuarioId,
      tipo,
      titulo: titulo.slice(0, 80),
      descricao: descricao.slice(0, 300),
      ...(artigoId ? { artigoId } : {}),
      criadaEm: new Date(),
      lida: false,
    });
  } catch (e) {
    console.error('Não foi possível criar a notificação:', e?.message ?? e);
  }
}

export function rotasNotificacoes({ db, config }) {
  const r = Router();
  const login = exigirLogin({ db, config });

  const saida = (n) => ({
    id: n._id,
    tipo: n.tipo,
    titulo: n.titulo,
    descricao: n.descricao,
    criadaEm: n.criadaEm,
    lida: n.lida,
    artigo: n.artigoId ?? null,
  });

  const idDaRota = (req) => {
    if (!ObjectId.isValid(req.params.id)) throw naoEncontrado('Notificação não encontrada.');
    return new ObjectId(req.params.id);
  };

  // Caixa de entrada. ?lida=false traz só as não lidas; ?limite=50 (1 a 100).
  r.get('/notificacoes', login, async (req, res) => {
    const limite = Math.min(100, Math.max(1, Number.parseInt(req.query.limite, 10) || 50));
    const filtro = { usuarioId: req.usuario._id };
    if (req.query.lida === 'false') filtro.lida = false;
    if (req.query.lida === 'true') filtro.lida = true;
    const [lista, naoLidas] = await Promise.all([
      db.notificacoes.find(filtro).sort({ criadaEm: -1 }).limit(limite).toArray(),
      db.notificacoes.countDocuments({ usuarioId: req.usuario._id, lida: false }),
    ]);
    res.json({ naoLidas, itens: lista.map(saida) });
  });

  r.post('/notificacoes', login, async (req, res) => {
    const b = req.body ?? {};
    const tipo = String(b.tipo ?? '');
    const titulo = limpo(b.titulo);
    const descricao = limpo(b.descricao ?? '');
    if (!TIPOS.includes(tipo)) throw ruim(`O tipo deve ser um destes: ${TIPOS.join(', ')}.`);
    if (titulo.length < 1 || titulo.length > 80) throw ruim('O título precisa ter de 1 a 80 caracteres.');
    if (descricao.length > 300) throw ruim('A descrição pode ter no máximo 300 caracteres.');
    if ((await db.notificacoes.countDocuments({ usuarioId: req.usuario._id })) >= MAX_GUARDADAS) {
      throw new ErroHttp(429, 'Sua caixa está cheia. Apague notificações antigas.');
    }
    const doc = { usuarioId: req.usuario._id, tipo, titulo, descricao, criadaEm: new Date(), lida: false };
    const { insertedId } = await db.notificacoes.insertOne(doc);
    res.status(201).json(saida({ ...doc, _id: insertedId }));
  });

  // Marcar todas como lidas (antes de /:id para não confundir as rotas).
  r.post('/notificacoes/ler-todas', login, async (req, res) => {
    const { modifiedCount } = await db.notificacoes.updateMany(
      { usuarioId: req.usuario._id, lida: false }, { $set: { lida: true } },
    );
    res.json({ marcadas: modifiedCount });
  });

  r.patch('/notificacoes/:id', login, async (req, res) => {
    const id = idDaRota(req);
    if (typeof req.body?.lida !== 'boolean') throw ruim('Envie "lida" como verdadeiro ou falso.');
    const n = await db.notificacoes.findOneAndUpdate(
      { _id: id, usuarioId: req.usuario._id }, { $set: { lida: req.body.lida } }, { returnDocument: 'after' },
    );
    if (!n) throw naoEncontrado('Notificação não encontrada.');
    res.json(saida(n));
  });

  r.delete('/notificacoes/:id', login, async (req, res) => {
    const { deletedCount } = await db.notificacoes.deleteOne({ _id: idDaRota(req), usuarioId: req.usuario._id });
    if (!deletedCount) throw naoEncontrado('Notificação não encontrada.');
    res.status(204).end();
  });

  // Limpar a caixa.
  r.delete('/notificacoes', login, async (req, res) => {
    await db.notificacoes.deleteMany({ usuarioId: req.usuario._id });
    res.status(204).end();
  });

  return r;
}
