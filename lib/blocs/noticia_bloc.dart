import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latest_codigo_de_estrada/models/noticia.dart';

class NoticiaBloc extends BlocBase {
  Future<List<Noticia>> downloadNoticias() async {
    List<Noticia> noticias = [];
    await FirebaseFirestore.instance
        .collection("noticias")
        .get()
        .then((QuerySnapshot snapshot) {
      noticias = snapshot.docs.map((doc) {
        return Noticia.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
    return noticias;
  }
}
