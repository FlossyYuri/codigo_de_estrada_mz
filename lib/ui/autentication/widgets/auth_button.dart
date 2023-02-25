import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final String action;
  final Icon icon;
  final VoidCallback onPressed;
  AuthButton(
      {@required this.text,
      @required this.action,
      @required this.icon,
      @required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      // disabledColor: Colors.white30,
      // disabledTextColor: Colors.black.withOpacity(.6),
      style: ElevatedButton.styleFrom(backgroundColor: branco, elevation: 4),
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
                "$action com $text",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
            ],
          )),
    );
  }
}
