import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/orders_provider.dart' show OrdersProvider;
import 'package:shop/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var ordersProvider = Provider.of<OrdersProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your orders"),
      ),
      body: ListView.builder(
        itemBuilder: (ctx, index) {
          return OrderItem(
            orderItem: ordersProvider.orders[index],
          );
        },
        itemCount: ordersProvider.orders.length,
      ),
    );
  }
}
