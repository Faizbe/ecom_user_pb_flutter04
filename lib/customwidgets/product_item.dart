import 'package:ecom_user_pb_flutter04/models/product_model.dart';
import 'package:ecom_user_pb_flutter04/providers/cart_provider.dart';
import 'package:ecom_user_pb_flutter04/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatefulWidget {
  final ProductModel product;
  ProductItem(this.product);

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)
        ),
        elevation: 7,
      child: Column(
        children: [
          widget.product.productImageUrl == null ?
              Expanded(child: Image.asset('images/imagenotavailable.png', width: double.infinity, fit: BoxFit.cover,))
           :
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: FadeInImage.assetNetwork(
                image: widget.product.productImageUrl!,
                placeholder: 'images/imagenotavailable.png',
                width: double.infinity,
                fadeInDuration: const Duration(seconds: 3),
                fadeInCurve: Curves.bounceInOut,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(widget.product.name!, style: TextStyle(fontSize: 16, color: Colors.black),),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text('$takaSymbol${widget.product.price}', style: TextStyle(fontSize: 20, color: Colors.black),),
          ),
          Consumer<CartProvider>(
            builder: (context, provider, _) => ElevatedButton(
              child: Text(provider.isInCart(widget.product.id!) ? 'REMOVE' : 'ADD'),
              onPressed: () {

                if(provider.isInCart(widget.product.id!)) {
                  provider.removeFromCart(widget.product.id!);
                }else {
                  provider.addToCart(widget.product);
                }
                print(provider.totalItemsInCart);
              },
            ),
          )
        ],
      ),
    );
  }
}
