# Ikai - Entrega final

App Flutter + servidor Node (Express + MongoDB, pasta `backend/`). O histórico
das versões anteriores (v5, v6) está no git.

## Rodada de 25/11/2026 (site no Render e preparação para a banca)
1. **Site hospedado** no Render: o servidor entrega o app e a API no mesmo
   endereço. Passo a passo e roteiro da demonstração em `HOSPEDAGEM.md`.
2. **Conta de apresentação** com uso salvo (`npm run db:apresentacao`; dados de
   acesso em `HOSPEDAGEM.md`).
3. **Dados da conta no servidor**: biblioteca, progresso e tempo de uso são
   copiados para o banco (rota `/meus-dados-app`) e voltam em qualquer
   aparelho.
4. **Lembrar de mim** guarda o login no navegador por 7 dias.
5. **Meta de 2 min (apresentação)**, para mostrar o fim do tempo ao vivo.
6. **Fim do tempo**: resumo do que a pessoa consumiu (sempre disponível, com
   os artigos concluídos no dia) e **banco de sugestões** para depois da tela
   (24 sugestões na coleção `sugestoes`, de meditação a natureza, escolhidas
   pelo objetivo do dia; `backend/src/sugestoes.js`).
7. **Botão "Criar"** no canto do Início e da Comunidade (escrever artigo, criar
   comunidade, meus artigos) e cartões novos na aba Comunidade.
8. **Comentários e notificações** mostram "há 5 min", "há 2 h", "há 3 dias".
9. **Foto de perfil** aparece também no Início; **modo escuro** direto no
   Perfil.
10. **Conteúdo**: 180 artigos no acervo (6 por categoria, `lib/data/artigos_*.dart`)
    e 14 comunidades fixas.

## Rodada de 24/11/2026
1. **Senha forte.** Criar conta e trocar a senha exigem pelo menos 8 caracteres
   com letra maiúscula, minúscula, número e caractere especial (`12345678` não
   passa mais). A tela de cadastro mostra a lista de requisitos e vai marcando
   cada um enquanto a pessoa digita. A regra está no app
   (`lib/core/senha.dart`) e repetida no servidor (`backend/src/rotas/auth.js`).
   Contas antigas continuam entrando com a senha que já têm.
2. **Comentários com respostas.** No fim de cada artigo (do acervo e dos
   usuários): comentar, **Responder** (um nível só; responder a uma resposta
   continua a mesma conversa), foto de quem comentou, apagar (quem comentou ou
   o autor do artigo; apagar um comentário leva as respostas junto).
3. **Foto de perfil.** Em Perfil (e em Meu perfil), tocar na foto para colocar,
   trocar ou remover. O app reduz a imagem para 512 px; o servidor guarda até
   300 KB (JPEG, PNG ou WebP, conferido pelos bytes) e a foto aparece nos
   comentários.
4. **Botões iguais na entrada.** Em "Você realmente quer entrar agora?",
   "Sim, continuar" e "Não, sair" têm o mesmo estilo: o app não empurra a
   pessoa a entrar.
5. **Sem login social.** Os botões de Google e Facebook saíram das telas de
   login e cadastro (o login com Google de verdade exige configurar um projeto
   no Google Cloud; fica para depois).
6. **Leitura dos artigos.** O texto fica numa "folha" com fundo próprio sobre
   um fundo bege (no claro), largura máxima de leitura, fonte serifada (Lora),
   linhas mais espaçadas.
7. **Modo escuro.** Configurações > Preferências > Modo escuro. Vale na hora,
   sem fechar a tela, e fica guardado no aparelho. As cores estão em
   `lib/widgets/estilo.dart` (classe `Cores`, com o valor claro e o escuro de
   cada uma).
8. **Notificações entre contas.** Quando alguém comenta no seu artigo ou
   responde a um comentário seu, o servidor cria uma notificação. Ela aparece
   no sino da Home (tocar abre o artigo). O número de novas no sino só aparece
   se a pessoa ligar "Notificações" em Configurações (desligadas por padrão).
   Sem atualização em tempo real: a caixa é lida ao entrar, ao voltar do sino e
   ao puxar a tela para baixo.
9. **A Ik AI saiu do app.** Sem chat, sem Gemini, sem botão flutuante, sem
   "combinados", sem a etapa "Quer contar algo à Ik AI?" e sem nenhum texto que
   fale dela. A meta diária continua: o aviso da metade agora é neutro e, no
   fim do tempo, uma tela simples pergunta o que a pessoa aprendeu (opcional),
   deixa pedir mais 10, 15 ou 30 min explicando o motivo (até 2 vezes por dia)
   ou encerrar o dia. No servidor, a rota `/ia/gemini` e as chaves
   `GEMINI_*` foram removidas.

## Como rodar (sempre os dois juntos)
Servidor (porta 3100):
```powershell
cd C:\Ikai\TCC-Entrega-final\backend; node --env-file=.env src/server.js
```
App (porta 5300):
```powershell
cd C:\Ikai\TCC-Entrega-final; flutter run -d web-server --web-port 5300 --dart-define-from-file=env.json
```
Abrir http://localhost:5300. Conta de demonstração: `adm@email.com` / `1234`
(`npm run db:adm` cria ou repõe essa conta no banco).

Sem `--dart-define-from-file=env.json` o app roda no modo local (sem banco: sem
notificações nem fotos para os outros).

## Testes
- App: `flutter test` (199 testes) e `flutter analyze` (0 erros).
- Servidor: na pasta `backend`, `node --env-file=.env --test --test-concurrency=1 test/api.test.js test/banco.test.js`
  (65 testes; cria bancos temporários `ikai_teste_*` e apaga no fim).

## Rotas do servidor (todas exigem login, exceto cadastro, login e imagens)
| Rota | Função |
|---|---|
| `POST /auth/cadastro`, `POST /auth/login` | criar conta (senha forte), entrar (devolve token e a foto) |
| `GET/PATCH /auth/eu`, `POST /auth/senha` | ver/alterar nome, trocar senha |
| `PUT/DELETE /auth/eu/foto`, `GET /usuarios/:id/foto` | colocar/remover a foto; a imagem é pública pelo endereço |
| `DELETE /meus-dados` | exclui a conta e tudo o que a pessoa escreveu |
| `GET/POST /artigos`, `PATCH/DELETE /artigos/:id`, `GET /artigos/:id/capa` | artigos dos usuários |
| `GET/POST /artigos/:id/comentarios`, `DELETE .../comentarios/:id` | comentários e respostas (`resposta: <id>`) |
| `GET /notificacoes`, `PATCH /notificacoes/:id`, `POST /notificacoes/ler-todas`, `DELETE ...` | caixa de notificações |
| `GET/POST /comunidades`, `GET/POST /comunidades/:id/posts` | comunidades e mural |

## Ainda não existe
Atualização em tempo real,
notificação fora do app (push), edição de comunidade, recuperação de senha por
e-mail, login com Google.

## Pilares mantidos
Feed finito; histórico só como sugestão; notificações discretas e desligadas
por padrão; nenhum botão empurra a pessoa a ficar no app; gamificação só
individual; sem emojis (teste varre `lib/`).

## Adicionar mais artigos do app (sem banco)
Copie o modelo no topo de `lib/data/artigos_dados.dart` (ids `a001` a `a066`
já usados).
