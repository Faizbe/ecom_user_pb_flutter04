
import 'package:ecom_user_pb_flutter04/auth/auth_service.dart';
import 'package:ecom_user_pb_flutter04/models/user_model.dart';
import 'package:ecom_user_pb_flutter04/pages/product_list_page.dart';
import 'package:ecom_user_pb_flutter04/providers/user_provider.dart';
import 'package:ecom_user_pb_flutter04/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  String _errMsg = '';

  bool isLogin = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            shrinkWrap: true,
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  hintText: 'Email Address'
                ),
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return emptyFieldErrMsg;
                  }
                  return null;
                },
              ),
              SizedBox(height: 10,),
              TextFormField(
                obscureText: _obscureText,
                controller: _passwordController,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                    hintText: 'Password'
                ),
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return emptyFieldErrMsg;
                  }
                  return null;
                },
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                child: Text('LOGIN'),
                onPressed: () {
                  isLogin = true;
                  _loginUser();
                },
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('New User?'),
                  TextButton(
                    style: TextButton.styleFrom(
                        primary: Colors.blue
                    ),
                    child: Text('Reginster'),
                    onPressed: () {
                      isLogin = false;
                      _loginUser();
                    },
                  )
                ],
              ),
              Text(_errMsg)
            ],
          ),
        )
      ),
    );
  }

  void _loginUser() async {
    if(_formKey.currentState!.validate()) {
      try {
        String? uid;
        if(isLogin) {
          uid = await AuthService.loginUser(_emailController.text, _passwordController.text);
        }else {
          uid = await AuthService.registerUser(_emailController.text, _passwordController.text);
        }
        if(uid != null) {
          if(!isLogin) {
            final userModel = UserModel(userId: uid, email: AuthService.currentUser!.email!);
            Provider.of<UserProvider>(context, listen: false)
                .addUser(userModel);
          }
          Navigator.pushReplacementNamed(context, ProductListPage.routeName);
        }
      } on FirebaseAuthException catch (error) {
        setState(() {
          _errMsg = error.message!;
        });
    }
    }
  }
}
