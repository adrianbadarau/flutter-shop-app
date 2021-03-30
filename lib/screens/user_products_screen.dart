import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/screens/edit_product_screen.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/user_product_item_widget.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = "/products";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your products"),
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              })
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<ProductsProvider>(context,listen: false).fetchAndSetProducts(true),
        builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _refreshProducts(context),
                child: Consumer<ProductsProvider>(
                  builder: (context, productsData, _) => Padding(
                    padding: EdgeInsets.all(8),
                    child: ListView.builder(
                      itemCount: productsData.items.length,
                      itemBuilder: (context, index) => Column(
                        children: [
                          UserProductItemWidget(
                            id: productsData.items[index].id,
                            title: productsData.items[index].title,
                            imageUrl: productsData.items[index].imageUrl,
                          ),
                          Divider()
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
      drawer: AppDrawer(),
    );
  }

  Future<void> _refreshProducts(BuildContext context) async {
    Provider.of<ProductsProvider>(context, listen: false).fetchAndSetProducts(true);
  }
}
