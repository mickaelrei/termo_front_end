import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

const _animationDuration = Duration(milliseconds: 250);

/// Builder for info bar popup
typedef InfoBarPopupBuilder = Widget Function(
  BuildContext context,
  VoidCallback close,
);

/// Enum for severity level of info bars
enum InfoBarSeverity {
  /// Error severity
  error,

  /// Warning severity
  warning,

  /// Success severity
  success;

  /// Convert to color
  Color getColor(BuildContext context) {
    return switch (this) {
      error => Colors.red.shade400,
      warning => Colors.orange.shade300,
      success => Colors.green.shade400,
    };
  }

  ///Method to get the severity label
  String getLabel() {
    return switch (this) {
      error => 'Erro',
      warning => 'Aviso',
      success => 'Sucesso',
    };
  }

  ///Method to get the severity label
  IconData getIcon() {
    return switch (this) {
      error => Icons.error_outline_outlined,
      warning => Icons.warning_amber_rounded,
      success => Icons.check,
    };
  }
}

/// Show info bar with widget builder
Future<void> showInfoBar(
  BuildContext context, {
  required InfoBarPopupBuilder builder,
  Alignment alignment = Alignment.bottomCenter,
  Duration duration = const Duration(seconds: 3),
  String? message,
}) async {
  assert(debugCheckHasOverlay(context));

  var isFading = true;
  var alreadyInitialized = false;

  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (context) {
      return SafeArea(
        child: Align(
          alignment: alignment,
          child: StatefulBuilder(
            builder: (context, setState) {
              void close() async {
                if (entry.mounted) setState(() => isFading = true);

                await Future.delayed(_animationDuration);

                if (entry.mounted) entry.remove();
              }

              Future.delayed(_animationDuration).then((_) {
                if (entry.mounted && !alreadyInitialized) {
                  setState(() => isFading = false);
                }

                alreadyInitialized = true;
              }).then((_) => Future.delayed(duration).then((_) => close()));

              return AnimatedSwitcher(
                duration: _animationDuration,
                child: isFading
                    ? const SizedBox.shrink()
                    : PhysicalModel(
                        color: Colors.transparent,
                        elevation: 0.0,
                        child: builder(context, close),
                      ),
              );
            },
          ),
        ),
      );
    },
  );

  Overlay.of(context).insert(entry);
}

/// Show default panel info bar with title and content texts
Future<void> showDefaultInfoBar(
  BuildContext context, {
  String? content,
  String? title,
  required InfoBarSeverity severity,
  int? maxLines,
  Duration duration = const Duration(seconds: 3),
}) async {
  await showInfoBar(
    context,
    duration: duration,
    alignment: Alignment.bottomRight,
    builder: (context, close) {
      final color = severity.getColor(context);

      return Container(
        height: 150,
        width: 450,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16.0),
          ),
          border: Border.all(
            width: 2.5,
            color: color,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              severity.getIcon(),
              color: color,
              size: 35,
            ),
            Text(
              title ?? severity.getLabel(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: color,
                  ),
            ),
            if (content != null && content != '')
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 4.0,
                  right: 8.0,
                  left: 8.0,
                ),
                child: Text(
                  content,
                  maxLines: maxLines ?? 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              )
          ],
        ),
      )
          .animate(
            autoPlay: true,
            onComplete: (controller) async {
              final seconds = duration.inSeconds;

              final newDuration = Duration(
                seconds: seconds - 1,
              );

              await Future.delayed(
                newDuration,
              );
              await controller.animateTo(0);
            },
          )
          .slide(
            duration: const Duration(
              milliseconds: 300,
            ),
            curve: Curves.easeInOut,
            begin: const Offset(0, 1),
          );
    },
  );
}
