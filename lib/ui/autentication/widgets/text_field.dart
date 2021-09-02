import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final bool isObscure;
  final IconData prefix;
  final bool asSufix;
  final TextInputType keyboard;
  CustomTextField(
      {@required this.asSufix,
      @required this.hint,
      @required this.isObscure,
      @required this.prefix,
      @required this.keyboard});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 20),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      child: TextField(
        cursorColor: preto,
        style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            letterSpacing: 2,
            fontWeight: FontWeight.w300),
        keyboardType: keyboard,
        obscureText: isObscure,
        decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.black26, fontSize: 24),
            prefixIcon: Icon(
              prefix,
              color: Colors.black26,
            ),
            suffixIcon: asSufix
                ? Icon(
                    Icons.check_circle,
                    color: Colors.black26,
                  )
                : null,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide.none)),
      ),
    );
  }
}
