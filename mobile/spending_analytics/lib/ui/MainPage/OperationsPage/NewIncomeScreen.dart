import 'package:flutter/material.dart';
import 'package:spending_analytics/data/model/AccountModel.dart';
import 'package:spending_analytics/data/model/CategoryModel.dart';
import 'package:spending_analytics/data/repository/ISharedPrefRepository.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:toast/toast.dart';

class NewIncomeScreen extends StatefulWidget {

  NewIncomeScreen(this._sharedPrefRepository, this.addNewIncome, this.categories, this.accounts);

  final ISharedPrefRepository _sharedPrefRepository;

  final List<CategoryModel> categories;

  final List<AccountModel> accounts;

  final Function(DateTime dateTime, double amount, int accountId, int categoryId) addNewIncome;

  @override
  State<StatefulWidget> createState() {
    return NewIncomeScreenState(_sharedPrefRepository, addNewIncome, accounts, categories);
  }
}

class NewIncomeScreenState extends State<NewIncomeScreen> {

  final ISharedPrefRepository _sharedPrefRepository;

  final Function(DateTime dateTime, double amount, int accountId, int categoryId) addNewIncome;

  final List<CategoryModel> categories;

  final List<AccountModel> accounts;

  NewIncomeScreenState(this._sharedPrefRepository, this.addNewIncome, this.accounts, this.categories){

    dropDownValue = accounts.first.accountName;
    chosenAccountId = accounts.first.accountId;

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

  int chosenCategoryId = 0;

  int chosenAccountId = 0;

  String dropDownValue = "";

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
        title: Text("Доход", style: TextStyle(color: Colors.black)),
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
                if(balanceController.text.isNotEmpty && chosenAccountId != 0 && chosenCategoryId != 0) {
                  await addNewIncome(dateTime, double.parse(balanceController.text),
                      chosenAccountId, chosenCategoryId);
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
                  Text("Кошелек", style: TextStyle(fontSize: 15)),
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
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              child: GridView.builder(
                  itemCount: categories.length,
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                  itemBuilder: (BuildContext context, int index) {
                    if(categories[index].categoryType.compareTo("income") == 0) {
                      return Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: IconButton(
                                  icon: Image.asset('assets/${categories[index].categoryIcon}', color: categories[index].isFavorite ? Colors.red : Colors.black, scale: 3.2),
                                  onPressed: () {
                                    setState(() {
                                      chosenCategoryId = categories[index].categoryId;
                                      var temp = categories[index];
                                      temp.isFavorite = true;
                                      categories[index] = categories[0];
                                      categories[index].isFavorite = false;
                                      categories[0] = temp;
                                    });
                                  },
                                ),
                              ),
                              Text(categories[index].categoryName.toString(), style: TextStyle(fontSize: 12), textAlign: TextAlign.center,)
                            ],
                          )
                      );
                    } else {
                      return Container();
                    }
                  }
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