import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:codigo_de_estrada_mz/blocs/transacoes_bloc.dart';
import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UsarCupom extends StatefulWidget {
  @override
  _UsarCupomState createState() => _UsarCupomState();
}

class _UsarCupomState extends State<UsarCupom> {
  final _codigoController = TextEditingController();
  final Color corPrincipal = darkblue;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Text(
                      "Copie o texto do recibo e",
                      style: TextStyle(
                          fontSize: 18,
                          color: preto,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 1),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          backgroundColor: corPrincipal),
                      onPressed: () {
                        buscarCodigo();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 30,
                        width: 150,
                        child: Text(
                          "Clique aqui",
                          style: TextStyle(
                              fontSize: 18,
                              color: branco,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 1),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            height: 1,
                            color: corPrincipal,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Text(
                            "ou",
                            style: TextStyle(
                                fontSize: 24, color: preto.withOpacity(0.5)),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            height: 1,
                            color: corPrincipal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  validator: (text) {
                    if (text.length != 12) {
                      return "Codigo incompleto! O codigo deve ter 12 digitos";
                    }
                    return null;
                  },
                  controller: _codigoController,
                  keyboardType: TextInputType.text,
                  cursorColor: corPrincipal,
                  style: TextStyle(
                      color: corPrincipal,
                      fontSize: 22,
                      letterSpacing: 4,
                      fontWeight: FontWeight.bold),
                  maxLength: 12,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: corPrincipal),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(10)),
                    labelText: "Codigo do cupom",
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.redAccent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      color: corPrincipal,
                      letterSpacing: 2,
                    ),
                    focusColor: corPrincipal,
                    prefixIcon: Icon(
                      Icons.card_giftcard,
                      color: corPrincipal,
                      size: 22,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: corPrincipal),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    print("xs");
                    BlocProvider.getBloc<TransacoesBloc>()
                        .usarCupom(context, _codigoController.text);
                  }
                },
                child: Container(
                  height: 60,
                  alignment: Alignment.center,
                  child: Text(
                    "Usar cupom",
                    style: TextStyle(fontSize: 24, color: branco),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  buscarCodigo() async {
    ClipboardData cb = await Clipboard.getData('text/plain');
    if (cb.text.contains("Estrada - MZ.")) {
      for (String texto in cb.text.split(".")) {
        if (texto.contains("Código do cupom: ")) {
          _codigoController.text =
              texto.substring(texto.indexOf('"') + 1, texto.lastIndexOf('"'));
        }
      }
    } else {
      Fluttertoast.showToast(
        msg: "Dados incorectos",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
    }
  }
}
