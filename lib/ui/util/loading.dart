import 'package:flutter/material.dart';

import 'colors.dart';

/// Default dialog for loading
Future<T> showLoadingDialog<T>({
  required BuildContext context,
  required Future<T> Function() function,
  String? label,
}) async {
  late BuildContext contextDialog;

  /// ignore: unawaited_futures
  showDialog(
    useRootNavigator: true,
    barrierDismissible: false,
    context: context,
    builder: (ctx) {
      contextDialog = ctx;

      return PopScope(
        canPop: false,
        child: LoadingDialog(
          text: label ?? 'Carregando...',
        ),
      );
    },
  );

  /// Added delay to allow the animation of the bottom sheet to finish before
  /// awaiting for the future
  await Future.delayed(const Duration(milliseconds: 600));

  final item = await function();
  Navigator.of(contextDialog).pop();

  return item;
}

/// Default loading dialog
class LoadingDialog extends StatelessWidget {
  /// Standard constructor
  const LoadingDialog({
    required this.text,
    super.key,
  });

  /// Text to display
  final String text;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: SizedBox.square(
              dimension: 40,
              child: CircularProgressIndicator(
                strokeWidth: 1.0,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w200,
              ),
            ),
          )
        ],
      ),
      backgroundColor: AppColors.of(context).background,
      contentPadding: const EdgeInsets.all(32.0),
    );
  }
}
