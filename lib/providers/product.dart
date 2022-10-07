// ignore_for_file: unused_import, invalid_required_positional_param, unused_element
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String? id;
  final String? title;
  final String? description;
  final double? price;
  final String? imageUrl;
  bool isFavourite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavourite = false});

  void _setfavValue(bool newval) {
    isFavourite = newval;
    notifyListeners();
  }

  Future<void> toggleFavouriteStatus(String token, String userId) async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    final url = '';
    try {
      final res = await http.put(Uri.http(url), body: json.encode(isFavourite));
      if (res.statusCode >= 400) {
        _setfavValue(oldStatus);
      }
    } catch (e) {
      _setfavValue(oldStatus);
    }
  }
}
