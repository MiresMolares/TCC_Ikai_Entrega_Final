# Contexto do projeto Ikai (para continuar em uma conversa nova)

> Leia este arquivo inteiro antes de mexer no projeto. Ele resume o que já foi
> feito, como rodar e as decisões tomadas. Atualizado em 25/11/2026.

## 1. Onde está cada coisa

| O quê | Onde |
|---|---|
| Projeto (app Flutter + servidor) | `C:\Ikai\TCC-Entrega-final` (trabalhar SÓ aqui, no C:) |
| GitHub (repositório oficial agora) | https://github.com/MiresMolares/TCC_Ikai_Entrega_Final (branch `main`) |
| Banco de dados | MongoDB Atlas, cluster `ikai.3swygew.mongodb.net`, banco **`ikai_app`** |
| Flutter | 3.50.1 (Dart 3.14) em `C:\src\flutter` (no PATH do usuário) |
| Node.js | v26 (servidor), Git 2.56, GitHub CLI (`gh`) instalado mas **não logado** |
| Cópias antigas (backup, não usar) | `D:\TCC - Entrega final`, `D:\TCC_Ikai-claude-entrega-ikai`, `D:\TCC_Ikai`, `D:\tcc-flutter`, `D:\Ikai - TCC` (D: é pen drive FAT32: lento, evitar) |

O repositório da equipe (`danielrcruz7-boop/TCC_Ikai`) **não aceita push** da
conta do Caio (MiresMolares, erro 403). O histórico da equipe foi juntado no
repo novo (merge `-s ours`): a `main` tem o conteúdo da versão final e os
commits antigos da equipe ficam no histórico. As telas de recuperação de senha
e o tema novo da equipe (commit `9abd872`, 13/11) **não estão** na versão final.

## 2. Como rodar (sempre os DOIS juntos)

**Janela 1 — servidor (porta 3100, só dados, sem tela):**
```powershell
cd C:\Ikai\TCC-Entrega-final\backend; node --env-file=.env src/server.js
```
Espera: `Ikai API em http://localhost:3100 (IA desligada)`.

**Janela 2 — app (porta 5300, as telas):**
```powershell
cd C:\Ikai\TCC-Entrega-final; flutter run -d web-server --web-port 5300 --dart-define-from-file=env.json
```
Abrir **http://localhost:5300**. Login de demonstração: **adm@email.com / 1234**.

- Sem `--dart-define-from-file=env.json` o app abre no **modo local** (tudo no
  navegador, nada no banco).
- `flutter run -d chrome` falha neste PC (política do Windows Education
  bloqueia o Chrome controlado): usar `-d web-server`.
- Em modo debug o app aparece numa moldura de celular (device_preview) e
  demora ~20 s na primeira abertura; às vezes o clique em "Entrar" não pega:
  Enter no campo de senha funciona.
- Para ver mudanças com o `flutter run` aberto: `R` no terminal + F5.

**Arquivos de configuração (NUNCA vão para o GitHub, estão no .gitignore):**
- `backend\.env`: `PORT=3100`, `MONGODB_URI=...`, `MONGODB_DB=ikai_app`,
  `JWT_SECRET=...`, `CORS_ORIGEM=*` (as linhas `GEMINI_*` antigas são
  ignoradas). Tem a senha do banco. **Nunca ler o conteúdo nem exibir.**
  Já foi apagado por engano uma vez (caminho relativo num comando .NET);
  sempre usar caminho absoluto ao editar e conferir antes de gravar.
- `env.json` (raiz do app): `{"API_URL": "http://localhost:3100", ...}`.
- Em 24/11 o servidor e o app estavam abertos em janelas do Windows (portas
  3100 e 5300) com o código ANTIGO: **reiniciar os dois** para ver as
  mudanças (o servidor precisa reiniciar para ter as rotas novas).

## 3. Testes (como estavam no fim)

- App: `flutter test` → **199 passando**; `flutter analyze` → 0 erros
  (46 "info").
- Servidor: na pasta `backend`,
  `node --env-file=.env --test --test-concurrency=1 test/api.test.js test/banco.test.js`
  → **65 passando** (cria bancos temporários `ikai_teste_*` e apaga no fim).

## 4. O que já foi feito (resumo)

**Base:** versão de entrega v6 (meta diária, artigos, comunidades, biblioteca,
progresso, login pela API, servidor Node+Express+MongoDB em `backend/`) +
da linha da equipe: `docs/` (relatório, diagramas, Swagger) e 9 conteúdos de
estudo viraram artigos.

**Rodada de 24/11 (commit `3582da2`; detalhes em README_ENTREGA.md):**
- Ik AI **removida** do app e do servidor (chat, Gemini, combinados, botão,
  etapa do fluxo, textos). O fim do dia virou uma tela simples
  (`lib/pages_configurar/tela_fim_do_dia.dart`).
- Senha forte (`lib/core/senha.dart` + `problemaDaSenha` no servidor).
- Comentários com respostas (um nível, campo `respostaA`) e notificações
  automáticas (`notificar()` em `backend/src/rotas/notificacoes.js`; no app,
  `lib/services/notificacoes_service.dart`; o número no sino só aparece com
  "Notificações" ligado).
- Foto de perfil (`backend/src/rotas/perfil.js`,
  `lib/services/foto_perfil_service.dart`, `lib/widgets/avatar_pessoa.dart`).
- Modo escuro: `Cores` em `lib/widgets/estilo.dart` virou getters com valor
  claro/escuro; `ConfigService.definirEscuro` redesenha tudo.
