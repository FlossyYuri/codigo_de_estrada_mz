import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:codigo_de_estrada_mz/blocs/usuario_bloc.dart';
import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:codigo_de_estrada_mz/helpers/conexao.dart';
import 'package:codigo_de_estrada_mz/ui/autentication/widgets/background.dart';
import 'package:codigo_de_estrada_mz/ui/autentication/widgets/custom_text_field2.dart';
import 'package:codigo_de_estrada_mz/ui/home/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    _navHome() {
      return () {
        Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(
              builder: (BuildContext context) => HomeScreen(),
            ),
            ModalRoute.withName('/'));
      };
    }

    return Scaffold(
      key: _scaffKey,
      body: Stack(
        children: <Widget>[
          Background(),
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
                      margin: const EdgeInsets.symmetric(vertical: 35),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Bem-Vindo de volta!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: branco,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 3,
                              fontSize: 30,
                            ),
                          ),
                          Text(
                            "Entre para continuar",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: branco,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 3,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          CustomTextField2(
                            controller: _emailController,
                            hint: "email",
                            asSufix: true,
                            isObscure: false,
                            prefix: Icons.mail,
                            keyboard: TextInputType.emailAddress,
                            valid: (String text) {
                              Pattern pattern =
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                              RegExp regex = new RegExp(pattern);
                              if (!regex.hasMatch(text))
                                return 'Introduza um email valido.';
                              else
                                return null;
                            },
                          ),
                          CustomTextField2(
                            controller: _passController,
                            hint: "senha",
                            asSufix: false,
                            isObscure: true,
                            prefix: Icons.lock,
                            keyboard: TextInputType.text,
                            valid: (String text) {
                              if (text.length < 6) {
                                return "Deve conter pelo menos 6 letras";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                      onPressed: !loading
                          ? () async {
                              if (_formKey.currentState.validate()) {
                                setState(
                                  () async {
                                    loading = true;
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
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
                                      BlocProvider.getBloc<UsuarioBloc>()
                                          .entrarEmail(_emailController.text,
                                              _passController.text, _scaffKey)
                                          .then(
                                        (_) {
                                          setState(
                                            () {
                                              loading = false;
                                            },
                                          );
                                        },
                                      );
                                    } else {
                                      loading = false;
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(
                                              _scaffKey.currentContext)
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
                                  },
                                );
                              }
                            }
                          : null,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        alignment: Alignment.center,
                        child: Text(
                          "Entrar",
                          style: TextStyle(fontSize: 24, color: preto),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: transparente,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          )),
                      onPressed: () {
                        _navHome();
                      },
                      child: Container(
                        child: Text(
                          "Esqueceu a senha? recuperar",
                          style: TextStyle(
                            fontSize: 20,
                            color: branco,
                          ),
                        ),
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
