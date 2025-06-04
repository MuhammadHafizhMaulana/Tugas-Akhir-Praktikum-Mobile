import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:royal_clothes/models/product_model.dart';
import 'package:royal_clothes/network/base_network.dart';
import 'package:royal_clothes/views/sidebar_menu_page.dart';
import 'package:royal_clothes/views/appBar_page.dart';
import 'package:royal_clothes/views/detail_product_page.dart';
import 'package:royal_clothes/db/database_helper.dart';

class PaymentHistoryPage extends StatefulWidget {
  final String endpoint;

  const PaymentHistoryPage({super.key, required this.endpoint});

  @override
  _PaymentHistoryPage createState() => _PaymentHistoryPage();
}

class _PaymentHistoryPage extends State<PaymentHistoryPage> {
  final DBHelper _dbHelper = DBHelper();
  List<Product> favoriteProductList = [];
  bool isLoading = false;
  String? errorMessage;
  int? userId;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
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
      favoriteProductList = [];
    });

    try {
      final Ids = await _dbHelper.getPaymentHistory(userId);
      List<Product> products = [];

      for (var productId in Ids) {
        final productJson = await BaseNetwork.getDetalDataProduct(widget.endpoint, productId);
        products.add(Product.fromJson(productJson));
      }

      setState(() {
        favoriteProductList = products;
        isLoading = false;
      });
    } catch (e) {
       if (mounted) {
    setState(() {
       isLoading = true;
      errorMessage = null;
      favoriteProductList = [];
    });
  }
    }
  }

  Widget productCard(Product product) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              id: product.id,
              endpoint: widget.endpoint,
            ),
          ),
        ).then((_) {
          _loadUserEmail(); // refresh setelah kembali dari detail
        });
      },
      child: Container(
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
                'Rp ${product.price.toStringAsFixed(0)}.000',
                style: TextStyle(
                  color: Color(0xFFFFD700),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Garamond',
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppbarPage(
        title: 'Payment History',
        actions: [],
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
              : favoriteProductList.isEmpty
                  ? Center(
                      child: Text(
                        "No Payment History Products Found",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.all(16),
                      child: GridView.builder(
                        itemCount: favoriteProductList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                          childAspectRatio: 0.65,
                        ),
                        itemBuilder: (context, index) {
                          final product = favoriteProductList[index];
                          return productCard(product);
                        },
                      ),
                    ),
    );
  }
}
