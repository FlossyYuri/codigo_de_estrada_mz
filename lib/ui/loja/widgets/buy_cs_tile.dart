import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:codigo_de_estrada_mz/ui/loja/widgets/purchase_box.dart';
import 'package:flutter/material.dart';

const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

class BuyCSTile extends StatelessWidget {
  final String titulo;
  final int valor;
  final Color cor;
  final LinearGradient gradient;
  final Widget image;
  final GlobalKey<ScaffoldState> scaffoldKey;

  BuyCSTile({
    @required this.titulo,
    @required this.valor,
    @required this.scaffoldKey,
    this.cor,
    this.gradient,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: cor != null ? cor : null,
        gradient: gradient != null ? gradient : null,
        borderRadius: BorderRadius.circular(10),
      ),
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => PurchaseBox(
              cs: valor,
              cor: cor,
              gradient: gradient,
              scaffoldKey: scaffoldKey,
            ),
          );
        },
        splashColor: preto,
        focusColor: transparente,
        child: Container(
          child: ListTile(
            trailing: image,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  children: <Widget>[
                    Text(
                      valor.toString() + " CS",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    // SizedBox(
                    //   width: 8,
                    // ),
                    // Container(
                    //   margin: EdgeInsets.only(bottom: 5),
                    //   child: Text(
                    //     valor.toString() + " CS",
                    //     style: TextStyle(
                    //       fontSize: 18,
                    //       color: Colors.white,
                    //       fontWeight: FontWeight.w400,
                    //       decoration: TextDecoration.lineThrough,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                Text(
                  "Custo: $valor MZN",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  titulo,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
