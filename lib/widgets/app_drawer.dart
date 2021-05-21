import 'package:flutter/material.dart';
import 'package:shopapp/screens/products_overview_screen.dart';
import 'package:shopapp/screens/user_products_screen.dart';

import '../screens/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget drawers(String title, Function tap, Widget icon) {
      return GestureDetector(
        onTap: tap,
        child: Container(
          width: double.infinity,
          height: 70,
          child: Card(
            color: Theme.of(context).primaryColor,
            elevation: 6,
            child: Padding(
              padding: EdgeInsets.only(top: 20, left: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  icon,
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Drawer(
      child: Container(
        child: Column(
          children: <Widget>[
            AppBar(
              title: Text('Hello Friend !'),
              automaticallyImplyLeading: false,
            ),
            drawers(
              'Shop',
              () {
                print('All');
                Navigator.of(context)
                    .pushReplacementNamed(Productsoverviewscreen.routeName);
              },
              Icon(
                Icons.shop,
                color: Colors.white,
              ),
            ),
            drawers(
              'Orders',
              () {
                print('only');
                Navigator.of(context)
                    .pushReplacementNamed(OrdersScreen.routeName);
              },
              Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
            ),
            drawers(
              'Manage Your Products',
              () {
                Navigator.of(context)
                    .pushReplacementNamed(UserProductsScreen.routeName);
              },
              Icon(
                Icons.edit,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
