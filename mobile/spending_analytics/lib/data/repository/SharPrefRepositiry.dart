import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:spending_analytics/data/model/AccountModel.dart';
import 'package:spending_analytics/data/model/CategoryModel.dart';
import 'package:spending_analytics/data/model/CreditModel.dart';
import 'package:spending_analytics/data/model/DebtModel.dart';
import 'package:spending_analytics/data/model/DepositModel.dart';
import 'package:spending_analytics/data/model/ExpenseModel.dart';
import 'package:spending_analytics/data/model/IncomeModel.dart';
import 'package:spending_analytics/data/model/TransferModel.dart';
import 'package:spending_analytics/data/repository/ISharedPrefRepository.dart';

class SharedPrefRepository implements ISharedPrefRepository{

  static final SharedPrefRepository _singleton =
  new SharedPrefRepository._internal();

  factory SharedPrefRepository() {
    return _singleton;
  }

  SharedPrefRepository._internal();

  @override
  Future<bool> setUserToken(String userToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(KEY_USER_TOKEN, userToken);
  }
  @override
  Future<String> getUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_USER_TOKEN);
  }

  @override
  Future<bool> removeUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(KEY_USER_TOKEN);
  }

  @override
  Future<List<AccountModel>> getAccounts() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<AccountModel> accounts = new List();
    json.decode(prefs.getString(KEY_ACCOUNTS)).forEach((item) {
      accounts.add(AccountModel.fromJson(item));
    });
    return accounts;
  }

  @override
  Future<void> removeAccounts() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(KEY_ACCOUNTS);
  }

  @override
  Future<void> setAccounts(List<AccountModel> accounts) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(KEY_ACCOUNTS, json.encode(accounts));
  }

  @override
  Future<List<dynamic>> getOperations() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> operations = new List();
    if(prefs.getString(KEY_OPERATIONS) != null)
    json.decode(prefs.getString(KEY_OPERATIONS)).forEach((item) {
      switch(item['operation_type']) {
        case 'income':
          operations.add(IncomeModel.fromJson(item));
          break;
        case 'expense':
          operations.add(ExpenseModel.fromJson(item));
          break;
        case 'transfer':
          operations.add(TransferModel.fromJson(item));
          break;
        case 'debt':
          operations.add(DebtModel.fromJson(item));
          break;
        case 'credit':
          operations.add(CreditModel.fromJson(item));
          break;
        case 'deposit':
          operations.add(DepositModel.fromJson(item));
          break;
      }
    });
    return operations;
  }

  @override
  Future<void> removeOperations() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(KEY_OPERATIONS);
  }

  @override
  Future<void> setOperations(List<dynamic> operations) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(KEY_OPERATIONS, json.encode(operations));
  }

  @override
  Future<String> getBaseCurrency() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_BASE_CURRENCY);
  }


  @override
  Future<void> setBaseCurrency(String currency) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(KEY_BASE_CURRENCY, currency);
  }

  @override
  Future<void> removeBaseCurrency() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(KEY_BASE_CURRENCY);
  }

  @override
  Future<Map<String, dynamic>> getCurrencyExchanges() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString(KEY_CURRENCY_EXCHANGES) == null){
      return null;
    } else {
      return json.decode(prefs.getString(KEY_CURRENCY_EXCHANGES));
    }
  }

  @override
  Future<void> setCurrencyExchanges(Map<String, dynamic> currencyExchanges) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(KEY_CURRENCY_EXCHANGES, json.encode(currencyExchanges));
  }

  @override
  Future<void> removeCurrencyExchanges() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(KEY_CURRENCY_EXCHANGES);
  }

  @override
  Future<List<CategoryModel>> getCategories() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<CategoryModel> categories = new List();
    json.decode(prefs.getString(KEY_CATEGORIES)).forEach((item) {
      categories.add(CategoryModel.fromJson(item));
    });
    return categories;
  }

  @override
  Future<void> removeCategories() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(KEY_CATEGORIES);
  }

  @override
  Future<void> setCategories(List<CategoryModel> categories) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(KEY_CATEGORIES, json.encode(categories));
  }

  static const KEY_USER_TOKEN = 'KEY_USER_TOKEN';
  static const KEY_ACCOUNTS = 'KEY_ACCOUNTS';
  static const KEY_CATEGORIES = 'KEY_CATEGORIES';
  static const KEY_OPERATIONS = 'KEY_OPERATIONS';
  static const KEY_BASE_CURRENCY = 'KEY_BASE_CURRENCY';
  static const KEY_CURRENCY_EXCHANGES = 'KEY_CURRENCY_EXCHANGES';
}

