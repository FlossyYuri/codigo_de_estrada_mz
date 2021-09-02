import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:codigo_de_estrada_mz/ui/widgets/card_entity.dart';
import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:codigo_de_estrada_mz/blocs/transacoes_bloc.dart';
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
                FutureBuilder(
                  future: BlocProvider.getBloc<TransacoesBloc>()
                      .verificarTestesIlimitados(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return CardEntity(
                          entidade: snapshot.data ? "Testes ∞" : "Testes",
                          valor: 50,
                          icon: Icons.library_books);
                    } else {
                      return CardEntity(
                          entidade: "Testes",
                          valor: 50,
                          icon: Icons.library_books);
                    }
                  },
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
