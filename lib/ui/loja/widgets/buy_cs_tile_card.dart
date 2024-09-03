import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:flutter/material.dart';

const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

class BuyCSTileDollar extends StatelessWidget {
  final String titulo;
  final int valor;
  final Color cor;
  final LinearGradient gradient;
  final Widget image;
  final VoidCallback f;
  const BuyCSTileDollar(
      {super.key,
      required this.titulo,
      required this.valor,
      required this.f,
      required this.cor,
      required this.gradient,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      decoration: BoxDecoration(
        color: cor,
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: f,
        splashColor: preto,
        focusColor: transparente,
        child: ListTile(
          trailing: image,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "$valor CS",
                style: const TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),
              Text(
                "Custo: $valor MT",
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                titulo,
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
