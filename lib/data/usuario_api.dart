import 'dart:convert';
import 'package:http/http.dart' as http;

const String TIME_URL = "http://flossyyuri.com/app/dataAtual.php";
const String MPESA_URL = "https://mpesaphp.herokuapp.com/api/payment";

Future<Map<String, dynamic>> createPost({Map body}) async {
  return http.post(Uri.parse(TIME_URL), body: body).then(
    (http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return json.decode(response.body);
    },
  );
}

Future<http.Response> payMPESA(int phone, int amount, String userID) async {
  Map<String, String> dados = Map<String, String>();
  dados["phone"] = phone.toString();
  dados["amount"] = amount.toString();
  dados["channel"] = 'CDE-ANDROID';
  dados["user_id"] = userID;
  return http
      .post(Uri.parse(MPESA_URL),
          headers: {"Accept": "application/json"}, body: dados)
      .then(
    (http.Response response) {
      print(response.statusCode);
      return response;
    },
  );
}
