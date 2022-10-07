import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgits/app_drawer.dart';
import '../widgits/user_product_item.dart';
import 'edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const routename = '/User-product-screen';

  Future<void> _refreshProducts(BuildContext context) async {
    try {
      await Provider.of<Products>(context, listen: false)
          .fetchAndSetProducts(true);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context).items;

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(EditProductScreen.routename),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, AsyncSnapshot snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () => _refreshProducts(context),
                  child: Consumer<Products>(builder: (ctx, productdata, _) {
                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: ListView.builder(
                        itemCount: productdata.items.length,
                        itemBuilder: (_, int index) {
                          return Column(
                            children: [
                              UserProductItem(
                                productdata.items[index].id!,
                                productdata.items[index].title!,
                                productdata.items[index].imageUrl!,
                              ),
                              Divider(),
                            ],
                          );
                        },
                      ),
                    );
                  }),
                );
        },
      ),
      drawer: myDrawer(),
    );
  }
}
