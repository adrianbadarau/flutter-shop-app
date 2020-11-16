import 'package:flutter/cupertino.dart';
import 'package:shop/config/mocks.dart';
import 'package:shop/models/product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = Mocks.getDummyProducts(10);

  List<Product> get items => [..._items];

  void addProduct(Product product) {
    // _items.add(product);
    notifyListeners();
  }

  Product findById(String id){
    return _items.firstWhere((element) => element.id == id);
  }
}
