import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:codigo_de_estrada_mz/blocs/usuario_bloc.dart';
import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:codigo_de_estrada_mz/enums/signup_method.dart';
import 'package:codigo_de_estrada_mz/ui/autentication/cadastro_screen.dart';
import 'package:codigo_de_estrada_mz/ui/autentication/criar_conta_auth.dart';
import 'package:codigo_de_estrada_mz/ui/autentication/login_screen.dart';
import 'package:codigo_de_estrada_mz/ui/autentication/widgets/auth_button.dart';
import 'package:codigo_de_estrada_mz/ui/autentication/widgets/background.dart';
import 'package:codigo_de_estrada_mz/ui/utils/screen_notification_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthView extends StatefulWidget {
  final bool isLogin;
  AuthView({@required this.isLogin});
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
                  launchUrl(Uri.parse(politicasDePrivacidade));
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
                            widget.isLogin ? "Entrar" : "Criar conta",
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
                            action: widget.isLogin ? "Entrar" : "Criar conta",
                            text: "email",
                            icon: Icon(FontAwesomeIcons.envelope),
                            onPressed: () {
                              if (widget.isLogin) {
                                Navigator.of(context).push(
                                  CupertinoPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              } else {
                                Navigator.of(context).push(
                                  CupertinoPageRoute(
                                    builder: (context) => CadastroScreen(
                                      userCredencial: null,
                                      method: SignUpMethod.EMAIL,
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
                            action: widget.isLogin ? "Entrar" : "Criar conta",
                            text: "Facebook",
                            icon: Icon(
                              FontAwesomeIcons.facebookF,
                              color: Colors.indigo,
                              size: 28,
                            ),
                            onPressed: () async {
                              if (!clicked) {
                                clicked = true;
                                ScreenNotificationUtils()
                                    .showLoadingModal(context);
                                BlocProvider.getBloc<UsuarioBloc>()
                                    .facebookAuthentication(_scaffKey)
                                    .then((_) {
                                  clicked = false;
                                });
                              }
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          AuthButton(
                            action: widget.isLogin ? "Entrar" : "Criar conta",
                            text: "Google",
                            icon: Icon(
                              FontAwesomeIcons.google,
                              color: Colors.redAccent.withOpacity(.6),
                              size: 28,
                            ),
                            onPressed: () async {
                              if (!clicked) {
                                clicked = true;
                                ScreenNotificationUtils()
                                    .showLoadingModal(context);
                                BlocProvider.getBloc<UsuarioBloc>()
                                    .googleAuthentication(_scaffKey)
                                    .then((_) {
                                  clicked = false;
                                });
                              }
                            },
                          ),
                          SizedBox(height: 50),
                          TextButton(
                            onPressed: () {
                              if (widget.isLogin) {
                                Navigator.of(context).pushReplacement(
                                  CupertinoPageRoute(
                                    builder: (context) => CriarContaAuth(),
                                  ),
                                );
                              } else {
                                Navigator.of(context).pushReplacement(
                                  CupertinoPageRoute(
                                    builder: (context) => AuthView(
                                      isLogin: true,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              height: 40,
                              alignment: Alignment.center,
                              child: Text(
                                widget.isLogin
                                    ? "É novo aqui? crie uma conta"
                                    : "Tem uma conta? Entre",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: branco,
                                  fontWeight: FontWeight.w300,
                                ),
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
