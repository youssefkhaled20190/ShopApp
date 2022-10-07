// ignore_for_file: sort_child_properties_last, prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import '../screens/product_detail_screen.dart';

class productItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
            ProductDetailScreen.routename,
            arguments: product.id,
          ),
          child: Hero(
            tag: product.id!,
            child: FadeInImage(
              placeholder:
                  const AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl!),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black,
          leading: Consumer<Product>(
            builder: (ctx, product, _) {
              return IconButton(
                onPressed: () {
                  product.toggleFavouriteStatus(
                      authData.token!, authData.UserId);
                },
                icon: Icon(product.isFavourite
                    ? Icons.favorite
                    : Icons.favorite_border),
                color: Theme.of(context).accentColor,
              );
            },
          ),
          title: Text(product.title!, textAlign: TextAlign.center),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.additem(product.id!, product.price!, product.title!);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Added to cart!"),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO!',
                    onPressed: () {
                      cart.removeSingleItem(product.id!);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
