import 'package:codigo_de_estrada_mz/ui/tutoriais/custom_carousel.dart';
import 'package:flutter/material.dart';

class TutorialComprarCS extends StatefulWidget {
  @override
  _TutorialComprarCSState createState() => _TutorialComprarCSState();
}

class _TutorialComprarCSState extends State<TutorialComprarCS> {
  final List<String> titles = [
    "Clicar no cupom que deseja comprar",
    "Transferir o valor a pagar consoante o cupom que deseja pagar.\n"
        "Numero para tranferencia: 840521586\nNome: Emerson Cuambe",
    "Copiar a mensagem de confirmacao enviada pelo Mpesa.",
    "Voltar a janela de compra de cs e clicar no botao para validar a transferencia.",
    "Enviar mensagem de confirmacao de transferencia.",
    "Receberá uma mensagem com o recibo do cupom, guarde-a bem."
  ];
  final List<String> images = [
    "comprar cs.jpg",
    "transferir.jpg",
    "recibo de transferencia.jpg",
    "click validar.jpg",
    "enviar mensagem.jpg",
    "recibo.jpg"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      body: CustomCarousel(images: images, titles: titles),
    );
  }
}
