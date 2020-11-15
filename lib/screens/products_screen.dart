import 'package:flutter/material.dart';
import 'package:shop/widgets/products_overview_grid.dart';

class ProductsOverviewScreen extends StatelessWidget {
  static const String routeName = "/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key("SuperSeveret"),
      appBar: AppBar(
        title: Text("My shop"),
      ),
      body: ProductsGrid(),
    );
  }
}
