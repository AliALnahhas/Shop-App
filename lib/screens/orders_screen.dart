import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/widgets/app_drawer.dart';

import '../provider/orders.dart';
import '../widgets/order_item.dart' as ca;

class OrdersScreen extends StatelessWidget {
  static const routeName = '/OrdersScreen';

  @override
  Widget build(BuildContext context) {
    final orderDate = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: orderDate.orders.length,
        itemBuilder: (ctx, i) {
          return ca.OrderItem(orderDate.orders[i]);
        },
      ),
    );
  }
}
