import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:shopapp/models/http.exception.dart';
import 'package:shopapp/provider/cart.dart';
import 'package:shopapp/provider/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
    /* Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),*/
  ];
  //var _showFavoriteOnly = false;
  List<Product> get items {
    //if (_showFavoriteOnly) {
    //return _items.where((item) => item.isFavorite).toList();
    //}
    return [..._items];
  }

  List<Product> get favoriteOnly {
    return _items.where((item) => item.isFavorite).toList();
  }

  final String token;
  final String userId;
  Products(this.token, this._items, this.userId);

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  //void showFavoriteOnly() {
  //_showFavoriteOnly = true;
  //notifyListeners();
  //}

  //void showAll() {
  //_showFavoriteOnly = false;
  //notifyListeners();
  //}

  Future<void> fetchAndSetProducts([bool filter = false]) async {
    final filterString = filter ? '&orderBy="createrId"&equalTo="$userId"' : '';
    var url =
        'https://shop-app-52a45-default-rtdb.firebaseio.com/products.json?auth=$token$filterString';
    //try {
    final response = await http.get(url);
    print(json.decode(response.body));
    //print(json.decode(response.body)['-MbB_jr5A5TS48PvVlIC']['title']);
    if (json.decode(response.body) != null) {
      url =
          'https://shop-app-52a45-default-rtdb.firebaseio.com/userFavorite/$userId.json?auth=$token';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            imageUrl: prodData['imageUrl'],
            price: prodData['price'],
            isFavorite:
                favoriteData == null ? false : favoriteData[prodId] ?? false,
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    }
    /*} catch (error) {
      throw HttpException('sorry');
    }*/
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://shop-app-52a45-default-rtdb.firebaseio.com/products.json?auth=$token';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'createrId': userId,
          },
        ),
      );
      print(json.decode(response.body)['name']);
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> delete(String id) async {
    final url =
        'https://shop-app-52a45-default-rtdb.firebaseio.com/products/$id.json?auth=$token';
    final existingProductIndex = _items.indexWhere((pro) => pro.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete it !!');
    }
    existingProduct = null;
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final proIndex = _items.indexWhere((pro) => pro.id == id);
    if (proIndex >= 0) {
      final url =
          'https://shop-app-52a45-default-rtdb.firebaseio.com/products/$id.json?auth=$token';
      await http.patch(
        url,
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'price': newProduct.price,
          'imageUrl': newProduct.imageUrl,
        }),
      );
      _items[proIndex] = newProduct;
      notifyListeners();
    }
  }
}
