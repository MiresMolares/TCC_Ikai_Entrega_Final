// Cria (ou repõe) a conta de demonstração adm@email.com / 1234 no banco,
// a mesma conta de teste que o app tem no modo local.
//   npm run db:adm        (usa o banco do backend/.env)
//
// A senha é curta de propósito, igual à do modo local: o cadastro pelo app
// exige 8 caracteres, mas esta conta é criada direto no banco. Serve só para
// demonstração: não use em um banco de produção.
import bcrypt from 'bcryptjs';
import { lerConfig } from '../src/config.js';
import { conectar } from '../src/db.js';

const config = lerConfig();
const db = await conectar(config);

const email = 'adm@email.com';
const r = await db.usuarios.updateOne(
  { email },
  {
    $set: { nome: 'Administrador', senhaHash: await bcrypt.hash('1234', config.bcryptCusto) },
    $setOnInsert: { email, criadoEm: new Date() },
  },
  { upsert: true },
);

console.log(
  r.upsertedCount
    ? `Conta ${email} criada no banco "${config.mongoDb}" (senha 1234).`
    : `Conta ${email} já existia no banco "${config.mongoDb}": senha reposta para 1234.`,
);
await db.cliente.close();
