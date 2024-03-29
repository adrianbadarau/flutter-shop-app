import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/orders_provider.dart' show OrdersProvider;
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = "/orders";

  @override
  Widget build(BuildContext context) {
    var ordersProvider = Provider.of<OrdersProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your orders"),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: ordersProvider.refreshOrdersFromServer(),
        builder: (context, data) {
          return RefreshIndicator(
            onRefresh: () => _refreshItems(context),
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                return OrderItem(
                  orderItem: ordersProvider.orders[index],
                );
              },
              itemCount: ordersProvider.orders.length,
            ),
          );
        },
      ),
    );
  }

  _refreshItems(BuildContext context) {
    return Provider.of<OrdersProvider>(context, listen: false).refreshOrdersFromServer();
  }

}
