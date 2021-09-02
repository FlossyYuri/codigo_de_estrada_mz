import 'package:cached_network_image/cached_network_image.dart';
import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:codigo_de_estrada_mz/models/noticia.dart';
import 'package:flutter/material.dart';

class NoticiaView extends StatelessWidget {
  final Noticia noticia;
  NoticiaView(this.noticia);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          noticia.titulo,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 20),
        ),
        backgroundColor: mainBG,
        centerTitle: false,
      ),
      body: Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              child: CachedNetworkImage(
                imageUrl: noticia.imgUrl,
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
                errorWidget: (context, url, error) =>
                    Image.asset("assets/info/lost-conexion.jpg"),
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.fromLTRB(16, 150, 16, 0),
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SelectableText(
                    noticia.titulo,
                    style: TextStyle(
                      color: mainBG,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SelectableText(
                    noticia.time,
                    style: TextStyle(
                        fontSize: 14, color: Colors.blueGrey, letterSpacing: 1),
                  ),
                  Divider(),
                  SelectableText(
                    noticia.body,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
