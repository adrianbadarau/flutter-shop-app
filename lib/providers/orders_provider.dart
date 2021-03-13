import 'package:flutter/material.dart';
import 'package:shop/providers/cart_provider.dart' show CartItem;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime createdAt;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.createdAt});
}

class OrdersProvider with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> items, double total) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        products: items,
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
