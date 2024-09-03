import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:codigo_de_estrada_mz/blocs/transacoes_bloc.dart';
import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:codigo_de_estrada_mz/ui/loja/widgets/buy_teste_tile.dart';
import 'package:flutter/material.dart';

class BuyTeste extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateTime data = DateTime.now();

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            (data.month == 12 && data.day >= 8 && data.day <= 31)
                ? Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  title: Text(
                                    "Promoção do Natal",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: mainBG,
                                    ),
                                  ),
                                  content: Text(
                                    "Compre 200CS e ganhe 10 testes extras.\n"
                                    "Compre 500CS e ganhe 100cs + 15 testes.\n"
                                    "Aproveite agora as promoção na época festiva.",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: preto,
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text(
                                        "fechar".toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 22,
                                            color: mainBG,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.redAccent,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              "Ver Promoções".toUpperCase(),
                              style: TextStyle(
                                fontSize: 24,
                                color: branco,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  )
                : Container(),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
            BuyTesteTile(
              cs: 20,
              teste: 2,
              fundo: Color.fromRGBO(49, 222, 149, 1),
            ),
            SizedBox(
              height: 10,
            ),
            BuyTesteTile(
              cs: 100,
              teste: 10,
              fundo: Color.fromRGBO(49, 159, 222, 1),
            ),
            SizedBox(
              height: 10,
            ),
            BuyTesteTile(
              cs: 200,
              teste: 25,
              fundo: Color.fromRGBO(199, 16, 65, 1),
            ),
            SizedBox(
              height: 10,
            ),
            BuyTesteTile(
              cs: 500,
              teste: 65,
              fundo: Color.fromRGBO(237, 201, 19, 1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _testesInfinitos(BuildContext context, bool premium) {
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
              content: Text("Confirme a compra do pacote de testes (12h)?"),
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
                        .comprarTestes(-1, premium ? 100 : 150, ctx);
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
      color: Color.fromRGBO(30, 30, 30, 1),
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
              "ganhe testes infinitos",
              style: TextStyle(
                  color: branco, fontSize: 18, fontWeight: FontWeight.w300),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Por 12h",
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
              premium ? "100 CS" : "150 CS",
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
