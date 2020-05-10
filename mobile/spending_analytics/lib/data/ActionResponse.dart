class ActionResponse<ACTION_TYPE> {
  ActionResponse._(this._state, this._message, this._data, this._actionType);

  ResponseState _state;
  String _message;
  dynamic _data;
  ACTION_TYPE _actionType;

  factory ActionResponse.success(
      String msg, dynamic data, ACTION_TYPE actionType) =>
      ActionResponse<ACTION_TYPE>._(
          ResponseState.SUCCESS, msg, data, actionType);

  factory ActionResponse.error(
      String msg, dynamic data, ACTION_TYPE actionType) =>
      ActionResponse<ACTION_TYPE>._(ResponseState.ERROR, msg, data, actionType);

  factory ActionResponse.complete(String msg, ACTION_TYPE actionType) =>
      ActionResponse<ACTION_TYPE>._(
          ResponseState.COMPLETE, msg, null, actionType);

  factory ActionResponse.loading({dynamic data, ACTION_TYPE actionType}) =>
      ActionResponse<ACTION_TYPE>._(
          ResponseState.LOADING, null, data, actionType);

  factory ActionResponse.init() =>
      ActionResponse<ACTION_TYPE>._(ResponseState.INIT, null, null, null);

  ResponseState get state => _state;

  // ignore: unnecessary_getters_setters
  String get message => _message;

  // ignore: unnecessary_getters_setters
  set message(String value) {
    _message = value;
  }

  dynamic get data => _data;

  ACTION_TYPE get actionType => _actionType;

  @override
  String toString() {
    return 'Response{_state: $_state, _message: $_message, _data: $_data, _actionType: $_actionType}';
  }
}

enum ResponseState { INIT, LOADING, SUCCESS, ERROR, COMPLETE }