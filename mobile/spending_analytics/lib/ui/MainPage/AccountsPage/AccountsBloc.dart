import 'dart:convert';
import 'package:rxdart/rxdart.dart';
import 'package:spending_analytics/data/model/AccountModel.dart';
import 'package:http/http.dart';
import 'package:spending_analytics/data/model/CreditModel.dart';
import 'package:spending_analytics/data/model/DebtModel.dart';
import 'package:spending_analytics/data/model/DepositModel.dart';
import 'package:spending_analytics/data/model/ExpenseModel.dart';
import 'package:spending_analytics/data/model/IncomeModel.dart';
import 'package:spending_analytics/data/model/TransferModel.dart';
import 'package:spending_analytics/data/repository/IApiRepository.dart';
import 'package:spending_analytics/data/repository/ISharedPrefRepository.dart';
import 'package:spending_analytics/ui/BaseSate/BaseBloc.dart';

class AccountsBloc extends BaseBloC {

  AccountsBloc(this._apiRepository, this._sharedPrefRepository);

  final ISharedPrefRepository _sharedPrefRepository;
  final IApiRepository _apiRepository;

  List<AccountModel> accounts = List();
  // ignore: close_sinks
  BehaviorSubject<String> _balanceSubject;
  Observable<String> get balanceStream => _balanceSubject.stream;

  // ignore: close_sinks
  BehaviorSubject<List<AccountModel>> _accountSubject;
  Observable<List<AccountModel>> get accountStream => _accountSubject.stream;

  // ignore: close_sinks
  BehaviorSubject<List<dynamic>> _creditSubject;
  Observable<List<dynamic>> get creditStream => _creditSubject.stream;

  // ignore: close_sinks
  BehaviorSubject<List<dynamic>> _depositSubject;
  Observable<List<dynamic>> get depositStream => _depositSubject.stream;

  // ignore: close_sinks
  BehaviorSubject<List<dynamic>> _debtSubject;
  Observable<List<dynamic>> get debtStream => _debtSubject.stream;

  Future<void> getAccountsList() async{
    accounts = await _sharedPrefRepository.getAccounts();
    List<dynamic> operations = List();
    operations = await _sharedPrefRepository.getOperations();

    List<dynamic> debts = List();
    List<dynamic> credits = List();
    List<dynamic> deposits = List();

    if(operations.length > 0) {
      debts = operations.where((element) =>
        element.operationType.compareTo("debt") == 0).toList();
      credits = operations.where((element) =>
        element.operationType.compareTo("credit") == 0).toList();
      deposits = operations.where((element) =>
        element.operationType.compareTo("deposit") == 0).toList();
    }

    _depositSubject.sink.add(deposits);
    _debtSubject.sink.add(debts);
    _creditSubject.sink.add(credits);
    _accountSubject.sink.add(accounts);
  }

  Future<void> _refreshOperationsList() async{
    List<dynamic> operations = await _getAllOperations();
    if(operations != null) {
      operations.sort((a, b) {
        return a.operationId.compareTo(b.operationId);
      });
      _sharedPrefRepository.setOperations(operations);
    }
  }

  Future<void> calculateCurrentBalance() async{
    double balance = 0;
    var currencyRates = await _sharedPrefRepository.getCurrencyExchanges();
    String baseCurrency = await _sharedPrefRepository.getBaseCurrency();
    var accounts = await _sharedPrefRepository.getAccounts();
    accounts.forEach((account) {
      if(baseCurrency.compareTo(account.currency) == 0) {
        balance += account.balance;
      } else {
        balance += account.balance * currencyRates[account.currency];
      }
    });

    String balanceStr = balance.toString();
    if(int.parse(balanceStr.substring(balanceStr.indexOf('.') + 1, balanceStr.length)) == 0) {
      balanceStr = balanceStr.substring(0, balanceStr.indexOf('.'));
    } else {
      balanceStr = double.parse((balance).toStringAsFixed(2)).toString();
    }

    _balanceSubject.sink.add("$balanceStr $baseCurrency");
  }

  Future<void> createNewAccount(String accountName, double balance, String currency) async{
    Response response = await _apiRepository.createNewAccount(accountName, balance, currency);
    if(response.statusCode == 200) {
      int accountId = json.decode(response.body)['account_id'];
      List<AccountModel> accounts = await _sharedPrefRepository.getAccounts();
      accounts.add(AccountModel(accountId, accountName, balance, currency));
      _sharedPrefRepository.setAccounts(accounts);
      calculateCurrentBalance();
      _accountSubject.sink.add(accounts);
    } else {
      showMessage("Что-то не так, ошибка, печаль, тлен");
    }
  }

  Future<void> deleteAccount(int accountId) async{
    Response response = await _apiRepository.removeAccount(accountId);
    if(response.statusCode == 200) {
      int accountId = json.decode(response.body)['account_id'];
      List<AccountModel> accounts = await _sharedPrefRepository.getAccounts();
      accounts.removeWhere((element) => element.accountId.compareTo(accountId) == 0);
      _sharedPrefRepository.setAccounts(accounts);
      calculateCurrentBalance();
      _accountSubject.sink.add(accounts);
      await _refreshOperationsList();
    } else {
      showMessage("Что-то не так, ошибка, печаль, тлен");
    }
  }

