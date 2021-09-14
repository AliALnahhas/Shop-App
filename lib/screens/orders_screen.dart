import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/widgets/app_drawer.dart';

import '../provider/orders.dart';
import '../widgets/order_item.dart' as ca;

class OrdersScreen extends StatefulWidget {
  static const routeName = '/OrdersScreen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  Future _orderObtained;

  Future _future() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _orderObtained = _future();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('bulid !');
    //final orderDate = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _orderObtained,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.error != null) {
            return Center(
              child: Text('Error !'),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return RefreshIndicator(
              onRefresh: () => _refreshProducts(context),
              child: Consumer<Orders>(
                builder: (ctx, orderDate, child) => ListView.builder(
                  itemCount: orderDate.orders.length,
                  itemBuilder: (ctx, i) {
                    return ca.OrderItem(orderDate.orders[i]);
                  },
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
