import 'dart:convert';
import 'package:http/http.dart' as http;

const String TIME_URL = "http://flossyyuri.com/app/dataAtual.php";
const String MPESA_URL = "https://mpesa.flossyyuri.com/test/pay";

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

Future<http.Response> payMPESA(
    String phone, int amount, String username) async {
  Map<String, dynamic> dados = Map<String, dynamic>();
  dados["phone"] = phone;
  dados["amount"] = amount;
  dados["channel"] = 'CDE';
  dados["username"] = 'MZ';
  return http
      .post(Uri.parse(MPESA_URL),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(dados))
      .then(
    (http.Response response) {
      print(response.body);
      return response;
    },
  );
}
