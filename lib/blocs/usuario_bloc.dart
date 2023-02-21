import 'dart:async';
import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:codigo_de_estrada_mz/helpers/conexao.dart';
import 'package:codigo_de_estrada_mz/helpers/usuario_helper.dart';
import 'package:codigo_de_estrada_mz/models/usuario.dart';
import 'package:codigo_de_estrada_mz/ui/autentication/criar_conta_auth.dart';
import 'package:codigo_de_estrada_mz/ui/autentication/login_screen.dart';
import 'package:codigo_de_estrada_mz/ui/autentication/widgets/auth_view.dart';
import 'package:codigo_de_estrada_mz/ui/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthProblems { UserNotFound, PasswordNotValid, NetworkError }

class UsuarioBloc extends BlocBase {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User firebaseUser;
  Usuario userData;
  Map<String, dynamic> presentes = {'novo': false};
  UsuarioHelper userHelper = UsuarioHelper();
  final StreamController _userController = BehaviorSubject<Usuario>();
  Stream get outUsuario => _userController.stream;

  userSink() {
    _userController.sink.add(userData);
  }

  fullUpdateUser() async {
    userHelper.updateUsuario(userData);
    userSink();
    if (await checkConnection()) {
      await updateUserData();
    }
  }

  @override
  void dispose() {
    _userController.close();
    super.dispose();
  }

  Future<int> estadoSessao() async {
    final prefs = await SharedPreferences.getInstance();
    int estado = prefs.getInt("EstadoDaSessao");
    if (estado == null) return 0;
    return estado;
  }

  Future<int> offlineLogin() async {
    switch (await estadoSessao()) {
      case 1:
        await userHelper.getTodosusuarios().then((usuario) {
          this.userData = usuario[0];
        });
        _userController.sink.add(userData);
        return 1;
      default:
        return 0;
    }
  }

  autoLogin() {}
  Future<Null> criarContaComEmail(
      {@required Usuario dados,
      @required String pass,
      @required GlobalKey<ScaffoldState> key}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: dados.email, password: pass);

      await saveUserData(dados, result);
      await result.user.sendEmailVerification();
      _snackBar(key,
          "Usuario cadastrado com sucesso. Verique seu email para poder entrar.");

