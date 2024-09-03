import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:codigo_de_estrada_mz/blocs/in_game_bloc.dart';
import 'package:codigo_de_estrada_mz/blocs/noticia_bloc.dart';
import 'package:codigo_de_estrada_mz/blocs/questao_bloc.dart';
import 'package:codigo_de_estrada_mz/blocs/transacoes_bloc.dart';
import 'package:codigo_de_estrada_mz/blocs/usuario_bloc.dart';
import 'package:codigo_de_estrada_mz/ui/autentication/login_auth.dart';
import 'package:codigo_de_estrada_mz/ui/autentication/widgets/auth_view.dart';
import 'package:codigo_de_estrada_mz/ui/home/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      BlocProvider(
        blocs: [
          Bloc((i) => UsuarioBloc()),
          Bloc((i) => TransacoesBloc()),
          Bloc((i) => QuestaoBloc()),
          Bloc((i) => InGameBloc()),
          Bloc((i) => NoticiaBloc())
        ],
        dependencies: [],
        child: MaterialApp(
          title: "Codigo de Estrada",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'OpenRegular'),
          routes: {
            '/': (context) => LoginAuth(),
            '/auth/': (context) => AuthView(
                  isLogin: true,
                ),
            '/home/': (context) => HomeScreen(),
          },
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/auth':
                return CupertinoPageRoute(
                  builder: (context) => AuthView(
                    isLogin: true,
                  ),
                  settings: settings,
                );
              case '/home':
                return CupertinoPageRoute(
                  builder: (context) => HomeScreen(),
                  settings: settings,
                );
              default:
                return CupertinoPageRoute(
                  builder: (context) => AuthView(
                    isLogin: true,
                  ),
                  settings: settings,
                );
            }
          },
        ),
      ),
    );
  });
}
