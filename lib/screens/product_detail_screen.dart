
import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  static const String routeName = "/product-detail";

  ProductDetailScreen();

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments as Map<String, Object>;
    var product = args["product"] as Product;
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
    );
  }
}
