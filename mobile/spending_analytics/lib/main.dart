import 'package:flutter/material.dart';
import 'package:spending_analytics/ui/AuthPage/AuthScreen.dart';
import 'package:spending_analytics/ui/MainPage/MainPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(

      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("AppBarTitle"),
        ),
      ),
      initialRoute: '/auth',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/auth': (context) => LoginPage(),
        '/main': (context) => MainPage(),

        // When navigating to the "/second" route, build the SecondScreen widget.

      },
    );
  }
}