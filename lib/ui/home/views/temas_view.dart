import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:codigo_de_estrada_mz/blocs/in_game_bloc.dart';
import 'package:codigo_de_estrada_mz/blocs/questao_bloc.dart';
import 'package:codigo_de_estrada_mz/blocs/transacoes_bloc.dart';
import 'package:codigo_de_estrada_mz/blocs/usuario_bloc.dart';
import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:codigo_de_estrada_mz/enums/connectivity_status.dart';
import 'package:codigo_de_estrada_mz/helpers/conexao.dart';
import 'package:codigo_de_estrada_mz/models/tema.dart';
import 'package:codigo_de_estrada_mz/models/teste.dart';
import 'package:codigo_de_estrada_mz/ui/game/game_view.dart';
import 'package:codigo_de_estrada_mz/ui/home/views/premium_view.dart';
import 'package:codigo_de_estrada_mz/ui/widgets/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class TemasView extends StatefulWidget {
  @override
  _TemasViewState createState() => _TemasViewState();
}

class _TemasViewState extends State<TemasView> {
  bool conexao = false;

  int modo = 0;
  int idTema = 0;
  List<String> alertas = [
    'Sem conexão a internet!',
    'Algumas imagens não poderam ser carregadas.'
  ];
  List<Tema> temas;
  List<Tema> mostPlayed = [];
  List<Tema> relevant = [];
  List<Tema> pro = [];

  @override
  void initState() {
    super.initState();
    checkConnection().then((conexao) {
      this.conexao = conexao;
    });
  }

