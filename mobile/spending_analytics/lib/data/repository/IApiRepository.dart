import 'package:http/http.dart';

abstract class IApiRepository {

  Future<Response> login(String username, String password);



}