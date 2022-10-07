// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_field
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItem {
  String? id;
  String? title;
  int? quantity;
  final double? price;
  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get TotalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += (cartItem.price! * cartItem.quantity!);
    });
    return total;
  }

  void additem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingCartitems) => CartItem(
                id: existingCartitems.id,
                title: existingCartitems.title,
                quantity: existingCartitems.quantity! + 1,
                price: existingCartitems.price,
              ));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
                id: DateTime.now().toString(),
                title: title,
                quantity: 1,
                price: price,
              ));
    }
    notifyListeners();
  }

  void removeItems(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity! > 1) {
      _items.update(
          productId,
          (existingCartitems) => CartItem(
                id: existingCartitems.id,
                title: existingCartitems.title,
                quantity: existingCartitems.quantity! - 1,
                price: existingCartitems.price,
              ));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }
}
