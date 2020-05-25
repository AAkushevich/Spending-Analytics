import 'package:flutter/material.dart';
import 'package:spending_analytics/data/repository/ApiReposytory.dart';
import 'package:spending_analytics/data/repository/ISharedPrefRepository.dart';
import 'package:spending_analytics/data/repository/SharPrefRepositiry.dart';
import 'package:spending_analytics/main.dart';
import 'package:spending_analytics/ui/BaseSate/BaseState.dart';
import 'package:spending_analytics/ui/MainPage/MainPage.dart';
import 'package:spending_analytics/ui/MainPage/SettingsPage/SettingsBloc.dart';

class SettingsScreen extends StatefulWidget {

  SettingsScreen(this._sharedPrefRepository, this._baseCurrency);

  final ISharedPrefRepository _sharedPrefRepository;

  final String _baseCurrency;

  @override
  State<StatefulWidget> createState() {
    return SettingsScreenState(_sharedPrefRepository, _baseCurrency);
  }

}

class SettingsScreenState extends BaseState<SettingsScreen, SettingsBloc> {

  SettingsScreenState(this._sharedPrefRepository, this._baseCurrency);

  final ISharedPrefRepository _sharedPrefRepository;

  final String _baseCurrency;

  @override
  void initState() {

    super.initState();
  }
  @override
  BottomNavigationBar bottomBarWidget() {
    return null;
  }

  @override
  Widget buildStateContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 32),
          child: Text(
              "Основная валюта: $_baseCurrency",
              style: TextStyle(fontSize: 20, ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 16),
          child: Row(
            children: <Widget>[
              Text(
                "Изменить основную валюту:",
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 16),
          child:
          FlatButton(
            child: Container(
              height: 38,
              width: 130,
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(18)),
              ),
              child: Center(
                  child: Text("Сменить валюту", style: TextStyle(color: Colors.white))
              ),
            ),
            onPressed: () {
              showPopUpWindow();
            },
          ),
        )
      ],
    );
  }

  @override
  PreferredSizeWidget buildTopToolbarTitleWidget() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text("Настройки", style: TextStyle(color: Colors.black),),
      actions: <Widget>[
        FlatButton(
          child: Container(
            height: 38,
            width: 135,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Center(
                child: Text("Выйти из аккаунта", style: TextStyle(color: Colors.white))
            ),
          ),
          onPressed: () {
            _logout();
          },
        ),
      ],
    );
  }

  Future<void> _logout() async {
    await _sharedPrefRepository.removeAccounts();
    await _sharedPrefRepository.removeBaseCurrency();
    await _sharedPrefRepository.removeCurrencyExchanges();
    await _sharedPrefRepository.removeOperations();
    await _sharedPrefRepository.removeUserToken();
    Navigator.pushReplacementNamed(context, authPageRoute);
  }

  @override
  void disposeExtra() {
    // TODO: implement disposeExtra
  }

  @override
  SettingsBloc initBloC() {
    return SettingsBloc(ApiRepository(), SharedPrefRepository());
  }

  @override
  void preInitState() async {

  }

  void showPopUpWindow() async {
    await showDialog(
        context: context,
        builder: (_) => FunkyOverlay(saveBaseCurrency),
    );
  }

  Future<void> saveBaseCurrency(String baseCurrency) async{
    await _sharedPrefRepository.setBaseCurrency(baseCurrency);
    await bloc.getExchangeRates();
  }

  @override
  Widget buildFloatingActionButton() {
    return null;
  }

}