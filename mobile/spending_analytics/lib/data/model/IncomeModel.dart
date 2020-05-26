class IncomeModel {

  IncomeModel(this.operationId, this.dateTime, this.amount, this.operationType,
      this.accountId, this.categoryId, this.categoryName, this.categoryIcon);

  int operationId;
  DateTime dateTime;
  double amount;
  String operationType;
  int accountId;
  int categoryId;
  String categoryName;
  String categoryIcon;

  IncomeModel.fromJson(Map<String, dynamic> json) {
    operationId = json['operation_id'];
    dateTime = DateTime.parse(json['date_time']);
    amount = json['amount'].toDouble();
    operationType = json['operation_type'];
    accountId = json['account_id'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    categoryIcon = json['category_icon'];
  }

  Map<String, dynamic> toJson() => {
    'operation_id': operationId,
    'date_time': dateTime.toString(),
    'amount': amount,
    'operation_type': operationType,
    'account_id': accountId,
    'category_id': categoryId,
    'category_name': categoryName,
    'category_icon': categoryIcon,
  };
}
