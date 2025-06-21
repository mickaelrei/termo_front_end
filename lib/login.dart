import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _FormHeader('Nome'),
              SizedBox(height: 2),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Nome',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 18),
              _FormHeader('Senha'),
              SizedBox(height: 2),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Senha',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _FormHeader extends StatelessWidget {
  const _FormHeader(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(label);
  }
}
