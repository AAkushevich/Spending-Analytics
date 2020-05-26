import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:spending_analytics/data/model/AccountModel.dart';
import 'package:spending_analytics/data/model/CategoryModel.dart';
import 'package:spending_analytics/data/repository/ISharedPrefRepository.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:toast/toast.dart';

class NewDepositScreen extends StatefulWidget {

  NewDepositScreen(this._sharedPrefRepository, this.addNewDeposit, this.accounts);

  final ISharedPrefRepository _sharedPrefRepository;

  final List<AccountModel> accounts;

  final Function(String depositName, double amount, String currency, double interestRate, int sourceAccount, String interestPayments, DateTime dateTime, DateTime endDate) addNewDeposit;

  @override
  State<StatefulWidget> createState() {
    return NewDepositScreenState(_sharedPrefRepository, addNewDeposit, accounts);
  }

}

class NewDepositScreenState extends State<NewDepositScreen> {

  final ISharedPrefRepository _sharedPrefRepository;

  final Function(String depositName, double amount, String currency, double interestRate, int sourceAccount, String interestPayments, DateTime dateTime, DateTime endDate) addNewDeposit;

  final List<AccountModel> accounts;

  NewDepositScreenState(this._sharedPrefRepository, this.addNewDeposit, this.accounts) {
    dropDownValue = accounts.first.accountName;
    chosenAccountId = accounts.first.accountId;

    accounts.forEach((element) {
      accountNames.add(element.accountName);
      accountsMap[element.accountName] = element.accountId;
    });

    paymentType["Ежемесячно"] = "monthly";
    paymentType["В конце срока"] = "end_of_term";

    payments.add("Ежемесячно");
    payments.add("В конце срока");
    paymentsDropDownValue = payments.first;
    chosenPaymentType = paymentType[payments.first];
    currentDateString = "${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}";
  }

  Map<String, int> accountsMap = Map();

  List<String> accountNames = List();

  List<String> payments = List();

  Map<String,String> paymentType = Map();

  DateTime dateTime = DateTime.now();

  DateTime endDateTime = DateTime.now();

  int chosenAccountId = 0;


  String currentDateString = DateTime.now().toString();

  String endDateString = "";

  String chosenCurrency = "BYN";

  var currencyList = ["BYN", "USD", "RUB", "EUR"];

  String chosenPaymentType;

  String dropDownValue = "";

  String paymentsDropDownValue = "";

  TextEditingController balanceController = TextEditingController();

  TextEditingController depositNameController = TextEditingController();

  TextEditingController interestController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Вклад", style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          FlatButton(
              child: Text("Сохранить", style: TextStyle(color: Colors.black)),
              onPressed: () async{
                if(balanceController.text.isNotEmpty && chosenAccountId != 0 && depositNameController.text.isNotEmpty && interestController.text.isNotEmpty) {
                  await addNewDeposit(depositNameController.text, double.parse(balanceController.text), chosenCurrency,
                      double.parse(interestController.text), chosenAccountId, chosenPaymentType, dateTime, endDateTime);
                  Navigator.pop(context);
                } else {
                  Toast.show("Все поля должны быть заполнены", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                }
              }
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
                child: TextField(
                  controller: depositNameController,
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Заголовок",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
                child: TextField(
                  controller: balanceController,
                  maxLines: 1,
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: true
                  ),
                  decoration: InputDecoration(
                    labelText: "Сумма",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 32.0, right: 32.0, top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Валюта", style: TextStyle(fontSize: 15)),
                    DropdownButton<String>(
                      items: currencyList.map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      value: chosenCurrency.toString(),
                      underline: Container(
                        height: 0,
                      ),
                      onChanged: (value) {
                        setState(() {
                          chosenCurrency = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 32.0, right: 32.0, top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Кошелек(источник)", style: TextStyle(fontSize: 15)),
                    DropdownButton<String>(
                      items: accountNames.map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      value: dropDownValue.toString(),
                      underline: Container(
                        height: 0,
                      ),
                      onChanged: (value) {
                        setState(() {
                          chosenAccountId = accountsMap[value];
                          dropDownValue = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
                child: TextField(
                  controller: interestController,
                  maxLines: 1,
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: true
                  ),
                  decoration: InputDecoration(
                    labelText: "Процент",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 32.0, right: 32.0, top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Выплаты процентов:", style: TextStyle(fontSize: 15)),
                    DropdownButton<String>(
                      items: payments.map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      value: paymentsDropDownValue.toString(),
                      underline: Container(
                        height: 0,
                      ),
                      onChanged: (value) {
                        setState(() {
                          chosenPaymentType = paymentType[value];
                          paymentsDropDownValue = value;
                        });
                      },
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 16, top: 48),
                child: FlatButton(
                    onPressed: () {
                      DatePicker.showDateTimePicker(context, showTitleActions: true, onConfirm: (date) {
                        setState(() {
                          currentDateString = "${date.day}.${date.month}.${date.year}";
                          dateTime = date;
                        });
                      }, currentTime: DateTime.now(), locale: LocaleType.ru);
                    },
                    child: Text(
                      'Дата оформления: $currentDateString',
                      style: TextStyle(color: Colors.black),
                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 48),
                child: FlatButton(
                    onPressed: () {
                      DatePicker.showDateTimePicker(context, showTitleActions: true, onConfirm: (date) {
                        setState(() {
                          endDateString = "${date.day}.${date.month}.${date.year}";
                          endDateTime = date;
                        });
                      }, currentTime: DateTime.now(), locale: LocaleType.ru);
                    },
                    child: Text(
                      'Конечный срок: $endDateString',
                      style: TextStyle(color: Colors.black),
                    )
                ),
              ),
            ]
        ),
      ),
    );
  }

}