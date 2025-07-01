import 'package:flutter/material.dart';

class _CloseButton extends StatelessWidget {
  const _CloseButton();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () => Navigator.of(context).pop(),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 4,
            top: 4,
            bottom: 4,
            right: 8,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.close,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 4),
              Text(
                'Fechar',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shows a dialog with default styles
Future<T?> showDefaultDialog<T>(
  BuildContext context, {
  required Widget content,
  Widget? title,
  BoxConstraints? constraints,
  bool showCloseButton = true,
}) async {
  return showDialog<T>(
    context: context,
    builder: (context) {
      return Align(
        alignment: Alignment.center,
        child: Container(
          constraints: constraints,
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showCloseButton || title != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (title != null)
                            DefaultTextStyle.merge(
                              child: title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          if (showCloseButton) const _CloseButton(),
                        ],
                      ),
                    ),
                  Flexible(child: content),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
