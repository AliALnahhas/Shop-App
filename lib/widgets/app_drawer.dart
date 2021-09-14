import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/screens/products_overview_screen.dart';
import 'package:shopapp/screens/user_products_screen.dart';

import '../screens/orders_screen.dart';
import '../provider/auth.dart';
import '../helpers/custem_route.dart';

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
            //color: Theme.of(context).primaryColor,
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
                      //color: Colors.white,
                      //fontWeight: FontWeight.bold,
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
              title: Text('Manager'),
              automaticallyImplyLeading: false,
            ),
            drawers(
              'Shop',
              () {
                print('All');
                Navigator.of(context)
                    .pushReplacementNamed(Productsoverviewscreen.routeName);
                /*Navigator.of(context).pushReplacement(
                  CustemRoute(
                    builder: (ctx) => Productsoverviewscreen(),
                  ),
                );*/
              },
              Icon(
                Icons.shop,
                color: Colors.black38,
              ),
            ),
            drawers(
              'Orders',
              () {
                print('only');
                Navigator.of(context)
                    .pushReplacementNamed(OrdersScreen.routeName);
                /*Navigator.of(context).pushReplacement(
                  CustemRoute(
                    builder: (ctx) => OrdersScreen(),
                  ),
                );*/
              },
              Icon(
                Icons.shopping_cart,
                color: Colors.black38,
              ),
            ),
            drawers(
              'Manage Your Products',
              () {
                Navigator.of(context)
                    .pushReplacementNamed(UserProductsScreen.routeName);
                /*Navigator.of(context).pushReplacement(
                  CustemRoute(
                    builder: (ctx) => UserProductsScreen(),
                  ),
                );*/
              },
              Icon(
                Icons.edit,
                color: Colors.black38,
              ),
            ),
            drawers(
              'Logout',
              () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<Auth>(context, listen: false).logout();
              },
              Icon(
                Icons.exit_to_app,
                color: Colors.black38,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
