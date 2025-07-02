import '../../entities/user.dart';
import '../status_codes/user.dart';
import '../web_service/user.dart';

/// Interface for user handler
class UserHandler {
  /// Standard constructor
  UserHandler(this._userWS);

  final UserWS _userWS;

  /// Get user data
  Future<UserData?> getData() async {
    final response = await _userWS.requestData();
    if (response == null) {
      return null;
    }

    return UserData.fromJSON(response);
  }

  /// Update name
  Future<UserUpdateNameStatus> updateName(String newName) async {
    final response = await _userWS.updateName(newName);
    if (response == null) {
      return UserUpdateNameStatus.serverError;
    }

    return UserUpdateNameStatus.values[response['status']];
  }

  /// Update name
  Future<UserUpdatePasswordStatus> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await _userWS.updatePassword(currentPassword, newPassword);
    if (response == null) {
      return UserUpdatePasswordStatus.serverError;
    }

    return UserUpdatePasswordStatus.values[response['status']];
  }
}
