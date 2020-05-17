import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

/// print into console response details only in not release app mode
void printResponseInFormat(Response response) {
  if (!kReleaseMode) {
    print("\n!!!RESPONSE from REQUEST: ${response.request}"
        "\n--->statusCode: ${response.statusCode}"
        "\n----->headers: ${response.headers}"
        "\n------->body:${response.body}\n");
  }
}