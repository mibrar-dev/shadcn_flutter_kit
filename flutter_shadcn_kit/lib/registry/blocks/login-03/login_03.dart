// The `login-03` block: a sign-in card with social buttons and a validated
// email form.
//
// A block is layer 4 of the registry: it may import foundation, theme,
// primitives and components, never another block. Its public widget is the
// preview - the docs page renders it exactly as an app would.
//
// The card is constrained to 384px (max-w-sm) and centres itself; the content
// shrink-wraps so the docs frame sizes to its intrinsic height, and scrolls
// internally when the host is bounded and shorter than the form.

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../components/alert/alert.dart';
import '../../components/button/button.dart';
import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import '../../components/form/form.dart';
import '../../components/input/input.dart';
import '../../components/spinner/spinner.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/theme.dart';

/// Values submitted by [Login03].
class Login03Data {
  /// Creates the submitted values.
  const Login03Data({required this.email, required this.password});

  /// The validated email address.
  final String email;

  /// The validated password.
  final String password;
}

/// A sign-in card with social provider buttons and a validated email form.
class Login03 extends StatefulWidget {
  /// Creates the block.
  const Login03({
    super.key,
    this.onSubmit,
    this.onProvider,
    this.onForgotPassword,
    this.onSignUp,
  });

  /// Called once with the typed values after a valid submit (after a short
  /// simulated async call). Null keeps the demo success alert.
  final FutureOr<void> Function(Login03Data data)? onSubmit;

  /// Called with the provider name when a social button is tapped.
  final ValueChanged<String>? onProvider;

  /// Called when "Forgot your password?" is tapped.
  final VoidCallback? onForgotPassword;

  /// Called when "Sign up" is tapped.
  final VoidCallback? onSignUp;

  @override
  State<Login03> createState() => _Login03State();
}

class _Login03State extends State<Login03> {
  final FormController _controller = FormController();
  final FormKey<String> _emailKey = const FormKey<String>('email');
  final FormKey<String> _passwordKey = const FormKey<String>('password');
  final FocusNode _emailFocus = FocusNode(debugLabel: 'login-03 email');
  final FocusNode _passwordFocus = FocusNode(debugLabel: 'login-03 password');
  bool _submitting = false;
  bool _succeeded = false;

  @override
  void dispose() {
    _controller.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting) {
      return;
    }
    setState(() {
      _submitting = true;
      _succeeded = false;
    });
    try {
      final SubmissionResult result = await _controller.submit(context);
      if (!mounted) {
        return;
      }
      if (!result.isValid) {
        if (result.errors.containsKey(_emailKey)) {
          _emailFocus.requestFocus();
        } else if (result.errors.containsKey(_passwordKey)) {
          _passwordFocus.requestFocus();
        }
      }
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  Future<void> _handleValidSubmit(FormMapValues values) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final Login03Data data = Login03Data(
      email: values.getValue(_emailKey) ?? '',
      password: values.getValue(_passwordKey) ?? '',
    );
    await widget.onSubmit?.call(data);
    if (!mounted) {
      return;
    }
    setState(() => _succeeded = true);
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final Widget body = Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 384),
                child: Card(
                  padding: EdgeInsets.all(theme.spacing.xl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text('Sign in', style: theme.typography.h2),
                      Gap(theme.spacing.sm),
                      Text(
                        'Pick the way you prefer.',
                        style: theme.typography.textMuted.copyWith(
                          color: theme.colors.mutedForeground,
                        ),
                      ),
                      Gap(theme.spacing.xl),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Button(
                              variant: ButtonVariant.outline,
                              onPressed: () =>
                                  widget.onProvider?.call('GitHub'),
                              child: const _Login03ProviderButton('GitHub'),
                            ),
                          ),
                          Gap(theme.spacing.md),
                          Expanded(
                            child: Button(
                              variant: ButtonVariant.outline,
                              onPressed: () =>
                                  widget.onProvider?.call('Google'),
                              child: const _Login03ProviderButton('Google'),
                            ),
                          ),
                        ],
                      ),
                      Gap(theme.spacing.xl),
                      const Divider(),
                      Gap(theme.spacing.xl),
                      ShadcnForm(
                        controller: _controller,
                        onSubmit: _handleValidSubmit,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            ShadcnFormField<String>(
                              key: _emailKey,
                              label: const Text('Email'),
                              validator:
                                  const NotEmptyValidator() &
                                  const EmailValidator(),
                              showErrors: const <FormValidationMode>{
                                FormValidationMode.changed,
                                FormValidationMode.submitted,
                              },
                              child: Input(
                                hintText: 'name@example.com',
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                focusNode: _emailFocus,
                                onSubmitted: (_) =>
                                    _passwordFocus.requestFocus(),
                              ),
                            ),
                            Gap(theme.spacing.md),
                            ShadcnFormField<String>(
                              key: _passwordKey,
                              label: const Text('Password'),
                              validator:
                                  const NotEmptyValidator() &
                                  const LengthValidator(min: 8),
                              showErrors: const <FormValidationMode>{
                                FormValidationMode.changed,
                                FormValidationMode.submitted,
                              },
                              child: Input(
                                hintText: 'Password',
                                obscureText: true,
                                textInputAction: TextInputAction.done,
                                focusNode: _passwordFocus,
                                onSubmitted: (_) => _submit(),
                              ),
                            ),
                            Gap(theme.spacing.sm),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Button(
                                variant: ButtonVariant.link,
                                onPressed: widget.onForgotPassword ?? () {},
                                child: const Text('Forgot your password?'),
                              ),
                            ),
                            Gap(theme.spacing.md),
                            Button(
                              onPressed: _submitting ? null : _submit,
                              child: _submitting
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Spinner(
                                          size: 14,
                                          color: theme.colors.primaryForeground,
                                        ),
                                        Gap(theme.spacing.sm),
                                        const Text('Signing in'),
                                      ],
                                    )
                                  : const Text('Sign in with email'),
                            ),
                            if (_succeeded) ...<Widget>[
                              Gap(theme.spacing.lg),
                              Alert(
                                content: Text(
                                  'Signed in — welcome back.',
                                  style: theme.typography.textSmall,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Gap(theme.spacing.lg),
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 4,
                        children: <Widget>[
                          Text(
                            "Don't have an account?",
                            style: theme.typography.textSmall.copyWith(
                              color: theme.colors.mutedForeground,
                            ),
                          ),
                          Button(
                            variant: ButtonVariant.link,
                            onPressed: widget.onSignUp ?? () {},
                            child: const Text('Sign up'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
            if (!constraints.maxHeight.isFinite) {
              return Padding(
                padding: EdgeInsets.all(theme.spacing.lg),
                child: body,
              );
            }
            return SingleChildScrollView(
              padding: EdgeInsets.all(theme.spacing.lg),
              child: body,
            );
          },
        ),
      ),
    );
  }
}

/// A social provider button: an icon plus the provider name.
class _Login03ProviderButton extends StatelessWidget {
  const _Login03ProviderButton(this.provider);

  final String provider;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(LucideIcons.github, size: 16, color: theme.colors.foreground),
        Gap(theme.spacing.sm),
        Flexible(child: Text(provider, style: theme.typography.textSmall)),
      ],
    );
  }
}
