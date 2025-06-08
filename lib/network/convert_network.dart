import "dart:convert";
import "package:http/http.dart" as http;
import "package:royal_clothes/models/convert_model.dart"; // Import model yang sudah dibuat

class ConvertNetwork {
  static const String baseUrl =
      "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/usd.json"; // Base URL for the API

  // Mengambil data konversi mata uang dari API
  static Future<ConvertModel> getConvertData() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body); // Decode the JSON response
      // Memasukkan data ke dalam model Product
      return ConvertModel.fromJson(data); // Return an instance of Product
    } else {
      throw Exception("Failed to load data. Error: ${response.statusCode}");
    }
  }
}
