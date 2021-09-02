import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:flutter/material.dart';
import 'package:codigo_de_estrada_mz/blocs/questao_bloc.dart';

class LoadScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainBG,
        title: Text("Carregar todas imagens",
            style: TextStyle(
                color: branco,
                fontSize: 22,
                letterSpacing: 2,
                fontWeight: FontWeight.w300)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: <Widget>[
            Text(
              "Deslize até o fim e espere até todas imagens serem carreegadas.",
              style: TextStyle(
                fontSize: 20,
                color: mainBG,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:
                  BlocProvider.getBloc<QuestaoBloc>().questoes.map((quest) {
                if (quest.foto.length > 0) {
                  return Container(
                      width: 200,
                      height: 200,
                      child: Stack(
                        children: <Widget>[
                          CachedNetworkImage(
                            imageUrl: quest.foto,
                            placeholder: (context, url) => Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: 100,
                                width: 100,
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(mainBG),
                                ),
                              ),
                            ),
                            fadeInDuration: Duration(microseconds: 400),
                            errorWidget: (context, url, error) =>
                                Image.asset("assets/info/lost-conexion.jpg"),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "${quest.foto} - ${quest.id}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.purpleAccent,
                              ),
                            ),
                          ),
                        ],
                      ));
                }
                return Container();
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
