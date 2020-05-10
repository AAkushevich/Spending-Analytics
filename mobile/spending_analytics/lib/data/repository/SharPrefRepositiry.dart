import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefRepository {

  static final SharedPrefRepository _singleton =
  new SharedPrefRepository._internal();

  factory SharedPrefRepository() {
    return _singleton;
  }

  SharedPrefRepository._internal();

  Future<bool> setUserToken(String userToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(KEY_USER_TOKEN, userToken);
  }

  Future<String> getUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_USER_TOKEN);
  }

  Future<bool> removeUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(KEY_USER_TOKEN);
  }

}

const KEY_USER_TOKEN = 'KEY_USER_TOKEN';