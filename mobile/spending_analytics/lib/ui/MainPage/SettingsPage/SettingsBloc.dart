import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:spending_analytics/data/repository/IApiRepository.dart';
import 'package:spending_analytics/data/repository/ISharedPrefRepository.dart';
import 'package:spending_analytics/ui/BaseSate/BaseBloc.dart';
import 'package:http/http.dart';

class SettingsBloc extends BaseBloC {

  SettingsBloc(this._apiRepository, this._sharedPrefRepository);

  final ISharedPrefRepository _sharedPrefRepository;
  final IApiRepository _apiRepository;

  @override
  void initSubjects(List<Subject> subjects) {
    // TODO: implement initSubjects
  }

  Future<void> getExchangeRates() async {
    String baseCurrency = await _sharedPrefRepository.getBaseCurrency();
    var currencyCode = ["BYN", "RUB", "USD", "EUR"];
    currencyCode.removeWhere((element) => element == baseCurrency);
    Response response = await _apiRepository.getCurrencyExchangeRates(baseCurrency, currencyCode);
    if(response.statusCode == 200) {
      _sharedPrefRepository.setCurrencyExchanges(json.decode(response.body));
    } else {

    }
  }
}