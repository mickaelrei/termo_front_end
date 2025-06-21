import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import 'game.dart';
import 'login.dart';
import 'util/empty_screen.dart';

/// Error page location
class ErrorLocation extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => ['/error'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      const BeamPage(
        keepQueryOnPop: true,
        key: ValueKey('error'),
        title: 'Termo',
        child: EmptyScreen(),
      ),
    ];
  }
}

/// Login page location
class LoginLocation extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => ['/login'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      const BeamPage(
        key: ValueKey('login'),
        title: 'Termo',
        child: LoginScreen(),
      ),
    ];
  }
}

/// Login page location
class GameLocation extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => ['/game'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      const BeamPage(
        key: ValueKey('game'),
        title: 'Termo',
        child: GameScreen(),
      ),
    ];
  }
}
