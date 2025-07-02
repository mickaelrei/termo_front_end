import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../entities/game.dart';
import '../ui/util/loading.dart';
import 'global.dart';

/// State for game screen
class GameScreenState extends ChangeNotifier {
  /// Standard constructor
  GameScreenState(this._context, this._game) {
    // Automatically request focus when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });

    // Set variables based on provided game
    _currentAttemptIdx = _game.attempts.length;
    _attempts
      ..clear()
      ..addAll(_game.attempts);
    _gameStates
      ..clear()
      ..addAll(_game.gameStates);
    _currentAttempt
      ..clear()
      ..addAll(List<String>.filled(_game.wordLength, ' '));
  }

  final ActiveGameData _game;
  final BuildContext _context;

  final _currentAttempt = <String>[];
  final _attempts = <String>[];
  final _gameStates = <GameState>[];
  final _actualWords = <String>[];

  late int _currentAttemptIdx;
  var _focusedIdx = 0;
  bool? _won;

  /// Focus node for keyboard listener
  final focusNode = FocusNode();

  /// Current attempt index
  int get currentAttemptIdx => _currentAttemptIdx;

  /// Focused letter index
  int get focusedIdx => _focusedIdx;

  /// List of current attempts
  List<String> get attempts => _attempts;

  /// Word count
  int get wordCount => _game.wordCount;

  /// Word length
  int get wordLength => _game.wordLength;

  /// Max attempts
  int get maxAttempts => _game.maxAttempts;

  /// Whether user won/lost the game, or null if game still running
  bool? get won => _won;

  /// List of actual correct words
  List<String> get actualWords => _actualWords;

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }

  void _moveFocus(int diff) {
    _focusedIdx = max(0, min(_focusedIdx + diff, _game.wordLength - 1));
    notifyListeners();
  }

  void _clearAttempt() {
    _focusedIdx = 0;
    for (var i = 0; i < _currentAttempt.length; ++i) {
      _currentAttempt[i] = ' ';
    }
  }

  /// Get character for the given word, letter index and attempt index
  String? getChar(int wordIndex, int i, int attemptIndex) {
    final guessIndex = wordCorrectIndex(wordIndex);
    if (guessIndex != -1 && attemptIndex > guessIndex) {
      return null;
    }

    if (attemptIndex == _currentAttemptIdx) {
      return _currentAttempt[i];
    }

    return attemptIndex < _attempts.length ? _attempts[attemptIndex][i] : null;
  }

  /// Get state for the letter with specified location, or null if not revealed
  /// yet
  GameLetterState? getLetterState({
    required int wordIndex,
    required int attemptIndex,
    required int letterIndex,
  }) {
    assert(wordIndex >= 0 && wordIndex < _game.wordCount);
    assert(letterIndex >= 0 && letterIndex < _game.wordLength);
    assert(attemptIndex >= 0);

    if (attemptIndex >= _attempts.length) {
      return null;
    }

    final guessIndex = wordCorrectIndex(wordIndex);
    if (guessIndex != -1 && attemptIndex > guessIndex) {
      return null;
    }

    return _gameStates[attemptIndex][wordIndex][letterIndex];
  }

  /// Returns the index of the attempt where the word on the given index was
  /// correctly guessed, or -1 if not guessed
  int wordCorrectIndex(int wordIndex) {
    if (wordIndex < 0 || wordIndex >= _game.wordCount) return -1;

    // If we find one attempt that every letter is correct, then it is correct
    for (var i = 0; i < _gameStates.length; ++i) {
      if (_gameStates[i][wordIndex]
          .every((e) => e == GameLetterState.correct)) {
        return i;
      }
    }

    return -1;
  }

  /// Callback for a key event
  void onKeyEvent(KeyEvent event) {
    // Listen only to keydown events
    if (event is! KeyDownEvent) return;

    final logicalKey = event.logicalKey;
    if (logicalKey == LogicalKeyboardKey.arrowLeft) {
      _moveFocus(-1);
    } else if (logicalKey == LogicalKeyboardKey.arrowRight) {
      _moveFocus(1);
    } else if (logicalKey == LogicalKeyboardKey.enter) {
      attempt();
    } else if (logicalKey == LogicalKeyboardKey.backspace) {
      clearFocused();
    } else if (logicalKey.keyLabel.length == 1 &&
        RegExp(r'[A-Za-z]').hasMatch(logicalKey.keyLabel)) {
      onLetter(logicalKey.keyLabel);
    }
  }

  /// Clears current focused letter index
  void clearFocused() {
    if (_currentAttempt[_focusedIdx] == ' ') {
      _moveFocus(-1);
    }
    _currentAttempt[_focusedIdx] = ' ';
    notifyListeners();
  }

  /// Callback for when a letter is pressed
  void onLetter(String letter) {
    if (letter.length != 1) return;

    _currentAttempt[_focusedIdx] = letter;
    do {
      _moveFocus(1);
    } while (
        _currentAttempt[_focusedIdx] != ' ' && _focusedIdx < wordLength - 1);
    notifyListeners();
  }

  /// Sends an attempt with the current texts
  Future<GameAttemptResponse?> attempt() async {
    if (_currentAttempt.any((e) => e == ' ')) {
      return null;
    }

    var attempt = _currentAttempt.join('');
    if (attempt.length != _game.wordLength) {
      return null;
    }

    final response = await showLoadingDialog(
      context: _context,
      function: () => gameHandler.attempt(attempt),
    );
    if (response.status.isSuccess) {
      // Clear current attempt
      _clearAttempt();

      // Add new attempt to list
      _attempts.add(attempt);
      _currentAttemptIdx++;
      _gameStates.add(response.gameState);

      // Set won/lost state
      if (response.words != null) {
        _won = response.won;
        _actualWords
          ..clear()
          ..addAll(response.words!);
      }

      notifyListeners();
    }

    return response;
  }
}