  Future<List<dynamic>> _getAllOperations() async {
    Response response = await _apiRepository.fetchAllData();
    if(response.statusCode == 200) {
      List<dynamic> operations = List();
      var decodedResponse = json.decode(response.body);

      if(decodedResponse["income"] != null) {
        for(int i = 0; i < decodedResponse["income"].length; i++) {
          operations.add(IncomeModel.fromJson(decodedResponse["income"][i]));
        }
      }

      if(decodedResponse["expense"] != null) {
        for(int i = 0; i < decodedResponse["expense"].length; i++) {
          operations.add(ExpenseModel.fromJson(decodedResponse["expense"][i]));
        }
      }

      if(decodedResponse["transfers"] != null) {
        for(int i = 0; i < decodedResponse["transfers"].length; i++) {
          operations.add(TransferModel.fromJson(decodedResponse["transfers"][i]));
        }
      }

      if(decodedResponse["debts"] != null) {
        for(int i = 0; i < decodedResponse["debts"].length; i++) {
          operations.add(DebtModel.fromJson(decodedResponse["debts"][i]));
        }
      }


      if(decodedResponse["deposits"] != null) {
        for(int i = 0; i < decodedResponse["deposits"].length; i++) {
          operations.add(DepositModel.fromJson(decodedResponse["deposits"][i]));
        }
      }

      if(decodedResponse["credits"] != null) {
        for(int i = 0; i < decodedResponse["credits"].length; i++) {
          operations.add(CreditModel.fromJson(decodedResponse["credits"][i]));
        }
      }

      return operations;
    } else {
      return null;
    }
  }

  Future<void> _refreshAccounts() async{
    Response response = await _apiRepository.getAccounts();
    List<AccountModel> accounts = List();
    if(response.statusCode == 200) {

      for(int i = 0; i < json.decode(response.body)['accounts'].length; i++) {
        accounts.add(AccountModel.fromJson(json.decode(response.body)['accounts'][i]));
      }
      await _sharedPrefRepository.setAccounts(accounts);
      _accountSubject.sink.add(accounts);
    } else {
      showMessage("Ошибка. Вот так вот.");
    }
  }

  Future<void> deleteCredit(int operationId) async{
    Response response = await _apiRepository.deleteCredit(operationId);
    List<dynamic> credits = List();
    if(response.statusCode == 200) {
      await _refreshOperationsList();
      List<dynamic> list = await _sharedPrefRepository.getOperations();
      credits = list.where((element) => element.operationType.compareTo("credit") == 0);
      _creditSubject.sink.add(credits);
    } else {
      showMessage("Ошибка. Вот так вот.");
    }
  }

  Future<void> deleteDeposit(int operationId) async{
    Response response = await _apiRepository.deleteDeposit(operationId);
    List<dynamic> deposit = List();
    if(response.statusCode == 200) {
      await _refreshOperationsList();
      List<dynamic> list = await _sharedPrefRepository.getOperations();
      deposit = list.where((element) => element.operationType.compareTo("deposit") == 0);
      _depositSubject.sink.add(deposit);
    } else {
      showMessage("Ошибка. Вот так вот.");
    }
  }

  Future<void> deleteDebt(int operationId) async{
    Response response = await _apiRepository.deleteDeposit(operationId);
    List<dynamic> debts = List();
    if(response.statusCode == 200) {
      await _refreshOperationsList();
      List<dynamic> list = await _sharedPrefRepository.getOperations();
      debts = list.where((element) => element.operationType.compareTo("debt") == 0);
      _debtSubject.sink.add(debts);
    } else {
      showMessage("Ошибка. Вот так вот.");
    }
  }

  Future<void> closeDebt(int operationId) async{
    Response response = await _apiRepository.closeDebt(operationId);
    List<dynamic> debts = List();
    if(response.statusCode == 200) {
      await _refreshOperationsList();
      await _refreshAccounts();
      List<dynamic> list = await _sharedPrefRepository.getOperations();
      debts = list.where((element) => element.operationType.compareTo("debt") == 0);
      _debtSubject.sink.add(debts);
    } else {
      showMessage("Ошибка. Вот так вот.");
    }
  }

  Future<void> closeCredit(int operationId) async{
    Response response = await _apiRepository.closeCredit(operationId);
    List<dynamic> credits = List();
    if(response.statusCode == 200) {
      await _refreshOperationsList();
      await _refreshAccounts();
      List<dynamic> list = await _sharedPrefRepository.getOperations();
      credits = list.where((element) => element.operationType.compareTo("credit") == 0);
      _creditSubject.sink.add(credits);
    } else {
      showMessage("Ошибка. Вот так вот.");
    }
  }


  @override
  void initSubjects(List<Subject> subjects) {
    _balanceSubject = BehaviorSubject();
    _accountSubject = BehaviorSubject();
    _creditSubject = BehaviorSubject();
    _debtSubject = BehaviorSubject();
    _depositSubject = BehaviorSubject();

    subjects.add(_depositSubject);
    subjects.add(_debtSubject);
    subjects.add(_balanceSubject);
    subjects.add(_accountSubject);
    subjects.add(_creditSubject);
  }

}