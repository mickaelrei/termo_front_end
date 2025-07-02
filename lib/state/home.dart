import 'package:flutter/material.dart';

import '../entities/game.dart';
import 'global.dart';

/// State for home screen
class HomeState extends ChangeNotifier {
  var _wordLength = 5;
  var _wordCount = 1;

  /// Currently selected word length
  int get selectedWordLength => _wordLength;

  /// Currently selected word count
  int get selectedWordCount => _wordCount;

  set selectedWordLength(int value) {
    if (_wordLength == value) return;

    _wordLength = value;
    notifyListeners();
  }

  set selectedWordCount(int value) {
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
