import "dart:convert";


import "package:http/http.dart" as http;
import "package:royal_clothes/models/product_model.dart";

class BaseNetwork {
  static const String baseUrl =
      "https://fakestoreapi.com/"; //base URL for the API

  //Mengambil semua data Produk
  static Future<List<dynamic>> getDataProduct(String endpoint) async {
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

  //Mengambil data Produk base ID
  static Future<Map<String, dynamic>> getDetalDataProduct(
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

  //Mengambil data Produk berdasarkan kategori namun tidak ada api khususnya
  static Future<List<Product>> getDataProductByCategory(
    String endpoint,
    String category,
  ) async {
    final response = await http.get(Uri.parse(baseUrl + endpoint));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);

      // Map jsonResponse ke list Product
      List<Product> allProducts =
          jsonResponse.map((product) => Product.fromJson(product)).toList();

      // Filter produk berdasarkan category yang diinput
      List<Product> filteredProducts =
          allProducts.where((product) => product.category == category).toList();

      return filteredProducts;
    } else {
      throw Exception("Failed to load data by category");
    }
  }
}
