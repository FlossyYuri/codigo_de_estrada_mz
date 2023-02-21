import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:codigo_de_estrada_mz/blocs/in_game_bloc.dart';
import 'package:codigo_de_estrada_mz/blocs/noticia_bloc.dart';
import 'package:codigo_de_estrada_mz/blocs/questao_bloc.dart';
import 'package:codigo_de_estrada_mz/blocs/transacoes_bloc.dart';
import 'package:codigo_de_estrada_mz/blocs/usuario_bloc.dart';
import 'package:codigo_de_estrada_mz/ui/autentication/login_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
          home: LoginAuth(),
        ),
      ),
    );
  });
}
