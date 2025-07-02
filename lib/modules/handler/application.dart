import 'package:shared_preferences/shared_preferences.dart';

import '../../entities/user.dart';
import '../util.dart';
import '../web_service/auth.dart';

/// Interface for application handler
class ApplicationHandler {
  /// Standard constructor
  ApplicationHandler(this._preferences, this._applicationWS);

  final SharedPreferences _preferences;
  final ApplicationWS _applicationWS;

  Future<void> _setToken(String? token) async {
    if (token == null) {
      await _preferences.remove(SharedPreferencesKeys.token);
    } else {
      await _preferences.setString(SharedPreferencesKeys.token, token);
    }
  }

  /// Request to perform login
  Future<UserLoginResponse> requestLogin(UserCredentials credentials) async {
    final response = await _applicationWS.requestLogin(credentials);
    if (response == null) {
      return UserLoginResponse.fail();
    }

    final loginResponse = UserLoginResponse.fromJSON(response);

    // Check if got token and store it
    final token = loginResponse.token;
    if (loginResponse.status.isSuccess && token != null && token.isNotEmpty) {
      await _setToken(token);
    }

    return loginResponse;
  }

  /// Request to perform login
  Future<UserRegisterResponse> requestRegister(
    UserCredentials credentials,
  ) async {
    final response = await _applicationWS.requestRegister(credentials);
    if (response == null) {
      return UserRegisterResponse.fail();
    }

    final registerResponse = UserRegisterResponse.fromJSON(response);

    // Check if got token and store it
    final token = registerResponse.token;
    if (registerResponse.status.isSuccess &&
        token != null &&
        token.isNotEmpty) {
      await _setToken(token);
    }

    return registerResponse;
  }
}
