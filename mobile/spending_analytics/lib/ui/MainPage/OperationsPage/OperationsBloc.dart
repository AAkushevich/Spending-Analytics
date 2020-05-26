import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart';
import 'package:spending_analytics/data/model/AccountModel.dart';
import 'package:spending_analytics/data/model/CategoryModel.dart';
import 'package:spending_analytics/data/model/CreditModel.dart';
import 'package:spending_analytics/data/model/DebtModel.dart';
import 'package:spending_analytics/data/model/DepositModel.dart';
import 'package:spending_analytics/data/model/ExpenseModel.dart';
import 'package:spending_analytics/data/model/IncomeModel.dart';
import 'package:spending_analytics/data/model/TransferModel.dart';
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

    List<dynamic> operations = await _sharedPrefRepository.getOperations();
    operations.forEach((operation) {
      if(operation is DepositModel) {
        if(baseCurrency.compareTo(operation.currency) == 0) {
          balance += operation.amount;
        } else {
          balance += operation.amount / currencyRates[operation.currency];
        }
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
      await _refreshAccounts();
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
      await _refreshAccounts();
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
      await _refreshAccounts();
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
      await _refreshAccounts();
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
      await _refreshAccounts();
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
      await _refreshAccounts();
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
      await _refreshAccounts();
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
      await _refreshAccounts();
    } else {
      showMessage("Ошибка. Вот так вот.");
    }
  }

  Future<void> newExpense(DateTime dateTime, double amount, int accountId, categoryId) async{
    Response response = await _apiRepository.newExpense(dateTime, amount, accountId, categoryId);
    String categoryName = "";
    String categoryIcon = "";
    List<CategoryModel> categories = await _sharedPrefRepository.getCategories();
    categories.forEach((element) {
      if(element.categoryId == categoryId) {
        categoryName = element.categoryName;
        categoryIcon = element.categoryIcon;
      }
    });
    if(response.statusCode == 200) {
      List<dynamic> list = await _sharedPrefRepository.getOperations();
      int operationId = json.decode(response.body)['operation_id'];
      List<AccountModel> accounts = await _sharedPrefRepository.getAccounts();
      accounts.forEach((element) {
        if(element.accountId == accountId) {
          element.balance -= amount;
        }
      });
      await _sharedPrefRepository.setAccounts(accounts);
      list.add(ExpenseModel(operationId, dateTime, amount, "expense",
          accountId, categoryId, categoryName, categoryIcon));
      _operationsSubject.sink.add(list);
      await _sharedPrefRepository.setOperations(list);
      calculateCurrentBalance();
    } else {
      showMessage("Ошибка. Вот так вот.");
    }
  }

  Future<void> newIncome(DateTime dateTime, double amount, int accountId, categoryId) async{
    Response response = await _apiRepository.newIncome(dateTime, amount, accountId, categoryId);
    String categoryName = "";
    String categoryIcon = "";
    List<CategoryModel> categories = await _sharedPrefRepository.getCategories();
    categories.forEach((element) {
      if(element.categoryId == categoryId) {
        categoryName = element.categoryName;
        categoryIcon = element.categoryIcon;
      }
    });
    if(response.statusCode == 200) {
      List<dynamic> list = await _sharedPrefRepository.getOperations();
      int operationId = json.decode(response.body)['operation_id'];
      List<AccountModel> accounts = await _sharedPrefRepository.getAccounts();
      accounts.forEach((element) {
        if(element.accountId == accountId) {
          element.balance += amount;
        }
      });
      await _sharedPrefRepository.setAccounts(accounts);
      list.add(IncomeModel(operationId, dateTime, amount, "income",
          accountId, categoryId, categoryName, categoryIcon));
      _operationsSubject.sink.add(list);
      await _sharedPrefRepository.setOperations(list);
      calculateCurrentBalance();
    } else {
      showMessage("Ошибка. Вот так вот.");
    }
  }

  Future<void> newTransfer(DateTime dateTime, double amount, int sourceAccountId, int targetAccountId) async{
    Response response = await _apiRepository.newTransfer(dateTime, amount, sourceAccountId, targetAccountId);
    if(response.statusCode == 200) {
      List<dynamic> list = await _sharedPrefRepository.getOperations();
      int operationId = json.decode(response.body)['operation_id'];
      List<AccountModel> accounts = await _sharedPrefRepository.getAccounts();
      accounts.forEach((element) {
        if(element.accountId == sourceAccountId) {
          element.balance -= amount;
        }
        if(element.accountId == targetAccountId) {
          element.balance += amount;
        }
      });
      await _sharedPrefRepository.setAccounts(accounts);
      list.add(TransferModel(operationId, dateTime, amount, "transfer", sourceAccountId, targetAccountId));
      _operationsSubject.sink.add(list);
      await _sharedPrefRepository.setOperations(list);
    } else {
      showMessage("Ошибка. Вот так вот.");
    }
  }

  Future<void> newDebt(DateTime dateTime, double amount, String debtMode, String person, String userComment, int accountId) async{
    Response response = await _apiRepository.newDebt(dateTime, amount, debtMode, person, userComment, accountId);
    if(response.statusCode == 200) {
      List<dynamic> list = await _sharedPrefRepository.getOperations();
      int operationId = json.decode(response.body)['operation_id'];
      List<AccountModel> accounts = await _sharedPrefRepository.getAccounts();
      accounts.forEach((element) {
        if(element.accountId == accountId) {
          if(debtMode.compareTo("lent") == 0)
            element.balance -= amount;
          if(debtMode.compareTo("borrowed") == 0)
            element.balance += amount;
        }
      });
      await _sharedPrefRepository.setAccounts(accounts);
      list.add(DebtModel(operationId, dateTime, amount, "debt", accountId, person, userComment, debtMode, false));
      _operationsSubject.sink.add(list);
      await _sharedPrefRepository.setOperations(list);
      calculateCurrentBalance();
    } else {
      showMessage("Ошибка. Вот так вот.");
    }
  }

  Future<void> newDeposit(String depositName, double amount, String currency, double interestRate, int sourceAccount, String interestPayments, DateTime dateTime, DateTime endDate) async{
    Response response = await _apiRepository.newDeposit(depositName, amount, interestRate, sourceAccount, interestPayments, dateTime, endDate);
    if(response.statusCode == 200) {
      List<dynamic> list = await _sharedPrefRepository.getOperations();
      int operationId = json.decode(response.body)['operation_id'];
      List<AccountModel> accounts = await _sharedPrefRepository.getAccounts();
      accounts.forEach((element) async{
        if(element.accountId == sourceAccount) {
          if(element.currency.compareTo(currency) == 0) {
            element.balance -= amount;
          } else {
            String mainCurrency = await _sharedPrefRepository.getBaseCurrency();
            if(mainCurrency.compareTo(currency) == 0) {
              var exchanges = await _sharedPrefRepository.getCurrencyExchanges();
              element.balance -= amount / exchanges[currency];
            } else {
              var currencyCode = ["BYN", "RUB", "USD", "EUR"];
              currencyCode.removeWhere((code) => code.compareTo(element.currency) == 0);
              Response response = await _apiRepository.getCurrencyExchangeRates(element.currency, currencyCode);
              var decodedResponse = json.decode(response.body);
              element.balance -= amount / decodedResponse[currency];
            }
          }
        }
      });
      await _sharedPrefRepository.setAccounts(accounts);
      list.add(DepositModel(operationId, depositName, amount, "deposit", currency, dateTime, endDate, interestRate, sourceAccount, interestPayments));
      _operationsSubject.sink.add(list);
      await _sharedPrefRepository.setOperations(list);
      calculateCurrentBalance();
    } else {
      showMessage("Ошибка. Вот так вот.");
    }
  }

  Future<void> newCredit(String creditName, double amount, double interestRate, int targetAccount, String creditPayments, DateTime dateTime, DateTime endDate) async{
    Response response = await _apiRepository.newCredit(dateTime, endDate, amount, interestRate, creditName, targetAccount, creditPayments);
    if(response.statusCode == 200) {
      List<dynamic> list = await _sharedPrefRepository.getOperations();
      List<AccountModel> accounts = await _sharedPrefRepository.getAccounts();
      int operationId = json.decode(response.body)['operation_id'];
      accounts.forEach((element) {
        if(element.accountId == targetAccount) {
          element.balance += amount;
        }
      });
      await _sharedPrefRepository.setAccounts(accounts);
      list.add(CreditModel(operationId, creditName, amount, "credit", dateTime, endDate, interestRate, targetAccount, creditPayments, false));
      _operationsSubject.sink.add(list);
      await _sharedPrefRepository.setOperations(list);
      calculateCurrentBalance();
    } else {
      showMessage("Ошибка. Вот так вот.");
    }
  }
}