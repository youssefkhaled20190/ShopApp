// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routename = '/product-Detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedproduct = Provider.of<Products>(context).findbyId(productId);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                loadedproduct.title!,
                style: TextStyle(color: Colors.black),
              ),
              background: Hero(
                tag: loadedproduct.id!,
                child: Image.network(
                  loadedproduct.imageUrl!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 10,
                ),
                Text(
                  '\$${loadedproduct.price}',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    loadedproduct.description!,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
