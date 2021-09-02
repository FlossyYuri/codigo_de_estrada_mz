import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:flutter/material.dart';

class TemaCard extends StatelessWidget {
  final String tema;
  TemaCard({@required this.tema});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(
              width: 4,
              color: secBG,
            ),
          ),
          boxShadow: [
            new BoxShadow(
              color: Colors.black26,
              offset: new Offset(10.0, 5.0),
              blurRadius: 20.0,
            )
          ],
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              Text(
                tema,
                style: TextStyle(
                  color: secBG,
                  fontWeight: FontWeight.w400,
                  fontSize: 18.0,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
