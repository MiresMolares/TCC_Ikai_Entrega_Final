import { Router } from 'express';
import bcrypt from 'bcryptjs';
import rateLimit from 'express-rate-limit';
import { criarToken, exigirLogin } from '../auth.js';
import { conflito, naoAutorizado, ruim } from '../erros.js';
import { limpo } from '../texto.js';
import { fotoUrl } from './perfil.js';

const EMAIL = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const SENHA_MIN = 8;
const SENHA_MAX = 72; // limite do bcrypt

/** Senha forte (as mesmas regras de lib/core/senha.dart). Devolve o problema ou null. */
export function problemaDaSenha(senha) {
  if (senha.length > SENHA_MAX) return `A senha pode ter no máximo ${SENHA_MAX} caracteres.`;
  const faltam = [];
  if (senha.length < SENHA_MIN) faltam.push(`pelo menos ${SENHA_MIN} caracteres`);
  if (!/[A-Z]/.test(senha)) faltam.push('uma letra maiúscula');
  if (!/[a-z]/.test(senha)) faltam.push('uma letra minúscula');
  if (!/[0-9]/.test(senha)) faltam.push('um número');
  if (!/[^A-Za-z0-9\s]/.test(senha)) faltam.push('um caractere especial (ex.: ! @ # $ %)');
  return faltam.length ? `A senha precisa ter: ${faltam.join(', ')}.` : null;
}

export function rotasAuth({ db, config }) {
  const r = Router();
  const login = exigirLogin({ db, config });

  const resposta = (u) => ({
    token: criarToken(config, u),
    usuario: { nome: u.nome, email: u.email, foto: fotoUrl(u) },
  });

  // Contra tentativas de adivinhar senha: 20 a cada 15 minutos por IP.
  const limite = config.limitarLogin
    ? rateLimit({
        windowMs: 15 * 60 * 1000,
        limit: 20,
        standardHeaders: true,
        legacyHeaders: false,
        message: { erro: 'Muitas tentativas. Tente de novo em alguns minutos.' },
      })
    : (_req, _res, next) => next();

  r.post('/auth/cadastro', limite, async (req, res) => {
    const nome = limpo(req.body?.nome);
    const email = String(req.body?.email ?? '').trim().toLowerCase();
    const senha = String(req.body?.senha ?? '');
    if (nome.length < 2 || nome.length > 80) throw ruim('Informe seu nome completo.');
    if (!EMAIL.test(email) || email.length > 120) throw ruim('Informe um e-mail válido.');
    const fraca = problemaDaSenha(senha);
    if (fraca) throw ruim(fraca);

    const doc = {
      nome,
      email,
      senhaHash: await bcrypt.hash(senha, config.bcryptCusto),
      criadoEm: new Date(),
    };
    try {
      const { insertedId } = await db.usuarios.insertOne(doc);
      res.status(201).json(resposta({ ...doc, _id: insertedId }));
    } catch (e) {
      if (e?.code === 11000) throw conflito('Este e-mail já está cadastrado.');
      throw e;
    }
  });

  // Hash falso para gastar o mesmo tempo quando o e-mail não existe.
  const hashFalso = bcrypt.hashSync('nao-existe', config.bcryptCusto);

  r.post('/auth/login', limite, async (req, res) => {
    const email = String(req.body?.email ?? '').trim().toLowerCase();
    const senha = String(req.body?.senha ?? '');
    if (!email || !senha) throw ruim('Preencha e-mail e senha.');
    if (!EMAIL.test(email)) throw ruim('Informe um e-mail válido.');
    const u = await db.usuarios.findOne({ email });
    const ok = await bcrypt.compare(senha, u ? u.senhaHash : hashFalso);
    if (!u || !ok) throw naoAutorizado('E-mail ou senha incorretos.');
    res.json(resposta(u));
  });

  r.get('/auth/eu', login, (req, res) => {
    res.json({
      usuario: { nome: req.usuario.nome, email: req.usuario.email, foto: fotoUrl(req.usuario) },
    });
  });

  // O e-mail identifica a conta e não muda por aqui (igual ao app).
  r.patch('/auth/eu', login, async (req, res) => {
    const nome = limpo(req.body?.nome);
    if (nome.length < 2 || nome.length > 80) {
      throw ruim('O nome deve ter pelo menos 2 caracteres.');
    }
    await db.usuarios.updateOne({ _id: req.usuario._id }, { $set: { nome } });
    res.json({ usuario: { nome, email: req.usuario.email, foto: fotoUrl(req.usuario) } });
  });

  r.post('/auth/senha', login, async (req, res) => {
    const atual = String(req.body?.atual ?? '');
    const nova = String(req.body?.nova ?? '');
    if (!(await bcrypt.compare(atual, req.usuario.senhaHash))) {
      throw ruim('A senha atual está incorreta.');
    }
    const fraca = problemaDaSenha(nova);
    if (fraca) throw ruim(fraca);
    const senhaHash = await bcrypt.hash(nova, config.bcryptCusto);
    await db.usuarios.updateOne({ _id: req.usuario._id }, { $set: { senhaHash } });
    res.status(204).end();
  });

  // Exclusão de conta: apaga a pessoa e tudo o que ela escreveu ou registrou
  // (artigos, comunidades, mensagens, sessões, notificações e preferências).
  r.delete('/meus-dados', login, async (req, res) => {
    const id = req.usuario._id;
    const minhas = await db.comunidades.find({ criadorId: id }, { projection: { _id: 1 } }).toArray();
    const ids = minhas.map((c) => c._id);
    if (ids.length) await db.posts.deleteMany({ comunidadeId: { $in: ids } });
    await db.comunidades.deleteMany({ criadorId: id });
    await db.posts.deleteMany({ autorId: id });
    // Comentários que a pessoa fez e os feitos nos artigos dela.
    const meusArtigos = await db.artigos.find({ autorId: id }, { projection: { _id: 1 } }).toArray();
    await db.comentarios.deleteMany({
      $or: [{ autorId: id }, { artigoId: { $in: meusArtigos.map((a) => a._id) } }],
    });
    await db.artigos.deleteMany({ autorId: id });
    await db.sessoes.deleteMany({ usuarioId: id });
    await db.notificacoes.deleteMany({ usuarioId: id });
    await db.preferencias.deleteOne({ _id: id });
    await db.usuarios.deleteOne({ _id: id });
    res.status(204).end();
  });

  return r;
}
