import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/http_exception.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  DateTime _expireDate;
  String _userId;

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> _authenticate(String email, String password, String type) async {
    final url = Uri.https('identitytoolkit.googleapis.com', '/v1/accounts:$type', {'key': 'AIzaSyDBs29Ek1QhLrKS_MNAcdRXtCmw6DPBNWs'});
    try {
      final resp = await http.post(url, body: jsonEncode({'email': email, 'password': password, 'returnSecureToken': true}));
      final data = jsonDecode(resp.body);
      if (data['error'] == null) {
        _token = data['idToken'];
        print(jsonDecode(resp.body));
      } else {
        throw HttpException(data['error']['message']);
      }
    } catch (e) {
      throw e;
    }
  }
}
