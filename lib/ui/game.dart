import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../entities/game.dart';
import '../state/application.dart';
import '../state/game.dart';

const double _letterBoxDimension = 60;
const double _paddingWords = 24;
const double _paddingAttempts = 8;

/// Widget for game screen
class GameScreen extends StatelessWidget {
  /// Standard constructor
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context);
    final game = appState.user?.activeGame;
    if (game == null) {
      return const SizedBox();
    }

    return ChangeNotifierProvider(
      create: (context) => GameScreenState(context, game),
      child: Consumer<GameScreenState>(
        builder: (context, state, _) {
          return KeyboardListener(
            focusNode: state.focusNode,
            onKeyEvent: state.onKeyEvent,
            child: Scaffold(
              backgroundColor: Colors.brown.shade300,
              body: Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Align(
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (state.won != null) const _GameOver(),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: _GameView(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GameOver extends StatelessWidget {
  const _GameOver();

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GameScreenState>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          splashRadius: 20,
          onPressed: html.window.location.reload,
          icon: const Icon(
            Icons.arrow_back_rounded,
            size: 24,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          state.won!
              ? 'Você venceu!'
              : 'Você perdeu! '
                  '${state.actualWords.length == 1 ? 'A palavra era' : ''
                      'As palavras eram'}: '
                  '${state.actualWords.join(', ')}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
        ),
      ],
    );
  }
}

class _GameView extends StatelessWidget {
  const _GameView();

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GameScreenState>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < state.wordCount; ++i)
          Padding(
            padding: EdgeInsets.only(
              left: i == 0 ? _paddingWords / 2 : 0,
              right: _paddingWords / 2,
            ),
            child: SizedBox(
              width: -_paddingWords +
                  (_letterBoxDimension + _paddingWords) * state.wordLength,
              child: _GameWordView(i),
            ),
          ),
      ],
    );
  }
}

class _GameWordView extends StatelessWidget {
  const _GameWordView(this.wordIndex);

  final int wordIndex;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GameScreenState>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < state.maxAttempts; ++i)
          Padding(
            padding: EdgeInsets.only(
              top: i == 0 ? _paddingAttempts / 2 : 0,
              bottom: _paddingAttempts / 2,
            ),
            child: SizedBox(
              height: _letterBoxDimension,
              child: _GameWordAttemptView(wordIndex, i),
            ),
          ),
      ],
    );
  }
}

class _GameWordAttemptView extends StatelessWidget {
  const _GameWordAttemptView(
    this.wordIndex,
    this.attemptIndex,
  );

  final int wordIndex;
  final int attemptIndex;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GameScreenState>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < state.wordLength; ++i)
          Padding(
            padding: EdgeInsets.only(
              left: i == 0 ? _paddingAttempts / 2 : 0,
              right: _paddingAttempts / 2,
            ),
            child: _LetterBox(
              char: state.getChar(wordIndex, i, attemptIndex),
              attemptIndex: attemptIndex,
              isFocused: i == state.focusedIdx,
              correctGuessIdx: state.wordCorrectIndex(wordIndex),
              letterState: state.getLetterState(
                wordIndex: wordIndex,
                attemptIndex: attemptIndex,
                letterIndex: i,
              ),
            ),
          ),
      ],
    );
  }
}

class _LetterBox extends StatelessWidget {
  const _LetterBox({
    required this.char,
    required this.isFocused,
    required this.attemptIndex,
    required this.correctGuessIdx,
    required this.letterState,
  });

  final String? char;
  final bool isFocused;
  final int attemptIndex;
  final int correctGuessIdx;
  final GameLetterState? letterState;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GameScreenState>(context);
    final isCurrentAttempt = attemptIndex == state.currentAttemptIdx;

    final Color? color;
    if (correctGuessIdx != -1 && attemptIndex > correctGuessIdx) {
      color = _letterStateToColor(null);
    } else if (isCurrentAttempt) {
      color = null;
    } else {
      color = _letterStateToColor(letterState);
    }

    return SizedBox.square(
      dimension: _letterBoxDimension,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: (!isCurrentAttempt || correctGuessIdx != -1)
              ? const Border.fromBorderSide(BorderSide.none)
              : Border.all(
                  color: Colors.brown.shade400,
                  width: 6,
                  strokeAlign: -1.0,
                ),
          color: color,
        ),
        child: Stack(
          children: [
            if (isCurrentAttempt && isFocused && (correctGuessIdx == -1))
              Positioned(
                bottom: 5,
                left: 0,
                right: 0,
                height: 6,
                child: Container(
                  color: Colors.brown.shade400,
                ),
              ),
            Positioned.fill(
              child: Center(
                child: Text(
                  char?.toUpperCase() ?? ' ',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _letterStateToColor(GameLetterState? state) {
  return switch (state) {
    null => const Color.fromRGBO(110, 104, 105, 1.0),
    GameLetterState.correct => Colors.green.shade600,
    GameLetterState.wrongPosition => Colors.orange.shade300,
    GameLetterState.wrong => const Color.fromRGBO(49, 42, 44, 1.0),
  };
}
