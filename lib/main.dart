import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'infrastructure/ui/navigator_locations.dart';
import 'infrastructure/ui/routes.dart';
import 'infrastructure/ui/util/empty_screen.dart';
import 'theme.dart';

void main() {
  usePathUrlStrategy();

  runApp(MyApp());
}

/// Main app widget
class MyApp extends StatelessWidget {
  /// Standard constructor
  MyApp({super.key});

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
        // TODO: Add this back
        // return ChangeNotifierProvider(
        //   create: (context) => ApplicationState(context, sharedPreferences),
        //   child: child,
        // );

        return child ?? const SizedBox();
      },
    );
  }
}
