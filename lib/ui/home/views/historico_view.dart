import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:codigo_de_estrada_mz/models/historico.dart';
import 'package:codigo_de_estrada_mz/blocs/questao_bloc.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HistoricoView extends StatefulWidget {
  @override
  _HistoricoViewState createState() => _HistoricoViewState();
}

class _HistoricoViewState extends State<HistoricoView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    List<Widget> lista = [];
    var bloc = BlocProvider.getBloc<QuestaoBloc>();
    int acErros = 0, contLoses = 0, cont = 0;
    double mediaWins = 0, mediaErros = 0;
    String desempenho = "";
    String desErros = "";
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Historico",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 20),
        ),
        backgroundColor: mainBG,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              await bloc.deleteHistorico();
              await bloc.lerHistorico();
              setState(
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Todo histórico foi apagado com sucesso.'),
                      action: SnackBarAction(
                        label: 'Desfazer',
                        onPressed: () {
                          // Algum código para desfazer alguma alteração
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
        centerTitle: false,
      ),
      backgroundColor: mainBG,
      body: Container(
        color: mainBG,
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              CarouselSlider(
                items: <Widget>[
                  _card("Desempenho nos últimos 15 testes",
                      "\$${mediaWins.round()}%", desempenho),
                  _card("Aprovações nos ultimos 15 testes",
                      "${cont - contLoses}", desempenho),
                  _card("Media de erros por teste ", "${mediaErros.round()}",
                      desErros),
                ],
                height: 200.0,
                autoPlay: true,
              ),
              SizedBox(
                height: 10,
              ),
              FutureBuilder(
                future: bloc.lerHistorico(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (bloc.listaHistorico.length > 0) {
                      for (ResultadoHistorico res in bloc.listaHistorico) {
                        print("Start ------------------");
                        print(res.toString());
                        print("End --------------------");
                        lista.add(_card2(res, context));
                        if (cont < 15) {
                          if (res.nrErros > res.teste.maxErros) contLoses++;
                          acErros += res.nrErros;
                          cont++;
                        } else {
                          break;
                        }
                      }
                      mediaErros = acErros / cont;
                      mediaWins = ((cont - contLoses) / cont) * 100;
                      if ((cont - contLoses) < 2)
                        desempenho = "Muito Bom";
                      else if ((cont - contLoses) < 3)
                        desempenho = "Aceitável";
                      else
                        desempenho = "Precisa estudar mais";

                      if (mediaErros.round() <= 1)
                        desErros = "Muito Bom";
                      else if (mediaErros.round() <= 3)
                        desErros = "Aceitável";
                      else
                        desErros = "Precisa estudar mais";

                      return Column(
                        children: lista,
                      );
                    }
                    return Container();
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card(String titulo, String value, String classificacao) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: secBG,
        elevation: 7,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xFFC33764), Color(0xFF1D2671)],
            ),
            // gradient: LinearGradient(
            //   begin: Alignment.topRight,
            //   end: Alignment.bottomLeft,
            //   colors: [Color(0xFFDA4453), Color(0xFF89216B)],
            // ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                titulo,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  letterSpacing: 1,
                  color: branco,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.check,
                    size: 30,
                    color: branco,
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 24,
                      letterSpacing: 2,
                      color: branco,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(
                    Icons.check,
                    size: 30,
                    color: branco,
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Classicação: $classificacao",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  letterSpacing: 1,
                  color: branco,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card2(ResultadoHistorico h, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: secBG,
        elevation: 4,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: Color(0xFFE7E7E7),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.clock,
                    size: 18,
                    color: secBG,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    h.data.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      letterSpacing: 1,
                      color: preto,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              Divider(
                height: 10,
                color: preto.withOpacity(.2),
              ),
              Row(
                children: <Widget>[
                  Icon(
                    h.nrErros > h.teste.maxErros
                        ? FontAwesomeIcons.thumbsDown
                        : FontAwesomeIcons.thumbsUp,
                    size: 18,
                    color: secBG,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    h.nrErros > h.teste.maxErros ? "Reprovado" : "Aprovado",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      letterSpacing: 1,
                      color: preto,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              Divider(
                height: 10,
                color: preto.withOpacity(.2),
              ),
              Row(
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.dotCircle,
                    size: 18,
                    color: secBG,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    BlocProvider.getBloc<QuestaoBloc>()
                        .temaPorID(h.teste.idTema),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      letterSpacing: 1,
                      color: preto,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              Divider(
                height: 20,
                color: preto.withOpacity(.2),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.hashtag,
                        size: 18,
                        color: lightgreen,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        h.teste.id.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          letterSpacing: 1,
                          color: preto,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.question,
                        size: 18,
                        color: lightblue,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "${h.teste.questoes.length} Questões",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 1,
                          color: preto,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Icon(
                        Icons.close,
                        size: 18,
                        color: lightred,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "${h.nrErros} Erro(s)",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 1,
                          color: preto,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
