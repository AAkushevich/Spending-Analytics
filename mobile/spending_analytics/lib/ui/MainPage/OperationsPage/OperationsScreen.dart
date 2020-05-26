import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:spending_analytics/data/model/AccountModel.dart';
import 'package:spending_analytics/data/model/CategoryModel.dart';
import 'package:spending_analytics/data/model/CreditModel.dart';
import 'package:spending_analytics/data/model/DebtModel.dart';
import 'package:spending_analytics/data/model/DepositModel.dart';
import 'package:spending_analytics/data/model/ExpenseModel.dart';
import 'package:spending_analytics/data/model/IncomeModel.dart';
import 'package:spending_analytics/data/model/TransferModel.dart';
import 'package:spending_analytics/data/repository/ApiReposytory.dart';
import 'package:spending_analytics/data/repository/ISharedPrefRepository.dart';
import 'package:spending_analytics/data/repository/SharPrefRepositiry.dart';
import 'package:spending_analytics/ui/BaseSate/BaseState.dart';
import 'package:spending_analytics/ui/MainPage/OperationsPage/NewCreditScreen.dart';
import 'package:spending_analytics/ui/MainPage/OperationsPage/NewDebtScreen.dart';
import 'package:spending_analytics/ui/MainPage/OperationsPage/NewDepositScreen.dart';
import 'package:spending_analytics/ui/MainPage/OperationsPage/NewExpenseScreen.dart';
import 'package:spending_analytics/ui/MainPage/OperationsPage/NewIncomeScreen.dart';
import 'package:spending_analytics/ui/MainPage/OperationsPage/NewTransferScreen.dart';
import 'package:spending_analytics/ui/MainPage/OperationsPage/OperationsBloc.dart';
import 'package:spending_analytics/ui/Widgets/Preloader.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;

class OperationsScreen extends StatefulWidget {

  OperationsScreen(this._sharedPrefRepository);

  final ISharedPrefRepository _sharedPrefRepository;

  @override
  State<StatefulWidget> createState() {
    return OperationsState(_sharedPrefRepository);
  }
}

class OperationsState extends BaseState<OperationsScreen, OperationsBloc> {

  final ISharedPrefRepository _sharedPrefRepository;

  OperationsState(this._sharedPrefRepository);

  @override
  BottomNavigationBar bottomBarWidget() {
    return null;
  }

