import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:codigo_de_estrada_mz/ui/loja/tabs/buy_cs.dart';
import 'package:codigo_de_estrada_mz/ui/loja/tabs/buy_teste.dart';
import 'package:codigo_de_estrada_mz/ui/loja/tabs/usar_cupom.dart';
import 'package:codigo_de_estrada_mz/ui/widgets/card_entity.dart';
import 'package:flutter/material.dart';

class LojaScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "LOJA",
                  style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 5,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.shop,
                  size: 24,
                )
              ],
            ),
          ),
          backgroundColor: mainBG,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(200.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CardEntity(
                        entidade: "Testes",
                        valor: 50,
                        icon: Icons.library_books),
                    CardEntity(
                        entidade: "CS", valor: 100, icon: Icons.attach_money),
                  ],
                ),
                Container(
                  color: mainBG,
                  child: TabBar(
                    indicatorColor: branco,
                    tabs: [
                      Tab(text: "CS", icon: Icon(Icons.attach_money)),
                      Tab(text: "Testes", icon: Icon(Icons.library_books)),
                      Tab(text: "Usar Cuppon", icon: Icon(Icons.card_giftcard)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            BuyCS(
              scaffoldKey: _scaffoldKey,
            ),
            BuyTeste(),
            UsarCupom(),
          ],
        ),
      ),
    );
  }
}
