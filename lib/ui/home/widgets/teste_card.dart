import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TesteCard extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final int nrQuestoes;
  final int duracao;
  final int erros;
  final int maxErros;
  final String estado;
  final Function f;
  TesteCard({
    @required this.icon,
    @required this.titulo,
    @required this.nrQuestoes,
    @required this.duracao,
    @required this.estado,
    @required this.maxErros,
    @required this.erros,
    @required this.f,
  });

  @override
  Widget build(BuildContext context) {
    Widget item2;
    Widget item1;
    switch (estado) {
      case "novo":
        item1 = Column(
          children: <Widget>[
            Icon(
              icon,
              color: branco,
              size: 30,
            ),
          ],
        );
        item2 = Column(
          children: <Widget>[
            Icon(
              FontAwesomeIcons.angleRight,
              color: branco,
              size: 24,
            ),
            Text(
              "Jogar",
              style: TextStyle(color: branco),
            )
          ],
        );
        break;
      case "bloqueado":
        item1 = Column(
          children: <Widget>[
            Icon(
              icon,
              color: branco,
              size: 30,
            ),
            Text(
              "Bloqueado",
              style: TextStyle(color: branco, fontSize: 10),
            ),
          ],
        );
        item2 = Column(
          children: <Widget>[
            Icon(
              Icons.lock_outline,
              color: branco,
              size: 24,
            ),
            Text(
              "Locked",
              style: TextStyle(color: branco),
            )
          ],
        );
        break;
      case "reprovado":
        item1 = Column(
          children: <Widget>[
            Icon(
              icon,
              color: branco,
              size: 30,
            ),
            Text(
              "Reprovado",
              style: TextStyle(color: branco, fontSize: 10),
            ),
          ],
        );
        item2 = Column(
          children: <Widget>[
            Icon(
              FontAwesomeIcons.angleRight,
              color: branco,
              size: 24,
            ),
            Text(
              "Repetir",
              style: TextStyle(color: branco),
            )
          ],
        );
        break;
      case "aprovado":
        item1 = Column(
          children: <Widget>[
            Icon(
              icon,
              color: branco,
              size: 30,
            ),
            Text(
              "Aprovado",
              style: TextStyle(color: branco, fontSize: 10),
            ),
          ],
        );
        item2 = Column(
          children: <Widget>[
            Icon(
              FontAwesomeIcons.check,
              color: branco,
              size: 24,
            ),
            Text(
              "Repetir",
              style: TextStyle(color: branco),
            )
          ],
        );
        break;
      default:
    }

    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onPressed: f,
      color: secBG,
      splashColor: lightBG,
      elevation: 4,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  item1,
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 1,
                    height: 60,
                    color: Colors.white24,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          Text(
                            titulo.toUpperCase(),
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.w600,
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.clock,
                              size: 10.0,
                              color: Color(0x66FFFFFF),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              "$duracao mins de duração",
                              style: TextStyle(
                                color: Color(0x66FFFFFF),
                                fontWeight: FontWeight.w300,
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.close,
                              size: 10.0,
                              color: Color(0x66FFFFFF),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              "$maxErros erros no máximo",
                              style: TextStyle(
                                color: Color(0x66FFFFFF),
                                fontWeight: FontWeight.w300,
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.circleQuestion,
                              size: 10.0,
                              color: Color(0x66FFFFFF),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              "$nrQuestoes questões no total",
                              style: TextStyle(
                                color: Color(0x66FFFFFF),
                                fontWeight: FontWeight.w300,
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              item2,
            ],
          ),
        ),
      ),
    );
  }
}
