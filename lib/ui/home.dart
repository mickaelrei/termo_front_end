import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/application.dart';
import '../state/home.dart';
import 'util/info_bar.dart';
import 'util/loading.dart';

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
              child: SizedBox(
                width: 460,
                child: _Body(),
              ),
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
    final state = Provider.of<HomeState>(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Letras por palavra: ${state.wordLength}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Slider(
                    value: state.wordLength.toDouble(),
                    onChanged: (value) => state.wordLength = value.toInt(),
                    min: state.minWordLength.toDouble(),
                    max: state.maxWordLength.toDouble(),
                    divisions: state.maxWordLength - state.minWordLength,
                    label: state.wordLength.toString(),
                    activeColor: Colors.brown.shade400,
                    inactiveColor: Colors.brown.shade200,
                    thumbColor: Colors.brown.shade600,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            SizedBox(
              height: 80,
              child: VerticalDivider(
                thickness: 2,
                width: 16,
                color: Colors.brown.shade700,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Número de palavras: ${state.wordCount}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Slider(
                    value: state.wordCount.toDouble(),
                    onChanged: (value) => state.wordCount = value.toInt(),
                    min: state.minWordCount.toDouble(),
                    max: state.maxWordCount.toDouble(),
                    divisions: state.maxWordCount - state.minWordCount,
                    label: state.wordCount.toString(),
                    activeColor: Colors.brown.shade400,
                    inactiveColor: Colors.brown.shade200,
                    thumbColor: Colors.brown.shade600,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const _StartButton(),
      ],
    );
  }
}

class _StartButton extends StatelessWidget {
  const _StartButton();

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<HomeState>(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.brown.shade600,
          width: 6,
          strokeAlign: 1.0,
        ),
      ),
      child: InkWell(
        onTap: () async {
          final response = await showLoadingDialog(
            context: context,
            function: state.startGame,
          );

          if (!response.status.isSuccess) {
            await showDefaultInfoBar(
              context,
              severity: InfoBarSeverity.error,
              title: 'Erro',
              content: response.status.translate(),
            );
            return;
          }

          // Successful game start; go to game screen
          await Provider.of<ApplicationState>(context, listen: false)
              .onGameStart(
                  // ActiveGameData(
                  //   wordLength: state.wordLength,
                  //   wordCount: state.wordCount,
                  //   maxAttempts: response.maxAttempts,
                  //   attempts: [],
                  //   gameStates: [],
                  // ),
                  );
          Beamer.of(context).beamToNamed('/game');
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Começar jogo',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
          ),
        ),
      ),
    );
  }
}