  Widget getPopup(dynamic element, String accountName) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20),
            child: Text("${formatMoney(element.amount)} ${bloc.baseCurrency}" , style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("${(element.operationType == "expense" || element.operationType == "income") ? element.categoryName : element.operationType}",
                    style: TextStyle(fontSize: 16)),
                Text("${element.dateTime.day}.${element.dateTime.month}.${element.dateTime.year}" , style: TextStyle(fontSize: 16, color: Colors.black54)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, bottom: 10),
            child: Text("$accountName", style: TextStyle(fontSize: 14)),
          ),
          Container(height: 0.4, color: Colors.black),
          Container(height: MediaQuery.of(context).size.height * 0.6 * 0.6),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  onPressed: () {  },
                  child: Container(
                    height: 38,
                    width: 130,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                    child: Center(
                        child: Text("Редактировать", style: TextStyle(color: Colors.white))
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () {  },
                  child: Container(
                      height: 38,
                      width: 130,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(18)),
                      ),
                      child: Center(child: Text("Удалить", style: TextStyle(color: Colors.white)))
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getExpenseIncomeCart(dynamic element) {
    String acName;
    bloc.accounts.forEach((account) {
      if (account.accountId.compareTo(element.accountId) == 0) {
        acName = account.accountName;
      }
    });
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: IconButton(
          icon: new Image.asset('assets/${element.categoryIcon}'), onPressed: () {  },
        ),
        onTap: () {
          slideDialog.showSlideDialog(
            context: context,
            child: buildExpenseIncomePopup(element)
          );
        },
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(element.categoryName),
                Text(
                  acName,
                  style: TextStyle(color: Colors.black38),
                ),
              ],
            ),
            getAmountText(element)
          ],
        ));
  }

  Widget getTransferCart(TransferModel element) {
    String acName;
    bloc.accounts.forEach((account) {
      if (account.accountId.compareTo(element.targetAccountId) == 0) {
        acName = account.accountName;
      }
    });
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: IconButton(
          icon: new Image.asset('assets/transfer.png'), onPressed: () { },
        ),
        onTap: () {
          slideDialog.showSlideDialog(
            context: context,
            child: buildTransferPopup(element)
          );
        },
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Трансфер"),
                Text(
                  acName,
                  style: TextStyle(color: Colors.black38),
                ),
              ],
            ),
            getAmountText(element)
          ],
        )
    );
  }

  Widget getDebtCart(DebtModel element) {
    String acName;
    String currency;
    String money = formatMoney(element.amount);
    bool lent = element.debtMode.compareTo("lent") == 0;
    bloc.accounts.forEach((account) {
      if (account.accountId.compareTo(element.sourceAccountId) == 0) {
        acName = account.accountName;
        currency = account.currency;
      }
    });
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: IconButton(
          icon: new Image.asset('assets/debt.png'), onPressed: () { },
        ),
        onTap: () {
          slideDialog.showSlideDialog(
              context: context,
              child: buildDebtPopup(element)
          );
        },
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(element.person),
                Text(
                  acName,
                  style: TextStyle(color: Colors.black38),
                ),
              ],
            ),
            Text(
              lent ? "-$money $currency" : "+$money $currency",
              style: TextStyle(
                  color: lent ? Colors.red : Colors.green, fontSize: 18),
            )
          ],
        )
    );
  }

  Widget getCreditCart(CreditModel element) {
    String acName;
    String currency;
    bloc.accounts.forEach((account) {
      if (account.accountId.compareTo(element.targetAccountId) == 0) {
        acName = account.accountName;
        currency = account.currency;
      }
    });
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: IconButton(
          icon: new Image.asset('assets/credit.png'), onPressed: () {  },
        ),
        onTap: () {
          slideDialog.showSlideDialog(
              context: context,
              child: buildCreditPopup(element)
          );
        },
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Кредит"),
                Text(
                  acName,
                  style: TextStyle(color: Colors.black38),
                ),
              ],
            ),
            Text(
              "+${formatMoney(element.amount)} $currency",
              style: TextStyle(color: Colors.green, fontSize: 18),
            )
          ],
        ),
    );
  }

  Widget getDepositCart(DepositModel element) {
    String acName;
    String currency;

    bloc.accounts.forEach((account) {
      if (account.accountId.compareTo(element.sourceAccountId) == 0) {
        acName = account.accountName;
        currency = account.currency;
      }
    });
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: IconButton(
          icon: new Image.asset('assets/deposit.png'), onPressed: () {  },
        ),
        onTap: () {
          slideDialog.showSlideDialog(
              context: context,
              child: buildDepositPopup(element)
          );
        },
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(element.depositName),
                Text(
                  acName,
                  style: TextStyle(color: Colors.black38),
                ),
              ],
            ),
            Text(
              "-${formatMoney(element.amount)} ${element.currency}",
              style: TextStyle(color: Colors.red, fontSize: 18),
            )
          ],
        )
    );
  }

   String formatMoney(double money) {
     String balanceStr = money.toString();
     if(int.parse(balanceStr.substring(balanceStr.indexOf('.') + 1, balanceStr.length)) == 0) {
       balanceStr = balanceStr.substring(0, balanceStr.indexOf('.'));
     }
     return balanceStr;
   }

  Widget buildRow(dynamic element) {
    if (element is IncomeModel || element is ExpenseModel) {
      return getExpenseIncomeCart(element);
    } else if (element is TransferModel) {
      return getTransferCart(element);
    } else if (element is DebtModel) {
      return getDebtCart(element);
    } else if (element is CreditModel) {
      return getCreditCart(element);
    } else {
      return getDepositCart(element);
    }
  }

  // ignore: missing_return
  Widget getAmountText(dynamic model) {
    if (model is ExpenseModel) {
      String currency = bloc.accounts.where((element) => element.accountId.compareTo(model.accountId) == 0).first.currency;

      return Text(
        "-${formatMoney(model.amount)} $currency",
        style: TextStyle(color: Color.fromRGBO(200, 0, 0, 1), fontSize: 18),
      );
    } else if (model is IncomeModel) {
      String currency = bloc.accounts.where((element) => element.accountId.compareTo(model.accountId) == 0).first.currency;
      return Text(
        "+${formatMoney(model.amount)} $currency",
        style: TextStyle(color: Colors.green, fontSize: 18),
      );
    } else if (model is TransferModel) {
      String currency = bloc.accounts.where((element) => element.accountId.compareTo(model.sourceAccountId) == 0).first.currency;
      return Text(
        "${formatMoney(model.amount)} $currency",
        style: TextStyle(color: Colors.black, fontSize: 18),
      );
    }
  }

  @override
  Widget buildStateContent() {
    bloc.calculateCurrentBalance();
    bloc.getOperations();

    return StreamBuilder(
      stream: bloc.operationsStream,
      initialData: null,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return GroupedListView(
            elements: snapshot.data,
            groupBy: (element) => element.dateTime,
            groupSeparatorBuilder: _buildGroupSeparator,
            itemBuilder: (context, element) {
              return Card(
                elevation: 0,
                margin:
                    new EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Container(
                  child: buildRow(element)
                ),
              );
            },
            order: GroupedListOrder.DESC,
          );
        } else {
          return SpinKitPouringHourglass(color: Colors.black);
        }
      },
    );
  }

  Widget _buildGroupSeparator(dynamic date) {
    String header = "${date.day}-${date.month}-${date.year}";
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Text(
          header,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        )
      ]),
    );
  }

  @override
  PreferredSizeWidget buildTopToolbarTitleWidget() {
    return PreferredSize(
      preferredSize: Size.fromHeight(80.0),
      child: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: StreamBuilder<String>(
            stream: bloc.balanceStream,
            initialData: "****",
            builder: (context, snapshot) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(snapshot.data,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 19,
                            fontWeight: FontWeight.w400)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Баланс",
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }

  Widget buildCreditPopup(CreditModel credit) {
    String currency = bloc.accounts.where((element) =>
    element.accountId.compareTo(credit.targetAccountId) == 0).first.currency;

    String accountName = bloc.accounts.where((element) =>
    element.accountId.compareTo(credit.targetAccountId) == 0).first.accountName;

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
              padding: const EdgeInsets.only(top: 14.0),
              child: Text("Кошелек: $accountName", style: TextStyle(fontSize: 22)),
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

  Widget buildDebtPopup(DebtModel debt) {

    String currency = bloc.accounts.where((element) =>
    element.accountId.compareTo(debt.sourceAccountId) == 0).first.currency;

    String accountName = bloc.accounts.where((element) =>
    element.accountId.compareTo(debt.sourceAccountId) == 0).first.accountName;

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
              padding: const EdgeInsets.only(top: 14.0),
              child: Text("Кошелек: $accountName", style: TextStyle(fontSize: 22)),
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

  Widget buildExpenseIncomePopup(dynamic data) {

    String currency = bloc.accounts.where((element) =>
    element.accountId.compareTo(data.accountId) == 0).first.currency;

    String accountName = bloc.accounts.where((element) =>
    element.accountId.compareTo(data.accountId) == 0).first.accountName;

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Icon(Icons.monetization_on, size: 48, color: Colors.black),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(data.categoryName, style: TextStyle(fontSize: 22)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 14.0),
              child: Text("${data.amount} $currency", style: TextStyle(fontSize: 22)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 14.0),
              child: Text("Кошелек: $accountName", style: TextStyle(fontSize: 22)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text("${data.dateTime.day}.${data.dateTime.month}.${data.dateTime.year}", textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60, left: 30, right: 30),
              child: FlatButton(
                child: Text("Удалить"),
                onPressed: () async{
                  data.operationType.compareTo("income") == 0 ?
                     await bloc.deleteIncome(data.operationId) :
                     await bloc.deleteExpense(data.operationId);
                  Navigator.pop(context);
                },
              ),
            )
          ]
      ),
    );
  }

  Widget buildDepositPopup(DepositModel deposit) {

    String currency = bloc.accounts.where((element) =>
    element.accountId.compareTo(deposit.sourceAccountId) == 0).first.currency;

    String accountName = bloc.accounts.where((element) =>
    element.accountId.compareTo(deposit.sourceAccountId) == 0).first.accountName;

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
              child: Text("Кошелек: $accountName", style: TextStyle(fontSize: 22)),
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
              child: FlatButton(
                child: Text("Удалить"),
                onPressed: () async{
                  await bloc.deleteDeposit(deposit.operationId);
                  Navigator.pop(context);
                },
              ),
            )
          ]
      ),
    );
  }

  Widget buildTransferPopup(TransferModel transfer) {

    String currency = bloc.accounts.where((element) =>
    element.accountId.compareTo(transfer.sourceAccountId) == 0).first.currency;

    String accountName = bloc.accounts.where((element) =>
    element.accountId.compareTo(transfer.sourceAccountId) == 0).first.accountName;

    String currency2 = bloc.accounts.where((element) =>
    element.accountId.compareTo(transfer.targetAccountId) == 0).first.currency;

    String accountName2 = bloc.accounts.where((element) =>
    element.accountId.compareTo(transfer.targetAccountId) == 0).first.accountName;

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Image.asset('assets/transfer.png', scale: 2),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text("Источник: $accountName", style: TextStyle(fontSize: 22)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 14.0),
              child: Text("${transfer.amount} $currency", style: TextStyle(fontSize: 20)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text("Целевой счет: $accountName2", style: TextStyle(fontSize: 18)),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text("${transfer.dateTime.day}.${transfer.dateTime.month}.${transfer.dateTime.year}", textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60, left: 30, right: 30),
              child: FlatButton(
                child: Text("Удалить"),
                onPressed: () async{
                  await bloc.deleteTransfer(transfer.operationId);
                  Navigator.pop(context);
                },
              ),
            )
          ]
      ),
    );
  }

  @override
  void disposeExtra() {
    // TODO: implement disposeExtra
  }

  @override
  OperationsBloc initBloC() {
    return OperationsBloc(ApiRepository(), SharedPrefRepository());
  }

  @override
  void preInitState() async {
    await bloc.calculateCurrentBalance();
  }

  @override
  Widget buildFloatingActionButton() {
    return SpeedDial(
      child: Icon(Icons.add, color: Colors.white,),
      animatedIcon: AnimatedIcons.menu_close,
      backgroundColor: Colors.black,
      closeManually: true,
      children: [
        SpeedDialChild(
          child: Icon(Icons.remove),
          label: "Расход",
          onTap: () async{
            List<CategoryModel> categories = await _sharedPrefRepository.getCategories();
            categories.removeWhere((element) => element.categoryType.compareTo("income") == 0);
            List<AccountModel> accounts = await _sharedPrefRepository.getAccounts();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  NewExpenseScreen(SharedPrefRepository(), bloc.newExpense, categories, accounts)));
          },
          backgroundColor: Colors.black
        ),
        SpeedDialChild(
            child: Icon(Icons.add),
            label: "Доход",
            onTap: () async{
              List<CategoryModel> categories = await _sharedPrefRepository.getCategories();
              categories.removeWhere((element) => element.categoryType.compareTo("expense") == 0);
              List<AccountModel> accounts = await _sharedPrefRepository.getAccounts();
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      NewIncomeScreen(SharedPrefRepository(), bloc.newIncome, categories, accounts)));
            },
            backgroundColor: Colors.black
        ),
        SpeedDialChild(
            child: IconButton(icon: new Image.asset('assets/transfer.png', color: Colors.white)),
            label: "Трансфер",
            onTap: () async{
              List<AccountModel> accounts = await _sharedPrefRepository.getAccounts();
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      NewTransferScreen(SharedPrefRepository(), bloc.newTransfer, accounts)));
            },
            backgroundColor: Colors.black
        ),
        SpeedDialChild(
            child: IconButton(icon: new Image.asset('assets/debt.png', color: Colors.white,)),
            label: "Долг",
            onTap: () async{
              List<AccountModel> accounts = await _sharedPrefRepository.getAccounts();
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      NewDebtScreen(SharedPrefRepository(), bloc.newDebt, accounts)));
            },
            backgroundColor: Colors.black
        ),
        SpeedDialChild(
            child: IconButton(icon: new Image.asset('assets/credit.png', color: Colors.white,)),
            label: "Кредит",
            onTap: () async{
              List<AccountModel> accounts = await _sharedPrefRepository.getAccounts();
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      NewCreditScreen(SharedPrefRepository(), bloc.newCredit, accounts)));
            },
            backgroundColor: Colors.black
        ),
        SpeedDialChild(
            child: IconButton(icon: new Image.asset('assets/deposit.png', color: Colors.white,)),
            label: "Вклад",
            onTap: () async{
              List<AccountModel> accounts = await _sharedPrefRepository.getAccounts();
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      NewDepositScreen(SharedPrefRepository(), bloc.newDeposit, accounts)));
            },
            backgroundColor: Colors.black
        ),
      ],
    );
  }
}
