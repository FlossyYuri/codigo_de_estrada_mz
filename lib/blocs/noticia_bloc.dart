import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:codigo_de_estrada_mz/models/noticia.dart';

class NoticiaBloc extends BlocBase {
  Future<List<Noticia>> downloadNoticias() async {
    List<Noticia> noticias;
    // await Firestore.instance
    //     .collection("noticias")
    //     .getDocuments()
    //     .then((QuerySnapshot snapshot) {
    //   noticias = snapshot.documents.map((doc) {
    //     return Noticia.fromMap(doc.data);
    //   }).toList();
    // });
    return noticias;
  }
}
