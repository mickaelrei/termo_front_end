import 'package:shared_preferences/shared_preferences.dart';

import '../../entities/game.dart';
import '../web_service/game.dart';

/// Interface for game handler
class GameHandler {
  /// Standard constructor
  GameHandler(this._preferences, this._gameWS);

  final SharedPreferences _preferences;
  final GameWS _gameWS;

  /// Attempts to start a new game with the given config
  Future<GameStartResponse> start(GameConfig config) async {
    final response = await _gameWS.requestStart(config);
    if (response == null) {
      return GameStartResponse.fail();
    }

    return GameStartResponse.fromJSON(response);
  }

  /// Attempts to start a new game with the given config
  Future<GameAttemptResponse> attempt(String attempt) async {
    final response = await _gameWS.requestAttempt(attempt);
    if (response == null) {
      return GameAttemptResponse.fail();
    }

    return GameAttemptResponse.fromJSON(response);
  }
}
