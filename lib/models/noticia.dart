import 'package:flutter/widgets.dart';

class Noticia {
  int id;
  String titulo;
  String body;
  DateTime data;
  String imgUrl;
  bool ativo;
  Noticia(
      {@required this.titulo,
      @required this.body,
      @required this.data,
      @required this.id,
      @required this.ativo,
      @required this.imgUrl});

  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      titulo: json['titulo'],
      body: json['body'],
      data: json['data'].toDate(),
      imgUrl: json['imgUrl'],
      ativo: json['ativo'],
      id: json['id'],
    );
  }

  Noticia.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    titulo = map["titulo"];
    body = map["body"];
    imgUrl = map["imgUrl"];
    ativo = map["ativo"];
    data = map["data"].toDate();
  }

  Map<String, dynamic> toJson() {
    return {
      "titulo": titulo,
      "body": body,
      "data": data.microsecondsSinceEpoch,
      "imgUrl": imgUrl,
      "ativo": ativo,
      "id": id,
    };
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["titulo"] = titulo;
    map["body"] = body;
    map["data"] = data;
    map["id"] = id;
    map["ativo"] = ativo;
    map["imgUrl"] = imgUrl;
    return map;
  }

  String get time {
    switch (data.difference(DateTime.now()).inDays) {
      case 0:
        return "Hoje, as ${data.hour}:${data.minute}";
        break;
      case 1:
        return "Ontem, as ${data.hour}:${data.minute}";
        break;
      default:
        return "Dia ${data.day} pelas ${data.hour}:${data.minute}";
    }
  }
}
