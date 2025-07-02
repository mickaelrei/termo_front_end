import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../entities/user.dart';
import '../modules/util.dart';
import 'global.dart';

/// Main application state
class ApplicationState extends ChangeNotifier {
  /// Standard constructor
  ApplicationState(this._sharedPreferences) {
    _loadUser();
  }

  final SharedPreferences _sharedPreferences;

  var _loading = false;
  UserData? _userData;

  /// Whether application is loading
  bool get loading => _loading;

  /// Whether user is logged in
  bool get loggedIn => sessionToken != '';

  /// Data about logged user, or null if not logged in
  UserData? get user => _userData;

  /// Current session token
  String get sessionToken =>
      _sharedPreferences.getString(SharedPreferencesKeys.token) ?? '';

  Future<void> _loadUser() async {
    if (!loggedIn) return;

    _loading = true;
    notifyListeners();

    _userData = await userHandler.getData();

    _loading = false;
    notifyListeners();
  }

  /// Callback for successful login/register attempt
  Future<void> onLoginSuccess() async {
    await _loadUser();
    notifyListeners();
  }

  /// Callback for successful game start
  Future<void> onGameStart() async {
    await _loadUser();
    notifyListeners();
  }

  /// Perform log-out
  Future<void> logout() async {
    await _sharedPreferences.clear();
    notifyListeners();
  }
}
