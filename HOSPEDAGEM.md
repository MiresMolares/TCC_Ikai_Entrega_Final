# Como colocar o Ikai na internet (Render, gratuito)

No fim, o Ikai fica num endereço como `https://ikai-xxxx.onrender.com`.
Qualquer pessoa abre no navegador do celular ou do computador, sem instalar
nada. Um só serviço entrega o site e a API; o banco continua no MongoDB Atlas.

## Antes de começar
- O código precisa estar no GitHub (repositório
  `MiresMolares/TCC_Ikai_Entrega_Final`, branch `main`) com os arquivos
  `render.yaml` e `backend/public/` (o site já compilado).
- Tenha à mão a linha `MONGODB_URI=...` do seu `backend\.env`. Vai copiar só
  o que vem depois do `=`.
- No MongoDB Atlas, em **Network Access**, precisa estar liberado
  `0.0.0.0/0` (já está), porque o endereço do Render muda.

## Passo a passo (uma vez só)
1. Entre em https://render.com e crie a conta com **Sign in with GitHub**
   (o plano Free é de graça).
2. Quando o Render pedir acesso ao GitHub, permita o repositório
   `TCC_Ikai_Entrega_Final`.
3. No painel do Render: **New +** > **Blueprint**.
4. Escolha o repositório `TCC_Ikai_Entrega_Final`. O Render lê o
   `render.yaml` e mostra um serviço chamado **ikai**.
5. Ele pede o valor de **MONGODB_URI**: cole a conexão do Atlas (o texto que
   começa com `mongodb+srv://`). Os outros valores já estão prontos.
6. Clique em **Apply** (ou **Deploy Blueprint**). A primeira publicação leva
   uns 3 a 5 minutos. Acompanhe em **Logs**; quando aparecer
   `Ikai API em http://localhost:10000` (o número pode mudar), está no ar.
7. O endereço aparece no topo da página do serviço
   (`https://ikai-....onrender.com`). Abra no celular e entre com
   `adm@email.com` / `1234`.

### Se o Blueprint pedir cartão ou der erro
Crie o serviço à mão, com os mesmos valores do `render.yaml`:
**New +** > **Web Service** > repositório `TCC_Ikai_Entrega_Final`, e preencha:
- Root Directory: `backend`
- Runtime: `Node`
- Build Command: `npm ci`
- Start Command: `node src/server.js`
- Instance Type: **Free**
- Environment Variables: `MONGODB_URI` (a do Atlas), `MONGODB_DB` = `ikai_app`,
  `JWT_SECRET` = um texto longo qualquer (pelo menos 16 letras),
  `TRUST_PROXY` = `sim`, `NODE_VERSION` = `24`.

## Atualizar o site depois de mudar o app
O Render publica sozinho a cada envio ao GitHub. Mas o site é o app já
compilado, então, se mudar algo em `lib\`, gere de novo antes de enviar:

```powershell
cd C:\Ikai\TCC-Entrega-final; .\gerar-site.ps1
```

Depois: commit e envio ao GitHub. Mudanças só no servidor (`backend\src`) não
precisam do `gerar-site.ps1`.

## Bom saber
- **O plano gratuito "dorme"** depois de 15 minutos sem uso. A primeira
  abertura depois disso demora cerca de 1 minuto. No dia da banca, abra o
  link uns minutos antes.
- **Fechar a página pede login de novo** (o app não guarda o login).
- **"Adicionar à tela inicial"** no navegador do celular cria um ícone do
  Ikai, que abre em tela cheia, como um app.
- O site precisa de internet para baixar o motor gráfico e as fontes do
  Google (gstatic.com e fonts.googleapis.com).
- Depois da banca, vale restringir o Network Access do Atlas e trocar as
  senhas do banco.
