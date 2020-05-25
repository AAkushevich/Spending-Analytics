import 'package:flutter/material.dart';
import 'package:spending_analytics/data/model/AccountModel.dart';
import 'package:spending_analytics/data/model/CreditModel.dart';
import 'package:spending_analytics/data/model/DebtModel.dart';
import 'package:spending_analytics/data/model/DepositModel.dart';
import 'package:spending_analytics/data/repository/ApiReposytory.dart';
import 'package:spending_analytics/data/repository/SharPrefRepositiry.dart';
import 'package:spending_analytics/ui/BaseSate/BaseState.dart';
import 'package:spending_analytics/ui/MainPage/AccountsPage/AccountsBloc.dart';
import 'package:spending_analytics/ui/MainPage/AccountsPage/AddNewAccountScreen.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;

class AccountsScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return AccountsState();
  }

}

class AccountsState extends BaseState<AccountsScreen, AccountsBloc> {

  @override
  BottomNavigationBar bottomBarWidget() {
    return null;
  }

  @override
  Widget buildStateContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top:8.0, left: 16),
            child: Text("Кошельки", style: TextStyle(fontSize: 18),),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.2
              ),
              child: StreamBuilder<List<AccountModel>>(
                stream: bloc.accountStream,
                builder: (context, snapshot) {
                  if(snapshot.data != null ? snapshot.data.isNotEmpty : false) {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              slideDialog.showSlideDialog(
                                  context: context,
                                  child: getPopup(snapshot.data[index])
                              );
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.06,
                              child: Card(
                                elevation: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(snapshot.data[index].accountName, style: TextStyle(fontSize: 16)),
                                    Text("${snapshot.data[index].balance.toString()} ${snapshot.data[index].currency}", style: TextStyle(fontSize: 16)),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                    );
                  } else {
                    return Center(child: Text("Пусто"));
                  }
                }
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:8.0, left: 16),
            child: Text("Долги", style: TextStyle(fontSize: 18),),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.16
              ),
              child: StreamBuilder<List<dynamic>>(
                  stream: bloc.debtStream,
                  builder: (context, snapshot) {
                    if(snapshot.data != null ? snapshot.data.isNotEmpty : false) {
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            String currency = bloc.accounts.where((element) =>
                              element.accountId.compareTo(snapshot.data[index].sourceAccountId) == 0).first.currency;
                            return GestureDetector(
                              onTap: () {
                                slideDialog.showSlideDialog(
                                    context: context,
                                    child: buildDebtPopup(snapshot.data[index])
                                );
                              },
                              child: !snapshot.data[index].closed ? Container(
                                height: MediaQuery.of(context).size.height * 0.06,
                                child: Card(
                                  elevation: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(snapshot.data[index].person, style: TextStyle(fontSize: 16)),
                                      Text("${snapshot.data[index].amount.toString()} $currency", style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                ),
                              ) : Container(),
                            );
                          }
                      );
                    } else {
                      return Center(child: Text("Пусто"));
                    }
                  }
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:8.0, left: 16),
            child: Text("Кредиты", style: TextStyle(fontSize: 18),),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.16
              ),
              child: StreamBuilder<List<dynamic>>(
                  stream: bloc.creditStream,
                  builder: (context, snapshot) {
                    if(snapshot.data != null ? snapshot.data.isNotEmpty : false) {
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            String currency = bloc.accounts.where((element) =>
                            element.accountId.compareTo(snapshot.data[index].targetAccountId) == 0).first.currency;
                            return GestureDetector(
                              onTap: () {
                                slideDialog.showSlideDialog(
                                    context: context,
                                    child: buildCreditPopup(snapshot.data[index])
                                );
                              },
                              child: Container(
                                height: MediaQuery.of(context).size.height * 0.06,
                                child: Card(
                                  elevation: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(snapshot.data[index].creditName, style: TextStyle(fontSize: 16)),
                                      Text("${snapshot.data[index].amount.toString()} $currency", style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                      );
                    } else {
                      return Center(child: Text("Пусто"));
                    }
                  }
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:8.0, left: 16),
            child: Text("Вклады", style: TextStyle(fontSize: 18),),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.16
              ),
              child: StreamBuilder<List<dynamic>>(
                  stream: bloc.depositStream,
                  builder: (context, snapshot) {
                    if(snapshot.data != null ? snapshot.data.isNotEmpty : false) {
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            String currency = bloc.accounts.where((element) =>
                            element.accountId.compareTo(snapshot.data[index].sourceAccountId) == 0).first.currency;
                            return GestureDetector(
                              onTap: () {
                                slideDialog.showSlideDialog(
                                    context: context,
                                    child: buildDepositPopup(snapshot.data[index])
                                );
                              },
                              child: Container(
                                height: MediaQuery.of(context).size.height * 0.06,
                                child: Card(
                                  elevation: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(snapshot.data[index].depositName, style: TextStyle(fontSize: 16)),
                                      Text("${snapshot.data[index].amount.toString()} $currency", style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                      );
                    } else {
                      return Center(child: Text("Пусто"));
                    }
                  }
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getPopup(AccountModel account) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
           children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: Icon(
                  Icons.account_balance,
                  size: 40,
                  color: Colors.black,
                ),
              ),
             Padding(
               padding: const EdgeInsets.only(top: 20.0),
               child: Text(account.accountName, style: TextStyle(fontSize: 22),),
             ),
             Padding(
               padding: const EdgeInsets.only(top: 10.0),
               child: Text("Баланс", style: TextStyle(fontSize: 16),),
             ),
             Padding(
               padding: const EdgeInsets.only(top: 10.0),
               child: Text("${account.balance} ${account.currency}", style: TextStyle(fontSize: 22),),
             ),
             Padding(
               padding: const EdgeInsets.only(top: 10.0),
               child: FlatButton(
                 child: Text("Удалить"),
                 onPressed: () async{
                   await bloc.deleteAccount(account.accountId);
                   Navigator.pop(context);
                 },
               ),
             )
          ]
        ),
    );
  }

  Widget buildDebtPopup(DebtModel debt) {

    String currency = bloc.accounts.where((element) =>
      element.accountId.compareTo(debt.sourceAccountId) == 0).first.currency;

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Image.asset('assets/debt.png', scale: 2),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(debt.debtMode.compareTo("lent") == 0 ?
                "Я дал в долг" : "Мне дали в долг", style: TextStyle(fontSize: 18)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(debt.person, style: TextStyle(fontSize: 22)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 14.0),
              child: Text("${debt.amount} $currency", style: TextStyle(fontSize: 22)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0, left: 22, right: 22),
              child: Text("${debt.userComment}", textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text("${debt.dateTime.day}.${debt.dateTime.month}.${debt.dateTime.year}", textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60, left: 30, right: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    child: Text("Удалить"),
                    onPressed: () async{
                      await bloc.deleteDebt(debt.operationId);
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    child: Text("Долг погашен"),
                    onPressed: () async{
                      await bloc.closeDebt(debt.operationId);
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            )
          ]
      ),
    );
  }

  Widget buildCreditPopup(CreditModel credit) {

    String currency = bloc.accounts.where((element) =>
    element.accountId.compareTo(credit.targetAccountId) == 0).first.currency;

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Image.asset('assets/credit.png', scale: 2),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(credit.creditName, style: TextStyle(fontSize: 22)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 14.0),
              child: Text("${credit.amount} $currency", style: TextStyle(fontSize: 22)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text("${credit.dateTime.day}.${credit.dateTime.month}.${credit.dateTime.year}", textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60, left: 30, right: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    child: Text("Удалить"),
                    onPressed: () async{
                      await bloc.deleteCredit(credit.operationId);
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    child: Text("Кредит погашен"),
                    onPressed: () {
                      bloc.closeCredit(credit.operationId);
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            )
          ]
      ),
    );
  }

  Widget buildDepositPopup(DepositModel deposit) {

    String currency = bloc.accounts.where((element) =>
    element.accountId.compareTo(deposit.sourceAccountId) == 0).first.currency;

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Image.asset('assets/deposit.png', scale: 2),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(deposit.depositName, style: TextStyle(fontSize: 22)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 14.0),
              child: Text("${deposit.amount} $currency", style: TextStyle(fontSize: 22)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 14.0),
              child: Text("Процентная ставка: ${deposit.interestRate.toString()}%", style: TextStyle(fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 14.0),
              child: Text("Выплаты: ${deposit.interestPayments.compareTo("end_of_term") == 0 ? "В конце срока" : "Ежемесячно"}",
                  style: TextStyle(fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text("${deposit.dateTime.day}.${deposit.dateTime.month}.${deposit.dateTime.year}",
                textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: Text("Удалить"),
                    onPressed: () async{
                      await bloc.deleteDeposit(deposit.operationId);
                      Navigator.pop(context);
                    },
                  ),

                ],
              ),
            )
          ]
      ),
    );
  }

  @override
  PreferredSizeWidget buildTopToolbarTitleWidget() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: StreamBuilder<String>(
          stream: bloc.balanceStream,
          initialData: "****",
          builder: (context, snapshot) {
            return Text(snapshot.data, style: TextStyle(color: Colors.black, fontSize: 19, fontWeight: FontWeight.w400));
          }
      ),
    );
  }

  @override
  void disposeExtra() {
    // TODO: implement disposeExtra
  }

  @override
  AccountsBloc initBloC() {
    return AccountsBloc(ApiRepository(), SharedPrefRepository());
  }

  @override
  void preInitState() async{
    await bloc.calculateCurrentBalance();
    await bloc.getAccountsList();
  }

  @override
  Widget buildFloatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.add, color: Colors.white,),
      backgroundColor: Colors.black,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              AddNewAccountScreen(SharedPrefRepository(), bloc.createNewAccount)),
        );
      },
    );
  }

}