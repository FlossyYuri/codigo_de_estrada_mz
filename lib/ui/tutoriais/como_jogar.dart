import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TutorialComoJogar extends StatefulWidget {
  @override
  _TutorialComoJogarState createState() => _TutorialComoJogarState();
}

class _TutorialComoJogarState extends State<TutorialComoJogar> {
  // final SwiperController _swiperController = SwiperController();
  int _currentIndex = 0;
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
      body: Column(
        children: <Widget>[
          Expanded(
            child:
                // Swiper(
                //   index: _currentIndex,
                //   controller: _swiperController,
                //   itemCount: titles.length,
                //   onIndexChanged: (index) {
                //     setState(() {
                //       _currentIndex = index;
                //     });
                //   },
                //   loop: false,
                //   itemBuilder: (context, index) {
                //     return _buildPage(
                //       title: titles[index],
                //       icon: "assets/screenshots/" + images[index],
                //     );
                //   },
                //   pagination: SwiperPagination(
                //       builder: DotSwiperPaginationBuilder(
                //           activeSize: 15,
                //           space: 5,
                //           activeColor: Colors.white,
                //           color: Colors.grey[800])),
                // ),
                SizedBox(height: 10.0),
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
              // if (_currentIndex < titles.length - 1)
              //   _swiperController.next();
              // else {
              //   Navigator.of(context).pop();
              // }
            },
          )
        ],
      ),
    );
  }

  // Widget _buildPage({String title, String icon}) {
  //   final TextStyle titleStyle =
  //       TextStyle(fontWeight: FontWeight.w300, fontSize: 24.0);
  //   return Container(
  //     width: double.infinity,
  //     margin: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 40.0),
  //     padding: const EdgeInsets.all(16.0),
  //     decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(30.0),
  //         color: Color.fromRGBO(40, 40, 40, 1),
  //         image: DecorationImage(
  //             image: AssetImage(icon),
  //             fit: BoxFit.contain,
  //             colorFilter:
  //                 ColorFilter.mode(Colors.black38, BlendMode.multiply))),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.end,
  //       children: <Widget>[
  //         Text(
  //           title,
  //           textAlign: TextAlign.start,
  //           style: titleStyle.copyWith(
  //             color: Colors.white,
  //             shadows: [
  //               Shadow(
  //                 blurRadius: 10,
  //                 color: Colors.black.withOpacity(1),
  //               )
  //             ],
  //           ),
  //         ),
  //         SizedBox(height: 30),
  //       ],
  //     ),
  //   );
  // }
}
