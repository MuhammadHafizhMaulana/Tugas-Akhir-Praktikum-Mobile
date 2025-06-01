import 'package:flutter/material.dart';
import 'package:royal_clothes/presenters/product_presenter.dart';
import 'package:royal_clothes/models/product_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> implements ProductView{
  late ProductPresenter presenter;
  List<Product> productList = [];
  bool isLoading = false;
  String? errorMessage;
  

  @override
  void initState() {
    super.initState();
    presenter = ProductPresenter (this);
    presenter.loadProductData('products');
  }

    @override
  void showProductList(List<Product> products) {
    setState(() {
      productList = products;
      errorMessage = null;
    });
  }

  @override
  void showError(String message) {
    setState(() {
      errorMessage = message;
      productList = [];
    });
  }

    @override
  void showLoading() {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
  }

  @override
  void hideLoading() {
    setState(() {
      isLoading = false;
    });
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Color(0xFF1E1E1E),
        title: Text('Royal Clothes', style: TextStyle(fontFamily: 'Garamond')),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.redAccent, fontSize: 16),
                  ),
                )
              : productList.isEmpty
                  ? Center(
                      child: Text(
                        "No products available",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.all(16),
                      child: GridView.builder(
                        itemCount: productList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                          childAspectRatio: 0.65,
                        ),
                        itemBuilder: (context, index) {
                          final product = productList[index];
                          return productCard(product);
                        },
                      ),
                    ),
    );
  }

  Widget productCard(Product product) {
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
                  fontFamily: 'Garamond'),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Rp${product.price.toStringAsFixed(0)}',
              style: TextStyle(
                  color: Color(0xFFFFD700),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Garamond',
                  fontSize: 16),
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}