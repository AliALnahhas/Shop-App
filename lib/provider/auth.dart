//import 'dart:ffi';
//import 'dart:math';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http.exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) return _token;
    return null;
  }

  Future<void> signup(String email, String password) async {
    print('email : $email');
    print('password : $password');
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBo6-oaHl7I7nS3nlo2edfUtHJZrxbB1-s';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseDate = json.decode(response.body);
      if (responseDate['error'] != null) {
        throw HttpException(responseDate['error']['message']);
      }
      _token = responseDate['idToken'];
      _userId = responseDate['localId'];
      _expiryDate = DateTime.now().add(
        Duration(seconds: int.parse(responseDate['expiresIn'])),
      );
      autoLogout();
      notifyListeners();
      //SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String email, String password) async {
    print('email : $email');
    print('password : $password');
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBo6-oaHl7I7nS3nlo2edfUtHJZrxbB1-s';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseDate = json.decode(response.body);
      if (responseDate['error'] != null) {
        throw HttpException(responseDate['error']['message']);
      }
      _token = responseDate['idToken'];
      _userId = responseDate['localId'];
      _expiryDate = DateTime.now().add(
        Duration(seconds: int.parse(responseDate['expiresIn'])),
      );
      autoLogout();
      notifyListeners();
      //SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
      print('i am login ${prefs.getString('userData')}');
      print(prefs.containsKey('userData'));
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryautologin() async {
    final prefs = await SharedPreferences.getInstance();
    print('tryautologin1');
    print(prefs.getString('userData'));
    if (!prefs.containsKey('userData')) {
      print('return');
      return false;
    }
    print('tryautologin2');
    final extractedData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) return false;
    _token = extractedData['token'];
    _userId = extractedData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    autoLogout();
    print('tryautologin');
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    print('Logout !!');
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void autoLogout() {
    if (_authTimer != null) _authTimer.cancel();
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
