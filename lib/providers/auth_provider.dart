import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/models/http_exception.dart';

class AuthProvider with ChangeNotifier {
  static const String USER_DATA_KEY = 'userData';
  String _token;
  DateTime _expireDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return (token != null);
  }

  String get token {
    if (_expireDate != null && _expireDate.isAfter(DateTime.now()) && _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  void _saveLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = jsonEncode({'token': _token, 'userId': _userId, 'expireDate': _expireDate.toIso8601String()});
    prefs.setString(USER_DATA_KEY, userData);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(USER_DATA_KEY)) {
      final userData = jsonDecode(prefs.getString(USER_DATA_KEY)) as Map<String, Object>;
      final expireDate = DateTime.parse(userData['expireDate']);
      if (expireDate.isAfter(DateTime.now())) {
        _expireDate = expireDate;
        _userId = userData['userId'];
        _token = userData['token'];
        notifyListeners();
        _autoLogOut();
        return true;
      }
      return false;
    }
    return false;
  }

  Future<void> _authenticate(String email, String password, String type) async {
    final url = Uri.https('identitytoolkit.googleapis.com', '/v1/accounts:$type', {'key': 'AIzaSyDBs29Ek1QhLrKS_MNAcdRXtCmw6DPBNWs'});
    try {
      final resp = await http.post(url, body: jsonEncode({'email': email, 'password': password, 'returnSecureToken': true}));
      final data = jsonDecode(resp.body);
      if (data['error'] == null) {
        _token = data['idToken'];
        _userId = data['localId'];
        _expireDate = DateTime.now().add(Duration(seconds: int.parse(data['expiresIn'])));
        _autoLogOut();
        notifyListeners();
        _saveLoginData();
      } else {
        throw HttpException(data['error']['message']);
      }
    } catch (e) {
      throw e;
    }
  }

  void logout() async {
    _cancelTimer();
    _token = null;
    _userId = null;
    _expireDate = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(USER_DATA_KEY);
    notifyListeners();
  }

  void _autoLogOut() {
    _cancelTimer();
    final expireTime = _expireDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: expireTime), logout);
  }

  void _cancelTimer() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
  }
}
