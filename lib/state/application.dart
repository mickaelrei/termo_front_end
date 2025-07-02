import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../entities/user.dart';
import '../modules/util.dart';
import 'global.dart';

/// Main application state
class ApplicationState extends ChangeNotifier {
  /// Standard constructor
  ApplicationState(this._sharedPreferences) {
    init();
  }

  final SharedPreferences _sharedPreferences;

  UserData? _userData;

  /// Whether user is logged in
  bool get loggedIn => sessionToken != '';

  /// Data about logged user, or null if not logged in
  UserData? get user => _userData;

  /// Current session token
  String get sessionToken =>
      _sharedPreferences.getString(SharedPreferencesKeys.token) ?? '';

  /// Initialize state
  Future<void> init() async {
    await _loadUser();
  }

  Future<void> _loadUser() async {
    if (!loggedIn) return;

    _userData = await userHandler.getData();

    notifyListeners();
  }

  /// Callback for successful login/register attempt
  Future<void> onLoginSuccess() async {
    await _loadUser();
    notifyListeners();
  }

  /// Perform log-out
  Future<void> logout() async {
    await _sharedPreferences.clear();
    notifyListeners();
  }
}
