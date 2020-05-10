import 'package:rxdart/rxdart.dart';
import 'package:spending_analytics/data/repository/IApiRepository.dart';
import 'package:spending_analytics/data/repository/SharPrefRepositiry.dart';
import 'package:http/http.dart';
import 'package:spending_analytics/ui/BaseSate/BaseBloc.dart';

class AuthBloc extends BaseBloC {

  final SharedPrefRepository _sharedPrefRepository;
  final IApiRepository _apiRepository;

  BehaviorSubject<LOGIN_STATE> _isUserAlreadyAuth;

  AuthBloc(this._apiRepository, this._sharedPrefRepository) {
    initEvent();
  }

  Observable<LOGIN_STATE> get isUserAlreadyAuthStream => _isUserAlreadyAuth.stream;

  _changeLoginPageState(LOGIN_STATE value) {
    _isUserAlreadyAuth.add(value);
  }

  void initEvent() {
    _sharedPrefRepository.getUserToken().then((token) {
      if(token != null) {
        _changeLoginPageState(LOGIN_STATE.ALREADY_AUTH);
      }
    });
  }

  @override
  void initSubjects(List<Subject> subjects) {
    _isUserAlreadyAuth = BehaviorSubject();
    subjects.add(_isUserAlreadyAuth);

  }

  Future<void> login(String username, String password) async{
    Response response = await _apiRepository.login(username, password);
    if(response.statusCode == 200) {
      print("asdas");
    }
  }
}

enum LOGIN_STATE {
  AUTH_REQUIRED,
  ALREADY_AUTH
}