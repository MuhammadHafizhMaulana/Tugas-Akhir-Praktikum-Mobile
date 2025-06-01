import "dart:convert";

import "package:http/http.dart" as http;

class BaseNetwork {
  static const String baseUrl =
      "https://fakestoreapi.com/"; //base URL for the API

  static Future<List<dynamic>> getData(String endpoint) async {
    final response = await http.get(Uri.parse(baseUrl + endpoint));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body); // Decode the JSON response
      return data; // Return the decoded data
    } else {
      throw Exception(
        "Failed to load data Error: ${response.statusCode}",
      ); // Throw an exception if the request fails
    }
  }

  static Future<Map<String, dynamic>> getDetalData(
    String endpoint,
    int id,
  ) async {
    final response = await http.get(Uri.parse(baseUrl + '$endpoint/$id'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Decode the JSON response
    } else {
      throw Exception(
        "Failed to load detail data",
      ); // Throw an exception if the request fails
    }
  }
}
