import 'package:flutter/material.dart';
import 'package:spending_analytics/ui/BaseSate/BaseState.dart';
import 'package:spending_analytics/ui/MainPage/OperationsPage/OperationsBloc.dart';

class OperationsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OperationsState();
  }

}

class OperationsState extends BaseState<OperationsScreen, OperationsBloc> {
  @override
  BottomNavigationBar bottomBarWidget() {
    // TODO: implement bottomBarWidget
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
  OperationsBloc initBloC() {
    return OperationsBloc();
  }

  @override
  void preInitState() {
    // TODO: implement preInitState
  }

}