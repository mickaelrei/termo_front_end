import 'package:flutter/material.dart';

/// Widget for empty screen
class EmptyScreen extends StatelessWidget {
  /// Constructor default
  const EmptyScreen({
    this.message,
    super.key,
  });

  /// Optional message to show in the empty screen
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          message ?? 'Erro inesperado',
        ),
      ),
    );
  }
}
