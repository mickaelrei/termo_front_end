import 'package:flutter/material.dart';

import '../entities/user.dart';
import 'global.dart';

/// State for login screen
class LoginState extends ChangeNotifier {
  /// Standard constructor
  LoginState() {
    _init();
  }

  /// Form key
  final formKey = GlobalKey<FormState>();

  /// Controller for name field
  final nameController = TextEditingController();

  /// Controller for password field
  final passwordController = TextEditingController();

  /// Controller for confirm password field
  final confirmPasswordController = TextEditingController();

  /// Focus node for name field
  final nameFocus = FocusNode();

  /// Focus node for password field
  final passwordFocus = FocusNode();

  /// Focus node for confirm password field
  final confirmPasswordFocus = FocusNode();

  var _isLogin = true;

  /// Whether state is in login mode
  bool get isLogin => _isLogin;

  @override
  void dispose() {
    passwordController.removeListener(notifyListeners);

    nameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameFocus.dispose();
    passwordFocus.dispose();
    confirmPasswordFocus.dispose();
    super.dispose();
  }

  void _init() {
    passwordController.addListener(notifyListeners);
  }

  /// Attempts to register with current input
  Future<UserRegisterResponse> register() async {
    assert(!isLogin, 'register() can only be called if in register mode');

    final credentials = UserCredentials(
      name: nameController.text,
      password: passwordController.text,
    );

    return applicationHandler.requestRegister(credentials);
  }

  /// Attempts to log in with current input
  Future<UserLoginResponse> login() async {
    assert(isLogin, 'login() can only be called if in login mode');

    final credentials = UserCredentials(
      name: nameController.text,
      password: passwordController.text,
    );

    return applicationHandler.requestLogin(credentials);
  }

  /// Toggles current login/register mode
  void toggleMode() {
    _isLogin = !_isLogin;
    notifyListeners();
  }
}
