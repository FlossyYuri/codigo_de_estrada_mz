import 'package:codigo_de_estrada_mz/ui/loja/widgets/buy_cs_tile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BuyCS extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const BuyCS({super.key, required this.scaffoldKey});
  @override
  _BuyCSState createState() => _BuyCSState();
}

class _BuyCSState extends State<BuyCS> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // SizedBox(
          //   height: 10,
          // ),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0.0, 4.0),
                  color: Colors.redAccent.withOpacity(.5),
                  blurRadius: 8,
                  spreadRadius: .6,
                ),
              ],
            ),
            child: const Wrap(
              children: <Widget>[
                Center(
                  child: Icon(
                    FontAwesomeIcons.peopleGroup,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  "Este aplicativo é feito para você e é 100% gratuito. Ajude-nos a continuar melhorando, adquirindo qualquer um dos pacotes abaixo via Mpesa!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          BuyCSTile(
            scaffoldKey: widget.scaffoldKey,
            titulo: "Cuppon Essencial",
            valor: 100,
            image: Image.asset(
              "assets/icons/gold1.png",
              height: 50,
            ),
            cor: const Color.fromRGBO(0, 145, 234, 1),
          ),
          BuyCSTile(
            scaffoldKey: widget.scaffoldKey,
            titulo: "Cuppon Standard",
            valor: 200,
            image: Image.asset(
              "assets/icons/gold2.png",
              height: 48,
            ),
            gradient: const LinearGradient(
              colors: [
                Color.fromRGBO(166, 13, 75, 1),
                Color.fromRGBO(235, 18, 107, 1)
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          BuyCSTile(
            scaffoldKey: widget.scaffoldKey,
            titulo: "Cuppon Dexule",
            valor: 500,
            image: Image.asset(
              "assets/icons/gold3.png",
              height: 60,
            ),
            gradient: const LinearGradient(
              colors: [
                Color.fromRGBO(237, 172, 34, 1),
                Color.fromRGBO(237, 217, 13, 1)
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
