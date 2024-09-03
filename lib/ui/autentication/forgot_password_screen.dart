import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:codigo_de_estrada_mz/blocs/usuario_bloc.dart';
import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:codigo_de_estrada_mz/helpers/conexao.dart';
import 'package:codigo_de_estrada_mz/ui/autentication/widgets/background.dart';
import 'package:codigo_de_estrada_mz/ui/autentication/widgets/custom_text_field2.dart';
import 'package:codigo_de_estrada_mz/ui/utils/screen_notification_utils.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
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
                            "Esqueceu sua senha?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: branco,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 3,
                              fontSize: 30,
                            ),
                          ),
                          Text(
                            "Insira seu e-mail para receber seu código de segurança",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: branco,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 3,
                              fontSize: 22,
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
                            hint: "Email",
                            asSufix: true,
                            isObscure: false,
                            prefix: Icons.mail,
                            keyboard: TextInputType.emailAddress,
                            valid: (String text) {
                              var pattern =
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                              RegExp regex = RegExp(pattern);
                              if (!regex.hasMatch(text)) {
                                return 'Introduza um email valido.';
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
                                    ScreenNotificationUtils().showSnackBar(
                                        context, "Sem conexao a internet.");
                                  }
                                  return;
                                }
                                setState(
                                  () {
                                    loading = true;
                                    ScreenNotificationUtils()
                                        .showLoadingModal(context);
                                    if (_emailController.text.isEmpty) {
                                      if (context.mounted) {
                                        Navigator.of(context)
                                            .pop(); // Close loading modal
                                      }
                                      ScreenNotificationUtils().showSnackBar(
                                          context, "Preencha o campo de email");
                                      loading = false;
                                      return;
                                    }
                                    BlocProvider.getBloc<UsuarioBloc>()
                                        .sendResetPasswordEmail(
                                            _emailController.text, _scaffKey)
                                        .then(
                                      (_) {
                                        setState(
                                          () {
                                            ScreenNotificationUtils()
                                                .showSnackBar(
                                              context,
                                              "Verifique sua caixa de entrada, enviamos um email com instruções para redefinir a senha.",
                                              backgroundColor: Colors.green,
                                            );
                                            loading = false;
                                          },
                                        );
                                      },
                                    );
                                  },
                                );
                              }
                            }
                          : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        alignment: Alignment.center,
                        child: const Text(
                          "Redefinir senha",
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
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Voltar ao login",
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
