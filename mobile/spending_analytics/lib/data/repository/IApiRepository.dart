import 'package:http/http.dart';

abstract class IApiRepository {

  Future<Response> login(String username, String password);
  Future<Response> signUp(String username, String password);
  Future<Response> fetchAllData();
  Future<Response> getAccounts();
  Future<Response> getCurrencyExchangeRates(String baseCurrency, List<String> currencyCode);
  Future<Response> createNewAccount(String scoreName, double balance, String currency);
  Future<Response> removeAccount(int accountId);

  Future<Response> deleteIncome(int operationId);
  Future<Response> deleteExpense(int operationId);
  Future<Response> deleteTransfer(int operationId);
  Future<Response> deleteDeposit(int operationId);
  Future<Response> deleteDebt(int operationId);
  Future<Response> closeDebt(int operationId);
  Future<Response> closeCredit(int operationId);
  Future<Response> deleteCredit(int operationId);

}