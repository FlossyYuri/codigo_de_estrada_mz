import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TutorialComprarCS extends StatefulWidget {
  @override
  _TutorialComprarCSState createState() => _TutorialComprarCSState();
}

class _TutorialComprarCSState extends State<TutorialComprarCS> {
  final SwiperController _swiperController = SwiperController();
  int _currentIndex = 0;
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
      body: Column(
        children: <Widget>[
          Expanded(
            child: Swiper(
              index: _currentIndex,
              controller: _swiperController,
              itemCount: titles.length,
              onIndexChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              loop: false,
              itemBuilder: (context, index) {
                return _buildPage(
                  title: titles[index],
                  icon: "assets/screenshots/" + images[index],
                );
              },
              pagination: SwiperPagination(
                builder: DotSwiperPaginationBuilder(
                  activeSize: 15,
                  space: 5,
                  activeColor: Colors.white,
                  color: Colors.grey[800],
                ),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          _buildButtons(),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Container(
      margin: const EdgeInsets.only(right: 16.0, left: 16.0, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: TextStyle(color: Colors.white70),
            ),
            child: Text("Saltar"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          IconButton(
            color: Colors.white,
            splashColor: Colors.black,
            icon: Icon(
              _currentIndex < titles.length - 1
                  ? FontAwesomeIcons.arrowRight
                  : FontAwesomeIcons.check,
            ),
            onPressed: () async {
              if (_currentIndex < titles.length - 1)
                _swiperController.next();
              else {
                Navigator.of(context).pop();
              }
            },
          )
        ],
      ),
    );
  }

  Widget _buildPage({String title, String icon}) {
    final TextStyle titleStyle =
        TextStyle(fontWeight: FontWeight.w300, fontSize: 24.0);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 40.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Color.fromRGBO(40, 40, 40, 1),
        image: DecorationImage(
          image: AssetImage(icon),
          fit: BoxFit.contain,
          colorFilter: ColorFilter.mode(Colors.black38, BlendMode.multiply),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            title,
            textAlign: TextAlign.start,
            style: titleStyle.copyWith(
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 10,
                  color: Colors.black.withOpacity(1),
                )
              ],
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
