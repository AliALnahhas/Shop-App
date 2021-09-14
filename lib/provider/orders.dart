import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:shopapp/provider/cart.dart';
import 'package:http/http.dart' as http;
import '../models/http.exception.dart';
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime datetime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.datetime,
    @required this.products,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  final String userId;
  final String token;
  Orders(this.token, this._orders, this.userId);
  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    print('add!');
    final url =
        'https://shop-app-52a45-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token';
    final time = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': DateTime.now().toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'title': cp.title,
                  'price': cp.price,
                  'quantity': cp.quantity,
                  'id': cp.id,
                })
            .toList(),
      }),
    );
    print(response.body);
    _orders.insert(
      0,
      OrderItem(
        id: jsonDecode(response.body)['name'],
        amount: total,
        datetime: time,
        products: cartProducts,
      ),
    );

    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://shop-app-52a45-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token';
    try {
      final response = await http.get(url);
      print(json.decode(response.body));
      if (json.decode(response.body) != null) {
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;
        final List<OrderItem> loadedOrders = [];

        extractedData.forEach((orid, oritem) {
          loadedOrders.add(
            OrderItem(
              id: orid,
              amount: oritem['amount'],
              datetime: DateTime.parse(oritem['dateTime']),
              products: (oritem['products'] as List<dynamic>).map(
                (item) {
                  return CartItem(
                    id: item['id'],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price'],
                  );
                },
              ).toList(),
            ),
          );
        });
        _orders = loadedOrders.reversed.toList();
        notifyListeners();
      }
    } catch (error) {
      throw HttpException('sorry');
    }
  }
}
