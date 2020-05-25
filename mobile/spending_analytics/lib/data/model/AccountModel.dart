class AccountModel {

  AccountModel(this.accountId, this.accountName, this.balance, this.currency);

  int accountId;
  String accountName;
  double balance;
  String currency;

  AccountModel.fromJson(Map<String, dynamic> json) {
    accountId = json['account_id'];
    accountName = json['account_name'];
    balance = json['balance'].toDouble();
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() =>
      {
        'account_id': accountId,
        'account_name': accountName,
        'balance': balance,
        'currency': currency,
      };
}
