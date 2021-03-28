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
  final String userId;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
    this.userId,
  });

  Future<void> toggleFavorite(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final dbUrl = Uri.https('flutter-shop-57d7b-default-rtdb.firebaseio.com', 'userFavorites/$userId/$id.json')
        .replace(queryParameters: {'auth': token});
    final resp = await http.put(dbUrl, body: jsonEncode({'isFavorite': isFavorite}));
    if (resp.statusCode >= 400) {
      isFavorite = oldStatus;
    }
  }

  @override
  String toString() {
    return 'Product{id: $id, title: $title, description: $description, price: $price, imageUrl: $imageUrl, isFavorite: $isFavorite}';
  }

  Map toJson() {
    return {'title': title, 'description': description, 'price': price, 'imageUrl': imageUrl, 'userId': userId};
  }
}
