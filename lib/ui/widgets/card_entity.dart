import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:codigo_de_estrada_mz/models/usuario.dart';
import 'package:codigo_de_estrada_mz/blocs/usuario_bloc.dart';
import 'package:codigo_de_estrada_mz/blocs/transacoes_bloc.dart';
import 'package:flutter/material.dart';

class CardEntity extends StatelessWidget {
  final String entidade;
  final int valor;
  final IconData icon;
  CardEntity({@required this.entidade, @required this.valor, this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      width: 140,
      height: 100,
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          elevation: 2,
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ListTile(
                    title: StreamBuilder<Usuario>(
                      stream: BlocProvider.getBloc<UsuarioBloc>().outUsuario,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Row(
                            children: <Widget>[
                              Text(
                                entidade.toLowerCase() == "cs"
                                    ? snapshot.data.cs.toString()
                                    : snapshot.data.nrTestes.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          );
                        }
                        return Container();
                      },
                    ),
                    trailing: Icon(
                      icon != null ? icon : Icons.add,
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16, top: 0, bottom: 10),
                    child: Text(
                      entidade,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                top: 40,
                left: 18,
                child: entidade.toLowerCase() != "cs"
                    ? StreamBuilder(
                        stream: BlocProvider.getBloc<TransacoesBloc>().outTimer,
                        builder: (context, snapshot) {
                          String time = "XX:XX";
                          if (snapshot.hasData) {
                            time =
                                '${snapshot.data.inMinutes}:${(snapshot.data.inSeconds % 60).toString().padLeft(2, '0')}';
                            return Text(
                              time,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            );
                          }
                          return Container();
                        },
                      )
                    : Container(),
              )
            ],
          )),
    );
  }
}
