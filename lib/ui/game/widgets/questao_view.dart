import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:codigo_de_estrada_mz/models/questao.dart';
import 'package:codigo_de_estrada_mz/blocs/in_game_bloc.dart';
import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:codigo_de_estrada_mz/ui/game/views/image_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuestaoView extends StatefulWidget {
  final Questao questao;
  final String alternativa;
  final String resposta;
  final String questionMode;
  QuestaoView({
    @required this.questao,
    this.alternativa,
    this.resposta,
    this.questionMode,
  });

  @override
  _QuestaoViewState createState() => _QuestaoViewState();
}

class _QuestaoViewState extends State<QuestaoView> {
  bool temFoto;
  String selectedOption;
  bool respondido = false;
  void initState() {
    super.initState();
    temFoto = widget.questao.foto == "";
  }

  _optionSelected(String val) {
    setState(() {
      selectedOption = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: temFoto
                  ? BoxDecoration(
                      gradient: questGrad3,
                    )
                  : null,
              height: 400,
              child: Stack(
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: widget.questao.foto == ""
                        ? Container()
                        : CachedNetworkImage(
                            imageUrl: widget.questao.foto,
                            // progressIndicatorBuilder:
                            //     (context, url, downloadProgress) =>
                            //         CircularProgressIndicator(
                            //             value: downloadProgress.progress),
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
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) =>
                                ImageView(questao: widget.questao),
                          ),
                        );
                      },
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          alignment: Alignment.center,
                          child: SelectableText(
                            widget.questao.portugues.questao,
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
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IgnorePointer(
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Icon(
                          Icons.zoom_in,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: pagePadding,
            child: Column(
              children: widget.questao.portugues.alternativas
                  .map(
                    (texto) => Column(
                      children: <Widget>[
                        _alternativa(
                          texto: texto,
                          f: (texto) {
                            if (widget.alternativa == null) {
                              if (widget.questionMode == 'classico') {
                                if (!respondido) {
                                  respondido = true;
                                  _optionSelected(texto);
                                  BlocProvider.getBloc<InGameBloc>()
                                      .escolherOpcao(widget.questao.id, texto);
                                }
                              } else {
                                _optionSelected(texto);
                                BlocProvider.getBloc<InGameBloc>()
                                    .escolherOpcao(widget.questao.id, texto);
                              }
                            }
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
          SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }

  _alternativa({@required String texto, @required Function f}) {
    Color cor = Colors.white;
    if (widget.alternativa == null) {
      cor = texto == selectedOption ? mainBG : preto;
      if (widget.questionMode == 'classico') {
        if (respondido) {
          if (widget.questao.portugues.resposta == texto)
            cor = lightgreen;
          else if (selectedOption == texto)
            cor = lightred;
          else
            cor = preto;
        }
      }
    } else {
      if (texto == widget.resposta) _optionSelected(texto);
      if (widget.resposta == texto)
        cor = lightgreen;
      else if (widget.alternativa == texto)
        cor = lightred;
      else
        cor = preto;
    }
    return Container(
      decoration: BoxDecoration(
        color: branco,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blueGrey.withOpacity(0.1), width: 1),
      ),
      child: RadioListTile(
        value: texto,
        groupValue: selectedOption,
        onChanged: f,
        activeColor: mainBG,
        title: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          alignment: Alignment.centerLeft,
          child: Text(
            texto,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: cor,
              fontSize: 18,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
