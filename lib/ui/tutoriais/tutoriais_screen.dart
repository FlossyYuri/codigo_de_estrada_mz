import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:codigo_de_estrada_mz/ui/tutoriais/ganhar_testes.dart';
import 'package:codigo_de_estrada_mz/ui/tutoriais/usar_cupom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TutoriaisScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainBG,
        title: Text("Tutoriais",
            style: TextStyle(
                color: branco,
                fontSize: 24,
                letterSpacing: 2,
                fontWeight: FontWeight.w300)),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // SizedBox(
              //   height: 30,
              // ),
              // _buildRaised("Como jogar", () {
              //   Navigator.push(
              //     context,
              //     CupertinoPageRoute(
              //       builder: (context) => TutorialComoJogar(),
              //     ),
              //   );
              // }),
              // SizedBox(
              //   height: 20,
              // ),
              // _buildRaised("Como comprar cs", () {
              //   Navigator.push(
              //     context,
              //     CupertinoPageRoute(
              //       builder: (context) => TutorialComprarCS(),
              //     ),
              //   );
              // }),
              // SizedBox(
              //   height: 20,
              // ),
              _buildRaised("Como ganhar testes", () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => TutorialGanharTestes(),
                  ),
                );
              }),
              SizedBox(
                height: 20,
              ),
              _buildRaised("Como usar cupom", () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => TutorialUsarCupom(),
                  ),
                );
              }),
              SizedBox(
                height: 20,
              ),
            ],
          )),
    );
  }

  Widget _buildRaised(String text, VoidCallback f) {
    return ElevatedButton(
      onPressed: f,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
        primary: branco,
      ),
      child: Container(
        alignment: Alignment.center,
        height: 60,
        child: Text(text,
            style: TextStyle(
              color: mainBG,
              fontWeight: FontWeight.w300,
              fontSize: 24,
            )),
      ),
    );
  }
}
