import 'package:flutter/material.dart';
import 'package:royal_clothes/network/Base_network.dart';
import 'package:royal_clothes/db/database_helper.dart';
import 'package:royal_clothes/views/appBar_page.dart';
import 'package:royal_clothes/network/convert_network.dart';
import 'package:royal_clothes/views/sidebar_menu_page.dart';

class PaymentPage extends StatefulWidget {
  final int userId;
  final int productId;
  final String endpoint;

  const PaymentPage({
    super.key,
    required this.userId,
    required this.productId,
    required this.endpoint,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _isLoading = true;
  Map<String, dynamic>? _detailData;
  String? errorMessage;
  int quantity = 1; // Inisialisasi jumlah item dengan nilai default 1
  double? totalPrice;
  Map<String, double>? currencyRates;
  final DBHelper _dbHelper = DBHelper();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Menggunakan data langsung dari widget
    int? productId = widget.productId;
    String? endpoint = widget.endpoint;

    if (productId == null || endpoint == null) {
      setState(() {
        errorMessage = 'Missing required data.';
        _isLoading = false;
      });
    } else {
      // Ambil data produk dari API dengan productId dan endpoint
      _fetchProductData(productId, endpoint);
    }

    // Mengambil data konversi mata uang
    _fetchCurrencyRates();
  }

  // Mendapatkan data produk dari API
  Future<void> _fetchProductData(int productId, String endpoint) async {
    try {
      final data = await BaseNetwork.getDetalDataProduct(endpoint, productId);
      setState(() {
        _detailData = data;
        totalPrice = _detailData!['price'] * quantity; // Menghitung total harga
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Error fetching product data: $e";
        _isLoading = false;
      });
    }
  }

  // Mendapatkan data konversi mata uang
  Future<void> _fetchCurrencyRates() async {
    try {
      // Mendapatkan data konversi mata uang melalui API
      final convertModel = await ConvertNetwork.getConvertData();

      setState(() {
        currencyRates =
            convertModel
                .idrToCurrencies; // Menggunakan data langsung tanpa konversi tambahan
      });
    } catch (e) {
      setState(() {
        errorMessage = "Error fetching currency rates: $e";
        _isLoading = false;
      });
    }
  }

  // Fungsi untuk menambah produk ke history pembayaran
  Future<void> _addToPaymentHistory() async {
    if (widget.userId == null || widget.productId == null) {
      setState(() {
        errorMessage = "User ID or Product ID is missing.";
      });
      return;
    }

    try {
      await _dbHelper.addPaymentHistory(
        widget.userId,
        widget.productId,
        quantity, // assuming this parameter expects int
        (totalPrice ?? 0.0).toDouble(), // assuming this parameter expects double
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product added to payment history')),
      );
    } catch (e) {
      setState(() {
        errorMessage = "Failed to add product to payment history: $e";
      });
    }
  }

  // Fungsi untuk menambah jumlah item
  void _increaseQuantity() {
    setState(() {
      quantity++;
      totalPrice = (_detailData!['price'] as double) * quantity;
    });
  }

  // Fungsi untuk mengurangi jumlah item
  void _decreaseQuantity() {
    setState(() {
      if (quantity > 1) {
        quantity--;
        totalPrice = (_detailData!['price'] as double) * quantity;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppbarPage(title: 'Payment'),
      drawer: SidebarMenu(),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(
                child: Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.redAccent, fontSize: 16),
                ),
              )
              : _detailData == null
              ? Center(
                child: Text(
                  "No detail data available",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              )
              : SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_detailData!['image'] != null)
                      Center(
                        child: Image.network(
                          _detailData!['image'],
                          height: 250,
                          fit: BoxFit.contain,
                          errorBuilder:
                              (context, error, stackTrace) => Icon(
                                Icons.broken_image,
                                size: 100,
                                color: Colors.grey,
                              ),
                        ),
                      ),
                    SizedBox(height: 24),
                    Text(
                      _detailData!['title'] ?? 'No Title',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Garamond',
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      _detailData!['price'] != null
                          ? '\$ ${(_detailData!['price'] as num).toStringAsFixed(0)}'
                          : 'No Price',
                      style: TextStyle(
                        color: Color(0xFFFFD700),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: 'Garamond',
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: _decreaseQuantity,
                        ),
                        Text(
                          '$quantity',
                          style: TextStyle(color: Colors.white70, fontSize: 20),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: _increaseQuantity,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Total Harga: \$ ${totalPrice?.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                        fontFamily: 'Garamond',
                      ),
                    ),
                    SizedBox(height: 20),
                    // Menampilkan total harga dalam mata uang lain
                    if (currencyRates != null)
                      ...currencyRates!.keys.map((currency) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            '$currency: ${(currencyRates![currency] ?? 0) * totalPrice!}',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        );
                      }).toList(),
                    SizedBox(height: 40),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            await _addToPaymentHistory();
                            Navigator.pushNamed(context, '/paymenthistory');
                          },
                          child: Text("BUY THIS PRODUCT"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(
                              0xFFFFD700,
                            ), // Tombol berwarna kuning
                            padding: EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 32,
                            ),
                            textStyle: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Garamond',
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
