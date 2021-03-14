import 'package:flutter/material.dart';
import 'package:shop/config/mocks.dart';
import 'package:shop/models/product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = Mocks.getDummyProducts(10);

  List<Product> get items => [..._items];

  List<Product> get favoriteItems =>
      _items.where((element) => element.isFavorite).toList();

  void addProduct(Product product) {
    final newProduct = Product(
        id: DateTime.now().toIso8601String(),
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl);
    _items.add(newProduct);
    notifyListeners();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  void updateProduct(Product editedProduct) {
    final index =
        _items.indexWhere((element) => element.id == editedProduct.id);
    _items[index] = editedProduct;
    notifyListeners();
  }

  void delete(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
