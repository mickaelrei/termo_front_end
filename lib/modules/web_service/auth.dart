import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../entities/user.dart';
import '../base_web_service.dart';
import '../util.dart';

/// Web service for application
class ApplicationWS extends BaseWS {
  /// Standard constructor
  ApplicationWS(super.sharedPreferences);

  /// Request to login user
  Future<Map<String, dynamic>?> requestLogin(
    UserCredentials credentials,
  ) async {
    final uri = Uri.parse('${BaseWS.domain}/login');

    try {
      final response = await http
          .post(
            uri,
            body: jsonEncode(
              credentials.toJSON(),
            ),
          )
          .timeout(BaseWS.requestTimeout);

      if (response.statusCode != 200) {
        logFail(uri, response);
        return null;
      }
      logSuccess(uri, response);
      return jsonDecode(response.body);
    } on Exception catch (e, trace) {
      logException(uri, 'error in requestLogin', e, trace);
      return null;
    }
  }

  /// Request to register user
  Future<Map<String, dynamic>?> requestRegister(
    UserCredentials credentials,
  ) async {
    final uri = Uri.parse('${BaseWS.domain}/register');

    try {
      final response = await http
          .post(
            uri,
            body: jsonEncode(
              credentials.toJSON(),
            ),
          )
          .timeout(BaseWS.requestTimeout);

      if (response.statusCode != 200) {
        logFail(uri, response);
        return null;
      }
      logSuccess(uri, response);
      return jsonDecode(response.body);
    } on Exception catch (e, trace) {
      logException(uri, 'error in requestRegister', e, trace);
      return null;
    }
  }
}
