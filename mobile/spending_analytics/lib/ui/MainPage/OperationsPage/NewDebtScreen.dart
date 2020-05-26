import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:spending_analytics/data/model/AccountModel.dart';
import 'package:spending_analytics/data/model/CategoryModel.dart';
import 'package:spending_analytics/data/repository/ISharedPrefRepository.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:toast/toast.dart';

class NewDebtScreen extends StatefulWidget {

  NewDebtScreen(this._sharedPrefRepository, this.addNewDebt, this.accounts);

  final ISharedPrefRepository _sharedPrefRepository;

  final List<AccountModel> accounts;

  final Function(DateTime dateTime, double amount, String debtMode, String person, String userComment, int accountId) addNewDebt;

  @override
  State<StatefulWidget> createState() {
    return NewDebtScreenState(_sharedPrefRepository, addNewDebt, accounts);
  }

}

class NewDebtScreenState extends State<NewDebtScreen> {

  final ISharedPrefRepository _sharedPrefRepository;

  final Function(DateTime dateTime, double amount, String debtMode, String person, String userComment, int accountId) addNewDebt;

  final List<AccountModel> accounts;

  NewDebtScreenState(this._sharedPrefRepository, this.addNewDebt, this.accounts) {
    dropDownValue = accounts.first.accountName;
    chosenAccountId = accounts.first.accountId;

    accounts.forEach((element) {
      accountNames.add(element.accountName);
      accountsMap[element.accountName] = element.accountId;
    });

    currentDateString = "${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}";
  }

  Map<String, int> accountsMap = Map();

  List<String> accountNames = List();

  int _radioValue = 0;

  String debtMode = "lent";

  DateTime dateTime = DateTime.now();

  String currentDateString = DateTime.now().toString();

  int chosenAccountId = 0;

  String dropDownValue = "";

  TextEditingController balanceController = TextEditingController();

  TextEditingController usernameController = TextEditingController();

  TextEditingController userCommentController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
      switch (_radioValue) {
        case 0:
          debtMode = 'lent';
          break;
        case 1:
          debtMode = 'borrowed';
          break;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Новый долг", style: TextStyle(color: Colors.black)),
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
                if(balanceController.text.isNotEmpty && chosenAccountId != 0 && userCommentController.text.isNotEmpty && usernameController.text.isNotEmpty) {
                  await addNewDebt(dateTime, double.parse(balanceController.text), debtMode, usernameController.text, userCommentController.text, chosenAccountId);
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
                    Text("Кошелек", style: TextStyle(fontSize: 15)),
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
                padding: const EdgeInsets.only(left: 80, right: 80, top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Radio(
                          value: 0,
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange,
                        ),
                        Text("Я занял", style: TextStyle(fontSize: 12),)
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Radio(
                          value: 1,
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange,
                        ),
                        Text("Я одолжил", style: TextStyle(fontSize: 12),)
                      ],
                    ),
                  ],
                )
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
                child: TextField(
                  controller: usernameController,
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Имя",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
                child: TextField(
                  controller: userCommentController,
                  maxLines: 5,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Комментарий",
                  ),
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
      ),
    );
  }

}