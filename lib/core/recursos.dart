/// Interruptores de recursos do app.
///
/// Para a apresentação, a conversa livre com a Ik AI (botão flutuante, cartão
/// da Home e botão "Falar com a Ik AI" dos avisos) fica escondida, e o Gemini
/// não é usado (sem GEMINI_API_KEY no servidor nem no env.json).
/// A tela de fim do dia continua: é por ela que a pessoa pede mais tempo ou
/// encerra o dia, com respostas prontas do próprio app.
///
/// Para religar: troque para true e configure a chave do Gemini no servidor
/// (backend/.env, GEMINI_API_KEY e GEMINI_MODEL=gemini-3.6-flash).
const bool conversaLivreIkAi = false;
