import 'dart:io';

import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class CSDialogue extends StatefulWidget {
  final int cs;
  final Color cor;
  final LinearGradient gradient;

  CSDialogue({
    @required this.cs,
    @required this.cor,
    @required this.gradient,
  });

  @override
  _CSDialogueState createState() => _CSDialogueState();
}

class _CSDialogueState extends State<CSDialogue> {
  final _codTransacao = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    String codigoTransacao, numero;
    double valor;
    int icon = 1;
    switch (widget.cs) {
      case 100:
        icon = 1;
        break;
      case 200:
        icon = 2;
        break;
      case 500:
        icon = 3;
        break;
    }
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: Consts.avatarRadius + Consts.padding,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          margin: EdgeInsets.only(top: Consts.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Consts.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), color: mainBG),
                  child: Material(
                    color: transparente,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      splashColor: preto,
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(text: "840521586"),
                        );
                        Fluttertoast.showToast(
                          msg: "840521586 copiado!",
                          textColor: branco,
                          backgroundColor: Colors.blueGrey,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 2,
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        margin: const EdgeInsets.all(0),
                        color: transparente,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "conta mpesa:",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: branco,
                                    fontWeight: FontWeight.w300),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Numero: 840521586",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: branco,
                                    fontWeight: FontWeight.w300),
                              ),
                              Text(
                                "Nome: Emerson Cuambe",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: branco,
                                    fontWeight: FontWeight.w300),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  child: Text(
                                    "clique para copiar o numero",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: branco,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    backgroundColor: mainBG.withOpacity(0.8),
                  ),
                  onPressed: () {
                    launchUrl(Uri.parse("tel:*150%23"));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    child: Text(
                      "Abrir Mpesa",
                      style: TextStyle(
                          fontSize: 20,
                          color: branco,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 1),
                    ),
                  ),
                ),
                Card(
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          width: 0.4, color: mainBG.withOpacity(0.2))),
                  elevation: 0,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Enviar Mensagem de Confirmacao",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              backgroundColor: Colors.blueGrey,
                            ),
                            onPressed: () async {
                              ClipboardData cb =
                                  await Clipboard.getData('text/plain');
                              if (cb.text.contains("Transferiste")) {
                                for (String texto in cb.text.split(". ")) {
                                  if (texto.contains("Confirmado")) {
                                    for (String texto in texto.split(" ")) {
                                      if (texto.length >= 11 &&
                                          !texto.contains(" ")) {
                                        codigoTransacao = texto.trim();
                                      }
                                    }
                                  }
                                  if (texto.contains("Transferiste")) {
                                    for (String texto in texto.split(" ")) {
                                      if (texto.contains("MT")) {
                                        valor = double.parse(
                                            texto.replaceFirst("MT", ""));
                                      }
                                      if (texto.contains("258")) {
                                        numero = texto.trim();
                                      }
                                    }
                                    for (String texto in texto.split(" - ")) {
                                      if (texto.contains(" aos")) {
                                        // nome = texto
                                        //     .substring(0, texto.indexOf(" aos"))
                                        //     .trim();
                                      }
                                    }
                                  }
                                }
                                if (numero.contains("84") &&
                                    codigoTransacao.length > 10)
                                  _codTransacao.text = codigoTransacao;
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 45,
                              width: 200,
                              child: Text(
                                "copie a mensagem de\nconfirmacao e clique aqui",
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: branco,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: _codTransacao,
                            style: TextStyle(color: mainBG),
                            cursorColor: mainBG,
                            validator: (text) {
                              if (text.length < 10) {
                                return "codigo com formato errado";
                              }
                              if (valor < 100) {
                                return "valor enviado insuficiente";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: "Codigo de transacao",
                              labelStyle: TextStyle(color: Colors.blueGrey),
                              disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: Colors.blueGrey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(width: 2, color: mainBG),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: TextButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                if (codigoTransacao != null)
                                  await enviarMensagem(codigoTransacao, valor);
                                else
                                  Fluttertoast.showToast(
                                    msg: "Dados incorectos",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                  );
                              }
                            },
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              backgroundColor: mainBG.withOpacity(0.8),
                            ),
                            child: Container(
                              height: 40,
                              width: 100,
                              alignment: Alignment.center,
                              child: Text(
                                "Enviar",
                                style: TextStyle(
                                  color: branco,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
        Positioned(
            left: Consts.padding,
            right: Consts.padding,
            child: Container(
              height: 120,
              decoration: widget.cs == 100
                  ? BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blueAccent,
                    )
                  : BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: widget.cs == 200
                          ? RadialGradient(
                              colors: [
                                Color.fromRGBO(235, 18, 107, 1),
                                Color.fromRGBO(166, 13, 75, 1),
                              ],
                            )
                          : RadialGradient(
                              colors: [
                                Color.fromRGBO(237, 217, 13, 1),
                                Color.fromRGBO(237, 172, 34, 1),
                              ],
                            ),
                    ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "assets/icons/gold$icon.png",
                    width: 60,
                  ),
                  Text(
                    "${widget.cs} MZN",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            )),
      ],
    );
  }

  enviarMensagem(String cod, double val) async {
    String texto = 'code:$cod. value:$val. cs:${widget.cs}.';
    if (Platform.isAndroid) {
      await launchUrl(Uri.parse('sms:+25884052158?body=$texto'));
    }
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 56.0;
}
