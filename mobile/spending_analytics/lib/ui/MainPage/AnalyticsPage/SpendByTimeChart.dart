import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart' as pref;
import 'package:flutter/material.dart';

class TimeSeriesBar extends StatelessWidget {
  final List<Series<TimeSeriesSales, DateTime>> seriesList;
  final bool animate;

  TimeSeriesBar(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: pref.IconButton(
          icon: Icon(pref.Icons.arrow_back, color: pref.Colors.black),
          onPressed: () {
            pref.Navigator.pop(context);
          },
        ),
        title: Text("Тенденции расходов", style: pref.TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 50),
              color: Colors.white,
              height: MediaQuery.of(context).size.height * 0.6,
              child: TimeSeriesChart(
                seriesList,
                animate: animate,
                defaultRenderer: new BarRendererConfig<DateTime>(),
                defaultInteractions: false,
                behaviors: [new SelectNearest(), new DomainHighlighter()],
              ),
            ),
          ],
        ),
      )
    );

  }

}

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}
