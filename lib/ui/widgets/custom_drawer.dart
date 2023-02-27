import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:codigo_de_estrada_mz/blocs/usuario_bloc.dart';
import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:codigo_de_estrada_mz/models/usuario.dart';
import 'package:codigo_de_estrada_mz/ui/home/views/historico_view.dart';
import 'package:codigo_de_estrada_mz/ui/home/views/premium_view.dart';
import 'package:codigo_de_estrada_mz/ui/tutoriais/tutoriais_screen.dart';
import 'package:codigo_de_estrada_mz/ui/widgets/load_all_images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomDrawer extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  CustomDrawer(this.scaffoldKey);
  @override
  Widget build(BuildContext context) {
    bool temFoto = BlocProvider.getBloc<UsuarioBloc>().userData.imgUrl != null;
    return Drawer(
      child: Container(
        padding: const EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          color: darkred,
          boxShadow: [BoxShadow(color: Colors.black45)],
        ),
        width: 300,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                color: darkred,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 16),
                          child: Text(
                            BlocProvider.getBloc<UsuarioBloc>().userData.premium
                                ? "Versão Premium"
                                : "",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                              color: branco,
                            ),
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.all(10),
                          splashColor: mainBG,
                          icon: Icon(
                            Icons.power_settings_new,
                            color: branco,
                            size: 30,
                          ),
                          onPressed: () => exit(0),
                        ),
                      ],
                    ),
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: temFoto
                            ? DecorationImage(
                                image: CachedNetworkImageProvider(
                                  BlocProvider.getBloc<UsuarioBloc>()
                                      .userData
                                      .imgUrl,
                                ),
                              )
                            : null,
                        color: temFoto ? null : Colors.blueGrey,
                      ),
                      child: temFoto
                          ? Image(
                              image: CachedNetworkImageProvider(
                                BlocProvider.getBloc<UsuarioBloc>()
                                    .userData
                                    .imgUrl,
                              ),
                              fit: BoxFit.fill,
                            )
                          : Padding(
                              padding: const EdgeInsets.all(20),
                              child: Icon(
                                FontAwesomeIcons.user,
                                size: 50,
                                color: branco,
                              ),
                            ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: StreamBuilder<Usuario>(
                        stream: BlocProvider.getBloc<UsuarioBloc>().outUsuario,
                        builder: (context, user) {
                          if (user.hasData) {
                            return Text(
                              user.data.username,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: branco,
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.white,
              ),
              Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      BlocProvider.getBloc<UsuarioBloc>().userData.premium
                          ? Container()
                          : _buildButton(
                              "VIRAR PREMIUM", FontAwesomeIcons.rectangleAd,
                              () {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) => GetPremium(),
                                ),
                              );
                            }),
                      BlocProvider.getBloc<UsuarioBloc>().presentes['novo']
                          ? _buildButton(
                              "Resgatar presente",
                              FontAwesomeIcons.gifts,
                              () {
                                Navigator.pop(context);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    // return object of type Dialog
                                    return _giftDialogue(context);
                                  },
                                );
                              },
                            )
                          : Container(),
                      _buildButton(
                        "Historico de testes",
                        FontAwesomeIcons.clockRotateLeft,
                        () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => HistoricoView(),
                            ),
                          );
                        },
                      ),
                      _buildButton("Tutoriais", FontAwesomeIcons.lightbulb, () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                              builder: (context) => TutoriaisScreen()),
                        );
                      }),
                      _buildButton("Testes ofline", FontAwesomeIcons.plug, () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => LoadScreen(),
                          ),
                        );
                      }),
                      _buildButton("Logout", FontAwesomeIcons.rightFromBracket,
                          () {
                        BlocProvider.getBloc<UsuarioBloc>().logout(context);
                      }),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildButton(String text, IconData icon, VoidCallback f) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: f,
        splashColor: Colors.white.withOpacity(.5),
        child: Container(
          height: 45,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 20,
              ),
              Icon(
                icon,
                color: branco,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                text,
                style: TextStyle(fontSize: 20, color: branco),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _giftDialogue(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List<Map<String, dynamic>>.from(
                  BlocProvider.getBloc<UsuarioBloc>().presentes['premios'])
              .map<Widget>((gift) => _giftContainer(context, gift))
              .toList(),
        ),
      ),
    );
  }

  _giftContainer(BuildContext context, Map<String, dynamic> gift) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      decoration: BoxDecoration(
        color: branco,
        borderRadius: BorderRadius.circular(10),
      ),
      height: 330,
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                color: secBG,
                height: 100,
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 50,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Parabens, Recebeu um prensente.",
                      style: TextStyle(
                        fontSize: 18,
                        color: secBG,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      gift['texto'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  TextButton(
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
                      bool premium = await BlocProvider.getBloc<UsuarioBloc>()
                          .coletarPresente(context, gift);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Presente resgatado com sucesso. " +
                                (premium
                                    ? "Reinicie para que reconfigurar a aplicação."
                                    : ""),
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                color: branco),
                          ),
                          backgroundColor: Colors.blueGrey,
                          duration: Duration(seconds: 4),
                        ),
                      );
                      scaffoldKey.currentState.setState(() {});
                    },
                    child: Text(
                      "Coletar",
                      style: TextStyle(
                        color: secBG,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Fechar",
                      style: TextStyle(
                        color: Colors.blueGrey[300],
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: Image.asset(
                'assets/images/gift@2x.png',
                height: 130,
              ),
            ),
          )
        ],
      ),
    );
  }

/*
  _buildButton("Recompensas diárias", FontAwesomeIcons.gifts,
      () {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ), //this right here
            child: Container(
              height: 250,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12.0),
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    _rewardCard(
                        "assets/icons/gold1.png",
                        Color.fromRGBO(195, 55, 100, 1),
                        "1 teste",
                        1),
                    _rewardCard(
                        "assets/icons/gold2.png",
                        Color.fromRGBO(170, 43, 109, 1),
                        "2 teste",
                        2),
                    _rewardCard(
                        "assets/icons/gold1.png",
                        Color.fromRGBO(151, 39, 114, 1),
                        "1 teste",
                        3),
                    _rewardCard(
                        "assets/icons/gold2.png",
                        Color.fromRGBO(118, 38, 118, 1),
                        "2 teste",
                        4),
                    _rewardCard(
                        "assets/icons/gold1.png",
                        Color.fromRGBO(80, 38, 118, 1),
                        "1 teste",
                        5),
                    _rewardCard(
                        "assets/icons/gold2.png",
                        Color.fromRGBO(50, 38, 115, 1),
                        "2 teste",
                        6),
                    _rewardCard(
                        "assets/icons/gold2.png",
                        Color.fromRGBO(29, 38, 113, 1),
                        "2 teste",
                        6),
                  ],
                ),
              ),
            ),
          );
        });
  });
*/

  _rewardCard(String url, Color cor, String recompensa, int dias) {
    return Container(
      height: 180,
      width: 140,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.green),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Align(
            child: Icon(Icons.close, size: 25, color: branco),
            alignment: Alignment.centerRight,
          ),
          Image.asset(
            url,
            height: 75,
            alignment: Alignment.center,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                recompensa,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                dias == 1 ? "1 dia" : "$dias dias",
                style: TextStyle(
                  color: Colors.grey[100],
                  fontSize: 18,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
