import 'package:flutter/material.dart';
import 'package:spending_analytics/data/model/AccountModel.dart';
import 'package:spending_analytics/data/model/CategoryModel.dart';
import 'package:spending_analytics/data/repository/ISharedPrefRepository.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:toast/toast.dart';

class NewTransferScreen extends StatefulWidget {

  NewTransferScreen(this._sharedPrefRepository, this.addNewTransfer, this.accounts);

  final ISharedPrefRepository _sharedPrefRepository;

  final List<AccountModel> accounts;

  final Function(DateTime dateTime, double amount, int accountId, int targetAccountId) addNewTransfer;

  @override
  State<StatefulWidget> createState() {
    return NewTransferScreenState(_sharedPrefRepository, addNewTransfer, accounts);
  }
}

class NewTransferScreenState extends State<NewTransferScreen> {

  final ISharedPrefRepository _sharedPrefRepository;

  final Function(DateTime dateTime, double amount, int accountId, int targetAccountId) addNewTransfer;

  final List<AccountModel> accounts;

  NewTransferScreenState(this._sharedPrefRepository, this.addNewTransfer, this.accounts){

    dropDownValue = accounts.first.accountName;
    chosenAccountId = accounts.first.accountId;

    dropDownValue2 = accounts.first.accountName;
    chosenAccountId2 = accounts.first.accountId;

    accounts.forEach((element) {
      categoriesNames.add(element.accountName);
      categoriesMap[element.accountName] = element.accountId;
    });

    currentDateString = "${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}";
  }

  Map<String, int> categoriesMap = Map();

  List<String> categoriesNames = List();

  DateTime dateTime = DateTime.now();

  String currentDateString = "";

  int chosenAccountId = 0;

  String dropDownValue = "";

  int chosenAccountId2 = 0;

  String dropDownValue2 = "";
  TextEditingController balanceController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Трансфер", style: TextStyle(color: Colors.black)),
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
                if(balanceController.text.isNotEmpty && chosenAccountId != 0 && chosenAccountId2 != 0) {
                  await addNewTransfer(dateTime, double.parse(balanceController.text),
                      chosenAccountId, chosenAccountId2);
                  Navigator.pop(context);
                } else {
                  Toast.show("Все поля должны быть заполнены", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                }
              }
          )
        ],
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
                  Text("Источник", style: TextStyle(fontSize: 15)),
                  DropdownButton<String>(
                    items: categoriesNames.map((String value) {
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
                        chosenAccountId = categoriesMap[value];
                        dropDownValue = value;
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
                  Text("Целевой счет", style: TextStyle(fontSize: 15)),
                  DropdownButton<String>(
                    items: categoriesNames.map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    value: dropDownValue2.toString(),
                    underline: Container(
                      height: 0,
                    ),
                    onChanged: (value) {
                      setState(() {
                        chosenAccountId2 = categoriesMap[value];
                        dropDownValue2 = value;
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
                    'Дата: $currentDateString',
                    style: TextStyle(color: Colors.black),
                  )
              ),
            ),
          ]
      ),
    );
  }
}