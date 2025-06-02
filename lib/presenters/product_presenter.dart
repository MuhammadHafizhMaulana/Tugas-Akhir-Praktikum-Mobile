import 'package:royal_clothes/models/product_model.dart';
import 'package:royal_clothes/network/base_network.dart';

abstract class ProductView {
  void showLoading();
  void hideLoading();
  void showProductList(List<Product> productList);
  void showError(String message);
}

class ProductPresenter {
  final ProductView view;
  ProductPresenter(this.view);

  Future<void> loadProductData(String endpoint) async {
    try {
      view.showLoading();

      final List<dynamic> data = await BaseNetwork.getDataProduct(endpoint);

      final productList = data.map((json) => Product.fromJson(json)).toList();

      view.showProductList(productList);
    } catch (e) {
      view.showError(e.toString());
    } finally {
      view.hideLoading();
    }
  }
}

class ProductDetailPresenter {
  final ProductView view;
  ProductDetailPresenter(this.view);

  Future<void> loadProductDetail(String endpoint, int id) async {
    try {
      view.showLoading();

      final Map<String, dynamic> data = await BaseNetwork.getDetalDataProduct(
        endpoint,
        id,
      );

      final product = Product.fromJson(data);

      view.showProductList([product]); // Wrap in a list for consistency
    } catch (e) {
      view.showError(e.toString());
    } finally {
      view.hideLoading();
    }
  }
}
