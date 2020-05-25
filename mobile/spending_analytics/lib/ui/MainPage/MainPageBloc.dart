import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:spending_analytics/data/model/AccountModel.dart';
import 'package:spending_analytics/data/model/CreditModel.dart';
import 'package:spending_analytics/data/model/DebtModel.dart';
import 'package:spending_analytics/data/model/DepositModel.dart';
import 'package:spending_analytics/data/model/ExpenseModel.dart';
import 'package:spending_analytics/data/model/IncomeModel.dart';
import 'package:spending_analytics/data/model/TransferModel.dart';
import 'package:spending_analytics/data/repository/IApiRepository.dart';
import 'package:spending_analytics/data/repository/ISharedPrefRepository.dart';
import 'package:spending_analytics/ui/BaseSate/BaseBloc.dart';
import 'package:http/http.dart';

class MainPageBloc extends BaseBloC {

  MainPageBloc(this._apiRepository, this._sharedPrefRepository);

  final ISharedPrefRepository _sharedPrefRepository;
  final IApiRepository _apiRepository;
  
  // ignore: close_sinks
  BehaviorSubject<MAIN_PAGE_STATE> _mainPageStateSubject;
  Observable<MAIN_PAGE_STATE> get mainPageStateStream => _mainPageStateSubject.stream;


  void mainPageState(MAIN_PAGE_STATE state) {
    _mainPageStateSubject.sink.add(state);
  }

  Future<void> fetchAllData() async {
    var savedData = await _sharedPrefRepository.getOperations();
    if(savedData.isEmpty) {
      List<AccountModel> accounts = await getUserAccounts();
      List<dynamic> operations = await getAllOperations();
      if(accounts != null && operations != null) {
        operations.sort((a, b) {
          return a.operationId.compareTo(b.operationId);
        });
        _sharedPrefRepository.setAccounts(accounts);
        _sharedPrefRepository.setOperations(operations);
        int status = await getExchangeRates();
        if(status == 0) {
          mainPageState(MAIN_PAGE_STATE.SUCCESS);
        } else {
          mainPageState(MAIN_PAGE_STATE.ERROR);
        }
      } else {
        mainPageState(MAIN_PAGE_STATE.ERROR);
      }
    } else {
      await getExchangeRates();
      mainPageState(MAIN_PAGE_STATE.SUCCESS);
    }
  }

  Future<List<AccountModel>> getUserAccounts() async {
    Response response = await _apiRepository.getAccounts();
    if(response.statusCode == 200) {
      List<AccountModel> accounts = List();
      for(int i = 0; i < json.decode(response.body)['accounts'].length; i++) {
        accounts.add(AccountModel.fromJson(json.decode(response.body)['accounts'][i]));
      }
      return accounts;
    } else {
      return null;
    }
  }

  Future<int> getExchangeRates() async {
    String baseCurrency = await _sharedPrefRepository.getBaseCurrency();
    var currencyCode = ["BYN", "RUB", "USD", "EUR"];
    currencyCode.removeWhere((element) => element == baseCurrency);
    Response response = await _apiRepository.getCurrencyExchangeRates(baseCurrency, currencyCode);
    if(response.statusCode == 200) {
      _sharedPrefRepository.setCurrencyExchanges(json.decode(response.body));
      return 0;
    } else {
      var exchanges = await _sharedPrefRepository.getCurrencyExchanges();
      if(exchanges == null) {
        return 1;
      }
      return 0;
    }
  }

  Future<List<dynamic>> getAllOperations() async {
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

  @override
  void initSubjects(List<Subject> subjects) {
    _mainPageStateSubject = BehaviorSubject();
    subjects.add(_mainPageStateSubject);
  }

}

enum MAIN_PAGE_STATE{
  SUCCESS,
  ERROR,
  LOADING
}