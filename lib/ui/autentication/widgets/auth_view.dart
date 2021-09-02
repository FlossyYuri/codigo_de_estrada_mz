import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:codigo_de_estrada_mz/blocs/usuario_bloc.dart';
import 'package:codigo_de_estrada_mz/helpers/conexao.dart';
import 'package:codigo_de_estrada_mz/ui/autentication/cadastro_screen.dart';
import 'package:codigo_de_estrada_mz/ui/autentication/criar_conta_auth.dart';
import 'package:codigo_de_estrada_mz/ui/autentication/login_screen.dart';
import 'package:codigo_de_estrada_mz/ui/autentication/widgets/auth_button.dart';
import 'package:codigo_de_estrada_mz/ui/autentication/widgets/background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthView extends StatefulWidget {
  final bool login;
  AuthView({@required this.login});
  @override
  _AuthViewState createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  bool clicked = false;
  final _scaffKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffKey,
      body: Stack(
        children: <Widget>[
          Background(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
              alignment: Alignment.bottomCenter,
              child: TextButton(
                onPressed: () {
                  launch(politicasDePrivacidade);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 40,
                  child: Text(
                    "Politica de privacida",
                    style: TextStyle(
                      fontSize: 20,
                      color: branco,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            widget.login ? "Entrar" : "Criar conta",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: branco,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 3,
                              fontSize: 30,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          AuthButton(
                            acao: widget.login ? "Entrar" : "Criar conta",
                            texto: "email",
                            icon: Icon(FontAwesomeIcons.envelope),
                            onPressed: () {
                              if (widget.login) {
                                Navigator.of(context).push(
                                  CupertinoPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              } else {
                                Navigator.of(context).push(
                                  CupertinoPageRoute(
                                    builder: (context) => CadastroScreen(
                                      user: null,
                                      metodo: "email",
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: branco,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: Text(
                                  "ou",
                                  style: TextStyle(fontSize: 24, color: branco),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: branco,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          AuthButton(
                            acao: widget.login ? "Entrar" : "Criar conta",
                            texto: "Facebook",
                            icon: Icon(
                              FontAwesomeIcons.facebookF,
                              color: Colors.indigo,
                              size: 28,
                            ),
                            onPressed: () async {
                              if (!clicked) {
                                clicked = true;
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Container(
                                        height: 200,
                                        width: 200,
                                        child: Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                height: 60,
                                                width: 60,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 5,
                                                  valueColor:
                                                      AlwaysStoppedAnimation(
                                                    mainBG,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text("Loading"),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                                if (await checkConnection()) {
                                  if (widget.login) {
                                    BlocProvider.getBloc<UsuarioBloc>()
                                        .entrarFacebook(_scaffKey)
                                        .then((_) {
                                      clicked = false;
                                    });
                                  } else {
                                    BlocProvider.getBloc<UsuarioBloc>()
                                        .criarContaFacebook(_scaffKey)
                                        .then((_) {
                                      clicked = false;
                                    });
                                  }
                                } else {
                                  clicked = false;
                                  Navigator.pop(context);
                                }
                              }
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          AuthButton(
                            acao: widget.login ? "Entrar" : "Criar conta",
                            texto: "Google",
                            icon: Icon(
                              FontAwesomeIcons.google,
                              color: Colors.redAccent.withOpacity(.6),
                              size: 28,
                            ),
                            onPressed: () async {
                              if (!clicked) {
                                clicked = true;
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Container(
                                        height: 200,
                                        width: 200,
                                        child: Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                height: 60,
                                                width: 60,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 5,
                                                  valueColor:
                                                      AlwaysStoppedAnimation(
                                                    mainBG,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text("Loading"),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                                if (await checkConnection()) {
                                  if (widget.login) {
                                    BlocProvider.getBloc<UsuarioBloc>()
                                        .entrarGoogle(_scaffKey)
                                        .then((_) {
                                      clicked = false;
                                    });
                                  } else {
                                    BlocProvider.getBloc<UsuarioBloc>()
                                        .criarContaGoogle(_scaffKey)
                                        .then(
                                      (_) {
                                        clicked = false;
                                      },
                                    );
                                  }
                                } else {
                                  clicked = false;
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(_scaffKey.currentContext)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Sem conexao a internet.",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w300,
                                            color: branco),
                                      ),
                                      backgroundColor: Colors.redAccent,
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                          SizedBox(height: 50),
                          TextButton(
                            onPressed: () {
                              if (widget.login) {
                                Navigator.of(context).pushReplacement(
                                  CupertinoPageRoute(
                                    builder: (context) => CriarContaAuth(),
                                  ),
                                );
                              } else {
                                Navigator.of(context).pushReplacement(
                                  CupertinoPageRoute(
                                    builder: (context) => AuthView(
                                      login: true,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              height: 40,
                              alignment: Alignment.center,
                              child: Text(
                                widget.login
                                    ? "É novo aqui? crie uma conta"
                                    : "Tem uma conta? Entre",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: branco,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
