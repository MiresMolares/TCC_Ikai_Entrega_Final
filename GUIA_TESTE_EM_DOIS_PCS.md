# Ikai: como testar em dois computadores ao mesmo tempo

Objetivo: duas pessoas, cada uma no seu computador, usando o Ikai **ligado ao
mesmo banco de dados** (MongoDB Atlas). Assim, o artigo que uma pessoa cria
aparece para a outra, e os comentários também.

> **Por que não funcionou só com `flutter run`?** Sem o servidor, o app roda no
> **modo local**: tudo fica salvo só naquele navegador. Para compartilhar, cada
> computador precisa rodar **o servidor** e abrir o app **apontando para ele**.

```
Computador A:  app (navegador)  ->  servidor (localhost:3100)  -\
                                                                  -> MongoDB Atlas
Computador B:  app (navegador)  ->  servidor (localhost:3100)  -/     (banco ikai_app)
```

Cada computador roda o próprio servidor, e os dois servidores usam o mesmo
banco. Não precisa estar na mesma rede Wi-Fi.

---

## Parte 1 — Preparar o Atlas (uma vez, quem tem a conta do Atlas faz)

### 1.1 Liberar o IP de cada computador
O Atlas só aceita conexões de endereços liberados. **Todo computador que for
rodar o servidor precisa estar na lista** (e se a internet mudar, o IP pode
mudar e precisar ser liberado de novo).

1. Entre em https://cloud.mongodb.com com a conta do projeto.
2. No menu da esquerda, clique em **Network Access** (em "Security").
3. Clique em **+ ADD IP ADDRESS**.
4. Se você estiver **no computador que vai ser liberado**, clique em
   **ADD CURRENT IP ADDRESS**. Se não, digite o IP que a outra pessoa mandar.
5. Em "Comment", escreva de quem é (ex.: "PC do João").
6. Clique em **Confirm** e espere o status ficar **Active** (1 a 2 minutos).

> Para descobrir o próprio IP: a tela do passo 4 mostra o IP de quem está
> com o Atlas aberto.

> **Situação atual do projeto:** está liberado **ALLOW ACCESS FROM ANYWHERE
> (`0.0.0.0/0`)**, então qualquer computador conecta (protegido só pelo
> usuário e senha do banco). Foi preciso porque a rede trocava de IP e o
> Atlas recusava a conexão mesmo com o IP cadastrado. **Depois da
> apresentação, apaguem essa entrada** em Network Access.

### 1.2 (Recomendado) Criar um usuário do banco só para o amigo
Assim vocês não precisam passar a senha de vocês e podem tirar o acesso depois.

1. No menu da esquerda, clique em **Database Access**.
2. Clique em **+ ADD NEW DATABASE USER**.
3. Método: **Password**. Escolha um nome (ex.: `amigo_teste`) e clique em
   **Autogenerate Secure Password**. **Copie a senha** e guarde.
4. Em "Database User Privileges", escolha **Read and write to any database**.
5. Clique em **Add User**.

---

## Parte 2 — Instalar as ferramentas (em cada computador)

Instale **no disco do computador (C:), não em pen drive** — pelo pen drive
fica lento e dá erro.

### 2.1 Git
1. Baixe em https://git-scm.com/download/win e instale com as opções padrão.

### 2.2 Node.js (para o servidor)
1. Baixe a versão **LTS** em https://nodejs.org e instale com as opções padrão.
2. Feche e abra o PowerShell e confira: `node -v` (precisa ser 20 ou mais).

### 2.3 Flutter 3.50.1 (para o app)
1. Baixe:
   https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.50.1-stable.zip
2. Crie a pasta `C:\src` e extraia o zip **dentro dela**. Tem que ficar
   `C:\src\flutter\bin\flutter.bat`.
3. Coloque `C:\src\flutter\bin` no PATH: menu Iniciar → digite
   **"variáveis de ambiente"** → **Editar as variáveis de ambiente para sua
   conta** → selecione **Path** → **Editar** → **Novo** → cole
   `C:\src\flutter\bin` → **OK** em tudo.
4. **Feche e abra** o PowerShell e confira: `flutter --version` (deve mostrar
   3.50.1). A primeira vez demora.
5. Rode `flutter doctor`. Para o navegador, bastam **Flutter** e **Chrome**
   com ✓ (Android e Visual Studio podem ficar com ✗).

### 2.4 Navegador
Chrome ou Edge.

---

## Parte 3 — Copiar o projeto (em cada computador)

1. Copie a pasta `TCC-Entrega-final` para o disco, por exemplo
   `C:\Ikai\TCC-Entrega-final`. **Não precisa copiar** as pastas `build`,
   `.dart_tool` e `backend\node_modules` (elas se refazem).
2. Confira que existem estes dois arquivos de configuração:
   - `C:\Ikai\TCC-Entrega-final\env.json` — o endereço do servidor. Conteúdo:
     ```json
     {
       "API_URL": "http://localhost:3100",
       "GEMINI_API_KEY": "",
       "GEMINI_MODEL": "gemini-3.6-flash"
     }
     ```
   - `C:\Ikai\TCC-Entrega-final\backend\.env` — a conexão com o banco. Tem 7
     linhas: `PORT=3100`, `MONGODB_URI=...`, `MONGODB_DB=ikai_app`,
     `JWT_SECRET=...`, `GEMINI_API_KEY=` (vazio), `GEMINI_MODEL=gemini-3.6-flash`
     e `CORS_ORIGEM=*`.
