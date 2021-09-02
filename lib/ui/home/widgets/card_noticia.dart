import 'package:cached_network_image/cached_network_image.dart';
import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:codigo_de_estrada_mz/models/noticia.dart';
import 'package:codigo_de_estrada_mz/ui/home/views/noticia_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardNoticia extends StatelessWidget {
  final Noticia noticia;
  CardNoticia(this.noticia);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Column(
        children: <Widget>[
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(noticia.imgUrl),
                            fit: BoxFit.cover,
                          ),
                          color: Colors.indigo,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10))),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: branco.withOpacity(0.2),
                          onTap: () => Navigator.of(context).push(
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      NoticiaView(noticia))),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: SelectableText(
                        noticia.titulo,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: mainBG),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 10, 16),
                      child: SelectableText(
                        noticia.time,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "clique para ler mais",
                        style: TextStyle(color: branco, fontSize: 14),
                      ),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
