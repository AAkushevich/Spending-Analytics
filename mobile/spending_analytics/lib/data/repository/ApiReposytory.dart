import 'dart:io';

import 'package:http/http.dart';
import 'package:spending_analytics/data/repository/IApiRepository.dart';

class ApiRepository implements IApiRepository {

  @override
  Future<Response> login(String username, String password) async{
    var response = await post(
        registerApi,
        headers: contentType,
        body: "{ \"username\" : \"$username\", \"password\" : \"$password\" }"
    );

    return response;
  }

  Map<String,String> contentType = {'Content-Type':'application/json'};

  static const String serverUrl = "http://192.168.43.4:7788/api";
  static const String registerApi = serverUrl + "/login";

}