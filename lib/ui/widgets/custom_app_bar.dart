import 'package:codigo_de_estrada/ui/widgets/card_entity.dart';
import 'package:codigo_de_estrada/constantes.dart';
import 'package:flutter/material.dart';

class CustomSliverAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: mainBG,
      floating: true,
      leading: SizedBox(),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CardEntity(
                  entidade: "Testes ∞",
                  valor: 50,
                  icon: Icons.library_books,
                ),
                CardEntity(
                    entidade: "CS", valor: 100, icon: Icons.attach_money),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
