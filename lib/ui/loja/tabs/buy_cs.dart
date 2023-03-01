import 'package:codigo_de_estrada_mz/ui/loja/widgets/buy_cs_tile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BuyCS extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  BuyCS({@required this.scaffoldKey});
  @override
  _BuyCSState createState() => _BuyCSState();
}

class _BuyCSState extends State<BuyCS> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // SizedBox(
            //   height: 10,
            // ),
            // Container(
            //   padding: EdgeInsets.all(10),
            //   margin: EdgeInsets.symmetric(
            //     vertical: 10,
            //     horizontal: 20,
            //   ),
            //   alignment: Alignment.center,
            //   child: Wrap(
            //     children: <Widget>[
            //       Icon(
            //         FontAwesomeIcons.percent,
            //         color: Colors.white,
            //         size: 20,
            //       ),
            //       SizedBox(
            //         width: 8,
            //       ),
            //       Text(
            //         "Aproveite o desconto de 50%",
            //         style: TextStyle(
            //           color: Colors.white,
            //           fontSize: 18,
            //         ),
            //       ),
            //       SizedBox(
            //         width: 8,
            //       ),
            //       Icon(
            //         FontAwesomeIcons.percent,
            //         color: Colors.white,
            //         size: 20,
            //       ),
            //     ],
            //   ),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(10),
            //     color: Colors.redAccent,
            //     boxShadow: [
            //       BoxShadow(
            //         offset: const Offset(0.0, 4.0),
            //         color: Colors.redAccent.withOpacity(.5),
            //         blurRadius: 8,
            //         spreadRadius: .6,
            //       ),
            //     ],
            //   ),
            // ),
            BuyCSTile(
              scaffoldKey: widget.scaffoldKey,
              titulo: "Cuppon Essencial",
              valor: 100,
              image: Image.asset(
                "assets/icons/gold1.png",
                height: 50,
              ),
              cor: Color.fromRGBO(0, 145, 234, 1),
            ),
            BuyCSTile(
              scaffoldKey: widget.scaffoldKey,
              titulo: "Cuppon Standard",
              valor: 200,
              image: Image.asset(
                "assets/icons/gold2.png",
                height: 48,
              ),
              gradient: LinearGradient(
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
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(237, 172, 34, 1),
                  Color.fromRGBO(237, 217, 13, 1)
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
