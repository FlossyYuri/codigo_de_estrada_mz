import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:codigo_de_estrada_mz/ui/home/views/home_view.dart';
import 'package:codigo_de_estrada_mz/ui/loja/loja_screen.dart';
import 'package:codigo_de_estrada_mz/ui/widgets/custom_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
          ],
        ),
        label: "Menu",
      ),
      BottomNavigationBarItem(
        icon: Icon(
          FontAwesomeIcons.bagShopping,
          color: branco,
        ),
        label: "Ofertas",
      ),
    ];

    return Scaffold(
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
          }
        },
        unselectedItemColor: branco,
        selectedItemColor: branco,
        items: itens,
      ),
    );
  }
}
