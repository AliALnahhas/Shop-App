import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/widgets/cart_item.dart';
import '../provider/cart.dart' show Cart;
import '../provider/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/CartScreen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'total',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(width: 10),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalamount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.title.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemcount,
              itemBuilder: (ctx, item) {
                return CartItem(
                  cart.items.values.toList()[item].id,
                  cart.items.keys.toList()[item],
                  cart.items.values.toList()[item].title,
                  cart.items.values.toList()[item].price,
                  cart.items.values.toList()[item].quantity,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
 
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (widget.cart.totalamount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalamount,
              );
              widget.cart.clear();
              setState(() {
                _isLoading = false;
              });
            },
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Text('ORDER NOW'),
      textColor: Theme.of(context).primaryColor,
    );
  }
}
