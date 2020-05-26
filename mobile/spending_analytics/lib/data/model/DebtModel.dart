class DebtModel {

  DebtModel(this.operationId, this.dateTime, this.amount, this.operationType,
      this.sourceAccountId, this.person, this.userComment, this.debtMode, this.closed);

  int operationId;
  DateTime dateTime;
  double amount;
  String operationType;
  int sourceAccountId;
  String person;
  String userComment;
  String debtMode;
  bool closed;

  DebtModel.fromJson(Map<String, dynamic> json) {
    operationId = json['operation_id'];
    dateTime = DateTime.parse(json['date_time']);
    operationType = json['operation_type'];
    amount = json['amount'].toDouble();
    sourceAccountId = json['source_account'];
    person = json['person'];
    userComment = json['user_comment'];
    debtMode = json['debt_mode'];
    closed = json['closed'];
  }

  Map<String, dynamic> toJson() => {
        'operation_id': operationId,
        'date_time': dateTime.toString(),
        'operation_type': operationType,
        'amount': amount,
        'source_account': sourceAccountId,
        'person': person,
        'user_comment': userComment,
        'debt_mode': debtMode,
        'closed': closed,
      };
}
