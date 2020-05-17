import 'package:http/http.dart';

abstract class IApiRepository {

  Future<Response> login(String username, String password);
  Future<Response> signUp(String username, String password);
  Future<Response> fetchAllData();
  Future<Response> getAccounts();
  Future<Response> getCurrencyExchangeRates(String baseCurrency, List<String> currencyCode);
}