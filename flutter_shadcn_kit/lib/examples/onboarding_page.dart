// ignore_for_file: duplicate_import, unnecessary_import
// Example: Onboarding / Multi-step Wizard Page
// Uses: Card, Button, TextField, Text extensions, AnimatedSwitcher

import 'package:flutter/material.dart' hide Card, TextField;
import '../registry/components/control/button/button.dart';
import '../registry/components/layout/card/card.dart';
import '../registry/components/display/text/text.dart';
import '../registry/components/form/text_field/text_field.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _step = 0;
  static const _steps = ['Welcome', 'Profile', 'Preferences', 'Done'];
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  void _next() {
    if (_step < _steps.length - 1) setState(() => _step++);
  }

  void _back() {
    if (_step > 0) setState(() => _step--);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                children: [
                  // Step progress bar
                  Row(
                    children: List.generate(_steps.length, (i) {
                      final isActive = i <= _step;
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: i == 0 ? 0 : 4),
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? colorScheme.primary
                                  : colorScheme.outlineVariant,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Step ${_step + 1} of ${_steps.length}').muted().small(),
                      Text(_steps[_step]).muted().small(),
                    ],
                  ),
                  const SizedBox(height: 32),

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: KeyedSubtree(
                      key: ValueKey(_step),
                      child: _buildStep(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep() {
    return switch (_step) {
      0 => Card(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('👋', style: TextStyle(fontSize: 36)),
              const SizedBox(height: 16),
              const Text('Welcome to the app').semiBold(),
              const SizedBox(height: 8),
              const Text(
                "We're excited to have you. Let's get you set up in just a few steps.",
              ).muted().small(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  onPressed: _next,
                  child: const Text('Get started'),
                ),
              ),
            ],
          ),
        ),

      1 => Card(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Your profile').semiBold(),
              const SizedBox(height: 4),
              const Text('Tell us a little about yourself.').muted().small(),
              const SizedBox(height: 20),

              const Text('Full name').semiBold().small(),
              const SizedBox(height: 6),
              TextField(
                controller: _nameController,
                placeholder: const Text('Jane Doe'),
              ),
              const SizedBox(height: 16),

              const Text('Job role').semiBold().small(),
              const SizedBox(height: 6),
              TextField(
                controller: _roleController,
                placeholder: const Text('e.g. Product Designer'),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  OutlineButton(onPressed: _back, child: const Text('Back')),
                  const Spacer(),
                  PrimaryButton(onPressed: _next, child: const Text('Continue')),
                ],
              ),
            ],
          ),
        ),

      2 => Card(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Preferences').semiBold(),
              const SizedBox(height: 4),
              const Text('Customize your experience.').muted().small(),
              const SizedBox(height: 20),
              const Text(
                "We'll use these to personalize your dashboard and recommendations.",
              ).muted().small(),
              const SizedBox(height: 24),
              Row(
                children: [
                  OutlineButton(onPressed: _back, child: const Text('Back')),
                  const Spacer(),
                  PrimaryButton(onPressed: _next, child: const Text('Continue')),
                ],
              ),
            ],
          ),
        ),

      _ => Card(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🎉', style: TextStyle(fontSize: 36)),
              const SizedBox(height: 16),
              const Text("You're all set!").semiBold(),
              const SizedBox(height: 8),
              const Text('Your account is ready. Start exploring the app.').muted().small(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  onPressed: () {},
                  child: const Text('Go to dashboard'),
                ),
              ),
            ],
          ),
        ),
    };
  }
}
