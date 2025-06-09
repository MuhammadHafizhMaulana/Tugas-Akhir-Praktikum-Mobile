import 'package:flutter/material.dart';
import 'package:royal_clothes/network/base_network.dart';
import 'package:royal_clothes/views/appBar_page.dart';
import 'package:royal_clothes/views/sidebar_menu_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:royal_clothes/db/database_helper.dart';

class DetailScreen extends StatefulWidget {
  final int id;
  final String endpoint;

  const DetailScreen({super.key, required this.id, required this.endpoint});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _detailData;
  String? errorMessage;
  bool _isFavorited = false;
  int? userId;
  final DBHelper _dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    _loadUserEmailAndFavorites();
    _fetchDetailData();
    _loadFavoriteStatus();
  }

  Future<void> _loadUserEmailAndFavorites() async {
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

    await _loadFavoriteStatus();
  }

  Future<void> _fetchDetailData() async {
    try {
      final data = await BaseNetwork.getDetalDataProduct(
        widget.endpoint,
        widget.id,
      );
      setState(() {
        _detailData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadFavoriteStatus() async {
    if (userId == null) return;
    bool status = await _dbHelper.isFavorited(userId!, widget.id);
    setState(() {
      _isFavorited = status;
    });
  }

  Future<void> _toggleFavorite() async {
    if (_isFavorited) {
      await _dbHelper.removeFavorite(userId!, widget.id);
    } else {
      await _dbHelper.addFavorite(userId!, widget.id);
    }
    bool status = await _dbHelper.isFavorited(userId!, widget.id);
    setState(() {
      _isFavorited = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppbarPage(title: 'Detail Product', actions: []),
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
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            _isFavorited
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: _isFavorited ? Colors.red : Colors.white70,
                          ),
                          onPressed: _toggleFavorite,
                        ),
                        Text(
                          _isFavorited ? 'Favorited' : 'Add to Chart',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      _detailData!['description'] ??
                          'No description available.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontFamily: 'Garamond',
                      ),
                    ),
                    SizedBox(height: 40),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (userId == null) {
                              setState(() {
                                errorMessage = "User ID tidak ditemukan.";
                              });
                              return;
                            }

                            // Mengarahkan ke halaman /payment dengan membawa data
                            Navigator.pushNamed(
                              context,
                              '/payment',
                              arguments: {
                                'userId': userId,
                                'productId': widget.id,
                                'endpoint': widget.endpoint,
                              },
                            ).then((result) {
                              // Jika ada pengembalian data, bisa ditangani disini
                              print('Returned: $result');
                            });
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
