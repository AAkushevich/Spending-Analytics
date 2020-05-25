import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart';
import 'package:spending_analytics/data/model/AccountModel.dart';
import 'package:spending_analytics/data/repository/IApiRepository.dart';
import 'package:spending_analytics/data/repository/ISharedPrefRepository.dart';
import 'package:spending_analytics/ui/BaseSate/BaseBloc.dart';

class OperationsBloc extends BaseBloC {

  OperationsBloc(this._apiRepository, this._sharedPrefRepository);

  final ISharedPrefRepository _sharedPrefRepository;
  final IApiRepository _apiRepository;

  List<AccountModel> accounts;
  // ignore: close_sinks
  BehaviorSubject<String> _balanceSubject;
  Observable<String> get balanceStream => _balanceSubject.stream;
  String baseCurrency;
  // ignore: close_sinks
  BehaviorSubject<List<dynamic>> _operationsSubject;
  Observable<List<dynamic>> get operationsStream => _operationsSubject.stream;

  Future<void> calculateCurrentBalance() async{
    double balance = 0;
    var currencyRates = await _sharedPrefRepository.getCurrencyExchanges();
    baseCurrency = await _sharedPrefRepository.getBaseCurrency();
    var accounts = await _sharedPrefRepository.getAccounts();
    accounts.forEach((account) {
      if(baseCurrency.compareTo(account.currency) == 0) {
        balance += account.balance;
      } else {
        balance += account.balance / currencyRates[account.currency];
      }
    });

    String balanceStr = balance.toString();
    if(int.parse(balanceStr.substring(balanceStr.indexOf('.') + 1, balanceStr.length)) == 0) {
      balanceStr = balanceStr.substring(0, balanceStr.indexOf('.'));
    } else if(balanceStr.substring(balanceStr.indexOf('.') + 1, balanceStr.length).length > 2){
      balanceStr = balanceStr.substring(0, balanceStr.indexOf('.') + 3);
    }

    _balanceSubject.sink.add("$balanceStr $baseCurrency");
  }

  void getOperations() async {
    List<dynamic> operations = await _sharedPrefRepository.getOperations();
    accounts = await _sharedPrefRepository.getAccounts();
    _operationsSubject.sink.add(operations);
  }

  @override
  void initSubjects(List<Subject> subjects) {
    _balanceSubject = BehaviorSubject();
    _operationsSubject = BehaviorSubject();
    subjects.add(_balanceSubject);
    subjects.add(_operationsSubject);
  }

  Future<void> _refreshAccounts() async{
    Response response = await _apiRepository.getAccounts();
    List<AccountModel> accounts = List();
    if(response.statusCode == 200) {
      for(int i = 0; i < json.decode(response.body)['accounts'].length; i++) {
        accounts.add(AccountModel.fromJson(json.decode(response.body)['accounts'][i]));
      }

      await _sharedPrefRepository.setAccounts(accounts);
      await calculateCurrentBalance();
    } else {
      showMessage("Ошибка. Вот так вот.");
    }
  }

  Future<void> deleteCredit(int operationId) async{
    Response response = await _apiRepository.deleteCredit(operationId);
    if(response.statusCode == 200) {
      List<dynamic> list = await _sharedPrefRepository.getOperations();
      list.removeWhere((element) => element.operationId.compareTo(operationId) == 0);
      _operationsSubject.sink.add(list);
      await _refreshAccounts();
      await _sharedPrefRepository.setOperations(list);
    } else {
      showMessage("Ошибка. Вот так вот.");
    }
  }

  Future<void> deleteDeposit(int operationId) async{
    Response response = await _apiRepository.deleteDeposit(operationId);
    if(response.statusCode == 200) {
      List<dynamic> list = await _sharedPrefRepository.getOperations();
      list.removeWhere((element) => element.operationId.compareTo(operationId) == 0);
      _operationsSubject.sink.add(list);
      await _refreshAccounts();
      await _sharedPrefRepository.setOperations(list);
    } else {
      showMessage("Ошибка. Вот так вот.");
    }
  }

  Future<void> deleteDebt(int operationId) async{
    Response response = await _apiRepository.deleteDeposit(operationId);
    if(response.statusCode == 200) {
      List<dynamic> list = await _sharedPrefRepository.getOperations();
      list.removeWhere((element) => element.operationId.compareTo(operationId) == 0);
      _operationsSubject.sink.add(list);
      await _refreshAccounts();
      await _sharedPrefRepository.setOperations(list);
    } else {
      showMessage("Ошибка. Вот так вот.");
    }
  }

  Future<void> deleteTransfer(int operationId) async{
    Response response = await _apiRepository.deleteTransfer(operationId);
    if(response.statusCode == 200) {
      List<dynamic> list = await _sharedPrefRepository.getOperations();
      list.removeWhere((element) => element.operationId.compareTo(operationId) == 0);
      _operationsSubject.sink.add(list);
      await _refreshAccounts();
      await _sharedPrefRepository.setOperations(list);
    } else {
      showMessage("Ошибка. Вот так вот.");
    }
  }

  Future<void> deleteIncome(int operationId) async{
    Response response = await _apiRepository.deleteIncome(operationId);
    if(response.statusCode == 200) {
      List<dynamic> list = await _sharedPrefRepository.getOperations();
      list.removeWhere((element) => element.operationId.compareTo(operationId) == 0);
      _operationsSubject.sink.add(list);
      await _refreshAccounts();
      await _sharedPrefRepository.setOperations(list);
    } else {
      showMessage("Ошибка. Вот так вот.");
    }
  }

  Future<void> deleteExpense(int operationId) async{
    Response response = await _apiRepository.deleteExpense(operationId);
    if(response.statusCode == 200) {
      List<dynamic> list = await _sharedPrefRepository.getOperations();
      list.removeWhere((element) => element.operationId.compareTo(operationId) == 0);
      _operationsSubject.sink.add(list);
      await _refreshAccounts();
      await _sharedPrefRepository.setOperations(list);
    } else {
      showMessage("Ошибка. Вот так вот.");
    }
  }

  Future<void> closeDebt(int operationId) async{
    Response response = await _apiRepository.closeDebt(operationId);
    if(response.statusCode == 200) {
      List<dynamic> list = await _sharedPrefRepository.getOperations();
      list.forEach((element) {
        element.closed = false;
      });
      _operationsSubject.sink.add(list);
      await _sharedPrefRepository.setOperations(list);
    } else {
      showMessage("Ошибка. Вот так вот.");
    }
  }

  Future<void> closeCredit(int operationId) async{
    Response response = await _apiRepository.closeCredit(operationId);
    if(response.statusCode == 200) {
      List<dynamic> list = await _sharedPrefRepository.getOperations();
      list.forEach((element) {
        element.closed = false;
      });
      _operationsSubject.sink.add(list);
      await _sharedPrefRepository.setOperations(list);
    } else {
      showMessage("Ошибка. Вот так вот.");
    }
  }

}