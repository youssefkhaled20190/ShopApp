// ignore_for_file: unused_import, unused_field

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  // this get method used to know if there are useres already signed in or not

  bool get isAuth {
    return _token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    } else {
      return null;
    }
  }

  String get UserId {
    return _userId!;
  }

  Future<void> _authenticate(
    String email,
    String password,
    String urlSegment,
  ) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCFOHR9PwOguhJnBIwjgOzDsVngfdZkjjU';
    try {
      final res = await http.post(Uri.parse(url),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responsedata = json.decode(res.body);
      if (responsedata['error'] != null) {
        throw HttpException(responsedata['error']['message']);
      }

      _token = responsedata['idToken'];
      _userId = responsedata['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responsedata['expiresIn'])));

      //autologOut();
      notifyListeners();
      final pref = await SharedPreferences.getInstance();
      String userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
      });
      pref.setString('userData', userData);
    } catch (e) {
      throw e;
    }
  }

  Future<void> signUp(String email, String password) async {
    return await _authenticate(email, password, "signUp");
  }

  Future<void> Login(String email, String password) async {
    return await _authenticate(email, password, "signInWithPassword");
  }

  Future<bool> AutoLogin() async {
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey('userData')) return false;

    final Map<String, Object> extractedData = json
        .decode(pref.getString('userData') as String) as Map<String, Object>;

    final expireyDate = DateTime.parse(extractedData['expiryDate'] as String);

    // if expireydate 3ada l wa2t l 7aley return false

    if (expireyDate.isBefore(DateTime.now())) return false;

    // store all the data of the user
    _token = extractedData['token'] as String;
    _userId = extractedData['userId'] as String;
    _expiryDate = expireyDate;
    notifyListeners();
    // autologOut();

    return true;
  }

  Future<void> LogOut() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer == null;
    }
    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  void autologOut() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timetoExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(days: timetoExpiry), LogOut);
  }
}
