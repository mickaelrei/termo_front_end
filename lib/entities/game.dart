import '../modules/status_codes/game.dart';

/// Possible letter states
enum GameLetterState {
  /// Letter is in the correct position
  correct,

  /// Letter is in the wrong position
  wrongPosition,

  /// Letter is not in the word
  wrong,
}

/// State for a word in a game
typedef GameWordState = List<GameLetterState>;

/// State of all words in a game
typedef GameState = List<GameWordState>;

/// Configurations for requesting to start agame
class GameConfig {
  /// Standard constructor
  GameConfig({
    required this.wordLength,
    required this.gameCount,
  });

  /// Word length; letter count
  final int wordLength;

  /// How many simultaneous words the player will have to guess
  final int gameCount;

  /// Convert this entity into a map for JSON uses
  Map<String, dynamic> toJSON() {
    return {
      'word_length': wordLength,
      'game_count': gameCount,
    };
  }
}

/// Response from game start attempt
class GameStartResponse {
  /// Standard constructor
  GameStartResponse({
    required this.status,
    required this.maxTries,
  });

  /// Constructor for failed game start attempt
  GameStartResponse.fail()
      : status = GameStartStatus.serverError,
        maxTries = 0;

  /// Create an entity from a JSON
  factory GameStartResponse.fromJSON(Map<String, dynamic> json) {
    return GameStartResponse(
      status: GameStartStatus.values[json['status']],
      maxTries: json['max_tries'] ?? 0,
    );
  }

  /// Register status
  final GameStartStatus status;

  /// User auth token, or null if failed
  final int maxTries;
}

/// Response from game attempt attempt
class GameAttemptResponse {
  /// Standard constructor
  GameAttemptResponse({
    required this.status,
    required this.gameState,
  });

  /// Constructor for failed game start attempt
  GameAttemptResponse.fail()
      : status = GameStartStatus.serverError,
        gameState = const [];

  /// Create an entity from a JSON
  factory GameAttemptResponse.fromJSON(Map<String, dynamic> json) {
    return GameAttemptResponse(
      status: GameStartStatus.values[json['status']],
      gameState: json['game_state'] ?? [],
    );
  }

  /// Register status
  final GameStartStatus status;

  /// Game state obtained from this new attempt
  final GameState gameState;
}