      Navigator.pop(key.currentContext);
      Navigator.pop(key.currentContext);
      Navigator.of(key.currentContext).push(
        CupertinoPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    } catch (e) {
      if (Platform.isAndroid) {
        Navigator.pop(key.currentContext);
        switch (e.message) {
          case 'The email address is already in use by another account.':
            _snackBar(key, "Esse email já está sendo usado.");
            break;
          default:
            _snackBar(key, "Não foi possivel criar uma conta.");
        }
      }
    }
  }

  Future<Null> criarContaComMedia(
      {@required Usuario dados,
      @required UserCredential result,
      @required GlobalKey<ScaffoldState> key}) async {
    await saveUserData(dados, result);
    _authDone(key);
  }

  Future<Null> criarContaFacebook(GlobalKey<ScaffoldState> key) async {
    // final FacebookLogin fbLogin = FacebookLogin();
    // final facebookLoginResult =
    //     await fbLogin.logIn(['email', 'public_profile']);

    // switch (facebookLoginResult.status) {
    //   case FacebookLoginStatus.error:
    //     Navigator.pop(key.currentContext);
    //     break;
    //   case FacebookLoginStatus.cancelledByUser:
    //     Navigator.pop(key.currentContext);
    //     break;
    //   case FacebookLoginStatus.loggedIn:
    //     await _firebaseAuthWithFacebook(
    //         token: facebookLoginResult.accessToken, key: key);
    // }
  }

  // _firebaseAuthWithFacebook(
  //     { //@required FacebookAccessToken token,
  //     @required GlobalKey<ScaffoldState> key}) async {
  //   // AuthCredential credential =
  //   //     FacebookAuthProvider.getCredential(accessToken: token.token);

  //   try {
  //     // AuthResult user = await _auth.signInWithCredential(credential);
  //     // if (await existeEmail(user.user.email)) {
  //     //   firebaseUser = user.user;
  //     //   this.userData = await getUserData();
  //     //   await userHelper.salvarUsuario(userData);
  //     //   _userController.sink.add(userData);
  //     //   final prefs = await SharedPreferences.getInstance();
  //     //   prefs.setInt("EstadoDaSessao", 1);
  //     //   _authDone(key);
  //     // } else {
  //     //   Navigator.pop(key.currentContext);
  //     //   Navigator.of(key.currentContext).push(
  //     //     CupertinoPageRoute(
  //     //       builder: (context) => CadastroScreen(
  //     //         user: user,
  //     //         metodo: "facebook",
  //     //       ),
  //     //     ),
  //     //   );
  //     // }
  //   } catch (error) {
  //     Navigator.pop(key.currentContext);
  //     switch (error.code) {
  //       case "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL":
  //         _snackBar(
  //             key, "Esta conta já foi criada usando outro método (provedor).");
  //         break;
  //       case "ERROR_CREDENTIAL_ALREADY_IN_USE":
  //         _snackBar(key, "Esta conta já existe");
  //         break;
  //       case "ERROR_EMAIL_ALREADY_IN_USE":
  //         _snackBar(key, "Esta conta ja está sendo usada.");
  //         break;
  //       default:
  //         _snackBar(key, "Não foi possivel criar uma conta.");
  //     }
  //     await resetLOGS();
  //   }
  // }

  Future<Null> criarContaGoogle(GlobalKey<ScaffoldState> key) async {
    // final GoogleSignIn gglSign = GoogleSignIn();
    // GoogleSignInAccount user = gglSign.currentUser;
    // try {
    //   if (user == null) user = await gglSign.signIn();
    //   if (await _auth.currentUser() == null) {
    //     GoogleSignInAuthentication credenciais =
    //         await gglSign.currentUser.authentication;
    //     AuthResult user = await _auth.signInWithCredential(
    //       GoogleAuthProvider.getCredential(
    //           idToken: credenciais.idToken,
    //           accessToken: credenciais.accessToken),
    //     );
    //     if (await existeEmail(user.user.email)) {
    //       firebaseUser = user.user;
    //       this.userData = await getUserData();
    //       await userHelper.salvarUsuario(userData);
    //       _userController.sink.add(userData);
    //       final prefs = await SharedPreferences.getInstance();
    //       prefs.setInt("EstadoDaSessao", 1);
    //       _authDone(key);
    //     } else {
    //       Navigator.pop(key.currentContext);
    //       Navigator.of(key.currentContext).push(
    //         CupertinoPageRoute(
    //           builder: (context) => CadastroScreen(
    //             user: user,
    //             metodo: "google",
    //           ),
    //         ),
    //       );
    //     }
    //   }
    // } catch (error) {
    //   Navigator.pop(key.currentContext);
    //   switch (error.code) {
    //     case "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL":
    //       _snackBar(
    //           key, "Esta conta já foi criada usando outro método (provedor).");
    //       break;
    //     case "ERROR_CREDENTIAL_ALREADY_IN_USE":
    //       _snackBar(key, "Esta conta já existe");
    //       break;
    //     case "ERROR_EMAIL_ALREADY_IN_USE":
    //       _snackBar(key, "Esta conta ja está sendo usada.");
    //       break;
    //     default:
    //       _snackBar(key, "Não foi possivel criar uma conta.");
    //   }
    //   await resetLOGS();
    //   print(error.message);
    // }
  }

  Future<Null> entrarGoogle(GlobalKey<ScaffoldState> key) async {
    final GoogleSignIn gglSign = GoogleSignIn();
    GoogleSignInAccount user;
    user = gglSign.currentUser;
    try {
      if (await gglSign.isSignedIn()) {
        if (user == null) {
          user = await gglSign.signInSilently(suppressErrors: false);
        }
        if (user == null) await gglSign.signIn();
        // if (await _auth.currentUser() == null) {
        //   GoogleSignInAuthentication credenciais =
        //       await gglSign.currentUser.authentication;
        //   AuthResult user = await _auth.signInWithCredential(
        //     GoogleAuthProvider.getCredential(
        //         idToken: credenciais.idToken,
        //         accessToken: credenciais.accessToken),
        //   );
        //   if (await verifyUser(user.user.uid)) {
        //     firebaseUser = user.user;
        //     this.userData = await getUserData();
        //     await userHelper.salvarUsuario(userData);
        //     _userController.sink.add(userData);
        //     final prefs = await SharedPreferences.getInstance();
        //     prefs.setInt("EstadoDaSessao", 1);
        //     _authDone(key);
        //   } else {
        //     Navigator.pop(key.currentContext);
        //     Navigator.of(key.currentContext).push(
        //       CupertinoPageRoute(
        //         builder: (context) => CadastroScreen(
        //           user: user,
        //           metodo: "google",
        //         ),
        //       ),
        //     );
        //   }
        // }
      } else {
        if (user == null) await gglSign.signIn();
        // if (await _auth.currentUser() == null) {
        //   GoogleSignInAuthentication credenciais =
        //       await gglSign.currentUser.authentication;
        //   AuthResult user = await _auth.signInWithCredential(
        //     GoogleAuthProvider.getCredential(
        //         idToken: credenciais.idToken,
        //         accessToken: credenciais.accessToken),
        //   );
        //   if (await verifyUser(user.user.uid)) {
        //     firebaseUser = user.user;
        //     this.userData = await getUserData();
        //     await userHelper.salvarUsuario(userData);
        //     _userController.sink.add(userData);
        //     final prefs = await SharedPreferences.getInstance();
        //     prefs.setInt("EstadoDaSessao", 1);
        //     _authDone(key);
        //   } else {
        //     Navigator.pop(key.currentContext);
        //     Navigator.of(key.currentContext).push(
        //       CupertinoPageRoute(
        //         builder: (context) => CadastroScreen(
        //           user: user,
        //           metodo: "google",
        //         ),
        //       ),
        //     );
        //   }
        // }
        if (!await gglSign.isSignedIn()) {
          Navigator.pop(key.currentContext);
          _snackBar(key,
              "Não foi possível fazer o login, certifique se de criar uma conta.");
          Future.delayed(Duration(seconds: 3)).then((value) {
            Navigator.of(key.currentContext).pushReplacement(
              CupertinoPageRoute(
                builder: (context) => CriarContaAuth(),
              ),
            );
          });
        }
      }
    } catch (error) {
      Navigator.pop(key.currentContext);
      try {
        switch (error.code) {
          case "ERROR_USER_NOT_FOUND":
            _snackBar(key, "Não existe nenhum usuario em estas credenciais");
            break;
          default:
            _snackBar(key,
                "Não foi possível fazer o login, certifique se de criar uma conta.");
        }
      } catch (error) {
        _snackBar(key,
            "Não foi possível fazer o login, certifique se de criar uma conta.");
        Future.delayed(Duration(seconds: 3)).then((value) {
          Navigator.of(key.currentContext).pushReplacement(
            CupertinoPageRoute(
              builder: (context) => CriarContaAuth(),
            ),
          );
        });
      }
    }
  }

  Future<Null> entrarFacebook(GlobalKey<ScaffoldState> key) async {
    try {
      // final FacebookLogin fbLogin = FacebookLogin();
      // final facebookLoginResult =
      //     await fbLogin.logIn(['email', 'public_profile']);
      // switch (facebookLoginResult.status) {
      //   case FacebookLoginStatus.error:
      //     Navigator.pop(key.currentContext);
      //     _snackBar(key, "Não foi possível fazer o login, Ocorreu algum erro.");
      //     Future.delayed(Duration(seconds: 3)).then((value) {
      //       Navigator.of(key.currentContext).pushReplacement(
      //         CupertinoPageRoute(
      //           builder: (context) => CriarContaAuth(),
      //         ),
      //       );
      //     });
      //     break;
      //   case FacebookLoginStatus.cancelledByUser:
      //     break;
      //   case FacebookLoginStatus.loggedIn:
      //     if (await fbLogin.isLoggedIn) {
      //       AuthCredential credential = FacebookAuthProvider.getCredential(
      //           accessToken: facebookLoginResult.accessToken.token);
      //       AuthResult user = await _auth.signInWithCredential(credential);

      //       if (await verifyUser(user.user.uid)) {
      //         firebaseUser = user.user;
      //         this.userData = await getUserData();
      //         await userHelper.salvarUsuario(userData);
      //         _userController.sink.add(userData);
      //         final prefs = await SharedPreferences.getInstance();
      //         prefs.setInt("EstadoDaSessao", 1);
      //         _authDone(key);
      //       } else {
      //         await resetLOGS();
      //         Navigator.pop(key.currentContext);
      //         Navigator.of(key.currentContext).push(
      //           CupertinoPageRoute(
      //             builder: (context) => CadastroScreen(
      //               user: user,
      //               metodo: "facebook",
      //             ),
      //           ),
      //         );
      //       }
      //     } else {
      //       Navigator.pop(key.currentContext);
      //       _snackBar(key,
      //           "Não foi possível fazer o login, certifique se de criar uma conta.");
      //       Future.delayed(Duration(seconds: 3)).then((value) {
      //         Navigator.of(key.currentContext).pushReplacement(
      //           CupertinoPageRoute(
      //             builder: (context) => CriarContaAuth(),
      //           ),
      //         );
      //       });
      //     }
      // }
    } catch (e) {
      Navigator.pop(key.currentContext);

      try {
        switch (e.code) {
          case "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL":
            _snackBar(key,
                "Esta conta já foi criada usando outro método (provedor).");
            break;
          case "ERROR_CREDENTIAL_ALREADY_IN_USE":
            _snackBar(key, "Esta conta já existe");
            break;
          case "ERROR_EMAIL_ALREADY_IN_USE":
            _snackBar(key, "Esta conta ja está sendo usada.");
            break;
          default:
            _snackBar(key,
                "Não foi possível fazer o login, certifique se de criar uma conta.");
        }
      } catch (error) {
        _snackBar(key,
            "Não foi possível fazer o login, certifique se de criar uma conta.");
        Future.delayed(Duration(seconds: 3)).then((value) {
          Navigator.of(key.currentContext).pushReplacement(
            CupertinoPageRoute(
              builder: (context) => CriarContaAuth(),
            ),
          );
        });
      }
    }
  }

  Future<Null> entrarEmail(
      String email, String pass, GlobalKey<ScaffoldState> key) async {
    try {
      UserCredential authResult =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      firebaseUser = authResult.user;
      this.userData = await getUserData();
      await userHelper.salvarUsuario(userData);
      _userController.sink.add(userData);
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt("EstadoDaSessao", 1);
      _authDone(key);
    } on PlatformException catch (e) {
      Navigator.pop(key.currentContext);
      Navigator.pop(key.currentContext);
      AuthProblems errorType;
      if (Platform.isAndroid) {
        switch (e.message) {
          case 'There is no user record corresponding to this identifier. The user may have been deleted.':
            errorType = AuthProblems.UserNotFound;
            ScaffoldMessenger.of(key.currentContext).showSnackBar(
              SnackBar(
                content: Text(
                  "Verifique seu email, nao existe nenhum usuario com esse email.",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w300, color: branco),
                ),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2),
              ),
            );
            break;
          case 'The password is invalid or the user does not have a password.':
            errorType = AuthProblems.PasswordNotValid;
            ScaffoldMessenger.of(key.currentContext).showSnackBar(
              SnackBar(
                content: Text(
                  "Senha errada. Tente novamente.",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w300, color: branco),
                ),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2),
              ),
            );
            break;
          case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
            errorType = AuthProblems.NetworkError;
            ScaffoldMessenger.of(key.currentContext).showSnackBar(
              SnackBar(
                content: Text(
                  "Erro ao tentar conectar",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w300, color: branco),
                ),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2),
              ),
            );
            break;
          // ...
          default:
            print('Case ${e.message} is not yet implemented');
        }
        print('The error is $errorType');
      }
    } catch (e) {
      Navigator.pop(key.currentContext);
      print("Podre:  $e");
    }
  }

  resetLOGS() async {
    try {
      await _auth.signOut();
    } catch (e) {}
    // firebaseUser = null;
    try {
      await userHelper.deleteUsuario(userData.id);
    } catch (e) {}
    userData = null;
    _userController.sink.add(userData);
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("EstadoDaSessao", 0);
  }

  logout(BuildContext context) async {
    await _auth.signOut();
    firebaseUser = null;
    await userHelper.deleteUsuario(userData.id);
    userData = null;
    _userController.sink.add(userData);
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("EstadoDaSessao", 0);
    Navigator.of(context).pushReplacement(
      CupertinoPageRoute(
        builder: (context) => AuthView(
          login: true,
        ),
      ),
    );
  }

  apagarTabela() {
    userHelper.apagarTabela();
  }

  bool isLogued() {
    // if (firebaseUser != null) return true;
    return false;
  }

  Future<Null> saveUserData(Usuario dados, UserCredential user) async {
    firebaseUser = user.user;
    dados.id = firebaseUser.uid;
    dados.imgUrl = user.user.photoURL;
    this.userData = dados;
    await FirebaseFirestore.instance
        .collection("usuarios")
        .doc(firebaseUser.uid)
        .set(dados.toMap(forDB: false));
    await userHelper.salvarUsuario(userData);
    _userController.sink.add(userData);
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("EstadoDaSessao", 1);
  }

  Future<Null> updateUserData() async {
    FirebaseFirestore.instance
        .collection("usuarios")
        .doc(userData.id)
        .update(userData.toMap(forDB: false));
  }

  Future<bool> verifyUser(String uid) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection("usuarios").doc(uid).get();
    return snapshot.exists;
  }

  _authDone(GlobalKey<ScaffoldState> key) {
    Navigator.pop(key.currentContext);
    Navigator.of(key.currentContext).pushReplacement(
      CupertinoPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  }

  Future<Usuario> getUserData() async {
    DocumentSnapshot document = await FirebaseFirestore.instance
        .collection("usuarios")
        .doc(firebaseUser.uid)
        .get();
    return Usuario.fromJson(document.data());
  }

  Future<bool> existeCell(String cell) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("usuarios")
        .where("cell", isEqualTo: cell)
        .get();
    return !snapshot.docs.isEmpty;
  }

  Future<bool> getPresentes() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("presentes")
        .where("username", isEqualTo: userData.username)
        .get();
    if (snapshot.docs.isEmpty)
      presentes['novo'] = false;
    else {
      List<Map<String, dynamic>> gifts = [];
      Map<String, dynamic> gift;
      snapshot.docs.forEach((document) {
        print(document.get("colected"));
        if (!document.get("colected")) {
          gift = Map<String, dynamic>();
          gift['documentID'] = document.get("documentID");
          gift['texto'] = document.get("texto");
          if (document.get("premium"))
            gift['premium'] = document.get("premium");
          if (document.get("cs")) gift['cs'] = document.get("cs");
          gifts.add(gift);
        }
      });
      if (gifts.isNotEmpty) {
        presentes['novo'] = true;
        presentes['premios'] = gifts;
        return true;
      } else {
        presentes['novo'] = false;
      }
    }
    return false;
  }

  Future<bool> getPrecos() async {
    DocumentSnapshot precos = await FirebaseFirestore.instance
        .collection("config")
        .doc('precos')
        .get();
    List<int> precario = precos['precario'];
    Map<String, dynamic> descontos = precos['desconto'];

    return false;
  }

  Future<bool> coletarPresente(
      BuildContext context, Map<String, dynamic> gift) async {
    bool premium = false;
    FirebaseFirestore.instance
        .collection("presentes")
        .doc(gift['documentID'])
        .update({'colected': true});
    await getPresentes();
    if (gift.containsKey('premium')) {
      userData.premium = gift['premium'];
      premium = true;
    }
    if (gift.containsKey('cs')) {
      userData.cs += gift['cs'];
    }
    await fullUpdateUser();
    Navigator.pop(context);
    Navigator.pop(context);
    return premium;
  }

  Future<bool> existeUsername(String username) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("usuarios")
        .where("username", isEqualTo: username)
        .get();
    return !snapshot.docs.isEmpty;
  }

  Future<bool> existeEmail(String email) async {
    QuerySnapshot docs = await FirebaseFirestore.instance
        .collection("usuarios")
        .where("email", isEqualTo: email)
        .get();
    return !docs.docs.isEmpty;
  }

  void _snackBar(GlobalKey<ScaffoldState> key, String message) {
    ScaffoldMessenger.of(key.currentContext).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w300, color: branco),
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 4),
      ),
    );
  }

  recuperarConta() {}
}
