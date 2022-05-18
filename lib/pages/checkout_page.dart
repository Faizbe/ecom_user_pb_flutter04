import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_user_pb_flutter04/auth/auth_service.dart';
import 'package:ecom_user_pb_flutter04/models/order_model.dart';
import 'package:ecom_user_pb_flutter04/pages/order_successful_page.dart';
import 'package:ecom_user_pb_flutter04/pages/product_list_page.dart';
import 'package:ecom_user_pb_flutter04/providers/cart_provider.dart';
import 'package:ecom_user_pb_flutter04/providers/order_provider.dart';
import 'package:ecom_user_pb_flutter04/utils/constants.dart';
import 'package:ecom_user_pb_flutter04/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  static const String routeName = '/checkout';

  const CheckoutPage({Key? key}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late CartProvider _cartProvider;
  late OrderProvider _orderProvider;
  String radioGroupValue = Payment.cod;
  final _addressController = TextEditingController();

  @override
  void didChangeDependencies() {
    _cartProvider = Provider.of<CartProvider>(context);
    _orderProvider = Provider.of<OrderProvider>(context);
    _orderProvider.getOrderConstants();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                const Text('Your Items', style: TextStyle(fontSize: 20),),
                const Divider(height: 1, color: Colors.black,),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _cartProvider.cartList.map((cartModel) => ListTile(
                    title: Text(cartModel.productName),
                    trailing: Text('${cartModel.qty}x${cartModel.price}'),
                  )).toList(),
                ),
                const Text('Order Summery', style: TextStyle(fontSize: 20),),
                const Divider(height: 1, color: Colors.black,),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Cart Total'),
                        Text('$takaSymbol${_cartProvider.cartItemsTotalPrice}',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Delivery Charge'),
                        Text('$takaSymbol${_orderProvider.orderConstantsModel.deliveryCharge}',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Discount(${_orderProvider.orderConstantsModel.discount}%)'),
                        Text('-$takaSymbol${_orderProvider.getDiscountAmount(_cartProvider.cartItemsTotalPrice)}',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('VAT(${_orderProvider.orderConstantsModel.vat}%)'),
                        Text('$takaSymbol${_orderProvider.getTotalVatAmount(_cartProvider.cartItemsTotalPrice)}',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),)
                      ],
                    ),
                    const Divider(height: 1, color: Colors.black,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Grand Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        Text('$takaSymbol${_orderProvider.getGrandTotal(_cartProvider.cartItemsTotalPrice)}',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),)
                      ],
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
                const Text('Set Delivery Address', style: TextStyle(fontSize: 20),),
                const Divider(height: 1, color: Colors.black,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder()
                    ),
                  ),
                ),
                const Text('Select Payment Method', style: TextStyle(fontSize: 20),),
                const Divider(height: 1, color: Colors.black,),
                Row(
                  children: [
                    Radio<String>(
                      groupValue: radioGroupValue,
                      value: Payment.cod,
                      onChanged: (value) {
                        setState(() {
                          radioGroupValue = value!;
                        });
                      },
                    ),
                    Text(Payment.cod)
                  ],
                ),
                Row(
                  children: [
                    Radio<String>(
                      groupValue: radioGroupValue,
                      value: Payment.online,
                      onChanged: (value) {
                        setState(() {
                          radioGroupValue = value!;
                        });
                      },
                    ),
                    Text(Payment.online)
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              child: const Text('PLACE ORDER'),
              onPressed: _saveOrder,
            ),
          )
        ],
      ),
    );
  }

  void _saveOrder() {
    if(_addressController.text.isEmpty) {
      showMsg(context, 'Please provide a delivery address');
      return;
    }

    final orderModel = OrderModel(
        timestamp: Timestamp.now(),
        grandTotal: _orderProvider.getGrandTotal(_cartProvider.cartItemsTotalPrice),
        discount: _orderProvider.orderConstantsModel.discount,
        deliveryCharge: _orderProvider.orderConstantsModel.deliveryCharge,
        vat: _orderProvider.orderConstantsModel.vat,
        orderStatus: OrderStatus.pending,
        userId: AuthService.currentUser!.uid,
        deliveryAddress: _addressController.text,
        paymentMethod: radioGroupValue);
    _orderProvider.addNewOrder(orderModel, _cartProvider.cartList)
        .then((value) {
          _cartProvider.clearCart();
      Navigator.pushNamedAndRemoveUntil(context, OrderSuccessfulPage.routeName, ModalRoute.withName(ProductListPage.routeName));
    }).catchError((error) {
      showMsg(context, 'Could not save');
    });
  }
}
