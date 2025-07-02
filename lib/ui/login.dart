import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../state/application.dart';
import '../state/login.dart';
import 'util/info_bar.dart';
import 'util/loading.dart';

final _lowerRegex = RegExp(r'[a-z]');
final _upperRegex = RegExp(r'[A-Z]');
final _digitRegex = RegExp(r'[0-9]');
final _specialRegex = RegExp(r'[!@#$%^&*(),.?:{}|<>_\-\\/\[\];`~+=]');
final _spaceRegex = RegExp(r'[\s\n\t ]');

/// Widget for login screen
class LoginScreen extends StatelessWidget {
  /// Standard constructor
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginState(),
      child: Scaffold(
        backgroundColor: Colors.brown.shade400,
        body: const _Body(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<LoginState>(context);

    final name = state.nameController.text;
    final password = state.passwordController.text;

    final validNameLength = name.length >= 3 && name.length <= 32;
    final validPassLength = password.length >= 8 && password.length <= 72;
    final nameNoSpaces = !_spaceRegex.hasMatch(name);
    final passLower = _lowerRegex.hasMatch(password);
    final passUpper = _upperRegex.hasMatch(password);
    final passDigit = _digitRegex.hasMatch(password);
    final passSpecial = _specialRegex.hasMatch(password);

    final bool canSubmit;
    if (state.isLogin) {
      canSubmit = validNameLength && validPassLength;
    } else {
      canSubmit = validNameLength &&
          validPassLength &&
          nameNoSpaces &&
          passLower &&
          passUpper &&
          passDigit &&
          passSpecial;
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Form(
          key: state.formKey,
          child: Material(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: Colors.brown.shade800,
                width: 10,
                strokeAlign: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      state.isLogin ? 'Faça login' : 'Registre-se',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const _DefaultTextHeader('Nome'),
                  const _NameField(),
                  if (!state.isLogin) ...[
                    const SizedBox(height: 6),
                    _ValidationCheck(
                      label: 'Entre 3 e 32 caracteres',
                      isChecked: validNameLength,
                    ),
                    _ValidationCheck(
                      label: 'Sem espaços em branco',
                      isChecked: nameNoSpaces,
                    ),
                  ],
                  const SizedBox(height: 18),
                  const _DefaultTextHeader('Senha'),
                  const _PasswordField(),
                  if (!state.isLogin) ...[
                    const SizedBox(height: 6),
                    _ValidationCheck(
                      label: 'Entre 8 e 72 caracteres',
                      isChecked: validPassLength,
                    ),
                    _ValidationCheck(
                      label: 'Uma letra minúscula',
                      isChecked: passLower,
                    ),
                    _ValidationCheck(
                      label: 'Uma letra maiúscula',
                      isChecked: passUpper,
                    ),
                    _ValidationCheck(
                      label: 'Um dígito',
                      isChecked: passDigit,
                    ),
                    _ValidationCheck(
                      label: 'Um caractere especial',
                      isChecked: passSpecial,
                    ),
                    const SizedBox(height: 12),
                    const _DefaultTextHeader('Confirmar senha'),
                    const _ConfirmPasswordField(),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Expanded(
                        child: _ToggleModeButton(),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SubmitButton(canSubmit: canSubmit),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField();

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<LoginState>(context);

    return TextFormField(
      controller: state.nameController,
      focusNode: state.nameFocus,
      onFieldSubmitted: (_) => state.passwordFocus.requestFocus(),
      decoration: const InputDecoration(
        hintText: 'Nome',
      ),
      autofillHints: const [AutofillHints.name],
      validator: (value) {
        if (value == null || value.length < 3 || value.length > 32) {
          return 'Necessário entre 3 e 32 caracteres';
        }

        if (state.isLogin) return null;

        if (_spaceRegex.hasMatch(value)) {
          return 'Não é permitido espaços em branco no nome';
        }

        return null;
      },
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField();

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<LoginState>(context);

    return TextFormField(
      controller: state.passwordController,
      focusNode: state.passwordFocus,
      onFieldSubmitted: (_) {
        if (!state.isLogin) {
          state.confirmPasswordFocus.requestFocus();
          return;
        }

        showLoadingDialog(
          context: context,
          function: () => _onSubmit(context, state),
        );
      },
      autofillHints: const [AutofillHints.password],
      obscureText: !state.showPassword,
      decoration: InputDecoration(
        hintText: 'Senha',
        suffixIcon: IconButton(
          splashRadius: 20,
          onPressed: () => state.showPassword = !state.showPassword,
          icon: Icon(
            state.showPassword ? Icons.visibility : Icons.visibility_off,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Senha não pode ser vazia';
        }

        if (state.isLogin) return null;

        if (value.length > 72) {
          return 'A senha não pode ter mais de 72 caracteres';
        }

        return null;
      },
    );
  }
}

class _ConfirmPasswordField extends StatelessWidget {
  const _ConfirmPasswordField();

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<LoginState>(context);

    return TextFormField(
      controller: state.confirmPasswordController,
      focusNode: state.confirmPasswordFocus,
      onFieldSubmitted: (_) => showLoadingDialog(
        context: context,
        function: () => _onSubmit(context, state),
      ),
      obscureText: !state.showConfirmPassword,
      decoration: InputDecoration(
        hintText: 'Confirmar senha',
        suffixIcon: IconButton(
          splashRadius: 20,
          onPressed: () =>
              state.showConfirmPassword = !state.showConfirmPassword,
          icon: Icon(
            state.showConfirmPassword ? Icons.visibility : Icons.visibility_off,
          ),
        ),
      ),
      validator: (value) {
        if (value != state.passwordController.text) {
          return 'Senhas não conferem';
        }

        return null;
      },
    );
  }
}

class _ValidationCheck extends StatelessWidget {
  const _ValidationCheck({
    required this.label,
    required this.isChecked,
  });

  final String label;
  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isChecked ? Icons.check : Icons.close,
          color: isChecked ? Colors.green.shade600 : Colors.red.shade400,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isChecked ? Colors.green.shade600 : Colors.red.shade400,
              ),
        ),
      ],
    );
  }
}

class _DefaultTextHeader extends StatelessWidget {
  const _DefaultTextHeader(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _ToggleModeButton extends StatelessWidget {
  const _ToggleModeButton();

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<LoginState>(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          width: 1.0,
          color: Colors.grey.shade800,
        ),
      ),
      child: InkWell(
        onTap: state.toggleMode,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Center(
            child: Text(
              state.isLogin ? 'Ir para registrar' : 'Ir para login',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 16,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.canSubmit});

  final bool canSubmit;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<LoginState>(context);

    return Material(
      borderRadius: BorderRadius.circular(4),
      color: canSubmit ? Colors.blue.shade400 : Colors.grey.shade500,
      child: InkWell(
        onTap: !canSubmit
            ? null
            : () => showLoadingDialog(
                  context: context,
                  function: () => _onSubmit(context, state),
                ),
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Center(
            child: Text(
              state.isLogin ? 'Entrar' : 'Registrar',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _onSubmit(BuildContext context, LoginState state) async {
  if (!state.formKey.currentState!.validate()) return;

  // Check if user is logging in or registering
  final bool success;
  final String message;
  if (state.isLogin) {
    final response = await state.login();
    success = response.status.isSuccess;
    message = response.status.translate();
  } else {
    final response = await state.register();
    success = response.status.isSuccess;
    message = response.status.translate();
  }

  // Show info bar with error if login failed
  if (!success) {
    await showDefaultInfoBar(
      context,
      severity: InfoBarSeverity.error,
      title: 'Erro',
      content: message,
    );
    return;
  }

  // Tell application state we logged in
  final appState = Provider.of<ApplicationState>(
    context,
    listen: false,
  );
  unawaited(appState.onLoginSuccess());

  // Ask to save credentials on browser
  TextInput.finishAutofillContext();

  Beamer.of(context).beamToNamed('/home');
}
