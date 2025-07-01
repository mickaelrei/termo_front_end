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
