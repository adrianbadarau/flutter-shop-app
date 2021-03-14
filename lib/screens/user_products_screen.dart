import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/user_product_item_widget.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = "/products";

  @override
  Widget build(BuildContext context) {
    var productsProvider = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your products"),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: () {})],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: productsProvider.items.length,
          itemBuilder: (context, index) => Column(
            children: [
              UserProductItemWidget(
                title: productsProvider.items[index].title,
                imageUrl: productsProvider.items[index].imageUrl,
              ),
              Divider()
            ],
          ),
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}