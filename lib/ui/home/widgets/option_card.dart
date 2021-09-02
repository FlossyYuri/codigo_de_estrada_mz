import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:flutter/material.dart';

class OptionCard extends StatelessWidget {
  final String texto;
  final IconData icon;
  final VoidCallback f;
  OptionCard({@required this.texto, @required this.icon, @required this.f});
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onPressed: f,
      color: branco,
      highlightColor: transparente,
      splashColor: Colors.blueGrey,
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 120,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: secBG,
              size: 60,
            ),
            Text(
              texto,
              style: TextStyle(
                color: secBG,
                fontSize: 28,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
