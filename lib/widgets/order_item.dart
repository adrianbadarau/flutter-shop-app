import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/providers/orders_provider.dart' as provider;

class OrderItem extends StatefulWidget {
  final provider.OrderItem orderItem;

  OrderItem({this.orderItem});

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text("\$ ${widget.orderItem.amount}"),
            subtitle: Text(DateFormat('dd/MM/yyyy hh:mm')
                .format(widget.orderItem.createdAt)),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                height: min(widget.orderItem.products.length * 20.0 + 10, 180),
                child: ListView(
                  children: widget.orderItem.products
                      .map((e) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                e.title,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text("${e.quantity} X \$${e.price}",style: TextStyle(fontSize: 18, color: Colors.grey),)
                            ],
                          ))
                      .toList(),
                ),
              )
        ],
      ),
    );
  }
}
