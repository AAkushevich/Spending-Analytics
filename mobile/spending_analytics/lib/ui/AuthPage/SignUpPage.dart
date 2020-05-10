import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {

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
                onPressed: () {},
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPageContent(context),
    );
  }
}