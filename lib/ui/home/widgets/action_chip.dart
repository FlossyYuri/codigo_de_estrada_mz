import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:flutter/material.dart';

class CustomChip extends StatefulWidget {
  final String text;
  final VoidCallback f;
  final int dificuldade;
  CustomChip(this.text, this.dificuldade, this.f);
  _CustomChipState createState() => _CustomChipState();
}

class _CustomChipState extends State<CustomChip> {
  @override
  Widget build(BuildContext context) {
    return ActionChip(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: preto.withOpacity(0.1), width: 0.5),
        borderRadius: BorderRadius.circular(40),
      ),
      labelPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      backgroundColor: mainBG,
      elevation: 0,
      label: Container(
        width: 130,
        alignment: Alignment.center,
        child: Text(
          widget.text,
          style: TextStyle(
              color: preto, fontSize: 24, fontWeight: FontWeight.w300),
        ),
      ),
      onPressed: () {
        setState(() {
          widget.f();
        });
      },
    );
  }
}
