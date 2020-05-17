import 'package:flutter/material.dart';
import 'package:spending_analytics/ui/BaseSate/BaseState.dart';
import 'package:spending_analytics/ui/MainPage/AccountsPage/AccountsBloc.dart';

class AccountsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AccountsState();
  }

}

class AccountsState extends BaseState<AccountsScreen, AccountsBloc> {
  @override
  BottomNavigationBar bottomBarWidget() {
    return null;
  }

  @override
  Widget buildStateContent() {
    return Container();
  }

  @override
  PreferredSizeWidget buildTopToolbarTitleWidget() {
    return AppBar(
      backgroundColor: Colors.white,

    );
  }

  @override
  void disposeExtra() {
    // TODO: implement disposeExtra
  }

  @override
  AccountsBloc initBloC() {
    return AccountsBloc();
  }

  @override
  void preInitState() {
    // TODO: implement preInitState
  }

}