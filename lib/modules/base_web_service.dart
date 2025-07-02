import 'package:shared_preferences/shared_preferences.dart';

import 'util.dart';

/// Environment variable "runType" defines which URL to use as domain
///
/// By default it is empty, which means production URL will be used
///
/// Other possible values:
///  - dev: development URL
///  - local: local server URL
const _runType = String.fromEnvironment('runType', defaultValue: '');

/// App's base connection with web service
class BaseWS {
  /// Standard constructor
  BaseWS(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  /// Standard path for requests
  static String domain = switch (_runType) {
    'local' => 'http://localhost:8080',
    _ => 'https://termo-backend.duckdns.org',
  };

  /// Timeout for requests
  static const requestTimeout = Duration(seconds: 10);

  /// Authorization token stored in shared preferences
  String get token =>
      _sharedPreferences.getString(SharedPreferencesKeys.token) ?? '';
}
