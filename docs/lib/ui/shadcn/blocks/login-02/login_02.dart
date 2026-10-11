// The `login-02` block: a split login with a validated form and a
// theme-token testimonial panel.
//
// A block is layer 4 of the registry: it may import foundation, theme,
// primitives and components, never another block. Its public widget is the
// preview - the docs page renders it exactly as an app would.
//
// From 900px the page is two equal columns: the form column centres a 320px
// (max-w-xs) validated form, and the panel fills its half with the muted
// token, a subtle dot pattern drawn from tokens, the product mark and a
// testimonial quote. Below 900px the panel stacks on top at a fixed 220px.
// No network images anywhere, so the block renders offline and in tests, and
// re-themes with every preset in light and dark.

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../components/alert/alert.dart';
import '../../components/button/button.dart';
import '../../components/form/form.dart';
import '../../components/input/input.dart';
import '../../components/spinner/spinner.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';
import 'login_02_panel.dart';

/// Values submitted by [Login02].
class Login02Data {
  /// Creates the submitted values.
  const Login02Data({required this.email, required this.password});

  /// The validated email address.
  final String email;

  /// The validated password.
  final String password;
}

/// A split login page: a validated form beside a testimonial panel.
class Login02 extends StatefulWidget {
  /// Creates the block.
  const Login02({super.key, this.onSubmit});

  /// Called once with the typed values after a valid submit (after a short
  /// simulated async call). Null keeps the demo success alert.
  final FutureOr<void> Function(Login02Data data)? onSubmit;

  @override
  State<Login02> createState() => _Login02State();
}

class _Login02State extends State<Login02> {
  final FormController _controller = FormController();
  final FormKey<String> _emailKey = const FormKey<String>('email');
  final FormKey<String> _passwordKey = const FormKey<String>('password');
  final FocusNode _emailFocus = FocusNode(debugLabel: 'login-02 email');
  final FocusNode _passwordFocus = FocusNode(debugLabel: 'login-02 password');
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
    final Login02Data data = Login02Data(
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
            final Widget form = _Login02Form(
              controller: _controller,
              onValidSubmit: _handleValidSubmit,
              emailKey: _emailKey,
              passwordKey: _passwordKey,
              emailFocus: _emailFocus,
              passwordFocus: _passwordFocus,
              submitting: _submitting,
              succeeded: _succeeded,
              onSubmit: _submit,
            );
            final Widget body;
            // `stretch` fills a bounded host (the app screen) edge to edge;
            // under unbounded height (the intrinsic docs frame) it would
            // hand the panel an infinite cross axis, so align to the start
            // and let both columns size to their content.
            final bool bounded = constraints.maxHeight.isFinite;
            if (constraints.maxWidth >= 900) {
              body = Row(
                crossAxisAlignment: bounded
                    ? CrossAxisAlignment.stretch
                    : CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 320),
                        child: form,
                      ),
                    ),
                  ),
                  const Expanded(child: Login02Panel()),
                ],
              );
            } else {
              body = Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Natural height: the quote needs more than 220px on a
                  // phone, and the column scrolls, so never fix it.
                  const Login02Panel(),
                  Padding(
                    padding: EdgeInsets.all(theme.spacing.lg),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 320),
                        child: form,
                      ),
                    ),
                  ),
                ],
              );
            }
            if (!constraints.maxHeight.isFinite) {
              return Padding(
                padding: EdgeInsets.all(theme.spacing.lg),
                child: body,
              );
            }
            if (constraints.maxWidth >= 900) {
              return Padding(
                padding: EdgeInsets.all(theme.spacing.lg),
                child: body,
              );
            }
            return SingleChildScrollView(child: body);
          },
        ),
      ),
    );
  }
}

/// The validated sign-in form, shared by both layouts.
class _Login02Form extends StatelessWidget {
  const _Login02Form({
    required this.controller,
    required this.onValidSubmit,
    required this.emailKey,
    required this.passwordKey,
    required this.emailFocus,
    required this.passwordFocus,
    required this.submitting,
    required this.succeeded,
    required this.onSubmit,
  });

  final FormController controller;
  final FormSubmitCallback onValidSubmit;
  final FormKey<String> emailKey;
  final FormKey<String> passwordKey;
  final FocusNode emailFocus;
  final FocusNode passwordFocus;
  final bool submitting;
  final bool succeeded;
  final Future<void> Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return ShadcnForm(
      controller: controller,
      onSubmit: onValidSubmit,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text('Sign in', style: theme.typography.h2),
          Gap(theme.spacing.sm),
          Text(
            'Enter your details below to continue.',
            style: theme.typography.textMuted.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          Gap(theme.spacing.xl),
          ShadcnFormField<String>(
            key: emailKey,
            label: const Text('Email'),
            validator: const NotEmptyValidator() & const EmailValidator(),
            showErrors: const <FormValidationMode>{
              FormValidationMode.changed,
              FormValidationMode.submitted,
            },
            child: Input(
              hintText: 'name@example.com',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              focusNode: emailFocus,
              onSubmitted: (_) => passwordFocus.requestFocus(),
            ),
          ),
          Gap(theme.spacing.md),
          ShadcnFormField<String>(
            key: passwordKey,
            label: const Text('Password'),
            validator:
                const NotEmptyValidator() & const LengthValidator(min: 8),
            showErrors: const <FormValidationMode>{
              FormValidationMode.changed,
              FormValidationMode.submitted,
            },
            child: Input(
              hintText: 'Password',
              obscureText: true,
              textInputAction: TextInputAction.done,
              focusNode: passwordFocus,
              onSubmitted: (_) => onSubmit(),
            ),
          ),
          Gap(theme.spacing.xl),
          Button(
            onPressed: submitting ? null : onSubmit,
            child: submitting
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Spinner(size: 14, color: theme.colors.primaryForeground),
                      Gap(theme.spacing.sm),
                      const Text('Signing in'),
                    ],
                  )
                : const Text('Sign in'),
          ),
          if (succeeded) ...<Widget>[
            Gap(theme.spacing.lg),
            Alert(
              content: Text(
                'Signed in — welcome back.',
                style: theme.typography.textSmall,
              ),
            ),
          ],
          Gap(theme.spacing.lg),
          Text(
            'By signing in you agree to our terms of service.',
            textAlign: TextAlign.center,
            style: theme.typography.xSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}
