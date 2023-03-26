import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:codigo_de_estrada_mz/blocs/in_game_bloc.dart';
import 'package:codigo_de_estrada_mz/blocs/questao_bloc.dart';
import 'package:codigo_de_estrada_mz/blocs/transacoes_bloc.dart';
import 'package:codigo_de_estrada_mz/blocs/usuario_bloc.dart';
import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:codigo_de_estrada_mz/helpers/conexao.dart';
import 'package:codigo_de_estrada_mz/models/resultados.dart';
import 'package:codigo_de_estrada_mz/ui/game/game_view.dart';
import 'package:codigo_de_estrada_mz/ui/widgets/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResultadosView extends StatefulWidget {
  @override
  _ResultadosViewState createState() => _ResultadosViewState();
}

class _ResultadosViewState extends State<ResultadosView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool conexao = true;
  bool resolucao = false;
  @override
  void initState() {
    super.initState();
    checkConnection().then((conexao) {
      this.conexao = conexao;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (BlocProvider.getBloc<InGameBloc>().salvarHistorico) {
      BlocProvider.getBloc<InGameBloc>().calcularResultados();
      BlocProvider.getBloc<QuestaoBloc>().lerHistorico();
    }

    Resultados result = BlocProvider.getBloc<InGameBloc>().resultados;

    if (resolucao == false)
      Future.delayed(
        Duration(seconds: 1),
      ).then((v) {
        BuildContext ctx = context;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: Text("Ver resolução?"),
              content: Text("Deseja ver a resolução do teste?"),
              backgroundColor: secBG,
              titleTextStyle: TextStyle(color: branco, fontSize: 18),
              contentTextStyle: TextStyle(color: branco, fontSize: 16),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                TextButton(
                  child: Text(
                    "Sim",
                    style: TextStyle(color: lightred, fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();

                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => GamePage(
                          gameMode: "resolucao",
                          teste: BlocProvider.getBloc<InGameBloc>().teste,
                        ),
                      ),
                    );
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
        resolucao = true;
      });

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(color: mainBG),
        child: CustomScrollView(
          slivers: <Widget>[
            CustomSliverAppBar(),
            SliverPadding(
              padding: pagePadding,
              sliver: SliverToBoxAdapter(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 16),
                          leading: CircularProgressIndicator(
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation(mainBG),
                            value: result.valorClassif,
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Classificação",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w300),
                              ),
                              Text(
                                result.classificacao,
                                style: TextStyle(
                                    color: mainBG,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          trailing: MaterialButton(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(
                                width: 1.5,
                                color: lightBG,
                              ),
                            ),
                            onPressed: () async {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) => GamePage(
                                    gameMode: "resolucao",
                                    teste: BlocProvider.getBloc<InGameBloc>()
                                        .teste,
                                  ),
                                ),
                              );
                            },
                            elevation: 11,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Ver resolução",
                                  style: TextStyle(
                                    color: lightBG,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      _buildResultCard(
                        title: "Tema",
                        trailing: BlocProvider.getBloc<InGameBloc>()
                            .teste
                            .nome
                            .substring(0),
                      ),
                      _buildResultCard(
                        title: "Acertos",
                        trailing:
                            "${result.acertos}/${result.teste.questoes.length}",
                      ),
                      _buildResultCard(
                        title: "Erros",
                        trailing:
                            "${result.erros}/${result.teste.questoes.length}",
                      ),
                      const SizedBox(height: 5),
                      _buildRaised("Jogar novamente", () {
                        Navigator.of(context).pushReplacement(
                          CupertinoPageRoute(
                            builder: (context) => GamePage(
                              gameMode: "repetir",
                              teste: BlocProvider.getBloc<InGameBloc>().teste,
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 5),
                      _buildRaised("Escolher Tema", () async {
                        Navigator.of(context).pop();
                      }),
                      const SizedBox(height: 24),
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard({@required String title, @required String trailing}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          title,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        trailing: Container(
          width: 200,
          alignment: Alignment.centerRight,
          child: Text(
            trailing,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: mainBG, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildRaised(String text, VoidCallback f) {
    return ElevatedButton(
      onPressed: f,
      style: ElevatedButton.styleFrom(
        backgroundColor: darkblue,
        foregroundColor: Colors.black,
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
