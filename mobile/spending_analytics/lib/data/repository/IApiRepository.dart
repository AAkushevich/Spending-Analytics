import 'package:http/http.dart';

abstract class IApiRepository {

  Future<Response> login(String username, String password);
  Future<Response> signUp(String username, String password);
  Future<Response> fetchAllData();
  Future<Response> getCategories();
  Future<Response> getAccounts();
  Future<Response> getCurrencyExchangeRates(String baseCurrency, List<String> currencyCode);
  Future<Response> createNewAccount(String scoreName, double balance, String currency);
  Future<Response> removeAccount(int accountId);

  Future<Response> newIncome(DateTime dateTime, double amount, int accountId, int categoryId);
  Future<Response> newExpense(DateTime dateTime, double amount, int accountId, int categoryId);
  Future<Response> newTransfer(DateTime dateTime, double amount, int sourceAccountId, int targetAccountId);
  Future<Response> newDebt(DateTime dateTime, double amount, String debtMode, String person, String userComment, int accountId);
  Future<Response> newCredit(DateTime dateTime, DateTime endDate, double amount, double interestRate, String creditName, int targetAccount, String creditPayments);
  Future<Response> newDeposit(String depositName, double amount, double interestRate, int sourceAccount, String interestPayments, DateTime dateTime, DateTime endDate);

  Future<Response> deleteIncome(int operationId);
  Future<Response> deleteExpense(int operationId);
  Future<Response> deleteTransfer(int operationId);
  Future<Response> deleteDeposit(int operationId);
  Future<Response> deleteDebt(int operationId);
  Future<Response> closeDebt(int operationId);
  Future<Response> closeCredit(int operationId);
  Future<Response> deleteCredit(int operationId);

}
