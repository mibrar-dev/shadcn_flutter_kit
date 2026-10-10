// The `login-03` block: a sign-in card with social buttons.
//
// Three providers, a divider between them, and the email/password form below.
// The provider buttons wrap, so the card keeps its 400px measure on a phone
// and centres itself on a desktop stage.

import 'package:flutter/widgets.dart';

import '../../components/button/button.dart';
import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import '../../components/input/input.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/theme.dart';

/// A sign-in card with social providers and an email form.
class Login03 extends StatelessWidget {
  /// Creates the block.
  const Login03({super.key});

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
                    _Login03Title(),
                    Gap(spacing.xl),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Button(
                            variant: ButtonVariant.outline,
                            onPressed: () {},
                            child: const _Login03ProviderButton('GitHub'),
                          ),
                        ),
                        Gap(0, crossAxisExtent: 12),
                        Expanded(
                          child: Button(
                            variant: ButtonVariant.outline,
                            onPressed: () {},
                            child: const _Login03ProviderButton('Google'),
                          ),
                        ),
                      ],
                    ),
                    Gap(spacing.xl),
                    const Divider(),
                    Gap(spacing.xl),
                    _Login03EmailField(),
                    Gap(spacing.md),
                    _Login03PasswordField(),
                    Gap(spacing.md),
                    const _Login03ForgotRow(),
                    Gap(spacing.xl),
                    Button(
                      onPressed: () {},
                      child: const Text('Sign in with email'),
                    ),
                    Gap(spacing.lg),
                    const _Login03Signup(),
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

class _Login03Title extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Sign in', style: theme.typography.h2),
        Gap(spacing.sm),
        Text(
          'Pick the way you prefer.',
          style: theme.typography.textMuted.copyWith(
            color: theme.colors.mutedForeground,
          ),
        ),
      ],
    );
  }
}

/// A social provider button: an icon plus the provider name.
class _Login03ProviderButton extends StatelessWidget {
  const _Login03ProviderButton(this.provider);

  final String provider;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(LucideIcons.github, size: 16, color: theme.colors.foreground),
        const Gap(0, crossAxisExtent: 8),
        Flexible(child: Text(provider, style: theme.typography.textSmall)),
      ],
    );
  }
}

class _Login03EmailField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: theme.typography.textSmall.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        Gap(spacing.sm),
        const Input(hintText: 'name@example.com'),
      ],
    );
  }
}

class _Login03PasswordField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: theme.typography.textSmall.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        Gap(spacing.sm),
        const Input(hintText: 'Password', obscureText: true),
      ],
    );
  }
}

class _Login03ForgotRow extends StatelessWidget {
  const _Login03ForgotRow();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    // Right-aligned under the password field, on the field's right edge;
    // the link wraps instead of overflowing on narrow screens.
    return Row(
      children: <Widget>[
        const Spacer(),
        Flexible(
          child: Text(
            'Forgot your password?',
            textAlign: TextAlign.end,
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}

class _Login03Signup extends StatelessWidget {
  const _Login03Signup();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: Text(
            "Don't have an account? Sign up",
            textAlign: TextAlign.center,
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
        ),
      ],
    );
  }
}
