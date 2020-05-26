import 'package:http/http.dart';
import 'package:spending_analytics/data/repository/IApiRepository.dart';
import 'package:spending_analytics/data/utils/ResponseLogger.dart';

class ApiRepository implements IApiRepository {

  static String _token;

  static Map<String, String> _headers;

  static set setToken(String value) {
    _token = value;
    _headers = {
      'Content-Type' : 'application/json',
      'token': _token
    };
  }

  Map<String,String> contentType = {'Content-Type':'application/json'};

  @override
  Future<Response> login(String username, String password) async {
    var response = await post(
        _loginApi,
        headers: contentType,
        body: "{ \"email\" : \"$username\", \"password\" : \"$password\" }"
    );
    printResponseInFormat(response);
    return response;
  }

  @override
  Future<Response> signUp(String username, String password) async {
    var response = await post(
        _registerApi,
        headers: contentType,
        body: "{ \"email\" : \"$username\", \"password\" : \"$password\" }"
    );
    printResponseInFormat(response);
    return response;
  }

  @override
  Future<Response> fetchAllData() async {
    var response = await get(
      _fetchAllDataApi,
      headers: _headers,
    );
    printResponseInFormat(response);
    return response;
  }

  @override
  Future<Response> getAccounts() async {
    var response = await get(
        _getAccountsApi,
        headers: _headers,
    );
    printResponseInFormat(response);
    return response;
  }

  @override
  Future<Response> getCategories() async {
    var response = await get(
      _getCategoriesApi,
      headers: _headers,
    );
    printResponseInFormat(response);
    return response;
  }

  Future<Response> getCurrencyExchangeRates(String baseCurrency, List<String> currencyCode) async{
    var response = await get(
        "http://min-api.cryptocompare.com/data/price?fsym=$baseCurrency&tsyms=${currencyCode[0]},${currencyCode[1]},${currencyCode[2]}",
    );
    printResponseInFormat(response);
    return response;
  }

  @override
  Future<Response> createNewAccount(String scoreName, double balance, String currency) async {
    var response = await post(
        _newAccountApi,
        headers: _headers,
        body: "{ \"scoreName\" : \"$scoreName\", \"balance\" : $balance, \"currency\" : \"$currency\" }"
    );
    printResponseInFormat(response);
    return response;
  }

  @override
  Future<Response> removeAccount(int accountId) async{
    var response = await get(
        "$_removeAccountApi?accountId=$accountId",
        headers: _headers,
    );
    printResponseInFormat(response);
    return response;
  }

  @override
  Future<Response> deleteCredit(int operationId) async{
    var response = await post(
        _deleteCreditApi,
        headers: _headers,
        body: "{ \"operation_id\" : $operationId }"
    );
    printResponseInFormat(response);
    return response;
  }

  @override
  Future<Response> deleteDebt(int operationId) async{
    var response = await post(
        _deleteDebtApi,
        headers: _headers,
        body: "{ \"operation_id\" : $operationId }"
    );
    printResponseInFormat(response);
    return response;
  }

  @override
  Future<Response> closeDebt(int operationId) async{
    var response = await post(
        _closeDebtApi,
        headers: _headers,
        body: "{ \"operation_id\" : $operationId }"
    );
    printResponseInFormat(response);
    return response;
  }

  @override
  Future<Response> deleteDeposit(int operationId) async{
    var response = await post(
        _deleteDepositApi,
        headers: _headers,
        body: "{ \"operation_id\" : $operationId }"
    );
    printResponseInFormat(response);
    return response;
  }

  @override
  Future<Response> deleteExpense(int operationId) async{
    var response = await post(
        _deleteExpenseApi,
        headers: _headers,
        body: "{ \"operation_id\" : $operationId }"
    );
    printResponseInFormat(response);
    return response;
  }

  @override
  Future<Response> deleteIncome(int operationId) async{
    var response = await post(
        _deleteIncomeApi,
        headers: _headers,
        body: "{ \"operation_id\" : $operationId }"
    );
    printResponseInFormat(response);
    return response;
  }

  @override
  Future<Response> deleteTransfer(int operationId) async{
    var response = await post(
        _deleteTransferApi,
        headers: _headers,
        body: "{ \"operation_id\" : $operationId }"
    );
    printResponseInFormat(response);
    return response;
  }

  @override
  Future<Response> closeCredit(int operationId) async{
    var response = await post(
        _closeCreditApi,
        headers: _headers,
        body: "{ \"operation_id\" : $operationId }"
    );
    printResponseInFormat(response);
    return response;
  }

