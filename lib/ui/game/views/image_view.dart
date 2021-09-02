import 'package:cached_network_image/cached_network_image.dart';
import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:codigo_de_estrada_mz/models/questao.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ImageView extends StatelessWidget {
  final Questao questao;
  final bool resposta;
  ImageView({@required this.questao, this.resposta});
  @override
  Widget build(BuildContext context) {
    bool temFoto = questao.foto == "";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainBG,
        title: Row(
          children: <Widget>[
            Text(
              "Sinais",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: temFoto
            ? BoxDecoration(
                gradient: questGrad3,
              )
            : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Transform.rotate(
              angle: math.pi / 2,
              child: Transform.scale(
                scale: 2,
                child: Stack(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: questao.foto == ""
                          ? Container()
                          : CachedNetworkImage(
                              imageUrl: questao.foto,
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
                    ),
                    Material(
                      color: Colors.black.withOpacity(0.0),
                      child: InkWell(
                        splashColor: Colors.white.withOpacity(0.2),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Container(
                            alignment: Alignment.center,
                            child: SelectableText(
                              resposta == null
                                  ? questao.portugues.questao
                                  : questao.portugues.resposta,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                shadows: [
                                  Shadow(
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(1),
                                  )
                                ],
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
