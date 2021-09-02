import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:codigo_de_estrada_mz/blocs/noticia_bloc.dart';
import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:codigo_de_estrada_mz/models/noticia.dart';
import 'package:codigo_de_estrada_mz/ui/home/widgets/card_noticia.dart';
import 'package:flutter/material.dart';

class NoticiasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainBG,
        title: Text("NOTICIAS",
            style: TextStyle(
                color: branco,
                fontSize: 24,
                letterSpacing: 2,
                fontWeight: FontWeight.w300)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FutureBuilder<List<Noticia>>(
              future: BlocProvider.getBloc<NoticiaBloc>().downloadNoticias(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data.map((Noticia not) {
                      return not.ativo ? CardNoticia(not) : Container();
                    }).toList(),
                  );
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }
}
