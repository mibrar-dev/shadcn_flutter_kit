// The `signup-02` block: a two-column sign-up with a summary aside.
//
// The form and the "what you get" aside sit side by side from 960px up, and
// stack below that. The password field carries a strength meter driven by the
// theme tokens, not a hard-coded colour.

import 'package:flutter/widgets.dart';

import '../../components/button/button.dart';
import '../../components/card/card.dart';
import '../../components/checkbox/checkbox.dart';
import '../../components/divider/divider.dart';
import '../../components/input/input.dart';
import '../../components/progress/progress.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/theme.dart';

/// A two-column sign-up: form on the left, a plan summary aside.
class Signup02 extends StatelessWidget {
  /// Creates the block.
  const Signup02({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool aside = constraints.maxWidth >= 960;
            final Widget form = const Signup02Form();
            if (!aside) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(spacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    form,
                    Gap(spacing.lg),
                    const Signup02Aside(),
                  ],
                ),
              );
            }
            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(spacing.xl),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1080),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(flex: 3, child: form),
                      Gap(spacing.xl),
                      const Expanded(flex: 2, child: Signup02Aside()),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// The sign-up form itself.
class Signup02Form extends StatelessWidget {
  /// Creates the form column.
  const Signup02Form({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text('Create your account', style: theme.typography.h2),
        Gap(spacing.sm),
        Text(
          'Start your 14-day trial. No credit card required.',
          style: theme.typography.textMuted.copyWith(
            color: theme.colors.mutedForeground,
          ),
        ),
        Gap(spacing.xl),
        Row(
          children: <Widget>[
            const Expanded(
              child: _Signup02Field(label: 'First name', hint: 'Ada'),
            ),
            Gap(spacing.md),
            const Expanded(
              child: _Signup02Field(label: 'Last name', hint: 'Lovelace'),
            ),
          ],
        ),
        Gap(spacing.md),
        const _Signup02Field(label: 'Work email', hint: 'ada@example.com'),
        Gap(spacing.md),
        const _Signup02Field(
          label: 'Password',
          hint: 'At least 8 characters',
          obscure: true,
        ),
        Gap(spacing.sm),
        const _Signup02Strength(),
        Gap(spacing.lg),
        const _Signup02Consent(),
        Gap(spacing.xl),
        const Button(child: Text('Start free trial')),
        Gap(spacing.lg),
        const Divider(),
        Gap(spacing.lg),
        const Center(child: Text('Already have an account? Sign in')),
      ],
    );
  }
}

class _Signup02Field extends StatelessWidget {
  const _Signup02Field({
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

/// A four-step strength meter; the colour follows the preset charts so it
/// re-themes with the app.
class _Signup02Strength extends StatelessWidget {
  const _Signup02Strength();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    const List<String> labels = <String>['Weak', 'Fair', 'Good', 'Strong'];
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            for (var i = 0; i < 4; i++) ...<Widget>[
              Expanded(
                child: Container(
                  height: spacing.xs,
                  decoration: BoxDecoration(
                    color: i < 2 ? theme.colors.chart1 : theme.colors.muted,
                    borderRadius: theme.borderRadiusXl,
                  ),
                ),
              ),
              if (i < 3) Gap(spacing.sm),
            ],
          ],
        ),
        Gap(spacing.sm),
        Text(
          labels[1],
          style: theme.typography.xSmall.copyWith(
            color: theme.colors.mutedForeground,
          ),
        ),
      ],
    );
  }
}

class _Signup02Consent extends StatelessWidget {
  const _Signup02Consent();

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
          child: RichText(
            text: TextSpan(
              style: theme.typography.textSmall.copyWith(
                color: theme.colors.mutedForeground,
              ),
              children: <TextSpan>[
                const TextSpan(text: 'I agree to the '),
                TextSpan(
                  text: 'terms',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
                const TextSpan(text: ' and the '),
                TextSpan(
                  text: 'privacy policy',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
                const TextSpan(text: '.'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// The aside that lists what the trial includes.
class Signup02Aside extends StatelessWidget {
  /// Creates the summary aside.
  const Signup02Aside({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Card(
      padding: EdgeInsets.all(spacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('What you get', style: theme.typography.h3),
          Gap(spacing.lg),
          for (final line in const <String>[
            'Unlimited projects during the trial',
            'All component categories',
            'Priority support',
          ]) ...<Widget>[_Signup02Bullet(line: line), Gap(spacing.md)],
          Gap(spacing.sm),
          const Divider(),
          Gap(spacing.lg),
          const Progress(value: 1, height: 8),
          Gap(spacing.sm),
          Text(
            '14 days left in your trial',
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

class _Signup02Bullet extends StatelessWidget {
  const _Signup02Bullet({required this.line});

  final String line;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(LucideIcons.check, size: 16, color: theme.colors.primary),
        Gap(spacing.sm),
        Expanded(child: Text(line, style: theme.typography.textSmall)),
      ],
    );
  }
}
