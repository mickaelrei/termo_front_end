import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/game.dart';

/// Widget for game screen
class GameScreen extends StatelessWidget {
  /// Standard constructor
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameState(),
      child: Consumer<GameState>(
        builder: (context, state, child) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Cached server time: ${_formatTime(state.serverTime)}'),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => state.updateServerTime(),
                    child: const Text('Update server time'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

String _formatTime(int t) {
  final seconds = (t % 60).toString();

  final minutes = (t ~/ 60 % 60).toString();
  t ~/= 60;

  final hours = (t ~/ 60 % 24).toString();
  t ~/= 60;

  final days = (t ~/ 24 % 365.25).floor().toString();
  t ~/= 24;

  final years = (t ~/ 365).toString();

  return '${hours.padLeft(2, '0')}:'
      '${minutes.padLeft(2, '0')}:'
      '${seconds.padLeft(2, '0')}, '
      '$days dias, $years anos';
}
