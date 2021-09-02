import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:codigo_de_estrada_mz/helpers/conexao.dart';
import 'package:codigo_de_estrada_mz/ui/widgets/divider_titled_row.dart';
import 'package:flutter/material.dart';

class RemoverAnunciosCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DividerTitledRow(
          text: "Remover anuncios",
          lineColor: Colors.blueGrey,
          textColor: Colors.blueGrey,
        ),
        Stack(children: <Widget>[
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(241, 39, 17, 1),
                    Color.fromRGBO(245, 175, 25, 1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                children: <Widget>[
                  Align(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white),
                      child: Text(
                        "Remover anúncios",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    alignment: Alignment.topRight,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          "Remova os anúncios que aparecem na aplicação para sempre e tenha uma experiência muito melhor.",
                          style: TextStyle(
                            fontSize: 18,
                            color: branco,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Nota: Apenas a funcionalidade de ganhar testes assistindo anúncios sera mantida.",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[100],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (await checkConnection())
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text(
                                    "Remover anúncios",
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  content: Text(
                                    "Confirme o pagamento de 200 CS para remoção de anúncios no aplicativo.",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        // if (await BlocProvider.getBloc<TransacoesBloc>(
                                        //         context)
                                        //     .removerAnuncios(context))
                                        //   Fluttertoast.showToast(
                                        //     msg: "Anúncios removidos com sucesso",
                                        //     textColor: branco,
                                        //     backgroundColor: Colors.blueGrey,
                                        //     toastLength: Toast.LENGTH_SHORT,
                                        //     gravity: ToastGravity.BOTTOM,
                                        //     timeInSecForIos: 2,
                                        //   );
                                        // else
                                        //   Fluttertoast.showToast(
                                        //     msg: "Não tem CS suficientes!!",
                                        //     textColor: branco,
                                        //     backgroundColor: Colors.blueGrey,
                                        //     toastLength: Toast.LENGTH_SHORT,
                                        //     gravity: ToastGravity.BOTTOM,
                                        //     timeInSecForIos: 2,
                                        //   );
                                      },
                                      child: Text(
                                        "Confirmar",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.blueGrey,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Cancelar",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.blueGrey,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            else
                              showSnackBar(
                                context,
                                "Nao está conectado a internet",
                                Colors.blueAccent,
                              );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: branco,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            height: 50,
                            child: Text(
                              "200 CS",
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ],
    );
  }
}
