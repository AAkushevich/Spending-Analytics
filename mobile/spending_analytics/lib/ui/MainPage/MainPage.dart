import 'package:flutter/material.dart';
import 'package:spending_analytics/ui/BaseSate/BaseState.dart';
import 'package:spending_analytics/ui/MainPage/MainPageBloc.dart';

class MainPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MainPageState();
  }

}

class MainPageState extends BaseState<MainPage, MainPageBloc> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(

      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.shifting ,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance, color: Color.fromARGB(255, 0, 0, 0)),
              title: new Text('Accounts')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.credit_card, color: Color.fromARGB(255, 0, 0, 0)),
              title: new Text('Transactions')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.poll, color: Color.fromARGB(255, 0, 0, 0)),
              title: new Text('Statistics')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings, color: Color.fromARGB(255, 0, 0, 0)),
              title: new Text('Settings')
          )
        ],
        onTap: (index){
          //  _incrementTab(index);
        },
      ),
    );
  }

  @override
  Widget buildStateContent() {
    // TODO: implement buildStateContent
    return null;
  }

  @override
  PreferredSizeWidget buildTopToolbarTitleWidget() {
    // TODO: implement buildTopToolbarTitleWidget
    return null;
  }

  @override
  void disposeExtra() {
    // TODO: implement disposeExtra
  }

  @override
  initBloC() {
    // TODO: implement initBloC
    return null;
  }

  @override
  void preInitState() {
    // TODO: implement preInitState
  }

}