import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:codigo_de_estrada_mz/blocs/questao_bloc.dart';
import 'package:codigo_de_estrada_mz/blocs/usuario_bloc.dart';
import 'package:codigo_de_estrada_mz/ui/autentication/widgets/auth_view.dart';
import 'package:codigo_de_estrada_mz/ui/home/home_screen.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';

class LoginAuth extends StatefulWidget {
  @override
  _LoginAuthState createState() => _LoginAuthState();
}

class _LoginAuthState extends State<LoginAuth> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.getBloc<QuestaoBloc>().load();
    return FlareActor(
      "assets/animations/splash.flr",
      animation: "start",
      alignment: Alignment.center,
      fit: BoxFit.cover,
      callback: (val) async {
        BlocProvider.getBloc<UsuarioBloc>().offlineLogin().then(
          (val) {
            switch (val) {
              case 1:
                Navigator.of(context).pushReplacement(
                  CupertinoPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
                break;
              default:
                Navigator.of(context).pushReplacement(
                  CupertinoPageRoute(
                    builder: (context) => AuthView(
                      login: true,
                    ),
                  ),
                );
            }
          },
        );
      },
    );
  }
}
/*
showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text(
                "Nova Atualização disponível",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: mainBG,
                ),
              ),
              content: SingleChildScrollView(
                child: Text(
                  "Já está disponivel uma atualização da aplicação. Veja o que há de novo na tela de noticias. Atualize já porque a qualquer momento a sua versao pode ser desativada.\n"
                  "se a versão atual estiver desactivada nao permitir a utilização",
                  style: TextStyle(
                    fontSize: 20,
                    color: preto,
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    "Baixar Atualização",
                    style: TextStyle(
                        fontSize: 22,
                        color: mainBG,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    launchUrl(Uri.parse(appURL));
                  },
                ),
                FlatButton(
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
                ),
              ],
            );
          },
        );

        */
