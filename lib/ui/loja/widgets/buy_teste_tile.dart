import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:codigo_de_estrada_mz/blocs/transacoes_bloc.dart';
import 'package:flutter/material.dart';

class BuyTesteTile extends StatelessWidget {
  final int teste;
  final int cs;
  final Color fundo;
  BuyTesteTile({@required this.fundo, @required this.cs, @required this.teste});
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onPressed: () {
        BuildContext ctx = context;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: Text("Comprar testes"),
              content: Text("Confirme a compra de $teste testes por $cs CS?"),
              backgroundColor: secBG,
              titleTextStyle: TextStyle(color: branco, fontSize: 18),
              contentTextStyle: TextStyle(color: branco, fontSize: 16),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                TextButton(
                  child: Text(
                    "Confirmar",
                    style: TextStyle(color: lightred, fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    BlocProvider.getBloc<TransacoesBloc>()
                        .comprarTestes(teste, cs, ctx);
                  },
                ),
                TextButton(
                  child: Text(
                    "cancelar",
                    style: TextStyle(color: branco, fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      color: fundo,
      splashColor: preto,
      child: ListTile(
        contentPadding: EdgeInsets.all(5),
        title: SizedBox(
          height: 60,
        ),
        leading: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "ganhe",
              style: TextStyle(
                  color: branco, fontSize: 18, fontWeight: FontWeight.w300),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "$teste Testes",
              style: TextStyle(
                color: branco,
                fontSize: 24,
              ),
            ),
          ],
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              "por",
              style: TextStyle(
                  color: branco, fontSize: 18, fontWeight: FontWeight.w300),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "$cs CS",
              style: TextStyle(
                color: branco,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
