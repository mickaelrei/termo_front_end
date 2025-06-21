import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// State for game screen
class GameState extends ChangeNotifier {
  var _serverTime = 0;

  /// Cached server time
  int get serverTime => _serverTime;

  /// Update cached server time
  Future<void> updateServerTime() async {
    final time = await _getServerTime();
    _serverTime = time;
    notifyListeners();
  }

  Future<int> _getServerTime() async {
    final response = await http.get(
      Uri.parse('http://168.138.128.110'),
    );

    if (response.statusCode != 200) {
      return -1;
    }

    return int.parse(response.body);
  }
}
