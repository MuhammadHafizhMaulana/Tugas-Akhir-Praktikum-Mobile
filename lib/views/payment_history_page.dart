import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:royal_clothes/models/product_model.dart';
import 'package:royal_clothes/network/base_network.dart';
import 'package:royal_clothes/views/sidebar_menu_page.dart';
import 'package:royal_clothes/views/appBar_page.dart';
import 'package:royal_clothes/db/database_helper.dart';
import 'package:intl/intl.dart'; // Pastikan intl diimport

class PaymentHistoryPage extends StatefulWidget {
  final String endpoint;

  const PaymentHistoryPage({super.key, required this.endpoint});

  @override
  _PaymentHistoryPageState createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
  final DBHelper _dbHelper = DBHelper();
  List<Map<String, dynamic>> paymentHistoryList = [];
  bool isLoading = false;
  String? errorMessage;
  int? userId;
  
  // Menyimpan zona waktu yang dipilih oleh pengguna
  String selectedTimezone = "WIB"; // Default adalah WIB

  @override
  void initState() {
    super.initState();
    _loadUserEmailAndHistory();
  }

  Future<void> _loadUserEmailAndHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('userEmail');

    if (email == null) {
      setState(() {
        errorMessage = "User belum login.";
      });
      return;
    }

    // Dapatkan userId berdasarkan email dari SQLite
    final userData = await _dbHelper.getUserByEmail(email);
    if (userData == null) {
      setState(() {
        errorMessage = "User tidak ditemukan di database lokal.";
      });
      return;
    }

    int userId = userData['id'] as int;
    setState(() {
      this.userId = userId;
    });

    await _loadPaymentHistory(userId);
  }

  Future<void> _loadPaymentHistory(int userId) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      paymentHistoryList = [];
    });

    try {
      final history = await _dbHelper.getPaymentHistory(userId);

      if (history.isEmpty) {
        setState(() {
          errorMessage = "Tidak ada riwayat pembayaran ditemukan.";
          isLoading = false;
        });
        return;
      }

      List<Map<String, dynamic>> productsData = [];

      // Memetakan data berdasarkan product_id untuk mendapatkan data produk dari API
      for (var productMap in history) {
        final int productId = productMap['product_id'];

        // Ambil data produk berdasarkan product_id
        final productJson = await BaseNetwork.getDetalDataProduct(widget.endpoint, productId);

        // Menyusun data produk dengan data riwayat pembelian
        Map<String, dynamic> productData = {
          'product': Product.fromJson(productJson),  // Data produk dari API
          'quantity': productMap['quantity'],      // Quantity dari riwayat pembelian
          'createdAt': productMap['created_at'],   // Created_at dari riwayat pembelian
          'totalPrice': productMap['total_price'], // Total_price dari riwayat pembelian
        };

        productsData.add(productData); // Menambahkan data produk beserta riwayat pembelian
      }

      setState(() {
        paymentHistoryList = productsData;  // Menyimpan data produk beserta riwayat pembelian
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Terjadi kesalahan saat memuat riwayat pembayaran.";
      });
    }
  }

  // Fungsi untuk mengonversi dan menampilkan waktu sesuai zona waktu
  String _convertTimeBasedOnLocation(String createdAt, String location) {
    DateTime utcDate = DateTime.parse(createdAt);  // Mengonversi string ke DateTime (UTC)
    DateTime localDate = utcDate.toLocal(); // Mengonversi UTC ke waktu lokal

    // Format tanggal dengan menggunakan intl
    var format = DateFormat.yMMMd('id_ID').add_jm();  // Format waktu dengan DateFormat

    // Menyesuaikan zona waktu yang diinginkan
    if (location == 'London') {
      localDate = localDate.toUtc();  // Mengonversi ke waktu UTC (London waktu)
    } else if (location == 'WIB') {
      localDate = localDate.add(Duration(hours: 7)); // Waktu Indonesia Barat (GMT+7)
    } else if (location == 'WITA') {
      localDate = localDate.add(Duration(hours: 8)); // Waktu Indonesia Tengah (GMT+8)
    } else if (location == 'WIT') {
      localDate = localDate.add(Duration(hours: 9)); // Waktu Indonesia Timur (GMT+9)
    }

    return format.format(localDate);  // Mengembalikan waktu yang sudah diformat
  }

  Widget productCard(Map<String, dynamic> productData) {
    final Product product = productData['product'];
    final quantity = productData['quantity'];
    final createdAt = productData['createdAt'];
    final totalPrice = productData['totalPrice'];

    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.broken_image, size: 50, color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              product.title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontFamily: 'Garamond',
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '\$ ${product.price.toStringAsFixed(0)}',
              style: TextStyle(
                color: Color(0xFFFFD700),
                fontWeight: FontWeight.bold,
                fontFamily: 'Garamond',
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(height: 8),
          
          // Menampilkan quantity, tanggal pembelian dan total harga
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Quantity: $quantity',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Menampilkan dropdown untuk memilih zona waktu
                DropdownButton<String>(
                  value: selectedTimezone,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.white),
                  dropdownColor: Color(0xFF2C2C2C),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTimezone = newValue!;
                    });
                  },
                  items: <String>['WIB', 'WITA', 'WIT', 'London']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                // Menampilkan tanggal pembelian berdasarkan zona waktu yang dipilih
                Text(
                  'Tanggal Pembelian ($selectedTimezone): ${_convertTimeBasedOnLocation(createdAt, selectedTimezone)}',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Total Harga: \$ ${totalPrice.toStringAsFixed(0)}',
              style: TextStyle(
                color: Color(0xFFFFD700),
                fontWeight: FontWeight.bold,
                fontFamily: 'Garamond',
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppbarPage(
        title: 'Payment History',
      ),
      drawer: SidebarMenu(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.redAccent, fontSize: 16),
                  ),
                )
              : paymentHistoryList.isEmpty
                  ? Center(
                      child: Text(
                        "No Payment History Products Found",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.all(16),
                      child: GridView.builder(
                        itemCount: paymentHistoryList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                          childAspectRatio: 0.65,
                        ),
                        itemBuilder: (context, index) {
                          final productData = paymentHistoryList[index];
                          return productCard(productData);  // Menampilkan produk
                        },
                      ),
                    ),
    );
  }
}
