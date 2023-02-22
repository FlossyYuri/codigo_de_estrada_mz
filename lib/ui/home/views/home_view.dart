import 'dart:io';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:codigo_de_estrada_mz/helpers/conexao.dart';
import 'package:codigo_de_estrada_mz/ui/home/noticias_screen.dart';
import 'package:codigo_de_estrada_mz/blocs/usuario_bloc.dart';
import 'package:codigo_de_estrada_mz/ui/home/sobre_screen.dart';
import 'package:codigo_de_estrada_mz/ui/home/temas_screen.dart';
import 'package:codigo_de_estrada_mz/ui/home/views/testes_view.dart';
import 'package:codigo_de_estrada_mz/ui/home/widgets/modo_card.dart';
import 'package:codigo_de_estrada_mz/ui/home/widgets/option_card.dart';
import 'package:codigo_de_estrada_mz/ui/home/widgets/promo-dialogue.dart';
import 'package:codigo_de_estrada_mz/ui/loja/loja_screen.dart';
import 'package:codigo_de_estrada_mz/ui/tutoriais/tutoriais_screen.dart';
import 'package:codigo_de_estrada_mz/ui/widgets/custom_app_bar.dart';
import 'package:codigo_de_estrada_mz/blocs/transacoes_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool videoReady = false;
  bool conexao = false;

  @override
  Widget build(BuildContext context) {
    checkConnection().then(
      (conexao) {
        this.conexao = conexao;
      },
    );
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getBool("update")) {
        _showUpdateInfo();
      }
    });

    return CustomScrollView(
      slivers: <Widget>[
        CustomSliverAppBar(),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Modos de teste",
                      style: TextStyle(
                        color: Color(0x66FFFFFF),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                        fontSize: 14.0,
                      ),
                    ),
                    Text(
                      "Escolha um modo de jogo",
                      style: TextStyle(
                        color: Color(0xAAFFFFFF),
                        fontWeight: FontWeight.w300,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              ModoCard(
                img: "assets/images/p2.png",
                titulo: "Personalisados",
                subtitulo: "Todas categorias",
                add1: "+700 Questões",
                add2: "17 temas",
                bgcolor: secBG,
                icon1: FontAwesomeIcons.question,
                icon2: FontAwesomeIcons.pen,
                f: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => TemasScreen(),
                    ),
                  );
                },
              ),
              ModoCard(
                img: "assets/images/e2.png",
                titulo: "Exercicios",
                subtitulo: "Por tema",
                add1: "+50 Testes",
                add2: "17 temas",
                bgcolor: secBG,
                icon1: FontAwesomeIcons.clipboardList,
                icon2: FontAwesomeIcons.pen,
                f: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => TestesView(),
                    ),
                  );
                },
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Divider(
                  height: 2,
                  color: Colors.white70,
                ),
              )
            ],
          ),
        ),
        SliverPadding(
          padding: pagePadding,
          sliver: SliverGrid.count(
            crossAxisCount: 2,
            childAspectRatio: 5 / 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: <Widget>[
              OptionCard(
                texto: "LOJA",
                icon: FontAwesomeIcons.bagShopping,
                f: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => LojaScreen(),
                    ),
                  );
                },
              ),
              OptionCard(
                texto: "Noticias",
                icon: FontAwesomeIcons.newspaper,
                f: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => NoticiasScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        SliverPadding(
          padding: pagePadding,
          sliver: SliverGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: <Widget>[
              OptionCard(
                texto: "Sobre",
                icon: FontAwesomeIcons.circleInfo,
                f: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => SobreScreen(),
                    ),
                  );
                },
              ),
              OptionCard(
                texto: "Tutoriais",
                icon: FontAwesomeIcons.lightbulb,
                f: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(builder: (context) => TutoriaisScreen()),
                  );
                },
              ),
            ],
          ),
        ),
        /*
        SliverToBoxAdapter(
          child: Column(children: <Widget>[
            ElevatedButton(
              color: Colors.purple,
              onPressed: () {
                setState(() {
                  BlocProvider.getBloc<QuestaoBloc>().buscarQuestoesDB();
                });
              },
              child: Text("Cancelar"),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              color: Colors.purple,
              onPressed: () {
                setState(() {
                  BlocProvider.getBloc<TransacoesBloc>()
                      .virarPremium(context);
                });
              },
              child: Text("Virar Premium"),
            ),
            SizedBox(
              height: 10,
            ),
          ]),
        ),
        */
      ],
    );
  }

  _showUpdateInfo() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Consts.padding),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                top: Consts.avatarRadius + Consts.padding,
                bottom: Consts.padding,
                left: Consts.padding,
                right: Consts.padding,
              ),
              margin: EdgeInsets.only(top: Consts.avatarRadius),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: mainBG,
                borderRadius: BorderRadius.circular(Consts.padding),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: const Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // To make the card compact
                children: <Widget>[
                  Text(
                    "Atualização Disponivel",
                    style: TextStyle(
                      color: branco,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.black.withOpacity(1),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    "Já está disponivel uma nova versão da aplicação. Baixe agora a nova versão porque a qualquer momento esta pode ser desactivada.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: branco,
                      fontSize: 20,
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.black.withOpacity(1),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 24.0),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        raised(() {
                          Navigator.pop(context);
                          launchUrl(Uri.parse(APP_URL));
                        }, "Baixar"),
                        raised(() {
                          SharedPreferences.getInstance().then((prefs) {
                            if (prefs.getBool("obrigatorio"))
                              exit(0);
                            else
                              Navigator.pop(context);
                          });
                        }, "Fechar"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: Consts.padding,
              right: Consts.padding,
              child: CircleAvatar(
                backgroundColor: branco.withOpacity(.5),
                radius: Consts.avatarRadius,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: Image.asset("assets/images/gift.png"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  verificarTestes(Function f) {
    BlocProvider.getBloc<TransacoesBloc>()
        .verificarTestesIlimitados()
        .then((ativo) {
      if (BlocProvider.getBloc<UsuarioBloc>().userData.nrTestes >= 1 || ativo) {
        if (!BlocProvider.getBloc<UsuarioBloc>().userData.premium && conexao)
          f();
      } else
        _showSnackBar(
          "Nao tem testes suficiente, compre testes na loja ou assista um anuncio e ganhe testes",
          lightred,
          action: SnackBarAction(
            label: "Assistir video",
            onPressed: () {
              _showRewardedVideo();
            },
          ),
        );
    });
  }

  Widget raised(Function f, String text) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: secBG,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        elevation: 1,
      ),
      onPressed: f,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: Text(
          text,
          style: TextStyle(color: branco, fontSize: 18),
        ),
      ),
    );
  }

  _showRewardedVideo() {
    if (conexao) {
      if (videoReady) {
      } else {
        _showSnackBar("Anuncio carregando! tente novamente", Colors.blueAccent);
      }
    } else {
      _showSnackBar("Nao está conectado a internet", Colors.blueAccent);
    }
  }

  _showSnackBar(String mensagem, Color cor, {SnackBarAction action}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          mensagem,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w300, color: branco),
        ),
        backgroundColor: cor,
        duration: Duration(seconds: 2),
        action: action != null ? action : null,
      ),
    );
  }
}
