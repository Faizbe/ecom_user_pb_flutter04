import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_user_pb_flutter04/models/order_model.dart';
import 'package:ecom_user_pb_flutter04/models/product_model.dart';
import 'package:ecom_user_pb_flutter04/models/user_model.dart';

import '../models/cart_model.dart';

class DBHelper {
  static const _collectionProduct = 'Products';
  static const _collectionCategory = 'Categories';
  static const _collectionUser = 'Users';
  static const _collectionOrder = 'Orders';
  static const _collectionOrderDetails = 'OrderDetails';
  static const _collectionOrderUtils = 'OrderUtils';
  static const _documentConstants = 'Constants';

  static FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> addNewUser(UserModel userModel) {
    final doc = _db.collection(_collectionUser).doc(userModel.userId);
    return doc.set(userModel.toMap());
  }

  static Future<void> addNewOrder(OrderModel orderModel, List<CartModel> cartList) {
    final writeBatch = _db.batch();
    final orderDoc = _db.collection(_collectionOrder).doc();
    orderModel.orderId = orderDoc.id;
    writeBatch.set(orderDoc, orderModel.toMap());
    for(var cartModel in cartList) {
      final cartDoc = orderDoc.collection(_collectionOrderDetails).doc();
      writeBatch.set(cartDoc, cartModel.toMap());
    }
    return writeBatch.commit();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllOrdersByUser(String userId) =>
      _db.collection(_collectionOrder).where('user_id', isEqualTo: userId).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllOrderDetails(String orderId) =>
      _db.collection(_collectionOrder).doc(orderId).collection(_collectionOrderDetails).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllCategories() =>
      _db.collection(_collectionCategory).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllProducts() =>
      _db.collection(_collectionProduct).snapshots();

  static Stream<DocumentSnapshot<Map<String, dynamic>>> fetchProductByProductId(String productId) =>
      _db.collection(_collectionProduct).doc(productId).snapshots();

  static Stream<DocumentSnapshot<Map<String, dynamic>>> fetchOrderConstants() =>
      _db.collection(_collectionOrderUtils).doc(_documentConstants).snapshots();



}