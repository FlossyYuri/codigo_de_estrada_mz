import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:codigo_de_estrada_mz/ui/widgets/load_all_images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SobreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainBG,
        title: Text("Sobre a app",
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
              SizedBox(
                height: 10,
              ),
              _buildRaised("Carregar todas imagens", () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => LoadScreen(),
                  ),
                );
              }),
              SizedBox(
                height: 20,
              ),
              _buildRaised("Politicas de privacidade", () {
                launchUrl(Uri.parse(politicasDePrivacidade));
              }),
              SizedBox(
                height: 20,
              ),
              _buildRaised("Contacto", () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    // return object of type Dialog
                    return AlertDialog(
                      title: Text("Contactos"),
                      content: Text(
                          "Caso queira nos contactar envie um email para \"emerson.yur@gmail.com\" ou uma sms para 840521586."
                          "\nClique no botao email ou sms."),
                      backgroundColor: secBG,
                      titleTextStyle: TextStyle(color: branco, fontSize: 18),
                      contentTextStyle: TextStyle(color: branco, fontSize: 16),
                      actions: <Widget>[
                        // usually buttons at the bottom of the dialog
                        TextButton(
                          child: Text(
                            "Email",
                            style: TextStyle(color: lightred, fontSize: 16),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            launchUrl(
                                Uri.parse("mailto:emerson.yur@gmail.com"));
                          },
                        ),
                        TextButton(
                          child: Text(
                            "sms",
                            style: TextStyle(color: lightred, fontSize: 16),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            launchUrl(Uri.parse("sms:+258840521586"));
                          },
                        ),
                        TextButton(
                          child: Text(
                            "cancelar",
                            style: TextStyle(color: branco, fontSize: 16),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }),
              SizedBox(
                height: 20,
              ),
              Text(
                'Contacte nos para qualquer feedback que deseja dar ou caso queira expor alguma inquietação.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 20, color: secBG),
              )
            ],
          )),
    );
  }

  Widget _buildRaised(String text, VoidCallback f) {
    return ElevatedButton(
      onPressed: f,
      style: ElevatedButton.styleFrom(
        backgroundColor: branco,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Container(
        alignment: Alignment.center,
        height: 60,
        child: Text(
          text,
          style: TextStyle(
            color: mainBG,
            fontWeight: FontWeight.w300,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
