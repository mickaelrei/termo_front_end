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
                  Text('Cached server time: ${state.serverTime}'),
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
