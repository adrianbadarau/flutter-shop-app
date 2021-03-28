import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite(String token) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final dbUrl = Uri.https(
        'flutter-shop-57d7b-default-rtdb.firebaseio.com', '/products/$id.json').replace(queryParameters: {'auth':token});
    final resp = await http.patch(dbUrl, body: jsonEncode(this));
    if (resp.statusCode >= 400) {
      isFavorite = oldStatus;
    }
  }

  @override
  String toString() {
    return 'Product{id: $id, title: $title, description: $description, price: $price, imageUrl: $imageUrl, isFavorite: $isFavorite}';
  }

  Map toJson() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite
    };
  }
}
