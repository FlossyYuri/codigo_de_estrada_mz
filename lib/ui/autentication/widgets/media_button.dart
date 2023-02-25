import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:flutter/material.dart';

class MediaButton extends StatelessWidget {
  final String text;
  final Color background;
  MediaButton({@required this.text, @required this.background});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Container(
        height: 50,
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
        ),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: background,
        backgroundColor: branco,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      ),
    );
  }
}
