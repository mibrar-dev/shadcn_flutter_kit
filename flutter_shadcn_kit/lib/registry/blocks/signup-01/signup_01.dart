// The `signup-01` block: a create-account card with a terms checkbox.
//
// The form is shrink-wrapped and scrollable, so the card never overflows on a
// 375px phone and centres itself on a desktop stage.

import 'package:flutter/widgets.dart';

import '../../components/button/button.dart';
import '../../components/card/card.dart';
import '../../components/checkbox/checkbox.dart';
import '../../components/input/input.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';

/// A create-account card: name, email, password and a terms checkbox.
class Signup01 extends StatelessWidget {
  /// Creates the block.
  const Signup01({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(spacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                padding: EdgeInsets.all(spacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text('Create an account', style: theme.typography.h2),
                    Gap(spacing.sm),
                    Text(
                      'Enter your email below to create your account.',
                      style: theme.typography.textMuted.copyWith(
                        color: theme.colors.mutedForeground,
                      ),
                    ),
                    Gap(spacing.xl),
                    _Signup01Field(label: 'Name', hint: 'Pavel Nikolov'),
                    Gap(spacing.md),
                    _Signup01Field(label: 'Email', hint: 'name@example.com'),
                    Gap(spacing.md),
                    _Signup01Field(
                      label: 'Password',
                      hint: 'Password',
                      obscure: true,
                    ),
                    Gap(spacing.lg),
                    const _Signup01Terms(),
                    Gap(spacing.xl),
                    const Button(child: Text('Create account')),
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

class _Signup01Field extends StatelessWidget {
  const _Signup01Field({
    required this.label,
    required this.hint,
    this.obscure = false,
  });

  final String label;
  final String hint;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: theme.typography.textSmall.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        Gap(spacing.sm),
        Input(hintText: hint, obscureText: obscure),
      ],
    );
  }
}

class _Signup01Terms extends StatelessWidget {
  const _Signup01Terms();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Checkbox(value: CheckboxValue.unchecked),
        Gap(spacing.sm),
        Expanded(
          child: Text(
            'I agree to the terms of service and the privacy policy.',
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
        ),
      ],
    );
  }
}
