import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../entities/game.dart';
import '../termo_web_service.dart';
import '../util.dart';

/// Web service for game
class GameWS extends TermoWS {
  /// Standard constructor
  GameWS(super.sharedPreferences);

  /// Base path for this web service
  static final base = '${TermoWS.domain}/api/game';

  /// Request to start a game
  Future<Map<String, dynamic>?> requestStart(GameConfig config) async {
    final uri = Uri.parse('${TermoWS.domain}/start');

    try {
      final response = await http
          .post(
            uri,
            body: jsonEncode(config.toJSON()),
          )
          .timeout(TermoWS.requestTimeout);

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
    final uri = Uri.parse('${TermoWS.domain}/attempt');

    try {
      final response = await http
          .post(
            uri,
            body: jsonEncode({
              'attempt': attempt,
            }),
          )
          .timeout(TermoWS.requestTimeout);

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
