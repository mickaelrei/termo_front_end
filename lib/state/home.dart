import 'package:flutter/material.dart';

import '../entities/game.dart';
import 'global.dart';

/// State for home screen
class HomeState extends ChangeNotifier {
  var _wordLength = 5;
  var _wordCount = 1;

  // TODO: These fields should be requested from the server; hardcoded for now
  final _minWordLength = 4;
  final _maxWordLength = 16;
  final _minWordCount = 1;
  final _maxWordCount = 8;

  /// Currently selected word length
  int get wordLength => _wordLength;

  /// Currently selected word count
  int get wordCount => _wordCount;

  /// Min word length
  int get minWordLength => _minWordLength;

  /// Max word length
  int get maxWordLength => _maxWordLength;

  /// Min word count
  int get minWordCount => _minWordCount;

  /// Max word count
  int get maxWordCount => _maxWordCount;

  set wordLength(int value) {
    if (_wordLength == value) return;

    _wordLength = value;
    notifyListeners();
  }

  set wordCount(int value) {
    if (_wordCount == value) return;

    _wordCount = value;
    notifyListeners();
  }

  /// Attempts to start a game with the chosen configs
  Future<GameStartResponse> startGame() async {
    final config = GameConfig(
      wordLength: _wordLength,
      wordCount: _wordCount,
    );

    return gameHandler.start(config);
  }
}
