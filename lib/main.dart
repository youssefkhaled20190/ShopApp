import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/screens/auth_screen.dart';
import 'package:shop/screens/cart_screeen.dart';
import 'package:shop/screens/edit_product_screen.dart';
import 'package:shop/screens/orders_screen.dart';
import 'package:shop/screens/product_detail_screen.dart';
import 'package:shop/screens/product_overview_screen.dart';
import 'package:shop/screens/splash_screen.dart';
import 'package:shop/screens/user_product_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders(),
          update: (ctx, authValue, PreviousOrders) => PreviousOrders!
            ..getData(
              authValue.token!,
              authValue.UserId,
              PreviousOrders.orders,
            ),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products(),
          update: (ctx, authValue, PreviousProducts) => PreviousProducts!
            ..getData(
              authValue.token!,
              authValue.UserId,
              PreviousProducts.items,
            ),
        ),
        // ChangeNotifierProvider.value(value: Products()),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.purple,
          ),
          home: auth.isAuth
              ? const ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.AutoLogin(),
                  builder: (context, Authsnapshot) =>
                      Authsnapshot.connectionState == ConnectionState.waiting
                          ? const splachScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routename: (_) => ProductDetailScreen(),
            CartScreen.routename: (_) => CartScreen(),
            OrdersScreen.routename: (_) => OrdersScreen(),
            UserProductScreen.routename: (_) => UserProductScreen(),
            EditProductScreen.routename: (_) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
