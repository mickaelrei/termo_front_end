import 'package:shared_preferences/shared_preferences.dart';

import '../modules/handler/application.dart';
import '../modules/termo_web_service.dart';
import '../modules/web_service/auth.dart';

/// Global instance of application handler
late final ApplicationHandler applicationHandler;

/// Initialize global use cases
Future<void> initializeUseCases(
  SharedPreferences sharedPrefs,
  TermoWS termoWS,
  ApplicationWS applicationWS,
) async {
  applicationHandler = ApplicationHandler(sharedPrefs, applicationWS);
}
