import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop/models/http_exception.dart';
import 'package:shop/models/product.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  String authToken;
  String userId;

  ProductsProvider();

  final dbUrl = Uri.https('flutter-shop-57d7b-default-rtdb.firebaseio.com', '/products.json');
  List<Product> _items = [];

  List<Product> get items => [..._items];

  List<Product> get favoriteItems => _items.where((element) => element.isFavorite).toList();

  Future<void> addProduct(Product product) async {
    try {
      var value = await http.post(dbUrl.replace(query: 'auth=$authToken'), body: json.encode(product));
      var newProduct = Product(
          id: jsonDecode(value.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
          userId: product.userId,
          isFavorite: product.isFavorite);
      _items.add(newProduct);
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    var productsEndpoint = dbUrl.replace(queryParameters: {'auth': authToken});
    if (filterByUser) {
      productsEndpoint = productsEndpoint.replace(queryParameters: {
        'auth': authToken,
        'orderBy': '"userId"',
        'equalTo': '"$userId"',
      });
    }
    final resp = await http.get(productsEndpoint);
    final extractedData = jsonDecode(resp.body) as Map<String, dynamic>;
    final List<Product> loadedProducts = [];
    final favoritesUrl = Uri.https('flutter-shop-57d7b-default-rtdb.firebaseio.com', 'userFavorites/$userId.json')
        .replace(queryParameters: {'auth': authToken});
    final favoritesResp = await http.get(favoritesUrl);
    final favoritesData = jsonDecode(favoritesResp.body) ?? {};
    extractedData.forEach((key, value) {
      loadedProducts.add(
        Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageUrl'],
            isFavorite: favoritesData[key] != null ? favoritesData[key]['isFavorite'] : false,
            userId: value['userId']),
      );
    });
    _items = loadedProducts;
    notifyListeners();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> updateProduct(Product editedProduct) async {
    final dbUrl = Uri.https('flutter-shop-57d7b-default-rtdb.firebaseio.com', '/products/${editedProduct.id}.json')
        .replace(queryParameters: {'auth': authToken});
    await http.patch(dbUrl, body: jsonEncode(editedProduct));
    final index = _items.indexWhere((element) => element.id == editedProduct.id);
    _items[index] = editedProduct;
    notifyListeners();
  }

  void delete(String id) {
    final dbUrl =
        Uri.https('flutter-shop-57d7b-default-rtdb.firebaseio.com', '/products/$id.json').replace(queryParameters: {'auth': authToken});
    http.delete(dbUrl).then((resp) {
      if (resp.statusCode >= 200) {
        throw HttpException('Could not delete product');
      }
    });
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
