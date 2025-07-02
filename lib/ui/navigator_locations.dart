import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/application.dart';
import 'routes.dart';
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
          final appState = Provider.of<ApplicationState>(
            context,
            listen: false,
          );

          return appState.loggedIn;
        },
      ),
    ],
    locationBuilder: BeamerLocationBuilder(
      beamLocations: <BeamLocation<RouteInformationSerializable>>[
        HomeLocation(),
        GameLocation(),
      ],
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
    return Column(
      children: [
        const _TopBar(),
        Expanded(
          child: Beamer(
            key: _beamerKey,
            routerDelegate: _routerDelegate,
          ),
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context);

    return Material(
      color: Colors.brown.shade600,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            const SizedBox(width: 8),
            IconButton(
              splashRadius: 20,
              onPressed: () {
                // TODO: Go to settings screen
              },
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                appState.user?.name ?? '-',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
