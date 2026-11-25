# Teste do Ikai no seu computador

Oi! Este guia é só para você testar duas coisas:

1. **Se você consegue passar da tela de login.**
2. **Se o artigo que o Caio publicou aparece para você.**

Se as duas funcionarem, o banco de dados está funcionando entre os dois
computadores. Leva uns 20 minutos na primeira vez.

> Você já tem o **Flutter**, o **Node.js** e o **Git** instalados (foram usados
> no teste anterior). Se algum comando abaixo der "não é reconhecido", avise o
> Caio.

---

## Passo 1 — Baixar o código novo

O código mudou desde o último teste (inclusive a correção do erro
`querySrv ECONNREFUSED` que apareceu no seu PC). Baixe a versão nova:

1. Abra o **PowerShell** (menu Iniciar → digite "PowerShell" → Enter).
2. Cole este comando e aperte Enter:

```powershell
git clone https://github.com/MiresMolares/TCC_Ikai_Entrega_Final.git C:\Ikai\TCC-Entrega-final
```

Se pedir login do GitHub, entre com a sua conta. Se der erro de
"Repository not found", é porque o repositório é privado: peça para o Caio te
adicionar como colaborador no GitHub e tente de novo.

Pronto: o projeto fica em `C:\Ikai\TCC-Entrega-final`.

---

## Passo 2 — Colocar os dois arquivos de configuração

Esses dois arquivos **não vão para o GitHub** (um deles tem a senha do
banco), então eles vêm à parte.

### 2.1 O `.env` do servidor (o Caio te manda)
1. Peça ao Caio o arquivo **`.env`** (em particular, não em grupo).
2. Salve ele dentro de `C:\Ikai\TCC-Entrega-final\backend\`, com o nome
   exatamente **`.env`** (com o ponto no começo e sem `.txt` no fim).

### 2.2 O `env.json` do app (você mesmo cria)
Cole este comando no PowerShell e aperte Enter:

```powershell
Set-Content -Path C:\Ikai\TCC-Entrega-final\env.json -Encoding ascii -Value '{"API_URL": "http://localhost:3100"}'
```

---

## Passo 3 — Instalar as dependências (só na primeira vez)

No mesmo PowerShell, cole um de cada vez:

```powershell
cd C:\Ikai\TCC-Entrega-final\backend
```

```powershell
npm install
```

```powershell
cd C:\Ikai\TCC-Entrega-final
```

```powershell
flutter pub get
```

Espere cada um terminar antes de colar o próximo.

---

## Passo 4 — Ligar o servidor (janela 1)

1. Abra um **PowerShell novo**.
2. Cole:

```powershell
cd C:\Ikai\TCC-Entrega-final\backend; node --env-file=.env src/server.js
```

3. Espere aparecer: **`Ikai API em http://localhost:3100 (IA desligada)`**

   Pode aparecer antes `[db] O DNS deste computador recusou...` e
   `[db] Conectado usando DNS público.` — **é normal no seu PC**, o servidor
   resolve sozinho.

4. **Não feche essa janela.**

---

## Passo 5 — Ligar o app (janela 2)

1. Abra **outro PowerShell novo** (deixe o primeiro aberto).
2. Cole:

```powershell
cd C:\Ikai\TCC-Entrega-final; flutter run -d web-server --web-port 5300 --dart-define-from-file=env.json
```

3. Espere aparecer: **`lib\main.dart is being served at http://localhost:5300`**
   (a primeira vez demora 1 a 2 minutos).
4. **Não feche essa janela também.**

---

## Passo 6 — TESTE 1: passar da tela de login

1. Abra o **Chrome** ou o **Edge** e vá em: **http://localhost:5300**
   (é a 5300, não a 3100). A primeira abertura demora uns 20 segundos.
2. Entre com:
   - E-mail: **adm@email.com**
   - Senha: **1234**
3. Clique em **Entrar** (se o botão não responder, aperte **Enter** no campo de
   senha).

**✅ Passou no teste 1** se aparecer **"Bem-vindo ao Ikai! Você realmente quer
entrar agora?"**. Clique em **Sim, continuar**.

❌ Se aparecer **"Sem conexão com o servidor"**: a janela 1 (Passo 4) está
fechada ou deu erro. Veja o que ela mostra.

---

## Passo 7 — TESTE 2: ver o artigo do Caio

1. Na tela da **meta de tempo**, clique em **Continuar**.
2. Em **"Qual é o seu objetivo?"**, escolha **Passar o tempo** (o último, em
   "Ou, sem preferências") e clique em **Confirmar e entrar**. Essa opção
   mostra conteúdo de todas as categorias.
3. Toque na aba **Explorar** (a lupa, embaixo).
4. No campo de busca, digite o **título do artigo do Caio** (ele vai te
   mandar).

**✅ Passou no teste 2** se o artigo aparecer, com o nome do autor e
**"(leitor)"** do lado. Toque nele para abrir e, se quiser, deixe um
comentário no fim — o Caio vai ver.

> Outro jeito: se o Caio publicou entrando também como **adm@email.com**, o
> artigo aparece em **Comunidade → Meus artigos**.

---

## Problemas comuns

| O que aparece | O que fazer |
|---|---|
| Janela 1: `SSL alert number 80` | Avise o Caio (é a liberação de IP no Atlas). |
| Janela 1: `bad auth` ou `Authentication failed` | O `.env` veio errado: peça de novo ao Caio. |
| Janela 1: `Cannot find module` | Você pulou o `npm install` do Passo 3. |
| Janela 1: `EADDRINUSE ... 3100` | Já tem um servidor aberto: feche as outras janelas e tente de novo. |
| App: **"Sem conexão com o servidor"** | A janela 1 não está rodando. |
| App: erros com `Matrix4`, `ValueNotifier`... | Rode `cd C:\Ikai\TCC-Entrega-final; Remove-Item -Recurse -Force .dart_tool; flutter pub get` e repita o Passo 5. |
| `flutter`, `node` ou `git` "não é reconhecido" | Feche e abra o PowerShell; se continuar, avise o Caio. |

**Para desligar tudo no final:** clique em cada janela do PowerShell e aperte
**Ctrl + C** (se perguntar, digite **S** e Enter), ou só feche as janelas.
