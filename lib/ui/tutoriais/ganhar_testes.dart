import 'package:codigo_de_estrada_mz/ui/tutoriais/custom_carousel.dart';
import 'package:flutter/material.dart';

class TutorialGanharTestes extends StatefulWidget {
  @override
  _TutorialGanharTestesState createState() => _TutorialGanharTestesState();
}

class _TutorialGanharTestesState extends State<TutorialGanharTestes> {
  final List<String> titles = [
    "Existem 3 formas de ganhar testes",
    "Assistir um anuncio em video até o fim e ganhar 2 testes como recompensa.",
    "Clicar em um anuncio anuncio de tela cheia.",
    "Comprar testes na loja usando CSs.",
  ];
  final List<String> images = [
    "formas ganhar testes.jpg",
    "ganhar testes.jpg",
    "intersticial ad.jpg",
    "loja de testes.jpg",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[300],
      body: CustomCarousel(images: images, titles: titles),
    );
  }
}
