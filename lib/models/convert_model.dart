class ConvertModel {
  final DateTime date;
  final Map<String, double> idrToCurrencies; // Menyimpan konversi IDR ke mata uang lain

  // Constructor
  ConvertModel({
    required this.date,
    required this.idrToCurrencies,
  });

  // Factory method untuk membuat objek ConvertModel dari JSON
  factory ConvertModel.fromJson(Map<String, dynamic> json) {
    return ConvertModel(
      date: json['date'] != null 
          ? DateTime.parse(json['date'])
          : DateTime.now(), 
      idrToCurrencies: Map<String, double>.from(
  json['usd'].map((key, value) => MapEntry(key, value is int ? value.toDouble() : value))
), 
    );
  }

  // Fungsi untuk mengonversi IDR ke mata uang lain berdasarkan simbol mata uang
  double convertToCurrency(String currencyCode, double amount) {
    if (idrToCurrencies.containsKey(currencyCode)) {
      double rate = idrToCurrencies[currencyCode]!;
      return rate * amount;
    }
    return 0.0; // Jika mata uang tidak ditemukan, return 0
  }
}
