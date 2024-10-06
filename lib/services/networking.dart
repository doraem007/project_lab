import 'package:http/http.dart' as http;
import 'dart:convert';
import '../global.dart' as globals;

class NetworkHelper {
  NetworkHelper(this.url);
  String prefixUrl = 'http://${globals.serverIP}:8000/';
  final String url;

  Future getData() async {
    try {
      http.Response response = await http
          .get(Uri.parse(prefixUrl + url))
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        String data = response.body;
        return jsonDecode(data);

      } else {
        String data = response.body;
        
        return jsonDecode(data);
      }
    } catch (e) {
      print(e);
    }
  }

  Future postData(String jsonData) async {
    try {
      http.Response response = await http
          .post(
            Uri.parse(prefixUrl + url),
            headers: {"Content-Type": "application/json"},
            body: jsonData,
          )
          .timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        String data = response.body;
        return jsonDecode(data);

      } else {
        String data = response.body;

        return jsonDecode(data);
      }
    } catch (e) {
      print(e);
    }
  }
}
