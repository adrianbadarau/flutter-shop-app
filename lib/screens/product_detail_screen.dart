import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const String routeName = "/product-detail";

  ProductDetailScreen();

  @override
  Widget build(BuildContext context) {
    var prodId = ModalRoute.of(context).settings.arguments as String;
    var product =
        Provider.of<ProductsProvider>(context, listen: false).findById(prodId);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
    );
  }
}