  @override
  Widget build(BuildContext context) {
    var connectivityStatus = Provider.of<ConnectivityStatus>(context);
    temas = BlocProvider.getBloc<QuestaoBloc>().temas;
    mostPlayed.add(Tema(id: 0, tema: "GERAL", icon: ""));
    for (Tema t in temas) {
      if (t.id == 1 || t.id == 4 || t.id == 14) {
        mostPlayed.add(t);
      } else if (t.id == 6 ||
          t.id == 7 ||
          t.id == 8 ||
          t.id == 9 ||
          t.id == 10 ||
          t.id == 12) {
        relevant.add(t);
      } else {
        pro.add(t);
      }
    }

    return CustomScrollView(
      slivers: <Widget>[
        CustomSliverAppBar(),
        SliverToBoxAdapter(
          child: (connectivityStatus == ConnectivityStatus.Offline)
              ? Column(
                  children: alertas.map((alerta) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: lightred,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            flex: 4,
                            fit: FlexFit.tight,
                            child: Text(
                              alerta,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: branco,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  textStyle: TextStyle(color: branco)),
                              onPressed: () {
                                setState(() {
                                  alertas.remove(alerta);
                                });
                              },
                              child: Icon(Icons.close),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                )
              : Container(),
        ),
        _header("Mais escolhidas"),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 7 / 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            delegate: SliverChildBuilderDelegate(
              _buildMostPlayed,
              childCount: mostPlayed.length,
            ),
          ),
        ),
        _header("Temas de Base"),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 10 / 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            delegate: SliverChildBuilderDelegate(
              _buildRelevant,
              childCount: relevant.length,
            ),
          ),
        ),
        _header("Temas Aprofundados"),
        SliverPadding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 6 / 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            delegate: SliverChildBuilderDelegate(
              _buildPro,
              childCount: pro.length,
            ),
          ),
        ),
        !BlocProvider.getBloc<UsuarioBloc>().userData.premium
            ? SliverToBoxAdapter(
                child: FutureBuilder<bool>(
                  future: checkConnection(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data) {
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 20),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            title: SizedBox(height: 10.0),
                          ),
                        );
                      }
                    }
                    return Container();
                  },
                ),
              )
            : SliverToBoxAdapter(
                child: Container(),
              ),
      ],
    );
  }

  Widget _header(String titulo) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              titulo.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: branco,
              ),
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMostPlayed(BuildContext context, int index) {
    return _buildItem(index, mostPlayed);
  }

  Widget _buildRelevant(BuildContext context, int index) {
    return _buildItem(index, relevant);
  }

  Widget _buildPro(BuildContext context, int index) {
    return _buildItem(index, pro);
  }

  Widget _buildItem(int index, List<Tema> list) {
    return MaterialButton(
      onPressed: () => _buildDificuldade(
        context,
        list[index],
      ),
      splashColor: mainBG,
      highlightColor: lightblue,
      elevation: 0,
      color: secBG,
      highlightElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            list[index].tema,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16, color: branco, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }

  _buildDificuldade(BuildContext context, Tema tema) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      context: context,
      builder: (sheetContext) => BottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        onClosing: () {},
        builder: (_) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 5),
          child: StatefulBuilder(builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  tema.tema,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Selecione o modo de jogo:",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _actionChip(
                      "Normal",
                      0,
                      () {
                        setState(() {
                          modo = 0;
                          BlocProvider.getBloc<InGameBloc>().questionMode =
                              'normal';
                        });
                      },
                    ),
                    _actionChip("Classico", 1, () {
                      setState(() {
                        modo = 1;
                        BlocProvider.getBloc<InGameBloc>().questionMode =
                            'classico';
                      });
                    },
                        active: BlocProvider.getBloc<UsuarioBloc>()
                            .userData
                            .premium),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.getBloc<TransacoesBloc>()
                        .verificarTestesIlimitados()
                        .then((ativo) {
                      if (BlocProvider.getBloc<UsuarioBloc>()
                                  .userData
                                  .nrTestes >=
                              1 ||
                          ativo) {
                        Navigator.of(context).pop();
                        switch (modo) {
                          case 0:
                            BlocProvider.getBloc<InGameBloc>().questionMode =
                                'normal';
                            break;
                          case 1:
                            BlocProvider.getBloc<InGameBloc>().questionMode =
                                'classico';
                            break;
                        }

                        BlocProvider.getBloc<InGameBloc>().tipoDeTeste = 1;
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => GamePage(
                              gameMode: "random",
                              teste: Teste(
                                nome: tema.tema,
                                categoria: tema.tema,
                                duracao: 30,
                                id: 0,
                                maxErros: 7,
                                questoes: BlocProvider.getBloc<InGameBloc>()
                                    .criarQuestoes(
                                  context: context,
                                  idTema: tema.id,
                                ),
                                idTema: tema.id,
                              ),
                            ),
                          ),
                        );
                      } else {
                        Fluttertoast.showToast(
                            msg:
                                "Nao tem testes suficientes, volte ao menu assita um video para ganhar teste ou compre teste na loja",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 2);
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainBG,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                      side: BorderSide(color: branco, width: 2),
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: 200,
                    child: Text(
                      "Jogar",
                      style: TextStyle(
                          color: branco,
                          fontSize: 24,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                )
              ],
            );
          }),
        ),
      ),
    );
  }

  _actionChip(String text, int mod, Function f, {bool active = true}) {
    bool classic = text == "Classico";
    return ActionChip(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: preto.withOpacity(0.1), width: 0.5),
        borderRadius: BorderRadius.circular(40),
      ),
      labelPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      backgroundColor: mod == modo ? mainBG : transparente,
      elevation: mod == modo ? 7 : 0,
      label: Container(
        width: 130,
        alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              text,
              style: TextStyle(
                color: !active && classic
                    ? Colors.grey
                    : mod == modo
                        ? branco
                        : preto,
                fontSize: 20,
                fontWeight: FontWeight.w300,
              ),
            ),
            !active && classic
                ? Icon(
                    Icons.lock_outline,
                    color: Colors.grey,
                    size: 24,
                  )
                : Container()
          ],
        ),
      ),
      onPressed: active
          ? f
          : () {
              _getPremium(context,
                  "Este Modo está disponivel apenas para usuários Premium.");
            },
    );
  }

  void _getPremium(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Teste Bloqueado"),
          content: Text(text),
          backgroundColor: secBG,
          titleTextStyle: TextStyle(color: branco, fontSize: 18),
          contentTextStyle: TextStyle(color: branco, fontSize: 16),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: Text(
                "Virar Premium",
                style: TextStyle(color: lightgreen, fontSize: 16),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => GetPremium(),
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
  }
}
