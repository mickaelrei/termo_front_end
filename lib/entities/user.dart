import '../modules/status_codes/user.dart';
import 'game.dart';

/// Credentials to be sent to the server for a register/login attempt
class UserCredentials {
  /// Standard constructor
  UserCredentials({
    required this.name,
    required this.password,
  });

  /// User name
  final String name;

  /// User password
  final String password;

  /// Convert this entity into a map for JSON uses
  Map<String, dynamic> toJSON() {
    return {
      'name': name,
      'password': password,
    };
  }
}

/// Holds data about a user
class UserData {
  /// Standard constructor
  UserData({
    required this.id,
    required this.name,
    required this.score,
    required this.activeGame,
  });

  /// User server identifier
  final int id;

  /// User name
  final String name;

  /// How many games the user has won
  final int score;

  /// User's active game, or null if none
  final ActiveGameData? activeGame;

  /// Create an entity from a JSON
  factory UserData.fromJSON(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      name: json['name'],
      score: json['score'],
      activeGame: json['active_game'] != null
          ? ActiveGameData.fromJSON(json['active_game'])
          : null,
    );
  }
}

/// Response from user register attempt
class UserRegisterResponse {
  /// Standard constructor
  UserRegisterResponse({
    required this.status,
    required this.token,
  });

  /// Constructor for failed register attempt
  UserRegisterResponse.fail()
      : status = UserRegisterStatus.serverError,
        token = null;

  /// Create an entity from a JSON
  factory UserRegisterResponse.fromJSON(Map<String, dynamic> json) {
    return UserRegisterResponse(
      status: UserRegisterStatus.values[json['status']],
      token: json['token'],
    );
  }

  /// Register status
  final UserRegisterStatus status;

  /// User auth token, or null if failed
  final String? token;
}

/// Response from user login attempt
class UserLoginResponse {
  /// Standard constructor
  UserLoginResponse({
    required this.status,
    required this.token,
  });

  /// Constructor for failed login attempt
  UserLoginResponse.fail()
      : status = UserLoginStatus.serverError,
        token = null;

  /// Create an entity from a JSON
  factory UserLoginResponse.fromJSON(Map<String, dynamic> json) {
    return UserLoginResponse(
      status: UserLoginStatus.values[json['status']],
      token: json['token'],
    );
  }

  /// Login status
  final UserLoginStatus status;

  /// User auth token, or null if failed
  final String? token;
}
