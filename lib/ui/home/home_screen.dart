import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:codigo_de_estrada_mz/blocs/usuario_bloc.dart';
import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:codigo_de_estrada_mz/ui/home/views/home_view.dart';
import 'package:codigo_de_estrada_mz/ui/home/views/premium_view.dart';
import 'package:codigo_de_estrada_mz/ui/loja/loja_screen.dart';
import 'package:codigo_de_estrada_mz/ui/widgets/custom_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info/package_info.dart';

class HomeScreen extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final Color branco = Colors.white;
  final Color preto = Colors.black;
  // background-image: linear-gradient( 114.9deg,  rgba(34,34,34,1) 8.3%, rgba(0,40,60,1) 41.6%, rgba(0,143,213,1) 93.4% );
  final LinearGradient mainGrad = LinearGradient(colors: [
    Color.fromRGBO(84, 13, 110, 1),
    Color.fromRGBO(238, 66, 102, 1),
  ], begin: Alignment.topCenter, end: Alignment.bottomCenter);
  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> itens = [
      BottomNavigationBarItem(
        icon: Stack(
          children: <Widget>[
            Icon(
              FontAwesomeIcons.user,
              color: branco,
            ),
            FutureBuilder(
              future: BlocProvider.getBloc<UsuarioBloc>().getPresentes(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (BlocProvider.getBloc<UsuarioBloc>().presentes['novo'])
                    return Positioned(
                      right: 0,
                      top: 0,
                      child: Icon(
                        FontAwesomeIcons.gift,
                        color: Colors.amber,
                        size: 15,
                      ),
                    );
                }
                return Positioned(
                  right: 0,
                  top: 0,
                  child: Icon(
                    FontAwesomeIcons.gift,
                    color: Colors.amber,
                    size: 0,
                  ),
                );
              },
            )
          ],
        ),
        label: "Menu",
      ),
      BottomNavigationBarItem(
        icon: Icon(
          FontAwesomeIcons.shoppingBag,
          color: branco,
        ),
        label: "Loja",
      ),
    ];
    if (!BlocProvider.getBloc<UsuarioBloc>().userData.premium)
      itens.add(
        BottomNavigationBarItem(
          icon: Icon(
            FontAwesomeIcons.ad,
            color: branco,
          ),
          label: "Virar Premium",
        ),
      );
    return WillPopScope(
      onWillPop: () => _requestPop(context),
      child: Scaffold(
        key: _scaffoldKey,
        body: Container(
          decoration: BoxDecoration(color: mainBG),
          child: Stack(
            children: <Widget>[
              HomeView(),
            ],
          ),
        ),
        drawer: CustomDrawer(_scaffoldKey),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: secBG,
          onTap: (index) {
            switch (index) {
              case 0:
                _scaffoldKey.currentState.openDrawer();
                break;
              case 1:
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => LojaScreen(),
                  ),
                );
                break;
              case 2:
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => GetPremium(),
                  ),
                );
                break;
            }
          },
          unselectedItemColor: branco,
          selectedItemColor: branco,
          items: itens,
        ),
      ),
    );
  }

  Future<bool> _requestPop(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Deseja sair?"),
          content: Text("Deseja fechar a aplicação?"),
          actions: <Widget>[
            TextButton(
              child: Text("Não"),
              onPressed: () {
                Navigator.pop(context);
                PackageInfo.fromPlatform().then((PackageInfo packageInfo) {});
              },
            ),
            TextButton(
              child: Text("Sim"),
              onPressed: () {
                exit(0);
              },
            ),
          ],
        );
      },
    );
    return Future.value(false);
  }
}
