
import 'package:ecom_user_pb_flutter04/auth/auth_service.dart';
import 'package:ecom_user_pb_flutter04/pages/login_page.dart';
import 'package:ecom_user_pb_flutter04/pages/user_order_list_page.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            color: Colors.green,
            height: 200,
          ),
          ListTile(
            onTap: () {},
            leading: Icon(Icons.person),
            title: Text('My Profile'),
          ),
          ListTile(
            onTap: () => Navigator.pushNamed(context, UserOrderListPage.routeName),
            leading: Icon(Icons.reorder),
            title: Text('My Orders'),
          ),
          ListTile(
            onTap: () {
              AuthService
                  .logout()
                  .then((_) => Navigator.pushReplacementNamed(context, LoginPage.routeName));
            },
            leading: Icon(Icons.logout),
            title: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
