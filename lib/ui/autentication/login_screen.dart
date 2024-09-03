import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:codigo_de_estrada_mz/blocs/usuario_bloc.dart';
import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:codigo_de_estrada_mz/helpers/conexao.dart';
import 'package:codigo_de_estrada_mz/ui/autentication/forgot_password_screen.dart';
import 'package:codigo_de_estrada_mz/ui/autentication/widgets/background.dart';
import 'package:codigo_de_estrada_mz/ui/autentication/widgets/custom_text_field2.dart';
import 'package:codigo_de_estrada_mz/ui/home/home_screen.dart';
import 'package:codigo_de_estrada_mz/ui/utils/screen_notification_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

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
          ModalRoute.withName('/'),
        );
      };
    }

    return Scaffold(
      key: _scaffKey,
      body: Stack(
        children: <Widget>[
          const Background(),
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
                      child: const Column(
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
                              if (text.isEmpty) {
                                return 'Campo obrigatório';
                              }
                              var pattern =
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                              RegExp regex = RegExp(pattern);
                              if (!regex.hasMatch(text)) {
                                return 'Introduza um email valido.';
                              }
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
                              if (text.isEmpty) {
                                return 'Campo obrigatório';
                              }
                              if (text.length < 6) {
                                return "Deve conter pelo menos 6 letras";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                      onPressed: !loading
                          ? () async {
                              if (_formKey.currentState!.validate()) {
                                if (!await checkConnection()) {
                                  loading = false;
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                  ScaffoldMessenger.of(
                                          _scaffKey.currentContext!)
                                      .showSnackBar(
                                    const SnackBar(
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
                                  return;
                                }
                                setState(
                                  () {
                                    loading = true;
                                    ScreenNotificationUtils()
                                        .showLoadingModal(context);
                                    if (_emailController.text.isNotEmpty &&
                                        _passController.text.isNotEmpty) {
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
                                      Navigator.of(context).pop();
                                      ScreenNotificationUtils().showSnackBar(
                                          context, "Preencha o formulário");
                                    }
                                  },
                                );
                              }
                            }
                          : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        alignment: Alignment.center,
                        child: const Text(
                          "Entrar",
                          style: TextStyle(fontSize: 24, color: preto),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: transparente,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          )),
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Esqueceu a senha? recuperar",
                        style: TextStyle(
                          fontSize: 20,
                          color: branco,
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
