import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

/// Shared prefs key constants used in the app
abstract class SharedPreferencesKeys {
  /// Key for storing session token
  static const String token = 'token';
}

/// Prints a formatted failed request message
void logFail(Uri uri, http.Response response) {
  log(
    '[FAIL | ${response.statusCode} | ${uri.path}]: ${response.body}',
    level: 2000,
  );
}

/// Prints a formatted successful request message
void logSuccess(Uri uri, http.Response response, {bool showBody = true}) {
  var message = '[SUCCESS | ${uri.path}';
  if (uri.query.isNotEmpty) {
    message += '&${uri.query}';
  }
  message += ']';

  if (showBody) {
    message += ': ${jsonDecode(response.body)}';
  }

  log(message);
}

/// Prints a formatted exception message
void logException(
  Uri uri,
  String description,
  Exception e, [
  StackTrace? stackTrace,
]) {
  log(
    '[EXCEPTION | ${uri.path}]: $description',
    level: 1000,
    error: e,
    stackTrace: stackTrace,
  );
}
