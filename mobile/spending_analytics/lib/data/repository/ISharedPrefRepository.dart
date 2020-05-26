import 'package:spending_analytics/data/model/AccountModel.dart';
import 'package:spending_analytics/data/model/CategoryModel.dart';

abstract class ISharedPrefRepository {

  Future<bool> setUserToken(String userToken);
  Future<String> getUserToken();
  Future<bool> removeUserToken();

  Future<void> setAccounts(List<AccountModel> accounts);
  Future<List<AccountModel>> getAccounts();
  Future<void> removeAccounts();

  Future<List<dynamic>> getOperations();
  Future<void> setOperations(List<dynamic> operations);
  Future<void> removeOperations();

  Future<String> getBaseCurrency();
  Future<void> setBaseCurrency(String currency);
  Future<void> removeBaseCurrency ();

  Future<Map<String, dynamic>> getCurrencyExchanges();
  Future<void> setCurrencyExchanges(Map<String, dynamic> currency);
  Future<void> removeCurrencyExchanges();

  Future<List<CategoryModel>> getCategories();
  Future<void> setCategories(List<CategoryModel> categories);
  Future<void> removeCategories();
}