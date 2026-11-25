import { existsSync } from 'node:fs';
import { join } from 'node:path';
import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import { ErroHttp } from './erros.js';
import { rotasAuth } from './rotas/auth.js';
import { rotasConteudo } from './rotas/conteudo.js';
import { rotasCatalogo } from './rotas/catalogo.js';
import { rotasSessoes } from './rotas/sessoes.js';
import { rotasPreferencias } from './rotas/preferencias.js';
import { rotasNotificacoes } from './rotas/notificacoes.js';
import { rotasPerfil } from './rotas/perfil.js';

/** Monta o app Express. `db` tem as coleções. */
export function criarApp({ db, config }) {
  const app = express();
  app.disable('x-powered-by');
  if (config.confiarProxy) app.set('trust proxy', 1);
  // O app Flutter na web precisa rodar WebAssembly e baixar fontes e o
  // motor gráfico do Google: a política de conteúdo padrão do helmet bloqueia.
  app.use(helmet({ contentSecurityPolicy: false, crossOriginEmbedderPolicy: false }));
  app.use(cors({ origin: config.corsOrigem === '*' ? true : config.corsOrigem.split(',') }));
  // 64 KB para tudo, exceto criar ou editar artigo (pode trazer a capa) e
  // trocar a foto de perfil.
  const jsonPequeno = express.json({ limit: '64kb' });
  const jsonComCapa = express.json({ limit: '700kb' });
  const comCapa = (req) =>
    (req.method === 'POST' && req.path === '/artigos') ||
    (req.method === 'PATCH' && /^\/artigos\/[^/]+$/.test(req.path)) ||
    (req.method === 'PUT' && req.path === '/auth/eu/foto') ||
    (req.method === 'PUT' && req.path === '/meus-dados-app');
  app.use((req, res, next) => (comCapa(req) ? jsonComCapa : jsonPequeno)(req, res, next));

  app.get('/saude', (_req, res) => {
    res.json({ ok: true });
  });

  // O site (app Flutter compilado), se existir: mesmo endereço da API, então
  // não há CORS nem endereço de servidor para configurar no app.
  const site = config.pastaSite;
  if (site && existsSync(join(site, 'index.html'))) {
    app.use(express.static(site, {
      setHeaders: (res, caminho) => {
        // Páginas e o "service worker" sempre conferem se há versão nova;
        // o resto (scripts, imagens) pode ficar em cache por um dia.
        const sempreNovo = /(index\.html|flutter_service_worker\.js|flutter_bootstrap\.js|version\.json|manifest\.json)$/.test(caminho);
        res.set('Cache-Control', sempreNovo ? 'no-cache' : 'public, max-age=86400');
      },
    }));
  }

  app.use(rotasAuth({ db, config }));
  app.use(rotasConteudo({ db, config }));
  app.use(rotasCatalogo({ db, config }));
  app.use(rotasSessoes({ db, config }));
  app.use(rotasPreferencias({ db, config }));
  app.use(rotasNotificacoes({ db, config }));
  app.use(rotasPerfil({ db, config }));

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
