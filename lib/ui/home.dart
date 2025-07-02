import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/home.dart';

/// Widget for home screen
class HomeScreen extends StatelessWidget {
  /// Standard constructor
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeState(),
      child: Scaffold(
        backgroundColor: Colors.brown.shade300,
        body: Center(
          child: Material(
            color: Colors.brown.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                width: 10,
                strokeAlign: 1.0,
                color: Colors.brown.shade400,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(24),
              child: _Body(),
            ),
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Letras por palavra'),
            SizedBox(width: 12),
            Text('Número de palavras'),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Começar novo jogo',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
