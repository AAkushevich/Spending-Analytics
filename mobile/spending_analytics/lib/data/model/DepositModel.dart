class DepositModel {

  DepositModel(this.operationId, this.depositName, this.amount, this.operationType,
      this.currency, this.dateTime, this.endDate, this.interestRate, this.sourceAccountId, this.interestPayments);

  int operationId;
  String depositName;
  double amount;
  String operationType;
  String currency;
  DateTime dateTime;
  DateTime endDate;
  double interestRate;
  int sourceAccountId;
  String interestPayments;

  DepositModel.fromJson(Map<String, dynamic> json) {
    operationId = json['operation_id'];
    depositName = json['deposit_name'];
    amount = json['amount'].toDouble();
    operationType = json['operation_type'];
    currency = json['currency'];
    dateTime = DateTime.parse(json['date_time']);
    endDate = DateTime.parse(json['end_date']);
    interestRate = json['interest_rate'].toDouble();
    interestPayments = json['interest_payments'];
    sourceAccountId = json['source_account'];
  }

  Map<String, dynamic> toJson() => {
        'operation_id': operationId,
        'deposit_name': depositName,
        'amount': amount,
        'operation_type': operationType,
        'currency': currency,
        'date_time': dateTime.toString(),
        'end_date': endDate.toString(),
        'interest_rate': interestRate,
        'interest_payments': interestPayments,
        'source_account': sourceAccountId,
      };
}
