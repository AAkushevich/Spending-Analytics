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

  Future<Response> getCurrencyExchangeRates(String baseCurrency, List<String> currencyCode) async{
    var response = await get(
      _getCurrencyExchange(baseCurrency, currencyCode),
    );
    printResponseInFormat(response);
    return response;
  }

  static const String _serverUrl = "http://192.168.43.4:3000/api/v1";
  static const String _registerApi = _serverUrl + "/sign_up";
  static const String _loginApi = _serverUrl + "/login";
  static const String _fetchAllDataApi = _serverUrl + "/fetch_all_data";
  static const String _getAccountsApi = _serverUrl + "/get_accounts";
  static String _getCurrencyExchange(String baseCurrency, List<String> currencyCode) {
    return "https://min-api.cryptocompare.com/data/price?fsym=$baseCurrency&tsyms=${currencyCode[0]},${currencyCode[1]},${currencyCode[2]}";
  }

}