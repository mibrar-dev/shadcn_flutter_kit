// The `login-01` block: a centred sign-in card with a validated form.
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
import '../../components/checkbox/checkbox.dart';
import '../../components/divider/divider.dart';
import '../../components/form/form.dart';
import '../../components/input/input.dart';
import '../../components/spinner/spinner.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';

/// Values submitted by [Login01].
class Login01Data {
  /// Creates the submitted values.
  const Login01Data({
    required this.email,
    required this.password,
    required this.rememberMe,
  });

  /// The validated email address.
  final String email;

  /// The validated password.
  final String password;

  /// Whether remember-me was checked.
  final bool rememberMe;
}

/// A centred sign-in card: validated email/password, remember-me and actions.
class Login01 extends StatefulWidget {
  /// Creates the block.
  const Login01({
    super.key,
    this.onSubmit,
    this.onForgotPassword,
    this.onCreateAccount,
  });

  /// Called once with the typed values after a valid submit (after a short
  /// simulated async call). Null keeps the demo success alert.
  final FutureOr<void> Function(Login01Data data)? onSubmit;

  /// Called when "Forgot password?" is tapped.
  final VoidCallback? onForgotPassword;

  /// Called when "Create an account" is tapped.
  final VoidCallback? onCreateAccount;

  @override
  State<Login01> createState() => _Login01State();
}

class _Login01State extends State<Login01> {
  final FormController _controller = FormController();
  final FormKey<String> _emailKey = const FormKey<String>('email');
  final FormKey<String> _passwordKey = const FormKey<String>('password');
  final FormKey<CheckboxValue> _rememberKey = const FormKey<CheckboxValue>(
    'rememberMe',
  );
  final FocusNode _emailFocus = FocusNode(debugLabel: 'login-01 email');
  final FocusNode _passwordFocus = FocusNode(debugLabel: 'login-01 password');
  CheckboxValue _rememberMe = CheckboxValue.checked;
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
        _focusFirstInvalid(result.errors);
      }
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  void _focusFirstInvalid(Map<FormKey, ValidationResult> errors) {
    for (final MapEntry<FormKey, FocusNode> entry
        in <MapEntry<FormKey, FocusNode>>[
          MapEntry<FormKey, FocusNode>(_emailKey, _emailFocus),
          MapEntry<FormKey, FocusNode>(_passwordKey, _passwordFocus),
        ]) {
      if (errors.containsKey(entry.key)) {
        entry.value.requestFocus();
        return;
      }
    }
  }

  Future<void> _handleValidSubmit(FormMapValues values) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final Login01Data data = Login01Data(
      email: values.getValue(_emailKey) ?? '',
      password: values.getValue(_passwordKey) ?? '',
      rememberMe:
          (values.getValue(_rememberKey) ?? CheckboxValue.unchecked) ==
          CheckboxValue.checked,
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
    final double spacing = theme.spacing.lg;
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
                  child: ShadcnForm(
                    controller: _controller,
                    onSubmit: _handleValidSubmit,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text('Sign in', style: theme.typography.h3),
                        Gap(theme.spacing.xs),
                        Text(
                          'Enter your credentials to access your workspace.',
                          style: theme.typography.textMuted.copyWith(
                            color: theme.colors.mutedForeground,
                          ),
                        ),
                        Gap(theme.spacing.xl),
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
                            onSubmitted: (_) => _passwordFocus.requestFocus(),
                          ),
                        ),
                        Gap(theme.spacing.md),
                        ShadcnFormField<String>(
                          key: _passwordKey,
                          label: const Text('Password'),
                          trailingLabel: Button(
                            variant: ButtonVariant.link,
                            onPressed: widget.onForgotPassword ?? () {},
                            child: const Text('Forgot password?'),
                          ),
                          validator:
                              const NotEmptyValidator() &
                              const LengthValidator(min: 8),
                          showErrors: const <FormValidationMode>{
                            FormValidationMode.changed,
                            FormValidationMode.submitted,
                          },
                          child: Input(
                            hintText: '••••••••',
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            focusNode: _passwordFocus,
                            onSubmitted: (_) => _submit(),
                          ),
                        ),
                        Gap(theme.spacing.md),
                        ShadcnFormField<CheckboxValue>(
                          key: _rememberKey,
                          // The checkbox carries its own inline label; the
                          // field label stays empty so no text is duplicated.
                          label: const SizedBox.shrink(),
                          showErrors: const <FormValidationMode>{
                            FormValidationMode.changed,
                            FormValidationMode.submitted,
                          },
                          child: Checkbox(
                            value: _rememberMe,
                            onChanged: (CheckboxValue value) =>
                                setState(() => _rememberMe = value),
                            label: const Text('Remember me'),
                          ),
                        ),
                        Gap(theme.spacing.xl),
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
                              : const Text('Sign in'),
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
                        Gap(theme.spacing.lg),
                        const Divider(),
                        Gap(theme.spacing.lg),
                        Button(
                          variant: ButtonVariant.outline,
                          onPressed: widget.onCreateAccount ?? () {},
                          child: const Text('Create an account'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
            if (!constraints.maxHeight.isFinite) {
              return Padding(padding: EdgeInsets.all(spacing), child: body);
            }
            return SingleChildScrollView(
              padding: EdgeInsets.all(spacing),
              child: body,
            );
          },
        ),
      ),
    );
  }
}
