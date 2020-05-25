import 'package:flutter/material.dart';
import 'package:multi_charts/multi_charts.dart';
import 'package:spending_analytics/ui/MainPage/AnalyticsPage/AnalyticsBloc.dart';


class DonutPieChart extends StatelessWidget {

  DonutPieChart(this.bloc);
  final AnalyticsBloc bloc;

  @override
  Widget build(BuildContext context) {
//    bloc.refreshChartData(month: DateTime.now().month, year: DateTime.now().year);
    bloc.refreshChartData(allTime: true, sortByExpense: true);

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("Расходы по категориям", style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: <Widget>[
            Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: StreamBuilder<Map<String, double>>(
                    stream: bloc.chartDataStream,
                    builder: (context, snapshot) {
                      if(snapshot.data != null) {
                        var colors = [
                          Colors.red,
                          Colors.blue,
                          Colors.green,
                          Colors.indigo,
                          Colors.amber,
                          Colors.teal,
                          Colors.blueGrey,
                        ];

                        List<String> labels = List();
                        List<double> values = List();
                        snapshot.data.forEach((key, value) {
                          labels.add(key);
                          values.add(value);
                        });

                        List<Color> colorList = List();
                        for(int i = 0; i < labels.length; i++) {
                          colorList.add(colors[i]);
                        }
                        return PieChart(
                          animationDuration: Duration(milliseconds: 300),
                          legendPosition: LegendPosition.Left,
                          legendIconShape: LegendIconShape.Circle,
                          legendIconSize: 8,
                          legendTextSize: 12,
                          values: values,
                          labels: labels,
                          sliceFillColors: colorList,
                        );
                      } else{
                        return Container();
                      }
                    }
                  ),
                ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    child: Container(
                      child: Text(
                        "За все время"
                      ),
                    ),
                    onPressed: () {
                      bloc.refreshChartData(allTime: true, sortByExpense: true);
                    },
                  ),
                  FlatButton(
                    child: Container(
                      child: Text(
                          "Предыдущий месяц"
                      ),
                    ),
                    onPressed: () {
                      int month = DateTime.now().month;
                      int year = DateTime.now().year;
                      month--;
                      if(month < 1) {
                        year--;
                        month = 12;
                      }
                      bloc.refreshChartData(month: month, year: year, allTime: false, sortByExpense: true);
                    },
                  ),
                  FlatButton(
                    child: Container(
                      child: Text(
                          "Этот месяц"
                      ),
                    ),
                    onPressed: () {
                      int month = DateTime.now().month;
                      int year = DateTime.now().year;
                      bloc.refreshChartData(month: month, year: year, allTime: false, sortByExpense: true);
                    },
                  ),
                ],
              ),
            )
          ],
        )
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);

  final String year;
  final double sales;
}