import 'dart:convert';

import 'package:http/http.dart' as http;

import '../base_web_service.dart';
import '../util.dart';

/// Web service for user
class UserWS extends BaseWS {
  /// Standard constructor
  UserWS(super.sharedPreferences);

  /// Base path for this web service
  static final base = '${BaseWS.domain}/api/user';

  /// Request user data
  Future<Map<String, dynamic>?> requestData() async {
    final uri = Uri.parse('$base/getData');

    try {
      final response = await http.get(
        uri,
        headers: {'Authorization': token},
      ).timeout(BaseWS.requestTimeout);

      if (response.statusCode != 200) {
        logFail(uri, response);
        return null;
      }
      logSuccess(uri, response);
      return jsonDecode(response.body);
    } on Exception catch (e, trace) {
      logException(uri, 'error in requestData', e, trace);
      return null;
    }
  }

  /// Request to update name
  Future<Map<String, dynamic>?> updateName(String newName) async {
    final uri = Uri.parse('$base/updateName');

    try {
      final response = await http.post(
        uri,
        body: jsonEncode({'new_name': newName}),
        headers: {'Authorization': token},
      ).timeout(BaseWS.requestTimeout);

      if (response.statusCode != 200) {
        logFail(uri, response);
        return null;
      }
      logSuccess(uri, response);
      return jsonDecode(response.body);
    } on Exception catch (e, trace) {
      logException(uri, 'error in updateName', e, trace);
      return null;
    }
  }

  /// Request to update password
  Future<Map<String, dynamic>?> updatePassword(
    String currentPassword,
    String newPassword,
  ) async {
    final uri = Uri.parse('$base/updatePassword');

    try {
      final response = await http.post(
        uri,
        body: jsonEncode({
          'current_password': currentPassword,
          'new_password': newPassword,
        }),
        headers: {'Authorization': token},
      ).timeout(BaseWS.requestTimeout);

      if (response.statusCode != 200) {
        logFail(uri, response);
        return null;
      }
      logSuccess(uri, response);
      return jsonDecode(response.body);
    } on Exception catch (e, trace) {
      logException(uri, 'error in updatePassword', e, trace);
      return null;
    }
  }
}
