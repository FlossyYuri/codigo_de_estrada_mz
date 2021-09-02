import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:flutter/material.dart';

class CustomTextField2 extends StatefulWidget {
  final String hint;
  final bool isObscure;
  final IconData prefix;
  final TextInputType keyboard;
  final bool asSufix;
  final Function valid;
  final TextEditingController controller;
  final int tamanho;
  CustomTextField2(
      {@required this.hint,
      @required this.isObscure,
      @required this.prefix,
      @required this.keyboard,
      @required this.asSufix,
      @required this.controller,
      @required this.valid,
      this.tamanho});

  @override
  _CustomTextField2State createState() => _CustomTextField2State();
}

class _CustomTextField2State extends State<CustomTextField2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: TextFormField(
        cursorColor: Colors.white,
        cursorWidth: 4,
        cursorRadius: Radius.circular(10),
        controller: widget.controller,
        textCapitalization: TextCapitalization.none,
        autocorrect: false,
        maxLength: widget.tamanho != null ? widget.tamanho : null,
        style: TextStyle(color: branco, fontSize: 22),
        obscureText: widget.isObscure,
        validator: widget.valid,
        keyboardType: widget.keyboard,
        decoration: InputDecoration(
          errorStyle: TextStyle(color: Colors.white, fontSize: 18),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: branco,width: 1),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: branco,width: 2),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white,width: 1),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white,width: 2),
          ),
          hintText: widget.hint,
          prefixText: widget.hint == "Cell" ? "+258" : null,
          hintStyle: TextStyle(
              color: branco, fontSize: 22, fontWeight: FontWeight.normal),
          prefixIcon: Icon(
            widget.prefix,
            size: 22,
            color: branco,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
      ),
    );
  }
}
