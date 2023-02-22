import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:codigo_de_estrada_mz/ui/tutoriais/custom_carousel.dart';
import 'package:flutter/material.dart';

class TutorialComoJogar extends StatefulWidget {
  @override
  _TutorialComoJogarState createState() => _TutorialComoJogarState();
}

class _TutorialComoJogarState extends State<TutorialComoJogar> {
  final List<String> titles = [
    "Clicar em escolher tema",
    "Selecionar um tema a sua escolha.",
    "Definir um nivel de dificuldade e clicar em jogar.",
    "Selecionar uma opcao clicando sobre ela.",
    "Pode clicar nas setas ou deslizar ou para cima ou para baixo para navegar entre as quesões.",
    "Pode clicar na imagem ou na lupa para maximizar.",
    "Depois de responder todas questoes, clicar em terminar.",
    "Na tela de estatisticas pode clicar em ver resolução se desejar consultá-la.",
  ];
  final List<String> images = [
    "tela inicial.jpg",
    "tela de categorias.jpg",
    "escolher nivel.jpg",
    "escolher-opcao.jpg",
    "navegar-entre-paginas.jpg",
    "maximizar.jpg",
    "terminar.jpg",
    "resultados.jpg",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBG,
      body: CustomCarousel(images: images, titles: titles),
    );
  }
}
