import 'dart:io';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:codigo_de_estrada_mz/data/usuario_api.dart';
import 'package:codigo_de_estrada_mz/blocs/usuario_bloc.dart';
import 'package:codigo_de_estrada_mz/blocs/transacoes_bloc.dart';
import 'package:codigo_de_estrada_mz/ui/loja/widgets/gplay_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PurchaseBox extends StatefulWidget {
  final int cs;
  final Color cor;
  final LinearGradient gradient;
  final GlobalKey<ScaffoldState> scaffoldKey;
  PurchaseBox({
    @required this.cs,
    @required this.cor,
    @required this.gradient,
    @required this.scaffoldKey,
  });

  @override
  _PurchaseBoxState createState() => _PurchaseBoxState();
}

class _PurchaseBoxState extends State<PurchaseBox> {
  final _cellController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(widget.scaffoldKey),
    );
  }

  dialogContent(GlobalKey<ScaffoldState> scaffoldKey) {
    String icon = "gold1";
    BoxDecoration d;
    int item = 1;
    switch (widget.cs) {
      case 100:
        d = BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blueAccent,
        );
        icon = "gold1";
        item = 0;
        break;
      case 200:
        d = BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Color.fromRGBO(235, 18, 107, 1),
              Color.fromRGBO(166, 13, 75, 1),
            ],
          ),
        );
        icon = "gold2";
        item = 1;
        break;
      case 400:
        d = BoxDecoration(
          shape: BoxShape.circle,
          color: lightgreen,
        );
        icon = "cde-white";
        item = 3;
        break;
      case 500:
        d = BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Color.fromRGBO(237, 217, 13, 1),
              Color.fromRGBO(237, 172, 34, 1),
            ],
          ),
        );
        icon = "gold3";
        item = 2;
        break;
    }
    _cellController.text = BlocProvider.getBloc<UsuarioBloc>().userData.cell;
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
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: branco,
                    border: Border.all(color: Colors.blueGrey[100], width: 1),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 5,
                        color: Colors.black.withOpacity(.1),
                        offset: Offset(0, 0),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(.2),
                        blurRadius: 5,
                        offset: Offset(2.0, 4.0),
                      ),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          "assets/images/mpesa.png",
                          height: 50,
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 0,
                        ),
                        child: TextFormField(
                          cursorColor: Colors.black,
                          cursorWidth: 4,
                          cursorRadius: Radius.circular(10),
                          controller: _cellController,
                          textCapitalization: TextCapitalization.none,
                          autocorrect: false,
                          maxLength: 9,
                          style: TextStyle(color: preto, fontSize: 22),
                          validator: (String text) {
                            if (text.length != 9) {
                              return "Deve conter 9 digitos";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                            ),
                            hintText: "84XXXXXXX",
                            hintStyle: TextStyle(
                                color: preto,
                                fontSize: 18,
                                fontWeight: FontWeight.normal),
                            prefixIcon: Icon(
                              Icons.phone,
                              size: 18,
                              color: Colors.red,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 20),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Container(
                                  height: 200,
                                  width: 200,
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          height: 60,
                                          width: 60,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 5,
                                            valueColor: AlwaysStoppedAnimation(
                                              mainBG,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text("Loading"),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                          payMPESA(
                            int.parse(_cellController.text),
                            widget.cs,
                            BlocProvider.getBloc<UsuarioBloc>()
                                .userData
                                .username,
                          ).then(
                            (http.Response response) {
                              Navigator.pop(scaffoldKey.currentContext);
                              Navigator.pop(scaffoldKey.currentContext);
                              switch (response.statusCode) {
                                case 200:
                                case 201:
                                  switch (widget.cs) {
                                    case 100:
                                      BlocProvider.getBloc<TransacoesBloc>()
                                          .comprarCS(
                                              100, scaffoldKey.currentContext);
                                      break;
                                    case 200:
                                      BlocProvider.getBloc<TransacoesBloc>()
                                          .comprarCS(
                                              200, scaffoldKey.currentContext);
                                      break;
                                    case 400:
                                      BlocProvider.getBloc<TransacoesBloc>()
                                          .virarPremium(
                                              scaffoldKey.currentContext);
                                      break;
                                    case 500:
                                      BlocProvider.getBloc<TransacoesBloc>()
                                          .comprarCS(
                                              500, scaffoldKey.currentContext);
                                      break;
                                  }
                                  setState(() {
                                    if (widget.cs == 400) {
                                      _showToast(
                                          "Parabéns, Versão Premium assinada com sucesso.\n A aplicação precisa ser reiniciada para configurar a versão premium. Ira fechar em 4 segundos.",
                                          true,
                                          scaffoldKey);
                                      Future.delayed(Duration(seconds: 5))
                                          .then((value) {
                                        exit(0);
                                      });
                                    } else {
                                      _showToast(
                                          'Pagamento realizado com sucesso.',
                                          true,
                                          scaffoldKey);
                                    }
                                  });
                                  break;
                                case 401:
                                  _showToast(
                                      "Opps, a transação falhou, provavelmente foi cancelada. Nenhum valor foi cobrado.",
                                      false,
                                      scaffoldKey);
                                  break;
                                case 408:
                                case 503:
                                  _showToast(
                                      "Opps, passou tempo demais, a processo expirou.",
                                      false,
                                      scaffoldKey);
                                  break;
                                case 409:
                                  _showToast(
                                      "Opps, Transação duplicada. Tente novamente outra hora.",
                                      false,
                                      scaffoldKey);
                                  break;
                                case 422:
                                  _showToast(
                                      "Opps, Saldo insuficiente. Recarregue a sua conta.",
                                      false,
                                      scaffoldKey);
                                  break;
                                default:
                                  _showToast(
                                      "Ocorreu algum erro. Nenhum valor foi cobrado, tente novamente.",
                                      false,
                                      scaffoldKey);
                              }
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          child: Text(
                            "Comprar",
                            style: TextStyle(
                              color: branco,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GPLAYCard(
                  item: item,
                )
              ],
            ),
          ),
        ),
        Positioned(
          left: Consts.padding,
          right: Consts.padding,
          child: Container(
            height: 120,
            decoration: d,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/icons/$icon.png",
                  width: 60,
                ),
                Text(
                  "${widget.cs} MZN",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

_showToast(String text, bool success, GlobalKey<ScaffoldState> scaffoldKey) {
  ScaffoldMessenger.of(scaffoldKey.currentContext).showSnackBar(SnackBar(
    content: Text(
      text,
      style:
          TextStyle(fontSize: 18, fontWeight: FontWeight.w300, color: branco),
    ),
    backgroundColor: success ? Colors.greenAccent : Colors.redAccent,
    duration: Duration(seconds: 4),
  ));
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 56.0;
}
