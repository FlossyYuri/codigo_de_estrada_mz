import 'dart:async';
import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
import 'package:codigo_de_estrada_mz/ui/utils/screen_notification_utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthProblems { UserNotFound, PasswordNotValid, NetworkError }

class UsuarioBloc extends BlocBase {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? firebaseUser;
  Usuario? userData;
  Map<String, dynamic> presentes = {'novo': false};
  UsuarioHelper userHelper = UsuarioHelper();
  final StreamController _userController = BehaviorSubject<Usuario>();
  Stream<Usuario> get outUsuario => _userController.stream as Stream<Usuario>;

  userSink() {
    _userController.sink.add(userData);
  }

  fullUpdateUser() async {
    userHelper.updateUsuario(userData!);
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

    AppSessionStatus estado = AppSessionStatus.values.firstWhere(
        (element) =>
            element.toString() == prefs.getString(APP_CONSTANTS.SESSION_STATE),
        orElse: () => AppSessionStatus.NOT_LOGGED_IN);
    return estado;
  }

  Future<AppSessionStatus> offlineLogin() async {
    switch (await sessionStatus()) {
      case AppSessionStatus.LOGGED_IN:
        await userHelper.getTodosusuarios().then((usuario) async {
          try {
            userData = usuario[0];
          } catch (e) {
            final prefs = await SharedPreferences.getInstance();
            prefs.clear();
          }
        });
        if (userData != null) {
          _userController.sink.add(userData);
        } else {
          return AppSessionStatus.NOT_LOGGED_IN;
        }
        return AppSessionStatus.LOGGED_IN;
      default:
        return AppSessionStatus.NOT_LOGGED_IN;
    }
  }

  autoLogin() {}
  Future<Null> criarContaComEmail(
      {required Usuario dados,
      required String pass,
      required GlobalKey<ScaffoldState> key}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: dados.email, password: pass);
      await saveUserData(dados, result);
      await result.user?.sendEmailVerification();
      ScreenNotificationUtils().showSnackBar(key.currentContext!,
          "Usuario cadastrado com sucesso. Verique seu email para poder entrar.");

