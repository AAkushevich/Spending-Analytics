import 'package:flutter/material.dart';
import 'package:spending_analytics/data/repository/ApiReposytory.dart';
import 'package:spending_analytics/data/repository/SharPrefRepositiry.dart';
import 'package:spending_analytics/ui/BaseSate/BaseState.dart';
import 'package:spending_analytics/ui/MainPage/AnalyticsPage/AnalyticsBloc.dart';
import 'package:spending_analytics/ui/MainPage/AnalyticsPage/PieChart.dart';
import 'package:spending_analytics/ui/MainPage/AnalyticsPage/PieChartByIncome.dart';
import 'package:spending_analytics/ui/MainPage/AnalyticsPage/SpendByTimeChart.dart';

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

    return ListView(
      children: <Widget>[
        ListTile(
          title: Text("Расходы по категориям"),
          onTap: () async {
            Navigator.push(context, MaterialPageRoute(builder: (context) => DonutPieChart(bloc)));
          }//DonutPieChart
        ),
        ListTile(
          title: Text("Доходы по категориям"),
          onTap: () async{
            Navigator.push(context, MaterialPageRoute(builder: (context) => DonutPieChartIncome(bloc)));
          }
        ),
        ListTile(
            title: Text("Тенденции расходов"),
            onTap: () async {
              var list = await bloc.getSpendingTrends();
              Navigator.push(context, MaterialPageRoute(builder: (context) => TimeSeriesBar(list)));
            }
        ),
      ],
    );

  }

  @override
  PreferredSizeWidget buildTopToolbarTitleWidget() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text("Статистика", style: TextStyle(color: Colors.black),),
    );
  }

  @override
  void disposeExtra() {
    // TODO: implement disposeExtra
  }

  @override
  AnalyticsBloc initBloC() {
    return AnalyticsBloc(ApiRepository(), SharedPrefRepository());
  }

  @override
  void preInitState() {

    // TODO: implement preInitState
  }

  @override
  Widget buildFloatingActionButton() {
    return null;

  }

}