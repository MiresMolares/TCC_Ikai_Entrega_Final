import { Router } from 'express';
import { ObjectId } from 'mongodb';
import { exigirLogin } from '../auth.js';
import { naoEncontrado, ruim } from '../erros.js';
import { enviarImagem, lerImagem } from '../imagem.js';

/** Tamanho máximo da foto de perfil (o app já reduz para 512 px). */
export const FOTO_BYTES_MAX = 300 * 1024;

/** Endereço público da foto. "v" muda a cada troca, para não vir do cache. */
export const fotoUrl = (u) =>
  u?.fotoEm ? `/usuarios/${u._id}/foto?v=${u.fotoEm.getTime()}` : null;

export function rotasPerfil({ db, config }) {
  const r = Router();
  const login = exigirLogin({ db, config });

  // Pública pelo endereço, como a capa dos artigos (a tag <img> do app não
  // manda o token). Só mostra a foto, nunca nome ou e-mail.
  r.get('/usuarios/:id/foto', async (req, res) => {
    if (!ObjectId.isValid(req.params.id)) throw naoEncontrado('Foto não encontrada.');
    const u = await db.usuarios.findOne(
      { _id: new ObjectId(req.params.id) },
      { projection: { foto: 1 } },
    );
    if (!u?.foto) throw naoEncontrado('Foto não encontrada.');
    enviarImagem(res, u.foto);
  });

  // Colocar ou trocar a foto: { foto: "<base64>" }.
  r.put('/auth/eu/foto', login, async (req, res) => {
    const foto = lerImagem(req.body?.foto, FOTO_BYTES_MAX, 'A foto');
    if (!foto) throw ruim('Envie a foto.');
    const fotoEm = new Date();
    await db.usuarios.updateOne({ _id: req.usuario._id }, { $set: { foto, fotoEm } });
    res.json({ foto: fotoUrl({ _id: req.usuario._id, fotoEm }) });
  });

  r.delete('/auth/eu/foto', login, async (req, res) => {
    await db.usuarios.updateOne({ _id: req.usuario._id }, { $unset: { foto: '', fotoEm: '' } });
    res.status(204).end();
  });

  return r;
}
