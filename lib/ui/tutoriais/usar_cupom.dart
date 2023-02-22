import 'package:codigo_de_estrada_mz/ui/tutoriais/custom_carousel.dart';
import 'package:flutter/material.dart';

class TutorialUsarCupom extends StatefulWidget {
  @override
  _TutorialUsarCupomState createState() => _TutorialUsarCupomState();
}

class _TutorialUsarCupomState extends State<TutorialUsarCupom> {
  final List<String> titles = [
    'Copiar a mensagem do recibo',
    'Entrar na loja',
    'Entrar na tela "Usar cupom"',
    'Clicar no botao clique aqui',
    'Clicar em usar cupom',
  ];
  final List<String> images = [
    'recibo.jpg',
    'entrar na loja.jpg',
    'tela usar cupom.jpg',
    'botao clique aqui.jpg',
    'click usar cupom.jpg'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink,
      body: CustomCarousel(images: images, titles: titles),
    );
  }
}
