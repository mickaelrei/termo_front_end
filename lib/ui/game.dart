import 'package:flutter/material.dart';

/// Widget for game screen
class GameScreen extends StatelessWidget {
  /// Standard constructor
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Game'),
      ),
    );
  }
}
