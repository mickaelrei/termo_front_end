/// Status for a game start attempt
enum GameStartStatus {
  /// Successful attempt
  success,

  /// There is already an active game for this user
  activeGame,

  /// Invalid world length (too short or too long)
  invalidWordLength,

  /// Invalid game count (too few, too many, not enough)
  invalidCount,

  /// Internal server error
  serverError;

  /// Convert the enum into a displayable string
  String translate() {
    switch (this) {
      case success:
        return 'Jogo iniciado com sucesso';
      case GameStartStatus.activeGame:
        return 'Você já possui um jogo em aberto';
      case GameStartStatus.invalidWordLength:
        return 'Comprimento de palavra inválido';
      case GameStartStatus.invalidCount:
        return 'Número de jogos inválido';
      case serverError:
        return 'Erro interno. Tente novamente mais tarde';
    }
  }

  /// Whether this status signals success
  bool get isSuccess => this == success;
}
