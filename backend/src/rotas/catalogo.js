import { Router } from 'express';
import { exigirLogin } from '../auth.js';
import { naoEncontrado } from '../erros.js';

/** Catálogo de objetivos e categorias, lido do banco (coleções `objetivos` e `categorias`). */
export function rotasCatalogo({ db, config }) {
  const r = Router();
  const login = exigirLogin({ db, config });

  const categoriaSaida = (c) => ({ id: c._id, objetivo: c.objetivoId, titulo: c.titulo, icone: c.icone });

  // Todos os objetivos, cada um com as suas categorias.
  r.get('/objetivos', login, async (_req, res) => {
    const [objetivos, categorias] = await Promise.all([
      db.objetivos.find().sort({ ordem: 1 }).toArray(),
      db.categorias.find().sort({ objetivoId: 1, ordem: 1 }).toArray(),
    ]);
    res.json(objetivos.map((o) => ({
      id: o._id,
      titulo: o.titulo,
      icone: o.icone,
      categorias: categorias.filter((c) => c.objetivoId === o._id).map(categoriaSaida),
    })));
  });

  // Sugestões para o fim do tempo. ?objetivos=ler,estudar traz as que
  // combinam com esses objetivos e as que servem para todos.
  r.get('/sugestoes', login, async (req, res) => {
    const pedidos = String(req.query.objetivos ?? '').split(',').map((s) => s.trim()).filter(Boolean);
    const filtro = pedidos.length
      ? { $or: [{ objetivos: { $size: 0 } }, { objetivos: { $in: pedidos } }] }
      : {};
    const lista = await db.sugestoes.find(filtro).sort({ ordem: 1 }).toArray();
    res.json(lista.map((s) => ({
      id: s._id, tipo: s.tipo, titulo: s.titulo, como: s.como, minutos: s.minutos, objetivos: s.objetivos,
    })));
  });

  r.get('/objetivos/:id/categorias', login, async (req, res) => {
    const o = await db.objetivos.findOne({ _id: req.params.id });
    if (!o) throw naoEncontrado('Objetivo não encontrado.');
    const lista = await db.categorias.find({ objetivoId: o._id }).sort({ ordem: 1 }).toArray();
    res.json(lista.map(categoriaSaida));
  });

  return r;
}