      if (key.currentContext != null && key.currentContext!.mounted) {
        Navigator.pop(key.currentContext!);
        Navigator.pop(key.currentContext!);
        Navigator.of(key.currentContext!).push(
          CupertinoPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      }
    } catch (e) {
      if (Platform.isAndroid) {
        Navigator.pop(key.currentContext!);
        if (e is FirebaseAuthException) {
          switch (e.code) {
            case 'email-already-in-use':
              ScreenNotificationUtils().showSnackBar(
                  key.currentContext!, "Esse email já está sendo usado.");
              break;
            default:
              ScreenNotificationUtils().showSnackBar(
                  key.currentContext!, "Não foi possivel criar uma conta.");
          }
        } else {
          ScreenNotificationUtils()
              .showSnackBar(key.currentContext!, "Ocorreu um erro inesperado.");
          print('-----------------');
          print(e);
        }
      }
    }
  }

  Future<Null> criarContaComMedia(
      {required Usuario dados,
      required UserCredential result,
      required GlobalKey<ScaffoldState> key}) async {
    await saveUserData(dados, result);
    _authDone(key);
  }

  Future<Null> facebookAuthentication(GlobalKey<ScaffoldState> key) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['public_profile', 'email'],
      );
      switch (result.status) {
        case LoginStatus.success:
          _firebaseAuthWithFacebook(accessToken: result.accessToken!, key: key);
          return;
        case LoginStatus.cancelled:
          Navigator.pop(key.currentContext!);
          return;
        case LoginStatus.failed:
          Navigator.pop(key.currentContext!);
          return;
        default:
          return null;
      }
    } catch (e) {
      print('-------------');
      print(e);
    }
  }

  _firebaseAuthWithFacebook(
      {required AccessToken accessToken,
      required GlobalKey<ScaffoldState> key}) async {
    final AuthCredential facebookCredential =
        FacebookAuthProvider.credential(accessToken.tokenString);
    try {
      final userCredential =
          await _auth.signInWithCredential(facebookCredential);
      _finishAuthProcess(userCredential, SignUpMethod.FACEBOOK, key);
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "account-exists-with-different-credential":
          ScreenNotificationUtils().showSnackBar(key.currentContext!,
              "Esta conta já foi criada usando outro método. Tentando Login com Google...");

          // Handling the specific case where the account exists with a Google credential
          final email = error.email;
          if (email != null) {
            final List<String> methods =
                await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
            if (methods.isNotEmpty && methods.first == "google.com") {
              await googleAuthentication(key);
            }
          }
          break;
        case "credential-already-in-use":
          ScreenNotificationUtils()
              .showSnackBar(key.currentContext!, "Esta conta já existe");
          break;
        case "email-already-in-use":
          ScreenNotificationUtils().showSnackBar(
              key.currentContext!, "Esta conta ja está sendo usada.");
          break;
        default:
          ScreenNotificationUtils().showSnackBar(key.currentContext!,
              "Não foi possivel criar uma conta: ${error.message}");
      }
    } catch (error) {
      ScreenNotificationUtils().showSnackBar(
          key.currentContext!, "Ocorreu um erro inesperado: $error");
    } finally {
      await resetLOGS();
    }
  }

  Future<Null> googleAuthentication(GlobalKey<ScaffoldState> key) async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    try {
      if (await googleSignIn.isSignedIn()) {}
      GoogleSignInAuthentication? credenciais =
          await googleUser?.authentication;
      UserCredential userCredential = await _auth.signInWithCredential(
        GoogleAuthProvider.credential(
            idToken: credenciais?.idToken,
            accessToken: credenciais?.accessToken),
      );
      _finishAuthProcess(userCredential, SignUpMethod.GOOGLE, key);
      if (!await googleSignIn.isSignedIn()) {
        Navigator.pop(key.currentContext!);
        ScreenNotificationUtils().showSnackBar(key.currentContext!,
            "Não foi possível fazer o login, certifique se de criar uma conta.");
        Future.delayed(const Duration(seconds: 3)).then((value) {
          Navigator.of(key.currentContext!).pushReplacement(
            CupertinoPageRoute(
              builder: (context) => CriarContaAuth(),
            ),
          );
        });
      }
    } on FirebaseAuthException catch (error) {
      Navigator.pop(key.currentContext!);
      try {
        switch (error.code) {
          case "user-not-found":
            ScreenNotificationUtils().showSnackBar(key.currentContext!,
                "Não existe nenhum usuario em estas credenciais");
            break;
          default:
            ScreenNotificationUtils().showSnackBar(key.currentContext!,
                "Não foi possível fazer o login, certifique se de criar uma conta.");
        }
      } catch (error) {
        ScreenNotificationUtils().showSnackBar(key.currentContext!,
            "Não foi possível fazer o login, certifique se de criar uma conta.");
        Future.delayed(const Duration(seconds: 3)).then((value) {
          Navigator.of(key.currentContext!).pushReplacement(
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
      userData = await getUserData();
      await userHelper.salvarUsuario(userData!);
      _userController.sink.add(userData);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(
          APP_CONSTANTS.SESSION_STATE, AppSessionStatus.LOGGED_IN.toString());
      _authDone(key);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(key.currentContext!);
      String currentError = "";

      switch (e.code) {
        case 'user-not-found':
          currentError = "Nenhum usuário encontrado com esse e-mail.";
          break;
        case 'wrong-password':
          currentError = "Credenciais erradas. tente novamente.";
          break;
        case 'invalid-email':
          currentError = "The email address is not valid.";
          break;
        case 'user-disabled':
          currentError =
              "Esta conta foi desativada. Entre em contato com o suporte.";
          break;
        case 'too-many-requests':
          currentError =
              "Muitas tentativas de login. Por favor, tente novamente mais tarde.";
          break;
        default:
          currentError = "Occoreu algum erro: ${e.message}";
      }
      ScreenNotificationUtils().showSnackBar(key.currentContext!, currentError);
    } catch (e) {
      Navigator.pop(key.currentContext!);
      print("Podre:  $e");
    }
  }

  Future<Null> sendResetPasswordEmail(
      String email, GlobalKey<ScaffoldState> key) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      CommonUtils().popUntilRoot(key.currentContext!);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(key.currentContext!);
      String currentError = "";

      switch (e.code) {
        case 'user-not-found':
          currentError = "Nenhum usuário encontrado com esse e-mail.";
          break;
        default:
          currentError = "Occoreu algum erro: ${e.message}";
      }
      ScreenNotificationUtils().showSnackBar(key.currentContext!, currentError);
    } catch (e) {
      Navigator.pop(key.currentContext!);
      print("Podre:  $e");
    }
  }

  resetLOGS() async {
    try {
      await _auth.signOut();
    } catch (e) {}
    // firebaseUser = null;
    try {
      await userHelper.deleteUsuario(userData!.id!);
    } catch (e) {}
    userData = null;
    _userController.sink.done;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        APP_CONSTANTS.SESSION_STATE, AppSessionStatus.NOT_LOGGED_IN.toString());
  }

  logout(BuildContext context) async {
    await _auth.signOut();
    firebaseUser = null;
    await userHelper.deleteUsuario(userData!.id!);
    userData = null;
    _userController.sink.done;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        APP_CONSTANTS.SESSION_STATE, AppSessionStatus.NOT_LOGGED_IN.toString());
    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        CupertinoPageRoute(
          builder: (context) => AuthView(
            isLogin: true,
          ),
        ),
      );
    }
  }

  apagarTabela() {
    userHelper.apagarTabela();
  }

  bool isLogued() {
    // if (firebaseUser != null) return true;
    return false;
  }

  Future<Null> saveUserData(Usuario dados, UserCredential user) async {
    try {
      firebaseUser = user.user;
      dados.id = firebaseUser?.uid;
      dados.imgUrl = user.user?.photoURL;
      userData = dados;
      await FirebaseFirestore.instance
          .collection("usuarios")
          .doc(firebaseUser?.uid)
          .set(dados.toMap(forDB: false) as Map<String, dynamic>);
      await userHelper.salvarUsuario(userData!);
      _userController.sink.add(userData);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(
          APP_CONSTANTS.SESSION_STATE, AppSessionStatus.LOGGED_IN.toString());
    } catch (e) {
      _auth.currentUser?.delete();
    }
  }

  Future<Null> updateUserData() async {
    FirebaseFirestore.instance
        .collection("usuarios")
        .doc(userData!.id)
        .update(userData!.toMap(forDB: false) as Map<String, dynamic>);
  }

  Future<bool> verifyUser(String uid) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection("usuarios").doc(uid).get();
    return snapshot.exists;
  }

  _authDone(GlobalKey<ScaffoldState> key) {
    CommonUtils().popUntilRoot(key.currentContext!);
    Navigator.of(key.currentContext!).pushReplacement(
      CupertinoPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  }

  Future<Usuario> getUserData() async {
    DocumentSnapshot document = await FirebaseFirestore.instance
        .collection("usuarios")
        .doc(firebaseUser!.uid)
        .get();
    return Usuario.fromJson(document.data() as Map<String, dynamic>);
  }

  Future<bool> existeCell(String cell) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("usuarios")
        .where("cell", isEqualTo: cell)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  Future<bool> existeUsername(String username) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("usuarios")
        .where("username", isEqualTo: username)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  Future<bool> existeEmail(String email) async {
    QuerySnapshot docs = await FirebaseFirestore.instance
        .collection("usuarios")
        .where("email", isEqualTo: email)
        .get();
    return docs.docs.isNotEmpty;
  }

  recuperarConta() {}

  void _finishAuthProcess(UserCredential userCredential, SignUpMethod method,
      GlobalKey<ScaffoldState> key) async {
    if (await existeEmail(userCredential.user!.email!)) {
      firebaseUser = userCredential.user;
      userData = await getUserData();
      await userHelper.salvarUsuario(userData!);
      _userController.sink.add(userData);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(
          APP_CONSTANTS.SESSION_STATE, AppSessionStatus.LOGGED_IN.toString());
      _authDone(key);
    } else {
      CommonUtils().popUntilRoot(key.currentContext!);
      Navigator.pushReplacement(
        key.currentContext!,
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
