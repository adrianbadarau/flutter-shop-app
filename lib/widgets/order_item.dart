import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/providers/orders_provider.dart' as provider;

class OrderItem extends StatelessWidget {
  final provider.OrderItem orderItem;

  OrderItem({this.orderItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text("\$ ${orderItem.amount}"),
            subtitle: Text(
                DateFormat('dd MM yyyy hh:mm').format(orderItem.createdAt)),
            trailing: IconButton(
              icon: Icon(Icons.expand_more),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
