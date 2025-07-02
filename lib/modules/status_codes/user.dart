/// Status for a user register attempt
enum UserRegisterStatus {
  /// Register success
  success,

  /// Invalid name (too short, too long etc.)
  invalidName,

  /// Invalid password (too short, too long, missing digit etc.)
  invalidPassword,

  /// Another use with the same name is already registered
  alreadyRegistered,

  /// Internal server error
  serverError;

  /// Convert the enum into a displayable string
  String translate() {
    switch (this) {
      case success:
        return 'Registrado com sucesso';
      case invalidName:
        return 'Nome inválido';
      case invalidPassword:
        return 'Senha inválida';
      case alreadyRegistered:
        return 'Esse nome já está em uso';
      case serverError:
        return 'Erro interno. Tente novamente mais tarde';
    }
  }

  /// Whether this status signals success
  bool get isSuccess => this == success;
}

/// Status for a user login attempt
enum UserLoginStatus {
  /// Login success
  success,

  /// User not found
  notFound,

  /// Wrong password
  wrongPassword,

  /// Internal server error
  serverError;

  /// Convert the enum into a displayable string
  String translate() {
    switch (this) {
      case success:
        return 'Login com sucesso';
      case notFound:
        return 'Nenhum usuário com esse nome foi encontrado';
      case wrongPassword:
        return 'Senha incorreta';
      case serverError:
        return 'Erro interno. Tente novamente mais tarde';
    }
  }

  /// Whether this status signals success
  bool get isSuccess => this == success;
}

/// Status for a name update attempt
enum UserUpdateNameStatus {
  /// Name update success
  success,

  /// Invalid new name
  invalid,

  /// Internal server error
  serverError;

  /// Convert the enum into a displayable string
  String translate() {
    switch (this) {
      case success:
        return 'Nome atualizado com sucesso';
      case invalid:
        return 'Nome inválido';
      case serverError:
        return 'Erro interno. Tente novamente mais tarde';
    }
  }

  /// Whether this status signals success
  bool get isSuccess => this == success;
}

/// Status for a password update attempt
enum UserUpdatePasswordStatus {
  /// Login success
  success,

  /// Wrong current password
  wrongCurrent,

  /// Invalid new password
  invalid,

  /// Internal server error
  serverError;

  /// Convert the enum into a displayable string
  String translate() {
    switch (this) {
      case success:
        return 'Senha atualizada com sucesso';
      case wrongCurrent:
        return 'Senha atual incorreta';
      case invalid:
        return 'Senha inválida';
      case serverError:
        return 'Erro interno. Tente novamente mais tarde';
    }
  }

  /// Whether this status signals success
  bool get isSuccess => this == success;
}
