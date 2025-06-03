import 'package:flutter/material.dart';
import 'package:royal_clothes/network/base_network.dart';
import 'package:royal_clothes/views/appBar_page.dart';
import 'package:royal_clothes/views/sidebar_menu_page.dart';
import 'package:royal_clothes/db/database_helper.dart'; // Import DBHelper

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
  String? _errorMessage;
  bool _isFavorited = false;

  final DBHelper _dbHelper = DBHelper();

  // Ganti dengan userId asli dari sistem loginmu
  final int currentUserId = 1; 

  @override
  void initState() {
    super.initState();
    _fetchDetailData();
    _loadFavoriteStatus();
  }

  Future<void> _fetchDetailData() async {
    try {
      final data = await BaseNetwork.getDetalDataProduct(widget.endpoint, widget.id);
      setState(() {
        _detailData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadFavoriteStatus() async {
    bool status = await _dbHelper.isFavorited(currentUserId, widget.id);
    setState(() {
      _isFavorited = status;
    });
  }

  Future<void> _toggleFavorite() async {
    if (_isFavorited) {
      await _dbHelper.removeFavorite(currentUserId, widget.id);
    } else {
      await _dbHelper.addFavorite(currentUserId, widget.id);
    }
    bool status = await _dbHelper.isFavorited(currentUserId, widget.id);
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Text(
                    _errorMessage!,
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
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.broken_image, size: 100, color: Colors.grey),
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
                                ? 'Rp ${(_detailData!['price'] as num).toStringAsFixed(0)}.000'
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
                                  _isFavorited ? Icons.favorite : Icons.favorite_border,
                                  color: _isFavorited ? Colors.red : Colors.white70,
                                ),
                                onPressed: _toggleFavorite,
                              ),
                              Text(
                                _isFavorited ? 'Favorited' : 'Add to Favorite',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),

                          SizedBox(height: 20),
                          Text(
                            _detailData!['description'] ?? 'No description available.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontFamily: 'Garamond',
                            ),
                          ),
                          SizedBox(height: 40),
                        ],
                      ),
                    ),
    );
  }
}
