class TransferModel {

  TransferModel(this.operationId, this.dateTime, this.amount, this.operationType,
      this.sourceAccountId, this.targetAccountId);

  int operationId;
  DateTime dateTime;
  double amount;
  String operationType;
  int sourceAccountId;
  int targetAccountId;

  TransferModel.fromJson(Map<String, dynamic> json) {
    operationId = json['operation_id'];
    dateTime = DateTime.parse(json['date_time']);
    amount = json['amount'].toDouble();
    operationType = json['operation_type'];
    sourceAccountId = json['source_account'];
    targetAccountId = json['target_account'];
  }

  Map<String, dynamic> toJson() => {
    'operation_id': operationId,
    'date_time': dateTime.toString(),
    'amount': amount,
    'operation_type': operationType,
    'source_account': sourceAccountId,
    'target_account': targetAccountId,
  };
}
