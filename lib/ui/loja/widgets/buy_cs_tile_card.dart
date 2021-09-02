import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/modules.dart';

const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

class BuyCSTileDollar extends StatelessWidget {
  final IAPItem item;
  final String titulo;
  final int valor;
  final Color cor;
  final LinearGradient gradient;
  final Widget image;
  final VoidCallback f;
  BuyCSTileDollar(
      {@required this.titulo,
      @required this.item,
      @required this.valor,
      @required this.f,
      this.cor,
      this.gradient,
      this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      decoration: BoxDecoration(
        color: cor != null ? cor : null,
        gradient: gradient != null ? gradient : null,
        borderRadius: BorderRadius.circular(20),
      ),
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: f,
        splashColor: preto,
        focusColor: transparente,
        child: Container(
          child: ListTile(
            trailing: image,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  valor.toString() + " CS",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  "Custo: ${double.parse(item.price).toStringAsPrecision(2)}${item.currency}",
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
