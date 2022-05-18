
import 'package:ecom_user_pb_flutter04/models/cart_model.dart';
import 'package:ecom_user_pb_flutter04/models/product_model.dart';
import 'package:flutter/foundation.dart';

class CartProvider with ChangeNotifier {
  List<CartModel> cartList = [];

  void addToCart(ProductModel productModel) {
    cartList.add(CartModel(productId: productModel.id!, productName: productModel.name!, price: productModel.price));
    notifyListeners();
  }

  void removeFromCart(String id) {
    final cartModel = cartList.firstWhere((element) => element.productId == id);
    cartList.remove(cartModel);
    notifyListeners();
  }

  void increaseQty(CartModel cartModel) {
      cartModel.qty += 1;
      notifyListeners();
  }

  void decreaseQty(CartModel cartModel) {
    if(cartModel.qty > 1) {
      cartModel.qty -= 1;
      notifyListeners();
    }
  }

  void clearCart() {
    cartList.clear();
    notifyListeners();
  }

  bool isInCart(String id) {
    bool tag = false;
    for(var model in cartList) {
      if(model.productId == id) {
        tag = true;
        break;
      }
    }
    return tag;
  }

  int get totalItemsInCart => cartList.length;

  num get cartItemsTotalPrice {
    num total = 0;
    cartList.forEach((element) {
      total += element.price * element.qty;
    });
    return total;
  }

  num grandTotal(int discount, int vat, int deliveryCharge) {
    var grandTotal = 0;

    return grandTotal;
  }
}