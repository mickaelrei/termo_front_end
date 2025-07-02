import 'package:shared_preferences/shared_preferences.dart';

import '../modules/base_web_service.dart';
import '../modules/handler/application.dart';
import '../modules/handler/game.dart';
import '../modules/handler/user.dart';
import '../modules/web_service/auth.dart';
import '../modules/web_service/game.dart';
import '../modules/web_service/user.dart';

/// Global instance of application handler
late final ApplicationHandler applicationHandler;

/// Global instance of user handler
late final UserHandler userHandler;

/// Global instance of game handler
late final GameHandler gameHandler;

/// Initialize global use cases
Future<void> initializeUseCases(
  SharedPreferences sharedPrefs,
  BaseWS baseWS,
  ApplicationWS applicationWS,
  UserWS userWS,
  GameWS gameWS,
) async {
  applicationHandler = ApplicationHandler(sharedPrefs, applicationWS);

  userHandler = UserHandler(userWS);

  gameHandler = GameHandler(gameWS);
}
