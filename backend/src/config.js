// Configuração lida das variáveis de ambiente (veja .env.example).
import { fileURLToPath } from 'node:url';

/** Onde fica o site (o app Flutter compilado para a web). */
const SITE_PADRAO = fileURLToPath(new URL('../public', import.meta.url));

export function lerConfig(env = process.env) {
  return {
    porta: Number(env.PORT || 3000),
    mongoUri: env.MONGODB_URI || 'mongodb://127.0.0.1:27017',
    mongoDb: env.MONGODB_DB || 'ikai',
    jwtSecret: env.JWT_SECRET || '',
    jwtExpira: env.JWT_EXPIRA || '7d',
    corsOrigem: env.CORS_ORIGEM || '*',
    bcryptCusto: Number(env.BCRYPT_CUSTO || 10),
    limitarLogin: env.LIMITAR_LOGIN !== 'nao',
    // Pasta do site. Se existir (com index.html), o servidor entrega o app
    // no mesmo endereço da API. Vazio desliga.
    pastaSite: env.SITE_DIR ?? SITE_PADRAO,
    // Atrás de um proxy (Render, por exemplo), o IP real vem no cabeçalho
    // X-Forwarded-For. Sem isto, o limite de tentativas de login valeria
    // para todo mundo junto.
    confiarProxy: env.TRUST_PROXY === 'sim',
  };
}

export function validarConfig(c) {
  if (c.jwtSecret.length < 16) {
    throw new Error(
      'Defina JWT_SECRET com pelo menos 16 caracteres (veja .env.example).',
    );
  }
}
