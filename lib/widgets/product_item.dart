import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';
import 'package:shop/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  final Product _product;

  const ProductItem(this._product);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(ProductDetailScreen.routeName, arguments: {'product': _product});
          },
          child: Image.network(
            _product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          title: Text(
            _product.title,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.black87,
          leading: IconButton(
            icon: Icon(Icons.favorite, color: Theme.of(context).accentColor),
            onPressed: () {},
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart, color: Theme.of(context).accentColor),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
