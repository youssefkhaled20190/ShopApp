// ignore_for_file: unused_field, non_constant_identifier_names, prefer_final_fields, unnecessary_null_comparison, curly_braces_in_flow_control_structures

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../models/http_exception.dart';
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
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
    ),
  ];
  String? _authToken;
  String? _UserId;

  getData(String AuthToken, String UserId, List<Product> Products) {
    _authToken = AuthToken;
    _UserId = UserId;
    _items = Products;
    notifyListeners();
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get Favitems {
    return _items.where((prodItem) => prodItem.isFavourite).toList();
  }

  Product findbyId(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$_UserId"' : '';

    var url =
        'https://shop-app-21487-default-rtdb.firebaseio.com/products.json?auth=$_authToken&$filterString';

    try {
      final res = await http.get(Uri.parse(url));
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url =
          'https://shop-app-21487-default-rtdb.firebaseio.com/userFavorites/$_UserId.json?auth=$_authToken';

      final favRes = await http.get(Uri.parse(url));
      final favData = json.decode(favRes.body);
      final List<Product> loadedProducts = [];

      extractedData.forEach((prodId, ProdData) {
        loadedProducts.add(Product(
          id: _UserId,
          title: ProdData['title'],
          description: ProdData['description'],
          price: ProdData['price'],
          isFavourite: favData == null ? false : favData[prodId] ?? false,
          imageUrl: ProdData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> AddProducts(Product product) async {
    final url =
        'https://shop-app-21487-default-rtdb.firebaseio.com/products.json?auth=$_authToken';

    try {
      final res = await http.post(
        Uri.parse(url),
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': _UserId
        }),
      );
      final newProduct = Product(
        id: json.decode(res.body)['name'],
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://shop-app-21487-default-rtdb.firebaseio.com/$id.json?auth=$_authToken';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print("...");
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://shop-app-21487-default-rtdb.firebaseio.com/$id.json?auth=$_authToken';
    final existingproductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingproduct = _items[existingproductIndex];
    _items.removeAt(existingproductIndex);
    notifyListeners();

    final res = await http.delete(Uri.parse(url));
    if (res.statusCode >= 400) {
      _items.insert(existingproductIndex, existingproduct);
      notifyListeners();
      throw HttpException('Could not delete Product.');
    }
    existingproduct = null;
  }
}
