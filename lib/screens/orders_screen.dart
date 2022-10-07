import 'package:flutter/material.dart';

import '../widgits/app_drawer.dart';

import 'package:provider/provider.dart';

import '../widgits/app_drawer.dart';
import '../widgits/order_item.dart';
import '../providers/orders.dart' show Orders;

class OrdersScreen extends StatelessWidget {
  static const routename = '/orders-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetorders(),
        builder: (_, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.error != null) {
              return Center(child: Text('An error occurred!'));
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (BuildContext context, int index) => OrderItem(
                    orderData.orders[index],
                  ),
                ),
              );
            }
          }
        },
      ),
      drawer: myDrawer(),
    );
  }
}
