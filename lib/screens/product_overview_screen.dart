// ignore_for_file: prefer_const_constructors, unused_field, prefer_final_fields, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/widgits/app_drawer.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import '../widgits/badge.dart';
import '../widgits/product_grid.dart';
import 'cart_screeen.dart';

// specific items that i need ( favourites , all items )
enum filteration { favourites, all }

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({super.key});

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _isloading = false;
  bool _showFavitems = false;

  @override
  void initState() {
    super.initState();
    _isloading = true;
    Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts()
        .then((_) => setState(
              () => _isloading = false,
            ))
        .catchError((_) => setState(
              () => _isloading = false,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shop"),
        actions: [
          PopupMenuButton(
            onSelected: (filteration selectedval) {
              setState(() {
                if (selectedval == filteration.favourites) {
                  _showFavitems = true;
                } else {
                  _showFavitems = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Show Favourites'),
                value: filteration.favourites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: filteration.all,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch!,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () =>
                  Navigator.of(context).pushNamed(CartScreen.routename),
            ),
          ),
        ],
      ),
      body: Center(
        child: _isloading
            ? Center(child: CircularProgressIndicator())
            : ProductsGrid(_showFavitems),
      ),
      drawer: myDrawer(),
    );
  }
}
