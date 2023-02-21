import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TutorialGanharTestes extends StatefulWidget {
  @override
  _TutorialGanharTestesState createState() => _TutorialGanharTestesState();
}

class _TutorialGanharTestesState extends State<TutorialGanharTestes> {
  // final SwiperController _swiperController = SwiperController();
  int _currentIndex = 0;
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
