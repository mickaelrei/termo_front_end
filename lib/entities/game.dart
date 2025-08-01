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

/// Construct a game state from json
GameState gameStateFromJSON(dynamic json) {
  final wordStates = <GameWordState>[];

  // Get all word states for this row
  for (final wordState in json ?? []) {
    final letterStates = <GameLetterState>[];

    // Get all letter states for this word
    for (final letterState in wordState) {
      letterStates.add(GameLetterState.values[letterState]);
    }

    wordStates.add(letterStates);
  }

  return wordStates;
}

/// Configurations for requesting to start agame
class GameConfig {
  /// Standard constructor
  GameConfig({
    required this.wordLength,
    required this.wordCount,
  });

  /// Word length; letter count
  final int wordLength;

  /// How many simultaneous words the player will have to guess
  final int wordCount;

  /// Convert this entity into a map for JSON uses
  Map<String, dynamic> toJSON() {
    return {
      'word_length': wordLength,
      'word_count': wordCount,
    };
  }
}

/// Data about an active/unfinished game
class ActiveGameData {
  /// Standard constructor
  ActiveGameData({
    required this.wordLength,
    required this.wordCount,
    required this.maxAttempts,
    required this.attempts,
    required this.gameStates,
  });

  /// Length of each word in the game
  final int wordLength;

  /// How many simultaneous words the user is guessing
  final int wordCount;

  /// Maximum number of attempts
  final int maxAttempts;

  /// List of current attempts
  final List<String> attempts;

  /// Game state for each attempt
  final List<GameState> gameStates;

  /// Create an entity from a JSON
  factory ActiveGameData.fromJSON(Map<String, dynamic> json) {
    final attempts = <String>[];
    final gameStates = <GameState>[];

    // Get all attempts
    for (final attempt in json['attempts'] ?? []) {
      attempts.add(attempt);
    }

    // Get all game states (each row)
    for (final state in json['game_states'] ?? []) {
      final wordStates = <GameWordState>[];

      // Get all word states for this row
      for (final wordState in state) {
        final letterStates = <GameLetterState>[];

        // Get all letter states for this word
        for (final letterState in wordState) {
          letterStates.add(GameLetterState.values[letterState]);
        }

        wordStates.add(letterStates);
      }

      gameStates.add(wordStates);
    }

    return ActiveGameData(
      wordLength: json['word_length'],
      wordCount: json['word_count'],
      maxAttempts: json['max_attempts'],
      attempts: attempts,
      gameStates: gameStates,
    );
  }
}

/// Response from game start attempt
class GameStartResponse {
  /// Standard constructor
  GameStartResponse({
    required this.status,
    required this.maxAttempts,
  });

  /// Constructor for failed game start attempt
  GameStartResponse.fail()
      : status = GameStartStatus.serverError,
        maxAttempts = 0;

  /// Create an entity from a JSON
  factory GameStartResponse.fromJSON(Map<String, dynamic> json) {
    return GameStartResponse(
      status: GameStartStatus.values[json['status']],
      maxAttempts: json['max_attempts'],
    );
  }

  /// Register status
  final GameStartStatus status;

  /// Max number of attempts for the game
  final int maxAttempts;
}

/// Response from game attempt attempt
class GameAttemptResponse {
  /// Standard constructor
  GameAttemptResponse({
    required this.status,
    required this.gameState,
    required this.words,
    required this.won,
  });

  /// Constructor for failed game start attempt
  GameAttemptResponse.fail()
      : status = GameStartStatus.serverError,
        gameState = const [],
        words = null,
        won = false;

  /// Create an entity from a JSON
  factory GameAttemptResponse.fromJSON(Map<String, dynamic> json) {
    final List<String>? words;
    if (json['words'] != null) {
      words = [];
      for (final word in json['words']) {
        words.add(word);
      }
    } else {
      words = null;
    }

    return GameAttemptResponse(
      status: GameStartStatus.values[json['status']],
      gameState: json['game_state'] != null
          ? gameStateFromJSON(json['game_state'])
          : [],
      words: words,
      won: json['won'],
    );
  }

  /// Register status
  final GameStartStatus status;

  /// Game state obtained from this new attempt
  final GameState gameState;

  /// List of actual words; null if game not finished yet
  final List<String>? words;

  /// Whether user won with this attempt
  final bool won;
}
