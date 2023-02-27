import 'dart:async';
import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:codigo_de_estrada_mz/enums/app_session_status.dart';
import 'package:codigo_de_estrada_mz/enums/signup_method.dart';
import 'package:codigo_de_estrada_mz/helpers/conexao.dart';
import 'package:codigo_de_estrada_mz/helpers/usuario_helper.dart';
import 'package:codigo_de_estrada_mz/models/usuario.dart';
import 'package:codigo_de_estrada_mz/ui/autentication/cadastro_screen.dart';
import 'package:codigo_de_estrada_mz/ui/autentication/criar_conta_auth.dart';
import 'package:codigo_de_estrada_mz/ui/autentication/login_screen.dart';
import 'package:codigo_de_estrada_mz/ui/autentication/widgets/auth_view.dart';
import 'package:codigo_de_estrada_mz/ui/home/home_screen.dart';
import 'package:codigo_de_estrada_mz/ui/utils/common_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
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

  Future<AppSessionStatus> sessionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    int estadoHelper;
    try {
      estadoHelper = prefs.getInt(APP_CONSTANTS.SESSION_STATE);
    } catch (e) {}

    if (estadoHelper != null && estadoHelper >= 0) {
      if (estadoHelper == 0) {
        prefs.remove(APP_CONSTANTS.SESSION_STATE);
        prefs.setString(APP_CONSTANTS.SESSION_STATE,
            AppSessionStatus.NOT_LOGGED_IN.toString());
        return AppSessionStatus.NOT_LOGGED_IN;
      }
      prefs.remove(APP_CONSTANTS.SESSION_STATE);
      prefs.setString(
          APP_CONSTANTS.SESSION_STATE, AppSessionStatus.LOGGED_IN.toString());
      return AppSessionStatus.LOGGED_IN;
    }
    AppSessionStatus estado = AppSessionStatus.values.firstWhere(
        (element) =>
            element.toString() == prefs.getString(APP_CONSTANTS.SESSION_STATE),
        orElse: () => AppSessionStatus.NOT_LOGGED_IN);

    if (estado == null) return AppSessionStatus.NOT_LOGGED_IN;
    return estado;
  }

  Future<AppSessionStatus> offlineLogin() async {
    switch (await sessionStatus()) {
      case AppSessionStatus.LOGGED_IN:
        await userHelper.getTodosusuarios().then((usuario) {
          this.userData = usuario[0];
        });
        _userController.sink.add(userData);
        return AppSessionStatus.LOGGED_IN;
      default:
        return AppSessionStatus.NOT_LOGGED_IN;
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

  Future<Null> facebookAuthentication(GlobalKey<ScaffoldState> key) async {
    final LoginResult result = await FacebookAuth.instance.login(
      permissions: ['public_profile', 'email'],
    );
    switch (result.status) {
      case LoginStatus.success:
        _firebaseAuthWithFacebook(accessToken: result.accessToken, key: key);
        return;
      case LoginStatus.cancelled:
        Navigator.pop(key.currentContext);
        return;
      case LoginStatus.failed:
        Navigator.pop(key.currentContext);
        return;
      default:
        return null;
    }
  }

  _firebaseAuthWithFacebook(
      {@required AccessToken accessToken,
      @required GlobalKey<ScaffoldState> key}) async {
    final AuthCredential facebookCredential =
        FacebookAuthProvider.credential(accessToken.token);
    try {
      final userCredential =
          await _auth.signInWithCredential(facebookCredential);
      _finishAuthProcess(userCredential, SignUpMethod.FACEBOOK, key);
    } catch (error) {
      switch (error.code) {
        case "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL":
          _snackBar(
              key, "Esta conta já foi criada usando outro método (provedor).");
          break;
        case "ERROR_CREDENTIAL_ALREADY_IN_USE":
          _snackBar(key, "Esta conta já existe");
          break;
        case "ERROR_EMAIL_ALREADY_IN_USE":
          _snackBar(key, "Esta conta ja está sendo usada.");
          break;
        case "account-exists-with-different-credential":
          List<String> emailList =
              await _auth.fetchSignInMethodsForEmail(error.email);
          if (emailList.first == "google.com") {
            await googleAuthentication(key);
          }
          break;
        default:
          _snackBar(key, "Não foi possivel criar uma conta.");
      }
      await resetLOGS();
    }
  }

  Future<Null> googleAuthentication(GlobalKey<ScaffoldState> key) async {
    final GoogleSignIn gglSign = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    GoogleSignInAccount googleUser = gglSign.currentUser;
    try {
      if (await gglSign.isSignedIn()) {
        if (googleUser == null) {
          googleUser = await gglSign.signInSilently(suppressErrors: false);
        }
      }
      if (googleUser == null) await gglSign.signIn();
      GoogleSignInAuthentication credenciais =
          await gglSign.currentUser.authentication;
      UserCredential userCredential = await _auth.signInWithCredential(
        GoogleAuthProvider.credential(
            idToken: credenciais.idToken, accessToken: credenciais.accessToken),
      );
      _finishAuthProcess(userCredential, SignUpMethod.GOOGLE, key);
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
      prefs.setString(
          APP_CONSTANTS.SESSION_STATE, AppSessionStatus.LOGGED_IN.toString());
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
    prefs.setString(
        APP_CONSTANTS.SESSION_STATE, AppSessionStatus.NOT_LOGGED_IN.toString());
  }

  logout(BuildContext context) async {
    await _auth.signOut();
    firebaseUser = null;
    await userHelper.deleteUsuario(userData.id);
    userData = null;
    _userController.sink.add(userData);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        APP_CONSTANTS.SESSION_STATE, AppSessionStatus.NOT_LOGGED_IN.toString());
    Navigator.of(context).pushReplacement(
      CupertinoPageRoute(
        builder: (context) => AuthView(
          isLogin: true,
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
    prefs.setString(
        APP_CONSTANTS.SESSION_STATE, AppSessionStatus.LOGGED_IN.toString());
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
    CommonUtils().popUntilRoot(key.currentContext);
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

  void _finishAuthProcess(UserCredential userCredential, SignUpMethod method,
      GlobalKey<ScaffoldState> key) async {
    if (await existeEmail(userCredential.user.email)) {
      firebaseUser = userCredential.user;
      this.userData = await getUserData();
      await userHelper.salvarUsuario(userData);
      _userController.sink.add(userData);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(
          APP_CONSTANTS.SESSION_STATE, AppSessionStatus.LOGGED_IN.toString());
      _authDone(key);
    } else {
      CommonUtils().popUntilRoot(key.currentContext);
      Navigator.pushReplacement(
        key.currentContext,
        CupertinoPageRoute(
          builder: (context) => CadastroScreen(
            userCredencial: userCredential,
            method: method,
          ),
        ),
      );
    }
  }
}
