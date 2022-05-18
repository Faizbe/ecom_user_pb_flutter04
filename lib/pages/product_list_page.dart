
import 'package:ecom_user_pb_flutter04/customwidgets/main_drawer.dart';
import 'package:ecom_user_pb_flutter04/customwidgets/product_item.dart';
import 'package:ecom_user_pb_flutter04/pages/cart_page.dart';
import 'package:ecom_user_pb_flutter04/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListPage extends StatefulWidget {
  static const String routeName = '/product_list';

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late ProductProvider _productProvider;

  @override
  void didChangeDependencies() {
    _productProvider = Provider.of<ProductProvider>(context);
    _productProvider.getAllProducts();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      drawer: MainDrawer(),
      appBar: AppBar(
        title: const Text('Product List'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, CartPage.routeName),
          )
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 0.65,
        children: _productProvider.productList.map((product) =>
            ProductItem(product)).toList(),
      ),
    );
  }
}
