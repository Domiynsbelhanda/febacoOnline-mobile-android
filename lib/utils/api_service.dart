import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://febaco.ourworldtkpl.com/public-data";

  static Future<Map<String, dynamic>> fetchPublicData() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Échec du chargement des données");
    }
  }
}
