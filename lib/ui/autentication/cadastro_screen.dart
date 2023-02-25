import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:codigo_de_estrada_mz/blocs/usuario_bloc.dart';
import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:codigo_de_estrada_mz/enums/signup_method.dart';
import 'package:codigo_de_estrada_mz/models/usuario.dart';
import 'package:codigo_de_estrada_mz/ui/autentication/widgets/background.dart';
import 'package:codigo_de_estrada_mz/ui/autentication/widgets/custom_text_field2.dart';
import 'package:codigo_de_estrada_mz/ui/utils/screen_notification_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CadastroScreen extends StatefulWidget {
  final UserCredential userCredencial;
  final SignUpMethod method;
  CadastroScreen({@required this.userCredencial, @required this.method});
  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cellController = TextEditingController();
  final _passController = TextEditingController();
  final _secPassController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scafKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    if (widget.userCredencial != null) {
      String username = widget.userCredencial.user.displayName
          .substring(0, widget.userCredencial.user.displayName.indexOf(" "))
          .toLowerCase();
      _usernameController.text = username;
      _emailController.text = widget.userCredencial.user.email;
      _cellController.text = widget.userCredencial.user.phoneNumber;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafKey,
      body: Stack(
        children: <Widget>[
          Background(),
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 40, bottom: 20),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Bem-Vindo!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: branco,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 3,
                                  fontSize: 30),
                            ),
                            Text(
                              "Faltam poucos passos para finalizar seu cadastro.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: branco,
                                fontWeight: FontWeight.w300,
                                letterSpacing: 3,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomTextField2(
                        controller: _usernameController,
                        hint: "Username",
                        isObscure: false,
                        prefix: Icons.person,
                        keyboard: TextInputType.text,
                        asSufix: false,
                        valid: (String text) {
                          text.toLowerCase();
                          if (text.length < 4)
                            return "Deve conter pelo menos 4 letras";
                          if (text.length > 15)
                            return "O nome deve conter no max 15 letras";
                          if (text.contains(" ")) {
                            return "O texto nao pode ter espaços em branco";
                          }
                          return null;
                        },
                      ),
                      CustomTextField2(
                        controller: _emailController,
                        hint: "Email",
                        isObscure: false,
                        prefix: Icons.mail,
                        keyboard: TextInputType.emailAddress,
                        asSufix: false,
                        valid: (String value) {
                          Pattern pattern =
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                          RegExp regex = new RegExp(pattern);
                          if (!regex.hasMatch(value))
                            return 'Introduza um email valido.';
                          else
                            return null;
                        },
                      ),
                      CustomTextField2(
                        controller: _cellController,
                        hint: "Cell",
                        isObscure: false,
                        prefix: Icons.phone,
                        keyboard: TextInputType.text,
                        asSufix: false,
                        size: 9,
                        valid: (String text) {
                          if (text.length != 9) {
                            return "Deve conter 9 digitos";
                          }
                          return null;
                        },
                      ),
                      widget.method == SignUpMethod.EMAIL
                          ? CustomTextField2(
                              controller: _passController,
                              hint: "Senha",
                              isObscure: true,
                              prefix: Icons.lock,
                              keyboard: TextInputType.text,
                              asSufix: false,
                              valid: (String text) {
                                if (text.length < 6) {
                                  return "Deve conter pelo menos 6 letras";
                                }
                                return null;
                              },
                            )
                          : Container(),
                      widget.method == SignUpMethod.EMAIL
                          ? CustomTextField2(
                              controller: _secPassController,
                              hint: "Confirmar senha",
                              isObscure: true,
                              prefix: Icons.lock,
                              keyboard: TextInputType.text,
                              asSufix: false,
                              valid: (String text) {
                                if (text != _passController.text) {
                                  return "Senha erada";
                                }
                                return null;
                              },
                            )
                          : Container(),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            backgroundColor: branco),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            ScreenNotificationUtils().showLoadingModal(context);
                            if (await BlocProvider.getBloc<UsuarioBloc>()
                                .existeCell(_cellController.text)) {
                              ScreenNotificationUtils().showToast(
                                  "Ja existe um usuario com esse contacto");
                              return;
                            }
                            if (await BlocProvider.getBloc<UsuarioBloc>()
                                .existeUsername(_usernameController.text)) {
                              ScreenNotificationUtils().showToast(
                                  "Ja existe um usuario com esse nome");
                              return;
                            }
                            final Usuario user = Usuario(
                              id: null,
                              email: _emailController.text,
                              cell: _cellController.text,
                              username: _usernameController.text,
                              imgUrl: null,
                              cs: 100,
                              nrTestes: 2,
                              premium: false,
                            );
                            switch (widget.method) {
                              case SignUpMethod.EMAIL:
                                BlocProvider.getBloc<UsuarioBloc>()
                                    .criarContaComEmail(
                                  dados: user,
                                  pass: _passController.text,
                                  key: _scafKey,
                                );
                                break;
                              case SignUpMethod.FACEBOOK:
                              case SignUpMethod.GOOGLE:
                                BlocProvider.getBloc<UsuarioBloc>()
                                    .criarContaComMedia(
                                  dados: user,
                                  result: widget.userCredencial,
                                  key: _scafKey,
                                );
                                break;
                            }
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          alignment: Alignment.center,
                          child: Text(
                            "Finalizar cadastro",
                            style: TextStyle(fontSize: 20.0, color: preto),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Ao clicar em \"Finalizar cadastro\" voce concorda com nossos Termos de uso e nossa Política de privacidade.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: branco, fontSize: 18),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
