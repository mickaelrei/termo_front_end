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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              message ?? 'Erro inesperado',
            ),
          ),
        ],
      ),
    );
  }
}
