import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../helpers/db_helper.dart';

class ProductProvider with ChangeNotifier {
  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  ProductProvider() {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    _products = await DatabaseHelper.instance.fetchAllProducts();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addProduct(String name, double price, String? imagePath) async {
    final newProduct = ProductModel(
      name: name,
      price: price,
      imagePath: imagePath,
    );
    await DatabaseHelper.instance.insertProduct(newProduct);
    await fetchProducts();
  }

  Future<void> updateProduct(int id, String name, double price, String? imagePath) async {
    final updatedProduct = ProductModel(
      id: id,
      name: name,
      price: price,
      imagePath: imagePath,
    );
    await DatabaseHelper.instance.updateProduct(updatedProduct);
    await fetchProducts();
  }

  Future<void> deleteProduct(int id) async {
    await DatabaseHelper.instance.deleteProduct(id);
    await fetchProducts();
  }
}
