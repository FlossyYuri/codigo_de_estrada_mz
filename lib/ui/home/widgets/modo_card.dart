import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:flutter/material.dart';

class ModoCard extends StatelessWidget {
  final String img;
  final String titulo;
  final String subtitulo;
  final String add1;
  final IconData icon1;
  final IconData icon2;
  final String add2;
  final Function f;
  final Color bgcolor;
  ModoCard(
      {@required this.img,
      @required this.titulo,
      @required this.subtitulo,
      @required this.bgcolor,
      @required this.f,
      @required this.icon1,
      @required this.icon2,
      @required this.add1,
      @required this.add2});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Stack(
        children: <Widget>[
          planetCard(),
          planetThumbnail(),
        ],
      ),
    );
  }

  Widget planetThumbnail() {
    return Container(
      alignment: FractionalOffset(-0.04, 0.5),
      margin: const EdgeInsets.only(left: 24.0, top: 6.5),
      child: Image(
        image: AssetImage(img),
        height: 100,
        width: 100,
      ),
    );
  }

  Widget planetCard() {
    return Container(
      margin: const EdgeInsets.only(left: 62.0, right: 16.0),
      decoration: BoxDecoration(
        color: secBG,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: f,
        color: bgcolor,
        splashColor: lightBG,
        elevation: 4,
        child: Container(
          margin: const EdgeInsets.only(
              top: 20.0, left: 55.0, bottom: 20, right: 5),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  titulo,
                  style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.w600,
                      fontSize: 24.0),
                ),
                Text(
                  subtitulo,
                  style: TextStyle(
                      color: Color(0x66FFFFFF),
                      fontWeight: FontWeight.w300,
                      fontSize: 14.0),
                ),
                Container(
                    color: const Color(0xFF00C6FF),
                    width: 24.0,
                    height: 1.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          icon1,
                          size: 14.0,
                          color: Color(0x66FFFFFF),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          add1,
                          style: TextStyle(
                            color: Color(0x66FFFFFF),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w300,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          icon2,
                          size: 14.0,
                          color: Color(0x66FFFFFF),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          add2,
                          style: TextStyle(
                            color: Color(0x66FFFFFF),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w300,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
