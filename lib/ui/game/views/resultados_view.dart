import 'dart:async';
import 'dart:math';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:codigo_de_estrada_mz/blocs/in_game_bloc.dart';
import 'package:codigo_de_estrada_mz/blocs/usuario_bloc.dart';
import 'package:codigo_de_estrada_mz/blocs/questao_bloc.dart';
import 'package:codigo_de_estrada_mz/blocs/transacoes_bloc.dart';
import 'package:codigo_de_estrada_mz/helpers/conexao.dart';
import 'package:codigo_de_estrada_mz/models/resultados.dart';
import 'package:codigo_de_estrada_mz/ui/game/game_view.dart';
import 'package:codigo_de_estrada_mz/ui/widgets/custom_app_bar.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResultadosView extends StatefulWidget {
  @override
  _ResultadosViewState createState() => _ResultadosViewState();
}

class _ResultadosViewState extends State<ResultadosView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool intersticialReady = false;
  bool conexao = true;
  bool resolucao = false;
  bool premium;
  InterstitialAd myInterstitial;
  StreamController _loadSub = StreamController<bool>.broadcast();
  @override
  void initState() {
    super.initState();
    checkConnection().then((conexao) {
      this.conexao = conexao;
      if (conexao) {
        myInterstitial = InterstitialAd(
          adUnitId: getIntersticialAdUnitId(),
          targetingInfo: targetingInfo,
        );
        myInterstitial.listener = (MobileAdEvent event) async {
          switch (event) {
            case MobileAdEvent.loaded:
              intersticialReady = true;
              _loadSub.sink.add(intersticialReady);
              break;
            case MobileAdEvent.failedToLoad:
              // The ad failed to load into memory.
              break;
            case MobileAdEvent.clicked:
              Random r = Random();
              if (r.nextInt(5) == 3) {
                await BlocProvider.getBloc<TransacoesBloc>()
                    .ganharTestes(context, 1);
              }
              break;
            case MobileAdEvent.impression:
              // The user is still looking at the ad. A new ad came up.
              break;
            case MobileAdEvent.opened:
              // The Ad is now open.
              break;
            case MobileAdEvent.leftApplication:
              // You've left the app after clicking the Ad.
              break;
            case MobileAdEvent.closed:
              // You've closed the Ad and returned to the app.
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Ao clicar neste tipo de anuncio se tiver sorte pode ganhar um teste",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: branco),
                  ),
                  backgroundColor: Colors.blue,
                ),
              );
              break;
            default:
            // There's a 'new' MobileAdEvent?!
          }
        };
        myInterstitial.load();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (BlocProvider.getBloc<InGameBloc>().salvarHistorico) {
      BlocProvider.getBloc<InGameBloc>().calcularResultados();
      BlocProvider.getBloc<QuestaoBloc>().lerHistorico();
    }
    premium = BlocProvider.getBloc<UsuarioBloc>().userData.premium;
    Resultados result = BlocProvider.getBloc<InGameBloc>().resultados;
    if (!BlocProvider.getBloc<UsuarioBloc>().userData.premium && conexao)
      _loadSub.stream.listen((load) {
        if (load) {
          myInterstitial.show();
          intersticialReady = false;
          _loadSub.close();
        }
      });

    if (resolucao == false)
      Future.delayed(Duration(seconds: 1)).then((v) {
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
                    premium ? "Sim" : "Sim (5 CS)",
                    style: TextStyle(color: lightred, fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (BlocProvider.getBloc<UsuarioBloc>().userData.cs >= 5 ||
                        premium) {
                      BlocProvider.getBloc<TransacoesBloc>()
                          .pagarResolucao(context);
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => GamePage(
                            gameMode: "resolucao",
                            teste: BlocProvider.getBloc<InGameBloc>().teste,
                          ),
                        ),
                      );
                    } else
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Nao tem cs suficiente, volte ao menu e compre cs na loja",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                color: branco),
                          ),
                          backgroundColor: Colors.redAccent,
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
                                borderRadius: BorderRadius.circular(10)),
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
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300),
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
                                    width: 0.4,
                                    color: preto.withOpacity(0.2),
                                  ),
                                ),
                                onPressed: () {
                                  if (BlocProvider.getBloc<UsuarioBloc>()
                                          .userData
                                          .cs >=
                                      5) {
                                    BlocProvider.getBloc<TransacoesBloc>()
                                        .pagarResolucao(context);
                                    Navigator.of(context).push(
                                      CupertinoPageRoute(
                                        builder: (context) => GamePage(
                                          gameMode: "resolucao",
                                          teste:
                                              BlocProvider.getBloc<InGameBloc>()
                                                  .teste,
                                        ),
                                      ),
                                    );
                                  } else
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Nao tem cs suficiente, volte ao menu e compre cs na loja",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w300,
                                              color: branco),
                                        ),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                },
                                elevation: 11,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Ver resolucao",
                                      style: TextStyle(
                                        color: mainBG,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      premium ? "grátis" : "custo: 5 cs",
                                      style: TextStyle(
                                        color: preto,
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
                          // _buildResultCard(title: "Dificuldade", trailing: dific),
                          !BlocProvider.getBloc<UsuarioBloc>()
                                      .userData
                                      .premium &&
                                  conexao
                              ? FutureBuilder<bool>(
                                  future: checkConnection(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data) {
                                        return Card(
                                          elevation: 4,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: ListTile(
                                            contentPadding:
                                                const EdgeInsets.all(0),
                                            title: AdmobBanner(
                                              adUnitId: getBannerAdUnitId(),
                                              adSize:
                                                  AdmobBannerSize.LARGE_BANNER,
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                    return Container();
                                  },
                                )
                              : Container(),
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
                            if (BlocProvider.getBloc<UsuarioBloc>()
                                    .userData
                                    .nrTestes >=
                                1) {
                              Navigator.of(context).pushReplacement(
                                CupertinoPageRoute(
                                  builder: (context) => GamePage(
                                    gameMode: "repetir",
                                    teste: BlocProvider.getBloc<InGameBloc>()
                                        .teste,
                                  ),
                                ),
                              );
                            } else
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Nao tem testes suficientes, volte ao menu e compre cs na loja",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300,
                                        color: branco),
                                  ),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                          }),
                          const SizedBox(height: 5),
                          _buildRaised("Escolher Tema", () async {
                            Navigator.of(context).pop();
                          }),
                          const SizedBox(height: 5),
                          const SizedBox(height: 5),
                          const SizedBox(height: 70),
                        ]),
                  ))
            ],
          ),
        ));
  }

  Widget _buildResultCard({@required String title, @required String trailing}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
        primary: darkblue,
        onPrimary: Colors.black,
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
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

  @override
  void dispose() {
    _loadSub.close();
    super.dispose();
  }
}
