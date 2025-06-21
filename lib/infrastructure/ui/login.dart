import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

/// Widget for login screen
class LoginScreen extends StatelessWidget {
  /// Standard constructor
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            Beamer.of(context).beamToNamed('/game');
          },
          child: const Text('Go to game'),
        ),
      ),
    );
  }
}
