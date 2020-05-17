import 'package:flutter/material.dart';
import 'package:spending_analytics/ui/BaseSate/BaseState.dart';
import 'package:spending_analytics/ui/MainPage/SettingsPage/SettingsBloc.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingsState();
  }

}

class SettingsState extends BaseState<SettingsScreen, SettingsBloc> {
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
      title: Text("Настройки"),
    );
  }

  @override
  void disposeExtra() {
    // TODO: implement disposeExtra
  }

  @override
  SettingsBloc initBloC() {
    return SettingsBloc();
  }

  @override
  void preInitState() {
    // TODO: implement preInitState
  }

}