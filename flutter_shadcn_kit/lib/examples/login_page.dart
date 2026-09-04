// ignore_for_file: duplicate_import, unnecessary_import
// Example: Login / Sign-in Page
// Uses: Button, Card, TextField, Text extensions, Divider

import 'package:flutter/material.dart' hide Card, TextField, Divider;
import '../registry/components/control/button/button.dart';
import '../registry/components/layout/card/card.dart';
import '../registry/components/display/text/text.dart';
import '../registry/components/form/text_field/text_field.dart';
import '../registry/components/display/divider/divider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Card(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Sign in').semiBold(),
                    const SizedBox(height: 4),
                    const Text('Enter your email and password to continue.').muted().small(),
                    const SizedBox(height: 24),

                    const Text('Email').semiBold().small(),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _emailController,
                      placeholder: const Text('you@example.com'),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Password').semiBold().small(),
                        LinkButton(
                          onPressed: () {},
                          child: const Text('Forgot password?').small(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _passwordController,
                      placeholder: const Text('••••••••'),
                      obscureText: true,
                      features: [InputFeature.passwordToggle()],
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        onPressed: _loading ? null : _submit,
                        child: Text(_loading ? 'Signing in...' : 'Sign in'),
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Divider(),
                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: OutlineButton(
                        onPressed: () {},
                        child: const Text('Continue with Google'),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("Don't have an account?").muted().small(),
                          const SizedBox(width: 4),
                          LinkButton(
                            onPressed: () {},
                            child: const Text('Sign up').small(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
