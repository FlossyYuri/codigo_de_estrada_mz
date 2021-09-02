import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:flutter/material.dart';

class Alternativa extends StatelessWidget {
  final String texto;
  final VoidCallback f;
Alternativa({@required this.texto, @required this.f});
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: f,
      splashColor: Colors.white.withOpacity(0.5),
      focusElevation: 4,
      elevation: 0.5,
      highlightElevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      color: mainBG,
      textColor: Colors.black,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        alignment: Alignment.center,
        child: Text(
          texto,
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.normal),
        ),
      ),
    );
  }
}
