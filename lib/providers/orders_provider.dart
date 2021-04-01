import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop/providers/cart_provider.dart' show CartItem;
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime createdAt;

  OrderItem({this.id, @required this.amount, @required this.products, @required this.createdAt});

  Map toJson() {
    return {'amount': amount, 'products': products, 'createdAt': createdAt.toString()};
  }
}

class OrdersProvider with ChangeNotifier {
  final String authToken;
  final dbUrl = Uri.https('flutter-shop-57d7b-default-rtdb.firebaseio.com', '/orders.json');
  List<OrderItem> _orders = [];
  final String userId;

  OrdersProvider(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> refreshOrdersFromServer() async {
    final resp = await http.get(dbUrl.replace(path: "/orders/$userId.json",queryParameters: {'auth': authToken}));
    final List<OrderItem> ordersList = [];
    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    if(data!=null){
      data.forEach((id, orderData) {
        final List<CartItem> products = [];
        final serverItems = orderData['products'] as List<dynamic>;
        serverItems.forEach((element) {
          products.add(CartItem(id: element['id'], title: element['title'], quantity: element['quantity'], price: element['price']));
        });
        ordersList.add(OrderItem(
            amount: orderData['amount'], products: products, createdAt: DateTime.parse(orderData['createdAt']), id: orderData['id']));
      });
    }
    _orders = ordersList;
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> items, double total) async {
    final order = OrderItem(
      amount: total,
      products: items,
      createdAt: DateTime.now(),
    );
    try {
      final resp = await http.post(dbUrl.replace(path: "/orders/$userId.json",queryParameters: {'auth': authToken}), body: jsonEncode(order));
      _orders.insert(
          0, OrderItem(amount: order.amount, products: order.products, createdAt: order.createdAt, id: jsonDecode(resp.body)['name']));
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
