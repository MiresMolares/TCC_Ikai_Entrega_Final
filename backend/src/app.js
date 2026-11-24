import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import { ErroHttp } from './erros.js';
import { rotasAuth } from './rotas/auth.js';
import { rotasConteudo } from './rotas/conteudo.js';
import { rotasIa } from './rotas/ia.js';
import { rotasCatalogo } from './rotas/catalogo.js';
import { rotasSessoes } from './rotas/sessoes.js';
import { rotasPreferencias } from './rotas/preferencias.js';
import { rotasNotificacoes } from './rotas/notificacoes.js';

/** Monta o app Express. `db` tem as coleções; `fetchImpl` é trocável nos testes. */
export function criarApp({ db, config, fetchImpl }) {
  const app = express();
  app.disable('x-powered-by');
  app.use(helmet());
  app.use(cors({ origin: config.corsOrigem === '*' ? true : config.corsOrigem.split(',') }));
  // 64 KB para tudo, exceto criar ou editar artigo, que pode trazer a capa.
  const jsonPequeno = express.json({ limit: '64kb' });
  const jsonComCapa = express.json({ limit: '600kb' });
  const comCapa = (req) =>
    (req.method === 'POST' && req.path === '/artigos') ||
    (req.method === 'PATCH' && /^\/artigos\/[^/]+$/.test(req.path));
  app.use((req, res, next) => (comCapa(req) ? jsonComCapa : jsonPequeno)(req, res, next));

  app.get('/saude', (_req, res) => {
    res.json({ ok: true, ia: Boolean(config.geminiKey) });
  });

  app.use(rotasAuth({ db, config }));
  app.use(rotasConteudo({ db, config }));
  app.use(rotasCatalogo({ db, config }));
  app.use(rotasSessoes({ db, config }));
  app.use(rotasPreferencias({ db, config }));
  app.use(rotasNotificacoes({ db, config }));
  app.use(rotasIa({ db, config, fetchImpl }));

  app.use((_req, res) => res.status(404).json({ erro: 'Rota não encontrada.' }));

  // eslint-disable-next-line no-unused-vars
  app.use((e, _req, res, _next) => {
    if (e instanceof ErroHttp) return res.status(e.status).json({ erro: e.message });
    if (e?.type === 'entity.parse.failed') return res.status(400).json({ erro: 'JSON inválido.' });
    if (e?.type === 'entity.too.large') return res.status(413).json({ erro: 'Pedido grande demais.' });
    console.error(e);
    res.status(500).json({ erro: 'Erro interno. Tente de novo.' });
  });

  return app;
}
