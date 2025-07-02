import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'modules/base_web_service.dart';
import 'modules/web_service/auth.dart';
import 'modules/web_service/game.dart';
import 'modules/web_service/user.dart';
import 'state/application.dart';
import 'state/global.dart';
import 'theme.dart';
import 'ui/navigator_locations.dart';
import 'ui/routes.dart';
import 'ui/util/empty_screen.dart';

void main() async {
  final sharedPrefs = await SharedPreferences.getInstance();

  final baseWS = BaseWS(sharedPrefs);
  final applicationWS = ApplicationWS(sharedPrefs);
  final userWS = UserWS(sharedPrefs);
  final gameWS = GameWS(sharedPrefs);

  await initializeUseCases(
    sharedPrefs,
    baseWS,
    applicationWS,
    userWS,
    gameWS,
  );

  usePathUrlStrategy();

  runApp(MyApp(sharedPreferences: sharedPrefs));
}

/// Main app widget
class MyApp extends StatelessWidget {
  /// Standard constructor
  MyApp({
    required this.sharedPreferences,
    super.key,
  });

  /// Global shared preferences
  final SharedPreferences sharedPreferences;

  late final BeamerDelegate _routerDelegate = BeamerDelegate(
    initialPath: '/login',
    notFoundRedirect: ErrorLocation(),
    notFoundRedirectNamed: '/error',
    notFoundPage: const BeamPage(
      keepQueryOnPop: true,
      key: ValueKey('error'),
      title: 'Termo',
      child: EmptyScreen(),
    ),
    locationBuilder: (routeInformation, _) {
      if (routeInformation.uri.pathSegments.contains('login')) {
        return LoginLocation();
      }

      return NavigatorLocations(routeInformation, '/game');
    },
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: _routerDelegate,
      title: 'Termo',
      routeInformationParser: BeamerParser(),
      backButtonDispatcher: BeamerBackButtonDispatcher(
        delegate: _routerDelegate,
      ),
      theme: AppTheme.lightTheme(context),
      builder: (context, child) {
        return ChangeNotifierProvider(
          create: (context) => ApplicationState(sharedPreferences),
          child: child,
        );
      },
    );
  }
}
