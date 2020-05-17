import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:spending_analytics/data/repository/ApiReposytory.dart';
import 'package:spending_analytics/data/repository/IApiRepository.dart';
import 'package:spending_analytics/data/repository/ISharedPrefRepository.dart';
import 'package:http/http.dart';
import 'package:spending_analytics/ui/BaseSate/BaseBloc.dart';

class AuthBloc extends BaseBloC {

  AuthBloc(this._apiRepository, this._sharedPrefRepository);

  final ISharedPrefRepository _sharedPrefRepository;
  final IApiRepository _apiRepository;

  // ignore: close_sinks
  BehaviorSubject<String> _loginEventSubject;
  Observable<String> get loginEventStream => _loginEventSubject.stream;

  // ignore: close_sinks
  BehaviorSubject<String> _signUpEventSubject;
  Observable<String> get signUpEventStream => _signUpEventSubject.stream;

  @override
  void initSubjects(List<Subject> subjects) {
    _loginEventSubject = BehaviorSubject();
    _signUpEventSubject = BehaviorSubject();

    subjects.add(_loginEventSubject);
    subjects.add(_signUpEventSubject);
  }

  void _loginEvent({String message}) {
    _loginEventSubject.sink.add(message);
  }

  void _loginEventError({String message}) {
    _loginEventSubject.sink.addError(message);
  }

  void _signUpEvent({String message}) {
    _signUpEventSubject.sink.add(message);
  }

  void _signUpEventError({String message}) {
    _signUpEventSubject.sink.addError(message);
  }

  Future<void> login(String username, String password) async {
    Response response = await _apiRepository.login(username, password);
    if(response.statusCode == 200) {
      String token = json.decode(response.body)['token'];
      ApiRepository.setToken = token;
      _sharedPrefRepository.setUserToken(token);
      _loginEvent();
    } else {
      String errorMessage = json.decode(response.body)['msg'];
      _loginEventError(message: errorMessage);
    }
  }

  Future<void> signUp(String username, String password) async {
    Response response = await _apiRepository.signUp(username, password);
    if(response.statusCode == 200) {
      _signUpEvent();
    } else {
      String errorMessage = json.decode(response.body)['msg'];
      _signUpEventError(message: errorMessage);
    }
  }

}
