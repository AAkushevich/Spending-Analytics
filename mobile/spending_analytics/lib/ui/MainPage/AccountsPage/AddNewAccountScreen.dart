import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:spending_analytics/data/repository/ISharedPrefRepository.dart';

class AddNewAccountScreen extends StatefulWidget {

  AddNewAccountScreen(this._sharedPrefRepository, this.addNewAccount);

  final ISharedPrefRepository _sharedPrefRepository;

  final Function(String scoreName, double balance, String currency) addNewAccount;

  @override
  State<StatefulWidget> createState() {
    return NewAccountScreenState(_sharedPrefRepository, addNewAccount);
  }

}

class NewAccountScreenState extends State<AddNewAccountScreen> {

  NewAccountScreenState(this._sharedPrefRepository, this.addNewAccount);

  final ISharedPrefRepository _sharedPrefRepository;

  final Function(String scoreName, double balance, String currency) addNewAccount;

  String dropDownValue = "BYN";

  List<String> currencyList = ["BYN", "RUB", "USD", "EUR"];

  TextEditingController titleController = TextEditingController();
  TextEditingController balanceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Новый кошелек", style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          FlatButton(
              child: Text("Сохранить", style: TextStyle(color: Colors.black),),
              onPressed: () async{
                if(titleController.text.isNotEmpty && balanceController.text.isNotEmpty) {
                  Response response = await addNewAccount(titleController.text, double.parse(balanceController.text), dropDownValue);
                  Navigator.pop(context);
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
              controller: titleController,
              maxLines: 1,
              decoration: InputDecoration(
                labelText: "Имя кошелька",
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
                labelText: "Текущий баланс",
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
                  value: dropDownValue.toString(),
                  underline: Container(
                    height: 0,
                  ),
                  onChanged: (value) {
                    setState(() {
                      dropDownValue = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}