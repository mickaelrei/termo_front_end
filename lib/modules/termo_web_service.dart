import 'package:shared_preferences/shared_preferences.dart';

import 'util.dart';

/// App's base connection with web service
class TermoWS {
  /// Standard constructor
  TermoWS(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  /// Standard path for requests
  static String domain = 'http://168.138.128.110';

  /// Timeout for requests
  static const requestTimeout = Duration(seconds: 10);

  /// Authorization token stored in shared preferences
  String get token =>
      _sharedPreferences.getString(SharedPreferencesKeys.token) ?? '';
}
