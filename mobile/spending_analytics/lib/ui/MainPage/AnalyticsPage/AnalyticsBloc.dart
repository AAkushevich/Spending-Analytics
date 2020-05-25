import 'package:rxdart/rxdart.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:spending_analytics/data/repository/IApiRepository.dart';
import 'package:spending_analytics/data/repository/ISharedPrefRepository.dart';
import 'package:spending_analytics/ui/BaseSate/BaseBloc.dart';
import 'package:spending_analytics/ui/MainPage/AnalyticsPage/SpendByTimeChart.dart';

class AnalyticsBloc extends BaseBloC {

  AnalyticsBloc(this._apiRepository, this._sharedPrefRepository);

  final ISharedPrefRepository _sharedPrefRepository;
  final IApiRepository _apiRepository;

  // ignore: close_sinks
  BehaviorSubject<Map<String, double>> _chartDataSubject;
  Observable<Map<String, double>> get chartDataStream => _chartDataSubject.stream;

  @override
  void initSubjects(List<Subject> subjects) {
    _chartDataSubject = BehaviorSubject();
    subjects.add(_chartDataSubject);
  }

  Future<List<Series<TimeSeriesSales, DateTime>>> getSpendingTrends() async {
    List<TimeSeriesSales> listSales = List();
    int year = DateTime.now().year;
    int month = DateTime.now().month;
    List<dynamic> operations = await _sharedPrefRepository.getOperations();
    var expenses = operations.where((element) => element.operationType.compareTo('expense') == 0);

    if(month < 12) {
      year--;
      month++;
    }

    for(int i = 0; i < 12; i++) {
      double balance = 0;
      expenses.forEach((element) {
        if(element.dateTime.month == month) {
          balance += element.amount;
        }
      });

      listSales.add(TimeSeriesSales(DateTime(year, month, 1), balance.toInt()));
      month++;

      if(month > 12) {
        year++;
        month = 1;
      }
    }

    return [
      new Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => MaterialPalette.black,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: listSales,
      )
    ];
  }

  Future<Map<String, double>> getSpendingByCategory({int month, int year, bool allTime, bool sortByExpense}) async {
    Map<String, double> spendingByCategory = Map();
    double expenseByMonth = 0;

    List<dynamic> operations = await _sharedPrefRepository.getOperations();

    List<dynamic> expenses = List();
    if(sortByExpense){
      expenses = operations.where((element) => element.operationType.compareTo('expense') == 0).toList();
    } else {
      expenses = operations.where((element) => element.operationType.compareTo('income') == 0).toList();
    }

    if(expenses.length == 0) {
      showMessage("Нет данных");
      return null;
    }

    List<dynamic> expensesByDate = List();
    if(!allTime){
      expensesByDate = expenses.where((element) =>
      (element.dateTime.month.compareTo(month) == 0) && (element.dateTime.year.compareTo(year) == 0)).toList();
    } else {
      expensesByDate = expenses.toList();
    }

    if(expensesByDate.length == 0) {
      showMessage("Нет данных");
      return null;
    }

    expensesByDate.forEach((element) {
      expenseByMonth += element.amount;
    });

    while(expensesByDate.length > 0) {
      String categoryName = expensesByDate.first.categoryName;
      double expenseByCategory = 0;

      expensesByDate.forEach((element) {
        if(element.categoryName.compareTo(categoryName) == 0) {
          expenseByCategory += element.amount;
        }
      });

      expensesByDate.removeWhere((element) =>
        element.categoryName.compareTo(categoryName) == 0);

      spendingByCategory[categoryName] = double.parse(
          ((expenseByCategory / expenseByMonth) * 100).toStringAsFixed(2));
    }

    return spendingByCategory;
  }

  void refreshChartData({int month, int year, bool allTime = false, bool sortByExpense}) async {
    Map<String, double> map = Map();
    if(!allTime) {
      map = await getSpendingByCategory(month: month, year: year, allTime: allTime, sortByExpense: sortByExpense);
    } else {
      map = await getSpendingByCategory(allTime: allTime, sortByExpense: sortByExpense);
    }
    _chartDataSubject.sink.add(map);
  }

}