  @override
  Future<Response> newExpense(DateTime dateTime, double amount, int accountId, int categoryId) async{
    var response = await post(
        _newExpenseApi,
        headers: _headers,
        body: "{ \"date_time\" : \"${dateTime.toString()}\", \"amount\" : $amount, \"account_id\" : $accountId, \"category_id\" : $categoryId  }"
    );
    printResponseInFormat(response);
    return response;
  }

  @override
  Future<Response> newIncome(DateTime dateTime, double amount, int accountId, int categoryId) async{
    var response = await post(
        _newIncomeApi,
        headers: _headers,
        body: "{ \"date_time\" : \"${dateTime.toString()}\", \"amount\" : $amount, \"account_id\" : $accountId, \"category_id\" : $categoryId  }"
    );
    printResponseInFormat(response);
    return response;
  }

  @override
  Future<Response> newTransfer(DateTime dateTime, double amount, int sourceAccountId, int targetAccountId) async{
    var response = await post(
        _newTransferApi,
        headers: _headers,
        body: "{ \"date_time\" : \"${dateTime.toString()}\", \"amount\" : $amount, \"source_account_id\" : $sourceAccountId, \"target_account_id\" : $targetAccountId }"
    );
    printResponseInFormat(response);
    return response;
  }

  @override
  Future<Response> newDebt(DateTime dateTime, double amount, String debtMode, String person, String userComment, int accountId) async{
    var response = await post(
        _newDebtApi,
        headers: _headers,
        body: "{ \"date_time\" : \"${dateTime.toString()}\", \"amount\" : $amount, "
              "\"debt_mode\" : \"$debtMode\", \"person\" : \"$person\", "
              "\"user_comment\" : \"$userComment\", \"account_id\" : $accountId }"
    );
    printResponseInFormat(response);
    return response;
  }

  @override
  Future<Response> newCredit(DateTime dateTime, DateTime endDate, double amount,
      double interestRate, String creditName, int targetAccount, String creditPayments) async{
    var response = await  post(
        _newCreditApi,
        headers: _headers,
        body: "{ \"date_time\" : \"${dateTime.toString()}\", \"end_date\" : \"${endDate.toString()}\", \"amount\" : $amount, \"interest_rate\" : $interestRate, \"credit_name\" : \"$creditName\", \"target_account_id\" : $targetAccount, \"credit_payments\" : \"$creditPayments\" }"
    );
    printResponseInFormat(response);
    return response;
  }

  @override
  Future<Response> newDeposit(String depositName, double amount, double interestRate, int sourceAccount,
      String interestPayments, DateTime dateTime, DateTime endDate) async{
    var response = await post(
        _newDepositApi,
        headers: _headers,
        body: "{ \"deposit_name\" : \"$depositName\", \"amount\" : $amount, \"interest_rate\" : $interestRate, \"source_account_id\" : $sourceAccount, \"interest_payments\" : \"$interestPayments\", \"date_time\" : \"${dateTime.toString()}\", \"end_date\" : \"${endDate.toString()}\" }"
    );
    printResponseInFormat(response);
    return response;
  }


  static const String _serverUrl = "http://192.168.43.4:3000/api/v1";
  static const String _registerApi = _serverUrl + "/sign_up";
  static const String _loginApi = _serverUrl + "/login";
  static const String _fetchAllDataApi = _serverUrl + "/fetch_all_data";
  static const String _newAccountApi = _serverUrl + "/new_score";
  static const String _newIncomeApi = _serverUrl + "/new_income";
  static const String _newExpenseApi = _serverUrl + "/new_expense";
  static const String _newTransferApi = _serverUrl + "/transfer";
  static const String _newDebtApi = _serverUrl + "/new_debt";
  static const String _newCreditApi = _serverUrl + "/credit";
  static const String _newDepositApi = _serverUrl + "/deposit";
  static const String _removeAccountApi = _serverUrl + "/remove_score";
  static const String _getAccountsApi = _serverUrl + "/get_accounts";
  static const String _deleteIncomeApi = _serverUrl + "/delete_income";
  static const String _getCategoriesApi = _serverUrl + "/get_categories";
  static const String _deleteExpenseApi = _serverUrl + "/delete_expense";
  static const String _deleteDepositApi = _serverUrl + "/delete_deposit";
  static const String _deleteCreditApi = _serverUrl + "/delete_credit";
  static const String _deleteDebtApi = _serverUrl + "/delete_debt";
  static const String _closeDebtApi = _serverUrl + "/close_debt";
  static const String _closeCreditApi = _serverUrl + "/close_credit";
  static const String _deleteTransferApi = _serverUrl + "/delete_transfer";

}