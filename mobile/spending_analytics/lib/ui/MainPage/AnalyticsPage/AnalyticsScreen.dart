import 'package:flutter/material.dart';
import 'package:spending_analytics/ui/BaseSate/BaseState.dart';
import 'package:spending_analytics/ui/MainPage/AnalyticsPage/AnalyticsBloc.dart';

class AnalyticsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AnalyticsState();
  }

}

class AnalyticsState extends BaseState<AnalyticsScreen, AnalyticsBloc> {
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

    );
  }

  @override
  void disposeExtra() {
    // TODO: implement disposeExtra
  }

  @override
  AnalyticsBloc initBloC() {
    return AnalyticsBloc();
  }

  @override
  void preInitState() {
    // TODO: implement preInitState
  }

}