
import 'package:ecom_user_pb_flutter04/db/db_helper.dart';
import 'package:ecom_user_pb_flutter04/models/cart_model.dart';
import 'package:ecom_user_pb_flutter04/models/order_constants_model.dart';
import 'package:ecom_user_pb_flutter04/models/order_model.dart';
import 'package:flutter/foundation.dart';

class OrderProvider with ChangeNotifier {
  OrderConstantsModel orderConstantsModel = OrderConstantsModel();
  List<OrderModel> userOrderList = [];
  List<CartModel> orderDetailsList = [];

  void getOrderConstants() async {
    DBHelper.fetchOrderConstants().listen((event) {
      if(event.exists) {
        orderConstantsModel = OrderConstantsModel.fromMap(event.data()!);
        notifyListeners();
      }
    });
  }

  void getOrderDetails(String orderId) async {
    DBHelper.fetchAllOrderDetails(orderId).listen((event) {
      orderDetailsList = List.generate(event.docs.length, (index) => CartModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }

  void getUserOrders(String userId) async {
    DBHelper.fetchAllOrdersByUser(userId).listen((event) {
      userOrderList = List.generate(event.docs.length, (index) => OrderModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }

  num getDiscountAmount(num total) {
    return ((total * orderConstantsModel.discount) / 100).round();
  }

  num getTotalVatAmount(num total) {
    return ((total * orderConstantsModel.vat) / 100).round();
  }

  num getGrandTotal(num total) {
    return (total + getTotalVatAmount(total) + orderConstantsModel.deliveryCharge) - getDiscountAmount(total);
  }

  Future<void> addNewOrder(OrderModel orderModel, List<CartModel> cartModels) {
    return DBHelper.addNewOrder(orderModel, cartModels);
  }
}