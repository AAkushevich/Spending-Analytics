import 'package:flutter/material.dart';
import 'package:spending_analytics/data/Constants/ConstStrings.dart';
import 'package:spending_analytics/data/repository/ApiReposytory.dart';
import 'package:spending_analytics/data/repository/SharPrefRepositiry.dart';
import 'package:spending_analytics/ui/AuthPage/AuthBloc.dart';
import 'package:spending_analytics/ui/BaseSate/BaseState.dart';
import 'package:toast/toast.dart';

class SignUpPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
   return LoginPageState();
  }
}

class LoginPageState extends BaseState<SignUpPage, AuthBloc> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordController2 = TextEditingController();


  void validateAndSignUp() {
    if(_emailController.text.isEmpty || _passwordController.text.isEmpty || _passwordController2.text.isEmpty) {
      Toast.show("Все поля должны быть заполнены", context, duration: Toast.LENGTH_LONG);
      return;
    }
    if(!RegExp(Constants.emailRegEx).hasMatch(_emailController.text)) {
      Toast.show("Невалидный email", context, duration: Toast.LENGTH_LONG);
      return;
    }
    if(_passwordController.text.compareTo(_passwordController2.text) != 0) {
      Toast.show("Пароли не совпадаюют", context, duration: Toast.LENGTH_LONG);
      return;
    }
    if(_passwordController.text.length < 6) {
      Toast.show("Длина пароля должна быть не менее 6 символов", context, duration: Toast.LENGTH_LONG);
      return;
    }
    bloc.signUp(_emailController.text, _passwordController.text);
  }

  @override
  Widget buildStateContent() {
    return _buildPageContent(context);
  }

  @override
  PreferredSizeWidget buildTopToolbarTitleWidget() {
    return null;
  }

  @override
  void disposeExtra() {
    // TODO: implement disposeExtra
  }

  @override
  AuthBloc initBloC() {
    return AuthBloc(ApiRepository(), SharedPrefRepository());
  }

  @override
  void preInitState() {
    bloc.signUpEventStream.listen((event) {
      Navigator.pop(context);
    },
        onError: (error) {
          Toast.show(error, context, duration: Toast.LENGTH_LONG);
        });
  }

  Widget _buildPageContent(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        children: <Widget>[
          SizedBox(height: 50.0),
          _buildLoginForm(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              FloatingActionButton(
                mini: true,
                onPressed: () {
                  Navigator.pop(context);
                },
                backgroundColor: Colors.black,
                child: Icon(Icons.arrow_back, color: Colors.white,),
              )
            ],
          )
        ],
      ),
    );
  }

  Container _buildLoginForm() {
    return Container(
      decoration: new BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 200.0, // has the effect of softening the shadow
            spreadRadius: -80.0, // has the effect of extending the shadow
            offset: Offset(
              0.0, // horizontal, move right 10
              0.0, // vertical, move down 10
            ),
          )
        ],
      ),
      padding: EdgeInsets.all(20.0),
      child: Stack(
        children: <Widget>[
          Container(
            height: 400,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(40.0)),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 90.0,),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      controller: _emailController,
                      decoration: InputDecoration(
                          hintText: "Email address",
                          hintStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                          icon: Icon(Icons.email, color: Colors.black,)
                      ),
                    )
                ),
                Container(child: Divider(color: Colors.black), padding: EdgeInsets.only(left: 20.0,right: 20.0, bottom: 10.0)),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      controller: _passwordController,
                      decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                          icon: Icon(Icons.lock, color: Colors.black)
                      ),
                    )
                ),
                Container(child: Divider(color: Colors.black), padding: EdgeInsets.only(left: 20.0,right: 20.0, bottom: 10.0),),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      controller: _passwordController2,
                      decoration: InputDecoration(
                          hintText: "Confirm password",
                          hintStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                          icon: Icon(Icons.lock, color: Colors.black)
                      ),
                    )
                ),
                Container(child: Divider(color: Colors.black), padding: EdgeInsets.only(left: 20.0,right: 20.0, bottom: 10.0),),
                SizedBox(height: 10.0,),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 35.0,
                backgroundColor: Colors.black,
                child: Icon(Icons.person, color: Colors.white,),
              ),
            ],
          ),
          Container(
            height: 420,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                onPressed: () {
                  validateAndSignUp();
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
                child: Text("Sign Up", style: TextStyle(color: Colors.white)),
                color: Colors.green,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  BottomNavigationBar bottomBarWidget() {
    return null;
  }

  @override
  Widget buildFloatingActionButton() {
    return null;
  }
}

