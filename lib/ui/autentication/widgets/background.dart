import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromRGBO(195, 55, 100, 1),
          Color.fromRGBO(29, 38, 113, 1)
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)));
  }
}
