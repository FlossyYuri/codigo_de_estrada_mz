import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:codigo_de_estrada_mz/models/historico.dart';
import 'package:codigo_de_estrada_mz/models/tema.dart';
import 'package:codigo_de_estrada_mz/blocs/questao_bloc.dart';
import 'package:codigo_de_estrada_mz/blocs/in_game_bloc.dart';
import 'package:codigo_de_estrada_mz/blocs/transacoes_bloc.dart';
import 'package:codigo_de_estrada_mz/blocs/usuario_bloc.dart';
import 'package:codigo_de_estrada_mz/models/teste.dart';
import 'package:codigo_de_estrada_mz/ui/game/game_view.dart';
import 'package:codigo_de_estrada_mz/ui/home/views/premium_view.dart';
import 'package:codigo_de_estrada_mz/ui/home/widgets/tema_card.dart';
import 'package:codigo_de_estrada_mz/ui/home/widgets/teste_card.dart';
import 'package:codigo_de_estrada_mz/ui/widgets/custom_app_bar.dart';
import 'package:codigo_de_estrada_mz/ui/widgets/custom_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TestesView extends StatefulWidget {
  @override
  _TestesViewState createState() => _TestesViewState();
}

class _TestesViewState extends State<TestesView>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final Color branco = Colors.white;

  final Color preto = Colors.black;
  List<Tema> temas;
  List<Teste> testes;
  List<ResultadoHistorico> historico;
  int modo = 0;

  final LinearGradient mainGrad = LinearGradient(colors: [
    Color.fromRGBO(84, 13, 110, 1),
    Color.fromRGBO(238, 66, 102, 1),
  ], begin: Alignment.topCenter, end: Alignment.bottomCenter);
  bool toogle = false;
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _animateColor;
  Animation<double> _animateIcon;
  Curve _curve = Curves.easeOut;
  @override
  initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animateColor = ColorTween(
      begin: secBG,
      end: lightred,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.00,
          1.00,
          curve: _curve,
        ),
      ),
    );
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
      _showBottomSheet();
    } else {
      _animationController.reverse();
      Navigator.pop(context);
    }
    isOpened = !isOpened;
  }

  Widget toggle() {
    return FloatingActionButton(
      backgroundColor: _animateColor.value,
      onPressed: () {
        animate();
      },
      tooltip: 'Toggle',
      child: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        progress: _animateIcon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    temas = BlocProvider.getBloc<QuestaoBloc>().temas;
    testes = BlocProvider.getBloc<QuestaoBloc>().testes;

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(color: mainBG),
        child: CustomScrollView(
          slivers: <Widget>[
            CustomSliverAppBar(),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      "Testes por temas",
                      style: TextStyle(
                        color: Color(0x66FFFFFF),
                        fontWeight: FontWeight.w300,
                        fontSize: 14.0,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      height: 2,
                      color: Colors.white70,
                    ),
                    FutureBuilder(
                      future:
                          BlocProvider.getBloc<QuestaoBloc>().lerHistorico(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Container();
                        } else {
                          return Column(
                            children: temas.map((Tema tema) {
                              List<Widget> w = [_tituloTema(tema.tema)];
                              int cont = 0, porTema = 0;
                              for (Teste t in testes) {
                                if (t.idTema == tema.id) {
                                  ResultadoHistorico hi;
                                  for (ResultadoHistorico his
                                      in BlocProvider.getBloc<QuestaoBloc>()
                                          .listaHistorico) {
                                    if (t.id == his.teste.id) {
                                      hi = his;
                                      break;
                                    }
                                  }
                                  String state = "";
                                  if (hi != null) {
                                    if (hi.nrErros > t.maxErros)
                                      state = "reprovado";
                                    else
                                      state = "aprovado";
                                  } else {
                                    state = "novo";
                                  }
                                  if (!BlocProvider.getBloc<UsuarioBloc>()
                                      .userData
                                      .premium) if (porTema >= 1)
                                    state = "bloqueado";
                                  w.add(
                                    Column(
                                      children: <Widget>[
                                        TesteCard(
                                          icon: FontAwesomeIcons.clipboardList,
                                          duracao: t.duracao,
                                          maxErros: t.maxErros,
                                          nrQuestoes: t.questoes.length,
                                          titulo: t.nome,
                                          erros: hi != null ? hi.nrErros : 0,
                                          f: () {
                                            if (state != "bloqueado") {
                                              _buildModo(
                                                  context,
                                                  tema,
                                                  t,
                                                  state,
                                                  hi != null ? hi.nrErros : 0);
                                            } else {
                                              _getPremium(context,
                                                  "Este teste está disponivel apenas para usuários Premium.");
                                            }
                                          },
                                          estado: state,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  );
                                  cont++;
                                  porTema++;
                                }
                              }
                              porTema = 0;

                              if (cont > 0) {
                                w.add(_divider());
                              } else {
                                w.removeLast();
                              }
                              return Column(children: w);
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: CustomDrawer(_scaffoldKey),
      floatingActionButton: toggle(),
    );
  }

  _divider() {
    return Column(
      children: <Widget>[
        Divider(
          height: 2,
          color: Colors.white70,
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  _tituloTema(String t) {
    return Column(
      children: <Widget>[
        Text(
          t,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 18.0,
              letterSpacing: 1),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  _showBottomSheet() {
    _scaffoldKey.currentState.showBottomSheet((context) {
      return Container(
        color: mainBG,
        height: 240,
        child: Container(
          padding: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Tema",
                        // "Escolha um tema",
                        style: TextStyle(
                          color: secBG,
                          fontWeight: FontWeight.w400,
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: temas.map((Tema tema) {
                          return TemaCard(tema: tema.tema);
                        }).toList(),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  _buildModo(
      BuildContext context, Tema tema, Teste t, String estado, int erros) {
    IconData ico = Icons.close;
    Color cor = preto;
    switch (estado) {
      case "aprovado":
        ico = FontAwesomeIcons.check;
        cor = lightgreen;
        break;
      case "reprovado":
        ico = Icons.close;
        cor = lightred;
        break;
      default:
    }
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
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
            Widget res = Column(
              children: <Widget>[
                Divider(
                  height: 2,
                  color: preto.withOpacity(.4),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  decoration: BoxDecoration(
                    color: mainBG,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Ultimos Resultados",
                        style: TextStyle(
                          color: branco,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(
                                ico,
                                color: cor,
                                size: 20,
                              ),
                              Text(
                                estado,
                                style: TextStyle(
                                  color: branco,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.close,
                                color: lightred,
                                size: 20,
                              ),
                              Text(
                                "$erros Erros",
                                style: TextStyle(
                                  color: branco,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            );

            switch (estado) {
              case "aprovado":
              case "reprovado":
                break;
              default:
                res = Container();
            }
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
                    fontSize: 18,
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
                  height: 10,
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
                        BlocProvider.getBloc<InGameBloc>().tipoDeTeste = 2;
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => GamePage(
                              gameMode: "teste",
                              teste: t,
                            ),
                          ),
                        );
                      } else {
                        SnackBar(
                          content: Text(
                            "Não tem testes suficientes",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                color: branco),
                          ),
                          backgroundColor: lightred,
                          duration: Duration(seconds: 2),
                        );
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                      side: BorderSide(color: branco, width: 2),
                    ),
                    primary: mainBG,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    height: 40,
                    width: 180,
                    child: Text(
                      "Jogar",
                      style: TextStyle(
                        color: branco,
                        fontSize: 22,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                res
              ],
            );
          }),
        ),
      ),
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

  _actionChip(String text, int mod, Function f, {bool active = true}) {
    bool classic = text == "Classico";
    return ActionChip(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: preto.withOpacity(0.1), width: 0.5),
        borderRadius: BorderRadius.circular(40),
      ),
      labelPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      backgroundColor: mod == modo ? mainBG : transparente,
      elevation: mod == modo ? 4 : 0,
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
}
