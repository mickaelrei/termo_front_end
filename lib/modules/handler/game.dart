import '../../entities/game.dart';
import '../web_service/game.dart';

/// Interface for game handler
class GameHandler {
  /// Standard constructor
  GameHandler(this._gameWS);

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
