import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import 'util/empty_screen.dart';

/// Navigator for panel paths
class NavigatorLocations extends BeamLocation<BeamState> {
  /// Standard constructor
  NavigatorLocations(super.routeInformation, this.initialRoute);

  /// Initial route
  final String initialRoute;

  @override
  List<String> get pathPatterns => ['/home'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        key: ValueKey('home-${state.uri}'),
        title: 'Home',
        child: NavigatorPage(
          initialRoute: initialRoute,
        ),
      ),
    ];
  }
}

/// Navigation bar of main application
class NavigatorPage extends StatefulWidget {
  /// Standard constructor
  const NavigatorPage({
    super.key,
    required this.initialRoute,
  });

  ///Keeps the right initial route
  final String initialRoute;

  @override
  State<StatefulWidget> createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  late final _routerDelegate = BeamerDelegate(
    notFoundPage: const BeamPage(
      keepQueryOnPop: true,
      key: ValueKey('error'),
      title: 'Termo',
      child: EmptyScreen(),
    ),
    initialPath: widget.initialRoute,
    guards: [
      BeamGuard(
        pathPatterns: ['/login'],
        guardNonMatching: true,
        beamToNamed: (origin, target) => '/login',
        check: (context, location) {
          return true;

          // TODO: Check if user is logged in
          // final appState = Provider.of<ApplicationState>(
          //   context,
          //   listen: false,
          // );

          // return appState.loggedIn;
        },
      ),
    ],
    locationBuilder: BeamerLocationBuilder(
      beamLocations: <BeamLocation<RouteInformationSerializable>>[],
    ).call,
  );

  final _beamerKey = GlobalKey<BeamerState>();

  void _setStateListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _beamerKey.currentState?.routerDelegate.addListener(_setStateListener);
    });
    super.initState();
  }

  @override
  void dispose() {
    _beamerKey.currentState?.routerDelegate.removeListener(_setStateListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Beamer(
      key: _beamerKey,
      routerDelegate: _routerDelegate,
    );
  }
}
