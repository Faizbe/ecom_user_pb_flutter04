import 'package:ecom_user_pb_flutter04/db/db_helper.dart';
import 'package:ecom_user_pb_flutter04/models/user_model.dart';
import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {

  Future<void> addUser(UserModel userModel) {
    return DBHelper.addNewUser(userModel);
  }
}