3. **O `.env` tem a senha do banco: mande em particular**, nunca em grupo nem
   no GitHub.
4. Se criou um usuário do banco para o amigo (passo 1.2): no `.env` **dele**,
   na linha `MONGODB_URI`, troque o usuário e a senha que ficam entre
   `mongodb+srv://` e o `@` pelos dele (`usuario:senha`). Se a senha tiver
   `@ : / ? # %`, ela precisa ser codificada (ex.: `@` vira `%40`).
5. **Os dois computadores precisam usar `MONGODB_DB=ikai_app`** (é o que faz
   os dois verem os mesmos dados).

---

## Parte 4 — Instalar as dependências (uma vez, em cada computador)

Abra o PowerShell e rode, **um comando de cada vez**:

```powershell
cd C:\Ikai\TCC-Entrega-final\backend
npm install
```

```powershell
cd C:\Ikai\TCC-Entrega-final
Remove-Item -Recurse -Force .dart_tool -ErrorAction SilentlyContinue
flutter pub get
```

(Apagar a `.dart_tool` evita um erro que acontece quando a pasta veio de
outro computador.)

---

## Parte 5 — Criar a conta adm@email.com no banco (uma vez só, em qualquer PC)

No modo com servidor, as contas ficam no banco. Para ter a mesma conta de
teste do modo local (**adm@email.com / 1234**), rode **uma vez**:

```powershell
cd C:\Ikai\TCC-Entrega-final\backend
npm run db:adm
```

Deve aparecer: `Conta adm@email.com criada no banco "ikai_app" (senha 1234).`
Como o banco é compartilhado, **os dois computadores passam a ter essa conta**.

> Para testar a interação, o ideal é **cada pessoa ter a própria conta**
> (botão **Cadastre-se** no app). A conta adm serve para demonstração.

---

## Parte 6 — Rodar (toda vez que for testar, em cada computador)

São **dois PowerShell abertos ao mesmo tempo**. Não feche nenhum enquanto
estiver usando o app.

### Janela 1 — o servidor
```powershell
cd C:\Ikai\TCC-Entrega-final\backend
node --env-file=.env src/server.js
```
Espere aparecer: **`Ikai API em http://localhost:3100 (IA desligada)`**.

### Janela 2 — o app
```powershell
cd C:\Ikai\TCC-Entrega-final
flutter run -d web-server --web-port 5300 --dart-define-from-file=env.json
```
Espere aparecer: **`lib\main.dart is being served at http://localhost:5300`**
(na primeira vez leva 1 a 2 minutos).

### No navegador
Abra **http://localhost:5300**.

> **Atenção:** sem o `--dart-define-from-file=env.json` o app abre no modo
> local e **não** conversa com o banco.

---

## Parte 7 — Testar a interação

1. **Computador A:** clique em **Cadastre-se**, crie uma conta (senha com 8 ou
   mais caracteres) e entre.
2. **Computador B:** faça o mesmo com outra conta.
3. Os dois escolhem o mesmo objetivo e categoria (ex.: **Ler → Romance**).
4. **A:** aba **Comunidade → Meus artigos → Escrever um artigo**. Escolha
   **Ler → Romance**, preencha e toque em **Publicar**.
5. **B:** atualize a página (F5), entre de novo e veja o artigo de A no feed,
   com "(leitor)". Abra e comente no fim do artigo.
6. **A:** atualize, entre de novo e abra o artigo: o comentário de B aparece.
7. **A** pode **Editar** ou **Apagar** o artigo em **Meus artigos**; **B** não.

> O app não atualiza sozinho: para ver o que a outra pessoa acabou de fazer,
> atualize a página (F5). Atualizar pede login de novo.

---

## Problemas comuns

| O que aparece | Causa | Como resolver |
|---|---|---|
| No servidor: `SSL alert number 80` ou `Server selection timed out` | O IP deste computador não está liberado no Atlas | Parte 1.1 (liberar o IP) e rodar o servidor de novo |
| No servidor: `bad auth` / `Authentication failed` | Usuário ou senha errados no `MONGODB_URI` | Conferir o `.env` (Parte 3, passo 4) |
| No app: tudo funciona mas o outro não vê nada | O app abriu no modo local | Rodar com `--dart-define-from-file=env.json` e com o servidor ligado |
| No app: erros com `Matrix4`, `ValueNotifier`, `SharedPreferences` | Pacotes do Flutter apontando para outro computador | Parte 4, comandos do `flutter pub get` |
| `flutter run -d chrome` abre e fecha o Chrome | Computador com política que bloqueia o Chrome controlado | Usar `-d web-server` como na Parte 6 |
| Servidor: `EADDRINUSE ... 3100` | Já existe um servidor rodando | Fechar a outra janela do servidor |
| `flutter` ou `node` "não é reconhecido" | PATH não atualizado | Fechar e abrir o PowerShell (ou rever a Parte 2) |
