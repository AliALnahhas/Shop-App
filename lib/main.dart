import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopapp/provider/auth.dart';
import 'package:shopapp/provider/cart.dart';
import 'package:shopapp/provider/orders.dart';
import 'package:shopapp/provider/products.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/screens/edit_products_screen.dart';
import 'package:shopapp/screens/orders_screen.dart';
import 'package:shopapp/screens/product_detail_screen.dart';
import 'package:shopapp/screens/products_overview_screen.dart';
import 'package:shopapp/screens/splash_screen.dart';
import 'package:shopapp/screens/user_products_screen.dart';
import 'screens/auth_screen.dart';
import './helpers/custem_route.dart';

void main() {
  print('setMockInitialValues');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousStatue) => Products(
            auth.token,
            previousStatue == null ? [] : previousStatue.items,
            auth.userId,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousStatue) => Orders(
            auth.token,
            previousStatue == null ? [] : previousStatue.orders,
            auth.userId,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Shop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustemPageTransitionBuilder(),
                TargetPlatform.iOS: CustemPageTransitionBuilder(),
              },
            ),
          ),
          home: auth.isAuth
              ? Productsoverviewscreen()
              : FutureBuilder(
                  future: auth.tryautologin(),
                  builder: (ctx, authResultsnapshot) =>
                      authResultsnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            Productsoverviewscreen.routeName: (ctx) => Productsoverviewscreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductSreen.routeName: (ctx) => EditProductSreen(),
          },
        ),
      ),
    );
  }
}
