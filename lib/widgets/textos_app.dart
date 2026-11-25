import 'package:flutter/material.dart';

import 'estilo.dart';

/// Textos de apoio do Ikai. São PRELIMINARES: antes de publicar o app,
/// os documentos de privacidade e termos precisam de revisão jurídica.
class TextosApp {
  TextosApp._();

  static const String ajuda = '''O que é o Ikai?
Um aplicativo para aprender e se desenvolver sem prender você na tela. O feed é finito e a meta de tempo é sua.

Sua meta diária
No primeiro uso você diz quanto tempo quer usar o Ikai por dia. O Ikai avisa quando você chega na metade. No fim, abre uma tela em que você conta o que aprendeu, pode pedir mais um pouco de tempo explicando por quê (até duas vezes por dia, e o motivo fica registrado) ou encerrar o dia. Diminuir a meta vale na hora; aumentar vale a partir de amanhã. Você muda a meta em Configurações.

Seu tempo, sempre à vista
Quem já usa com frequência vê, ao abrir o app, quanto usou nos últimos dias, a média por dia e se está dentro da meta, e responde se sente que está ganhando tempo. Esses números são só seus.

Versões
Iniciante: escolha o objetivo e as categorias (uma ou várias). Avançada: inclui um lembrete de foco por leitura. Você troca em Configurações.

Feed finito
O feed mostra uma quantidade fixa de conteúdos por dia, não importa quantas categorias você escolha. Quando eles acabam, o feed acaba.

Escrever e comunidades
Você pode escrever artigos e criar comunidades na aba Comunidade, e escrever mensagens no mural das comunidades. Com o app ligado ao servidor, o que você publica é visto pelas outras pessoas.

Biblioteca
Salve artigos em pastas que você mesmo cria. Um artigo pode estar em mais de uma pasta.

Comentários
No fim de cada artigo você pode comentar e responder aos comentários das outras pessoas. Você apaga os seus comentários, e quem escreveu o artigo pode apagar os comentários feitos nele.

Notificações
Quando alguém comenta no seu artigo ou responde a um comentário seu, isso aparece no sino da Home. O número de não lidas só aparece se você ligar as notificações em Configurações.

Problemas e sugestões
Reinicie o aplicativo e confira se há atualização. Se continuar, procure o canal oficial de suporte do Ikai.''';

  static const String privacidade = '''Seus dados no Ikai

O que é guardado no seu aparelho: sua biblioteca, seu progresso, seu tempo de uso por dia, suas respostas sobre o que aprendeu e sobre ganhar ou perder tempo, os artigos, comunidades e mensagens que você criou e suas preferências, separados por conta.

O que fica no servidor do Ikai: sua conta (nome, e-mail e senha protegida), sua foto de perfil, se você colocar uma, e o que você publica (artigos, comentários, comunidades e mensagens). Seu primeiro nome e sua foto aparecem para as outras pessoas junto do que você publica; seu e-mail, nunca.

O que é enviado a terceiros: nada. O Ikai não usa inteligência artificial externa.

Anúncios: quando existirem, serão escolhidos pelo contexto do conteúdo, sem usar seus dados privados.

Exportar e excluir: em Configurações você pode exportar seus dados e excluir sua conta.''';

  static const String termos = '''Termos de uso

Ao usar o Ikai você concorda em usar o aplicativo de forma respeitosa, sem publicar conteúdo ofensivo ou ilegal e sem tentar burlar a sua própria meta de tempo. Mensagens, artigos e comunidades que você criar devem respeitar as outras pessoas.

Os artigos são de caráter informativo e educacional.

O Ikai pode mudar estes termos; mudanças relevantes serão avisadas no aplicativo.''';

  static const String sobre = '''Ikai

Um companheiro de evolução pessoal de baixa dopamina: feed finito, meta de tempo definida por você e um convite para levar sua energia para fora da tela.

Projeto de Trabalho de Conclusão de Curso.''';
}

/// Página simples que mostra um dos textos acima.
class PaginaTexto extends StatelessWidget {
  final String titulo;
  final String texto;
  final bool preliminar;

  const PaginaTexto({
    super.key,
    required this.titulo,
    required this.texto,
    this.preliminar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.fundo,
      appBar: AppBar(title: Text(titulo), backgroundColor: Cores.fundo),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (preliminar)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Cores.rosado,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Texto preliminar, ainda sem revisão jurídica.',
                  style: TextStyle(fontSize: 12, color: Cores.titulo),
                ),
              ),
            Text(
              texto,
              style: TextStyle(fontSize: 14, height: 1.7, color: Cores.titulo),
            ),
          ],
        ),
      ),
    );
  }
}
