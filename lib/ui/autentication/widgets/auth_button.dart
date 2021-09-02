import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String texto;
  final String acao;
  final Icon icon;
  final VoidCallback onPressed;
  AuthButton(
      {@required this.texto,
      @required this.acao,
      @required this.icon,
      @required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      // disabledColor: Colors.white30,
      // disabledTextColor: Colors.black.withOpacity(.6),
      style: ElevatedButton.styleFrom(primary: branco, elevation: 4),
      child: Container(
          alignment: Alignment.center,
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              icon,
              SizedBox(
                width: 20,
              ),
              Text(
                "$acao com $texto",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
            ],
          )),
    );
  }
}
