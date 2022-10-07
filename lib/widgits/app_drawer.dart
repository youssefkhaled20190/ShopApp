import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/orders_screen.dart';
import '../screens/user_product_screen.dart';
import '../providers/auth.dart';

class myDrawer extends StatelessWidget {
  const myDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text("Welcome"),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("Shop"),
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text("Orders"),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(OrdersScreen.routename),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Manage Products"),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(UserProductScreen.routename),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
            onTap: () {
              Navigator.of(context).pop();

              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).LogOut();
            },
          ),
        ],
      ),
    );
  }
}
