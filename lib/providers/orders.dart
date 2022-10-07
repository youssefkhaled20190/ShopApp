// ignore_for_file: unused_field, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String? id;
  final double? amount;
  final List<CartItem>? products;
  final DateTime? dateTime;
  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _Oreders = [];
  String? _authToken;
  String? _UserId;

  getData(String AuthToken, String UserId, List<OrderItem> Products) {
    _authToken = AuthToken;
    _UserId = UserId;
    _Oreders = Products;
    notifyListeners();
  }

  List<OrderItem> get orders {
    return [..._Oreders];
  }

  Future<void> fetchAndSetorders() async {
    var url =
        'https://shop-app-21487-default-rtdb.firebaseio.com/orders/$_UserId.json?auth=$_authToken';

    try {
      final res = await http.get(Uri.parse(url));
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }

      final List<OrderItem> loadedOrders = [];

      extractedData.forEach((OrderId, OrderData) {
        loadedOrders.add(OrderItem(
          id: OrderId,
          amount: OrderData['amount'],
          dateTime: DateTime.parse(OrderData['dateTime']),
          products: (OrderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price'],
                  ))
              .toList(),
        ));
      });
      _Oreders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> Addorder(List<CartItem> cartProduct, double total) async {
    final url =
        'https://shop-app-21487-default-rtdb.firebaseio.com/orders/$_UserId.json?auth=$_authToken';

    try {
      final timestamp = DateTime.now();
      final res = await http.post(
        Uri.parse(url),
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProduct
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price
                  })
              .toList()
        }),
      );
      _Oreders.insert(
          0,
          OrderItem(
            id: json.decode(res.body)['name'],
            amount: total,
            products: cartProduct,
            dateTime: timestamp,
          ));

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
