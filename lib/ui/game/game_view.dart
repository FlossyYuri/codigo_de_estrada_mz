import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:codigo_de_estrada_mz/blocs/in_game_bloc.dart';
import 'package:codigo_de_estrada_mz/blocs/transacoes_bloc.dart';
import 'package:codigo_de_estrada_mz/blocs/usuario_bloc.dart';
import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:codigo_de_estrada_mz/helpers/conexao.dart';
import 'package:codigo_de_estrada_mz/models/teste.dart';
import 'package:codigo_de_estrada_mz/ui/game/views/resultados_view.dart';
import 'package:codigo_de_estrada_mz/ui/game/widgets/questao_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  final String gameMode;
  final Teste teste;
  GamePage({
    @required this.gameMode,
    this.teste,
  });
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final _controlador = PageController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int currentPage = 0;
  bool conexao = false;

  @override
  void initState() {
    super.initState();
    checkConnection().then((conexao) {
      this.conexao = conexao;
    });
  }

  @override
  Widget build(BuildContext context) {
    var blocInGame = BlocProvider.getBloc<InGameBloc>();
    if (!blocInGame.jogando) {
      //se nao estiver jogando
      switch (widget.gameMode) {
        case "repetir":
          blocInGame.jogarNovamente();
          break;
        case "resolucao":
          break;
        default:
          BlocProvider.getBloc<InGameBloc>().salvarHistorico = true;
          blocInGame.carregarTeste(context: context, teste: widget.teste);
      }
      if (widget.gameMode != "resolucao") blocInGame.jogando = true;
    }
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: mainBG,
          title: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  widget.teste.nome,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              widget.gameMode == "resolucao"
                  ? Container()
                  : StreamBuilder<int>(
                      stream: blocInGame.outQtdQuestoesResp,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            "${snapshot.data}/${widget.teste.questoes.length} Questoes",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w300),
                          );
                        }
                        return Text(
                          "0/${widget.teste.questoes.length} Questoes",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        );
                      },
                    ),
            ],
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget>[
            PageView.builder(
              controller: _controlador,
              scrollDirection: Axis.vertical,
              itemCount: widget.teste.questoes.length,
              itemBuilder: (context, index) {
                currentPage = index;
                if (widget.gameMode == "resolucao")
                  return QuestaoView(
                    questao: blocInGame.teste.questoes2[index],
                    resposta:
                        blocInGame.teste.questoes2[index].portugues.resposta,
                    alternativa: blocInGame.resultados.opcoesEscolhidas[index]
                        [blocInGame.teste.questoes2[index].id],
                  );
                else {
                  return QuestaoView(
                    questao: blocInGame.teste.questoes2[index],
                    questionMode: blocInGame.questionMode,
                  );
                }
              },
            ),
            Positioned(
              bottom: 20,
              right: 0,
              left: 0,
              child: _btsBuilder(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _btsBuilder() {
    if (widget.gameMode == "resolucao")
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildIconButton(Icons.arrow_drop_up, () {
            _controlador.previousPage(
                duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
          }),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                backgroundColor: mainBG,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                  side: BorderSide(width: 2, color: branco),
                ),
              ),
              child: Text(
                "Voltar",
                style: TextStyle(
                  color: branco,
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          _buildIconButton(Icons.arrow_drop_down, () {
            _controlador.nextPage(
              duration: Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          }),
        ],
      );
    else
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildIconButton(Icons.arrow_drop_up, () {
            _controlador.previousPage(
                duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
          }),
          StreamBuilder<int>(
            stream: BlocProvider.getBloc<InGameBloc>().outQtdQuestoesResp,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 4,
                      backgroundColor: mainBG,
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                          side: BorderSide(width: 2, color: branco)),
                    ),
                    child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: 120,
                        child: Text(
                          "Terminar",
                          style: TextStyle(
                            color: branco,
                            fontSize: 24,
                            fontWeight: FontWeight.w300,
                          ),
                        )),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // return object of type Dialog
                          return AlertDialog(
                            title: Text("Terminar teste"),
                            content: Text("Deseja terminar o teste?"),
                            backgroundColor: secBG,
                            titleTextStyle:
                                TextStyle(color: branco, fontSize: 18),
                            contentTextStyle:
                                TextStyle(color: branco, fontSize: 16),
                            actions: <Widget>[
                              // usually buttons at the bottom of the dialog
                              TextButton(
                                child: Text(
                                  "Sim",
                                  style:
                                      TextStyle(color: lightred, fontSize: 16),
                                ),
                                onPressed: () {
                                  BlocProvider.getBloc<InGameBloc>().jogando =
                                      false;
                                  Navigator.pop(context);
                                  Navigator.of(context).pushReplacement(
                                    CupertinoPageRoute(
                                      builder: (context) => ResultadosView(),
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
                    });
              }

              return Container();
            },
          ),
          _buildIconButton(Icons.arrow_drop_down, () {
            _controlador.nextPage(
              duration: Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          }),
        ],
      );
  }

  Widget _buildIconButton(IconData icon, VoidCallback f) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: CircleBorder(), backgroundColor: branco),
      child: Icon(
        icon,
        size: 35,
        color: mainBG,
      ),
      onPressed: f,
    );
  }

  Future<bool> _requestPop() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Voltar Para o menu"),
          content: Text("Tem certeza que quer voltar para o menu?"),
          actions: <Widget>[
            TextButton(
              child: Text("Não"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("Sim"),
              onPressed: () {
                BlocProvider.getBloc<InGameBloc>().jogando = false;
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
    return Future.value(false);
  }
}