- Leitura do artigo numa "folha" (`artigo_page.dart`, fonte Lora).
- Sem botões de Google/Facebook; "Sim, continuar" e "Não, sair" iguais.
- A escolha da foto não foi testada no navegador (abre o seletor de arquivos
  do Windows); a rota foi testada no servidor.

**App (antes de 24/11):**
- **Capa nos artigos** (estilo Substack): escolher na galeria (image_picker),
  miniatura quadrada nas listas, capa larga em "Meus artigos" e na leitura.
  `lib/widgets/capa_artigo.dart`.
- **Objetivos:** até 2 ao mesmo tempo (ex.: Ler e Estudar) + "Passar o tempo"
  (sem categorias, feed com de tudo, exclusivo). Descrição em cada objetivo.
  `lib/pages_configurar/controle_objetivo.dart`, `objetivo_livre.dart`.
- **Home:** temporizador compacto (abre ao tocar); filtros (nível/assunto)
  num botão "Filtrar" com bottom sheet.
- **Acervo:** 66 artigos em `lib/data/artigos_dados.dart` (a001–a066), todas
  as 30 categorias com ≥ 2.
- **Editar artigo** (botão em Meus artigos) e **comentários** no fim de cada
  artigo (acervo e de usuários). `lib/widgets/comentarios_artigo.dart`,
  `lib/data/comentario.dart`.

**Servidor (`backend/`):**
- Rotas novas: `PATCH /artigos/:id` (editar, só autor), capa em
  `GET /artigos/:id/capa` (pública, cache, endereço muda a cada edição),
  `GET/POST /artigos/:id/comentarios`, `DELETE .../comentarios/:id`
  (quem comentou ou autor do artigo). Coleção nova `comentarios`.
- `npm run db:adm`: cria/repõe a conta **adm@email.com / 1234** no banco
  (já criada no `ikai_app`).
- Conexão ao Atlas com fallback: se o DNS do PC recusar a consulta SRV
  (`querySrv ECONNREFUSED`, aconteceu no PC do amigo), tenta com DNS
  público 1.1.1.1/8.8.8.8 (`src/db.js`).

## 5. Estado do banco e do Atlas

- Banco **`ikai_app`** (10 coleções). Contém: conta adm; e do teste a conta
  `joao.teste@exemplo.com` + 1 artigo ("Segunda versão, editada") + 1
  comentário em "Orgulho e Preconceito" (podem ser apagados).
- **Network Access está `0.0.0.0/0`** (qualquer IP), porque a rede trocava de
  IP e o Atlas recusava (erro `SSL alert number 80`). **Apagar depois da
  apresentação.**
- Cada integrante do grupo recebe do Caio, em particular, um **user e senha
  de banco** próprio (Atlas → Database Access) para montar o próprio
  `backend\.env` (troca só USER e SENHA na linha `MONGODB_URI`).

## 6. Teste em dois computadores (em andamento)

Cada computador roda **o próprio servidor + o próprio app**, ambos apontando
para o mesmo banco `ikai_app` ("localhost" é sempre o próprio PC).
Guias: `GUIA_AMIGO_TESTE.txt` (para o amigo) e `GUIA_TESTE_EM_DOIS_PCS.md`.
Critérios do teste do amigo: passar do login (adm/1234) e achar o artigo do
Caio (objetivo "Passar o tempo" → Explorar → buscar pelo título).

## 7. Pendências e cuidados

- A rodada de 24/11 já está no GitHub (commit `3582da2`, branch `main`).
- **Hospedagem (no ar desde 25/11):** só site, sem APK. Um serviço no Render
  entrega a API e o site juntos (`render.yaml`, publica sozinho a cada envio
  ao GitHub; o site compilado fica em `backend/public`, gerado por
  `.\gerar-site.ps1` com `API_URL=origem`). Sempre que mudar `lib\`, rodar
  `.\gerar-site.ps1` antes de enviar ao GitHub. Detalhes em `HOSPEDAGEM.md`.
- **Rodada de 25/11 (para a banca):** conta de apresentação
  `apresentacao@ikai.app` com uso salvo (`npm run db:apresentacao` repõe;
  senha em `HOSPEDAGEM.md`); cópia de biblioteca/progresso/tempo no servidor
  (`/meus-dados-app`, `lib/services/sincronizacao_service.dart`); "Lembrar
  de mim" guarda o token 7 dias (`AuthService.restaurarSessao`, chamado na
  splash); meta de 2 min (apresentação); fim do tempo com resumo e banco de
  sugestões (coleção `sugestoes`, `backend/src/sugestoes.js`); botão "Criar"
  (`lib/widgets/botao_criar.dart`); tempo relativo nos comentários; foto no
  Início; modo escuro no Perfil; 180 artigos (6 por categoria) e 14
  comunidades fixas (ids também em `backend/src/catalogo.js`).
- Não existe: atualização em tempo real, edição de comunidade, recuperação de
  senha real, login com Google.
- `docs/api/openapi.yaml` (da equipe) ainda descreve login com
  Google/Facebook e não tem as rotas novas.
- `AGENTS.md` está desatualizado (é da linha antiga da equipe).
- Para atualizar o GitHub: `git add -A; git commit -m "..."; git push`
  (o login do Git já está salvo no Windows).
- Preferências do usuário: respostas em português, passo a passo calmo e
  claro, chamar as coisas pelos nomes que ele usa (ex.: "user e senha"), não
  agir em senhas/credenciais, confirmar antes de ações no GitHub.
