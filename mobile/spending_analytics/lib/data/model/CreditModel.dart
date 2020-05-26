class CreditModel {

  CreditModel(this.operationId, this.creditName, this.amount, this.operationType,
      this.dateTime, this.endDate, this.interestRate, this.targetAccountId, this.creditPayments, this.closed);

  int operationId;
  String creditName;
  String operationType;
  double amount;
  DateTime dateTime;
  DateTime endDate;
  double interestRate;
  int targetAccountId;
  String creditPayments;
  bool closed;

  CreditModel.fromJson(Map<String, dynamic> json) {
    operationId = json['operation_id'];
    creditName = json['credit_name'];
    operationType = json['operation_type'];
    amount = json['amount'].toDouble();
    dateTime = DateTime.parse(json['date_time']);
    endDate = DateTime.parse(json['end_date']);
    interestRate = json['interest_rate'].toDouble();
    targetAccountId = json['target_account'];
    creditPayments = json['credit_payments'];
    closed = json['closed'];
  }

  Map<String, dynamic> toJson() => {
    'operation_id': operationId,
    'credit_name': creditName,
    'operation_type': operationType,
    'amount': amount,
    'date_time': dateTime.toString(),
    'end_date': endDate.toString(),
    'interest_rate': interestRate,
    'target_account': targetAccountId,
    'credit_payments': creditPayments,
    'closed': closed,
  };
}
