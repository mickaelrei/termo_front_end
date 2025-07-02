import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../entities/game.dart';
import '../base_web_service.dart';
import '../util.dart';

/// Web service for game
class GameWS extends BaseWS {
  /// Standard constructor
  GameWS(super.sharedPreferences);

  /// Base path for this web service
  static final base = '${BaseWS.domain}/api/game';

  /// Request to start a game
  Future<Map<String, dynamic>?> requestStart(GameConfig config) async {
    final uri = Uri.parse('$base/start');

    try {
      final response = await http.post(
        uri,
        body: jsonEncode(config.toJSON()),
        headers: {'Authorization': token},
      ).timeout(BaseWS.requestTimeout);

      if (response.statusCode != 200) {
        logFail(uri, response);
        return null;
      }
      logSuccess(uri, response);
      return jsonDecode(response.body);
    } on Exception catch (e, trace) {
      logException(uri, 'error in requestStart', e, trace);
      return null;
    }
  }

  /// Request to attempt a word in a game
  Future<Map<String, dynamic>?> requestAttempt(String attempt) async {
    final uri = Uri.parse('$base/attempt');

    try {
      final response = await http.post(
        uri,
        body: jsonEncode({'attempt': attempt}),
        headers: {'Authorization': token},
      ).timeout(BaseWS.requestTimeout);

      if (response.statusCode != 200) {
        logFail(uri, response);
        return null;
      }
      logSuccess(uri, response);
      return jsonDecode(response.body);
    } on Exception catch (e, trace) {
      logException(uri, 'error in requestAttempt', e, trace);
      return null;
    }
  }
}
