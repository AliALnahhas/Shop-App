import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/screens/cart_screen.dart';
//import 'package:shopapp/screens/orders_screen.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/badge.dart';
import '../widgets/product_grid.dart';
import '../provider/products.dart';
import '../provider/cart.dart';

enum FilterOptions {
  Favorite,
  All,
  Orders,
}

class Productsoverviewscreen extends StatefulWidget {
  static const routeName = '/Productsoverviewscreen';
  @override
  _ProductsoverviewscreenState createState() => _ProductsoverviewscreenState();
}

class _ProductsoverviewscreenState extends State<Productsoverviewscreen> {
  bool showFavoriteOnly = false;
  bool showOrders = false;
  bool _isInit = true;
  bool _isloading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isloading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        print(_isloading);
        setState(() {
          _isloading = false;
          print(_isloading);
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //final cart = Provider.of<Cart>(context);

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Shop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(
                () {
                  if (selectedValue == FilterOptions.Favorite) {
                    showFavoriteOnly = true;
                  } else {
                    showFavoriteOnly = false;
                  }
                },
              );
            },
            child: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorite'),
                value: FilterOptions.Favorite,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemcount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                print('hello');
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(showFavoriteOnly),
    );
  }
}
