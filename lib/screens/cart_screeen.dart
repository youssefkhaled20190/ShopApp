// ignore_for_file: prefer_const_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart, CartItem;
import '../providers/orders.dart';
import '../widgits/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routename = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Cart"),
        ),
        body: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Card(
              margin: const EdgeInsets.all(15),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(fontSize: 20),
                    ),
                    Spacer(),
                    Chip(
                      label: Text(
                        '\$${cart.TotalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6!
                              .color,
                        ),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    // OrderButton(cart: cart),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
                child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, int index) {
                return Cartitem(
                  cart.items.values.toList()[index].id!,
                  cart.items.keys.toList()[index],
                  cart.items.values.toList()[index].price!,
                  cart.items.values.toList()[index].quantity!,
                  cart.items.values.toList()[index].title!,
                );
              },
            ))
          ],
        ));
  }
}

class OrderButton extends StatefulWidget {
  final Cart cart;
  const OrderButton({
    required this.cart,
  });

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
      onPressed: (widget.cart.TotalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).Addorder(
                widget.cart.items.values.toList(),
                widget.cart.TotalAmount,
              );
              setState(() {
                _isLoading = false;
              });
              widget.cart.clear();
            },
      // textColor: Theme.of(context).primaryColor,
    );
  }
}
