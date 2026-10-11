// GENERATED CODE - DO NOT MODIFY BY HAND.
//
// Sources:
//   * flutter_shadcn_kit/lib/registry/blocks/<id>/<file>.dart
//
// Regenerate: dart run tool/gen_docs_data.dart
//
// The Blocks code view: one file per block, verbatim, with the same
// 4-class highlight map the README snippets use (`p`/`c`/`k`/`s`,
// one class per character). Imported by the deferred Blocks pages.

/// One block file: its install-root-relative path and source.
class DocsBlockFile {
  /// Creates a block file entry.
  const DocsBlockFile({
    required this.path,
    required this.code,
    required this.tokenClasses,
  });

  /// Install-root-relative path (`lib/ui/shadcn/blocks/…`).
  final String path;

  /// File source, verbatim.
  final String code;

  /// One highlight class per character of [code].
  final String tokenClasses;

  /// File name without its block-directory prefix.
  String get name => path.split('/').last;
}

/// Block files keyed by block id, in manifest `files` order.
const Map<String, List<DocsBlockFile>>
kBlockFileSources = <String, List<DocsBlockFile>>{
  'login-01': <DocsBlockFile>[
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/login-01/login_01.dart',
      code:
          r'''// The `login-01` block: a centred sign-in card with a validated form.
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
''',
      tokenClasses:
          'ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccppkkkkkkpsssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppccccccccccccccccccccccccccccccccccpkkkkkpppppppppppppppppcccccccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppkkkkkkkkpkkkkppppppppppppkkkkkkkkpkkkkpppppppppppppppkkkkkkkkpkkkkppppppppppppppppppppppccccccccccccccccccccccccccccccccpppkkkkkppppppppppppppppppcccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppppccccccccccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppkkkkkkkppppppppppppppppppppccccccccccccccccccccccpppkkkkkpppppppppppppppkkkkkppppppppppkkkkpppppppppppppppkkkkpppppppppppppppppppppppkkkkpppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppkkkkkppppppppppkkkkppkkkkkkkkpppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccpppkkkkkppppppppppppppppppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppkkkkkkkppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppkkkkkpppppppppppppppppssssssspppppkkkkkppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppsssssssssspppppkkkkkpppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppsssssssssssspppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssspppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkpppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppkkkkppppppppppppkkkkkpppppppkkpppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppkkkkkppppppppppppppkkkpppppppppkkkkkpppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppkkkkkkppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkkpppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkkkppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppkkkkkppppppppkkkkppppppppppkkkkkpppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsspppppppppppppppppppppppppppppppppppppppppppppppppppssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppkkppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssspppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccpppppppppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'login-02': <DocsBlockFile>[
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/login-02/login_02.dart',
      code:
          r'''// The `login-02` block: a split login with a validated form and a
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
''',
      tokenClasses:
          'ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccpccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccppkkkkkkpsssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpssssssssssssssssssssssssppkkkkkkpssssssssssssssssssssspppccccccccccccccccccccccccccccccccccpkkkkkpppppppppppppppppcccccccccccccccccccccccccccccccccpppkkkkkppppppppppppppkkkkkkkkpkkkkppppppppkkkkkkkkpkkkkppppppppppppppppccccccccccccccccccccccccccccccccpppkkkkkppppppppppppppppppcccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppkkkkkkkppppppppppppppppppppccccccccccccccccccccccpppkkkkkppppppppppkkkkkppppppkkkkppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppkkkkkppppppppppkkkkppkkkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppkkkkkkkppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppkkkkkpppppppppppppppppssssssspppppkkkkkppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppsssssssssspppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssspppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssppppppppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkpppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppkkkkppppppppppppkkkkkpppppppkkpppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppkkkkkppppppppppppppkkkpppppppppkkkkkpppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppkkkkkkppppppppppppppppkkpppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkpkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkkpppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppkkkkkppppppppkkkkppppppppppkkkkkpppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsspppppppppppppppppppppppppppppppppppppppppppppppppppsspppppppppppppkkkkkppppppppppppppppppppppppppppppppppkkppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppppppccccccccccccccccccccccccccccccccccccccccccccccpppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppkkkkkkkkpkkkkpppppppppppppppppkkkkkkkkpkkkkppppppppppppppppppppkkkkkkkkpkkkkpppppppppppppppkkkkkkkkpkkkkppppppppppppppppppkkkkkkkkpkkkkpppppppppppppppppkkkkkkkkpkkkkppppppppppppppppppppkkkkkkkkpkkkkpppppppppppppppppkkkkkkkkpkkkkppppppppppppppppkkkkkkkkpkkkkppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppkkkkkppppppppppppppppppppkkkkkpppppppppppppppppppkkkkkppppppppkkkkppkkkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssspppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssssssssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/login-02/login_02_panel.dart',
      code:
          r'''// The `login-02` block, part 2: the testimonial panel. Imported by
// `login_02.dart`; a block never imports another block.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/theme.dart';

/// The testimonial panel: muted fill, a token-drawn dot pattern, the product
/// mark and a quote. No images, so it works offline and in every preset.
class Login02Panel extends StatelessWidget {
  /// Creates the panel.
  const Login02Panel({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final double spacing = theme.spacing.xl;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colors.muted,
        borderRadius: theme.borderRadiusLg,
        border: Border.all(color: theme.colors.border),
      ),
      child: ClipRRect(
        borderRadius: theme.borderRadiusLg,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: CustomPaint(
                painter: _DotPainter(color: theme.colors.mutedForeground),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(spacing),
              // `max` + `spaceBetween` fills a bounded host (the app
              // screen or the 220px stacked panel) and shrink-wraps an
              // unbounded one (the intrinsic docs frame): no Spacer, which
              // would throw under unbounded height.
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: theme.colors.primary,
                          borderRadius: theme.borderRadiusSm,
                        ),
                        child: Icon(
                          LucideIcons.command,
                          size: 16,
                          color: theme.colors.primaryForeground,
                        ),
                      ),
                      Gap(theme.spacing.sm),
                      Text('Acme Inc', style: theme.typography.textSmall),
                    ],
                  ),
                  Gap(theme.spacing.xl),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '"The kit paid for itself the week we adopted it. '
                        'Every screen ships on-brand, light or dark."',
                        style: theme.typography.textLarge,
                      ),
                      Gap(theme.spacing.md),
                      Text(
                        'Sofia Davis — Design lead, Acme',
                        style: theme.typography.textSmall.copyWith(
                          color: theme.colors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A subtle dot grid at 8% opacity of the muted-foreground token.
class _DotPainter extends CustomPainter {
  const _DotPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint dot = Paint()..color = color.withValues(alpha: 0.08);
    const double step = 22;
    for (double y = step / 2; y < size.height; y += step) {
      for (double x = step / 2; x < size.width; x += step) {
        canvas.drawCircle(Offset(x, y), 1.2, dot);
      }
    }
  }

  @override
  bool shouldRepaint(_DotPainter oldDelegate) => oldDelegate.color != color;
}
''',
      tokenClasses:
          'cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpssssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkppppppppppppppkkkkkkkpppppppppppppppppppppccccccccccccccccccccccpppkkkkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppppppppccccccccccccccccccccccccccccccccccccccppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssssssssssssssssssssssssssspppppppppppppppppppppppppsssssssssssssssssssssssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppppppkkkkkkkpppppppppppppppppppkkkkkppppppppppppppkkkkkkkkpkkkkpppppppppppppkkkkkpppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'login-03': <DocsBlockFile>[
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/login-03/login_03.dart',
      code:
          r'''// The `login-03` block: a sign-in card with social buttons and a validated
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
''',
      tokenClasses:
          'cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccpccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccppkkkkkkpsssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpssssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppccccccccccccccccccccccccccccccccccpkkkkkpppppppppppppppppcccccccccccccccccccccccccccccccccpppkkkkkppppppppppppppkkkkkkkkpkkkkppppppppkkkkkkkkpkkkkppppppppppppppppccccccccccccccccccccccccccccccccpppkkkkkppppppppppppppppppcccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppkkkkkkkppppppppppppppppppppccccccccccccccccccccccpppkkkkkpppppppppppppppkkkkkppppppppppkkkkpppppppppppppppkkkkpppppppppppppppppkkkkpppppppppppppppppppppppkkkkppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppkkkkkppppppppppkkkkppkkkkkkkkpppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppkkkkkppppppppppppppppppppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccpppkkkkkppppppppppppppppppppppppppppppppppppccccccccccccccccccccccccccccccccccccpppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppkkkkkkkppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppkkkkkpppppppppppppppppssssssspppppkkkkkppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppsssssssssspppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssspppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssppppppppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkpppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppkkkkppppppppppppkkkkkpppppppkkpppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppkkkkkppppppppppppppkkkpppppppppkkkkkpppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppkkkkkkppppppppppppppppkkpppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkpkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkkpppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppkkkkkppppppppkkkkppppppppppkkkkkpppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsspppppppppppppppppppppppppppppppppppppppppppppppppppsspppppppppppppkkkkkppppppppppppppppppppppppppppppppppkkppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssspppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkppppppppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppkkkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'otp-01': <DocsBlockFile>[
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/otp-01/otp_01.dart',
      code:
          r'''// The `otp-01` block: a one-time-code verification card with a validated
// form.
//
// A block is layer 4 of the registry: it may import foundation, theme,
// primitives and components, never another block. Its public widget is the
// preview - the docs page renders it exactly as an app would.
//
// The card is constrained to 384px (max-w-sm) and centres itself; the content
// shrink-wraps so the docs frame sizes to its intrinsic height, and scrolls
// internally when the host is bounded and shorter than the form. The code
// must be exactly 6 digits; completing all slots submits automatically.

import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../components/alert/alert.dart';
import '../../components/button/button.dart';
import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import '../../components/form/form.dart';
import '../../components/input_otp/input_otp.dart';
import '../../components/spinner/spinner.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';

/// Values submitted by [Otp01].
class Otp01Data {
  /// Creates the submitted values.
  const Otp01Data({required this.code});

  /// The validated 6-digit code.
  final String code;
}

/// A one-time-code verification card with a countdown before resending.
class Otp01 extends StatefulWidget {
  /// Creates the block.
  const Otp01({super.key, this.email, this.onSubmit, this.onChangeEmail});

  /// The address the code was sent to.
  final String? email;

  /// Called once with the typed values after a valid submit (after a short
  /// simulated async call). Null keeps the demo success alert.
  final FutureOr<void> Function(Otp01Data data)? onSubmit;

  /// Called when "Use a different email" is tapped.
  final VoidCallback? onChangeEmail;

  @override
  State<Otp01> createState() => _Otp01State();
}

class _Otp01State extends State<Otp01> {
  static final Validator<String> _codeValidator =
      const NotEmptyValidator() &
      const LengthValidator(min: 6, max: 6) &
      RegexValidator(RegExp(r'^\d{6}$'));

  final FormController _controller = FormController();
  final FormKey<String> _codeKey = const FormKey<String>('code');
  Timer? _timer;
  int _secondsLeft = 30;
  bool _submitting = false;
  bool _succeeded = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _secondsLeft = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (!mounted) {
        return;
      }
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _secondsLeft = 0);
        return;
      }
      setState(() => _secondsLeft -= 1);
    });
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
      await _controller.submit(context);
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  Future<void> _handleValidSubmit(FormMapValues values) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final Otp01Data data = Otp01Data(code: values.getValue(_codeKey) ?? '');
    await widget.onSubmit?.call(data);
    if (!mounted) {
      return;
    }
    setState(() => _succeeded = true);
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final String email = widget.email ?? 'ada@example.com';
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
                Text('Verify your email', style: theme.typography.h2),
                Gap(theme.spacing.sm),
                Text(
                  'We sent a six-digit code to $email.',
                  style: theme.typography.textMuted.copyWith(
                    color: theme.colors.mutedForeground,
                  ),
                ),
                Gap(theme.spacing.xl),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 320),
                    child: ShadcnFormField<String>(
                      key: _codeKey,
                      label: const Text('Code'),
                      validator: _codeValidator,
                      showErrors: const <FormValidationMode>{
                        FormValidationMode.changed,
                        FormValidationMode.submitted,
                      },
                      child: InputOtp(
                        length: 6,
                        onCompleted: (_) => _submit(),
                        onSubmitted: (_) => _submit(),
                      ),
                    ),
                  ),
                ),
                Gap(theme.spacing.lg),
                _Otp01Resend(
                  secondsLeft: _secondsLeft,
                  onResend: _startCountdown,
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
                            const Text('Verifying'),
                          ],
                        )
                      : const Text('Verify'),
                ),
                if (_succeeded) ...<Widget>[
                  Gap(theme.spacing.lg),
                  Alert(
                    content: Text(
                      'Email verified — you are all set.',
                      style: theme.typography.textSmall,
                    ),
                  ),
                ],
                Gap(theme.spacing.lg),
                const Divider(),
                Gap(theme.spacing.lg),
                Center(
                  child: Button(
                    variant: ButtonVariant.link,
                    onPressed: widget.onChangeEmail ?? () {},
                    child: const Text('Use a different email'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
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

class _Otp01Resend extends StatelessWidget {
  const _Otp01Resend({required this.secondsLeft, required this.onResend});

  final int secondsLeft;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Row(
      children: <Widget>[
        Flexible(
          child: Text(
            "Didn't get the code?",
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
        ),
        const Spacer(),
        if (secondsLeft > 0)
          Text(
            'Resend in ${secondsLeft}s',
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          )
        else
          Button(
            variant: ButtonVariant.link,
            onPressed: onResend,
            child: const Text('Resend'),
          ),
      ],
    );
  }
}
''',
      tokenClasses:
          'cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccpccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccppkkkkkkpsssssssssssspppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppccccccccccccccccccccccccccccccccpkkkkkpppppppppppppppcccccccccccccccccccccccccccccccccpppkkkkkppppppppppppkkkkkkkkpkkkkppppppppppppcccccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppkkkkkkkppppppppppppppppppppccccccccccccccccccccccpppkkkkkppppppppkkkkkppppppkkkkppppppppkkkkpppppppppppkkkkpppppppppppppppppppppcccccccccccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppkkkkkppppppppppkkkkppkkkkkkkkpppppppppppppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppkkkkkkkppppppppppppppppppkkkkkkpkkkkkppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssspppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppkkkkkpppppppppppppppppssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkpppppppppppppppppkkkkpppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppkkkkkkppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppkkkkkpppppppkkpppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppkkkkkppppppppppppppkkkpppppppppkkkkkppppppppppppppppppppppppppppppppppppkkkkkkkpppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppkkkkkppppppppkkkkppppppppppkkkkkpppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsspppppppkkkkkppppppppppppppppppppppppppppppppppkkppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppppsssssssssssssssssppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssssssssssppppppssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppkkkkkkkkpkkkkppppppppppppppkkkkkkkkpkkkkppppppppppppppppkkkkkppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppsssssssssssppppppppppppppssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssspppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'signup-01': <DocsBlockFile>[
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/signup-01/signup_01.dart',
      code:
          r'''// The `signup-01` block: a create-account card with a validated form.
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
import '../../components/form/form.dart';
import '../../components/input/input.dart';
import '../../components/spinner/spinner.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';

/// Values submitted by [Signup01].
class Signup01Data {
  /// Creates the submitted values.
  const Signup01Data({
    required this.name,
    required this.email,
    required this.password,
  });

  /// The validated display name.
  final String name;

  /// The validated email address.
  final String email;

  /// The validated password.
  final String password;
}

/// A create-account card: validated name/email/password and a required terms
/// checkbox.
class Signup01 extends StatefulWidget {
  /// Creates the block.
  const Signup01({super.key, this.onSubmit, this.onSignIn});

  /// Called once with the typed values after a valid submit (after a short
  /// simulated async call). Null keeps the demo success alert.
  final FutureOr<void> Function(Signup01Data data)? onSubmit;

  /// Called when "Sign in" is tapped.
  final VoidCallback? onSignIn;

  @override
  State<Signup01> createState() => _Signup01State();
}

class _Signup01State extends State<Signup01> {
  final FormController _controller = FormController();
  final FormKey<String> _nameKey = const FormKey<String>('name');
  final FormKey<String> _emailKey = const FormKey<String>('email');
  final FormKey<String> _passwordKey = const FormKey<String>('password');
  final FormKey<CheckboxValue> _termsKey = const FormKey<CheckboxValue>(
    'terms',
  );
  final FocusNode _nameFocus = FocusNode(debugLabel: 'signup-01 name');
  final FocusNode _emailFocus = FocusNode(debugLabel: 'signup-01 email');
  final FocusNode _passwordFocus = FocusNode(debugLabel: 'signup-01 password');
  CheckboxValue _terms = CheckboxValue.unchecked;
  bool _submitting = false;
  bool _succeeded = false;

  @override
  void dispose() {
    _controller.dispose();
    _nameFocus.dispose();
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
          MapEntry<FormKey, FocusNode>(_nameKey, _nameFocus),
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
    final Signup01Data data = Signup01Data(
      name: values.getValue(_nameKey) ?? '',
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
                Text('Create an account', style: theme.typography.h2),
                Gap(theme.spacing.sm),
                Text(
                  'Enter your email below to create your account.',
                  style: theme.typography.textMuted.copyWith(
                    color: theme.colors.mutedForeground,
                  ),
                ),
                Gap(theme.spacing.xl),
                ShadcnFormField<String>(
                  key: _nameKey,
                  label: const Text('Name'),
                  validator:
                      const NotEmptyValidator() &
                      const LengthValidator(min: 2, max: 50),
                  showErrors: const <FormValidationMode>{
                    FormValidationMode.changed,
                    FormValidationMode.submitted,
                  },
                  child: Input(
                    hintText: 'Ada Lovelace',
                    textInputAction: TextInputAction.next,
                    focusNode: _nameFocus,
                    onSubmitted: (_) => _emailFocus.requestFocus(),
                  ),
                ),
                Gap(theme.spacing.md),
                ShadcnFormField<String>(
                  key: _emailKey,
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
                    focusNode: _emailFocus,
                    onSubmitted: (_) => _passwordFocus.requestFocus(),
                  ),
                ),
                Gap(theme.spacing.md),
                ShadcnFormField<String>(
                  key: _passwordKey,
                  label: const Text('Password'),
                  hint: const Text('At least 8 characters.'),
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
                    focusNode: _passwordFocus,
                    onSubmitted: (_) => _submit(),
                  ),
                ),
                Gap(theme.spacing.md),
                ShadcnFormField<CheckboxValue>(
                  key: _termsKey,
                  // The checkbox carries its own inline label; the field
                  // label stays empty so no text is duplicated.
                  label: const SizedBox.shrink(),
                  validator: const _AcceptedValidator(),
                  showErrors: const <FormValidationMode>{
                    FormValidationMode.changed,
                    FormValidationMode.submitted,
                  },
                  child: _Signup01Terms(
                    value: _terms,
                    onChanged: (CheckboxValue value) =>
                        setState(() => _terms = value),
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
                            const Text('Creating account'),
                          ],
                        )
                      : const Text('Create account'),
                ),
                if (_succeeded) ...<Widget>[
                  Gap(theme.spacing.lg),
                  Alert(
                    content: Text(
                      'Account created — check your inbox to verify it.',
                      style: theme.typography.textSmall,
                    ),
                  ),
                ],
                Gap(theme.spacing.lg),
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 4,
                  children: <Widget>[
                    Text(
                      'Already have an account?',
                      style: theme.typography.textSmall.copyWith(
                        color: theme.colors.mutedForeground,
                      ),
                    ),
                    Button(
                      variant: ButtonVariant.link,
                      onPressed: widget.onSignIn ?? () {},
                      child: const Text('Sign in'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
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

/// Fails unless the terms checkbox is checked.
class _AcceptedValidator extends Validator<CheckboxValue> {
  /// Creates the validator.
  const _AcceptedValidator();

  @override
  FutureOr<ValidationResult?> validate(
    BuildContext context,
    CheckboxValue? value,
    FormValidationMode lifecycle,
  ) {
    if (value == CheckboxValue.checked) {
      return null;
    }
    return InvalidResult(
      'You must accept the terms to continue.',
      state: lifecycle,
    );
  }
}

class _Signup01Terms extends StatelessWidget {
  const _Signup01Terms({required this.value, required this.onChanged});

  final CheckboxValue value;
  final ValueChanged<CheckboxValue> onChanged;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Checkbox(value: value, onChanged: onChanged),
        Gap(theme.spacing.sm),
        Expanded(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 0,
            children: <Widget>[
              Text(
                'I agree to the ',
                style: theme.typography.textSmall.copyWith(
                  color: theme.colors.mutedForeground,
                ),
              ),
              Button(
                variant: ButtonVariant.link,
                onPressed: () {},
                child: const Text('terms'),
              ),
              Text(
                ' and the ',
                style: theme.typography.textSmall.copyWith(
                  color: theme.colors.mutedForeground,
                ),
              ),
              Button(
                variant: ButtonVariant.link,
                onPressed: () {},
                child: const Text('privacy policy'),
              ),
              Text(
                '.',
                style: theme.typography.textSmall.copyWith(
                  color: theme.colors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
''',
      tokenClasses:
          'ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccppkkkkkkpsssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppcccccccccccccccccccccccccccccccccccpkkkkkppppppppppppppppppcccccccccccccccccccccccccccccccccpppkkkkkppppppppppppppppppppkkkkkkkkpkkkkpppppppppppkkkkkkkkpkkkkppppppppppppkkkkkkkkpkkkkppppppppppppppppppppcccccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppccccccccccccccccccccccccccccccccpppkkkkkppppppppppppppppppcccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccpkkkkkppppppppppkkkkkkkppppppppppppppppppppccccccccccccccccccccccpppkkkkkpppppppppppkkkkkppppppkkkkpppppppppppkkkkppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppkkkkkppppppppppkkkkppkkkkkkkkppppppppppppppppppppppppppppppppppccccccccccccccccccccccccccccccccccccpppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppkkkkkpppppppppppppppppsssssspppppkkkkkpppppppppppppppppppppppppppppkkkkkpppppppppppppppppssssssspppppkkkkkppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppsssssssssspppppkkkkkppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppssssssspppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssspppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssspppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkpppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppkkkkppppppppppppkkkkkpppppppkkpppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppkkkkkppppppppppppppkkkpppppppppkkkkkpppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppkkkkkkppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkkpppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkkkppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppkkkkkppppppppkkkkppppppppppkkkkkpppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsspppppppppppppppppppppppppppppppppppppppppppppsspppppppppppppppppppppppppppppppppppppppppppppppppppsspppppppppppppkkkkkppppppppppppppppppppppppppppppppppkkppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssssssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssspppppppppppppppppppppppppppkkkkkppppppssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssspppppppppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssssssppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssssssssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccpkkkkkppppppppppppppppppppkkkkkkkppppppppppppppppppppppppppppppccccccccccccccccccccccccccpppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppkkkkkkpkkkkppppppppppppkkkkkkppppppppppppppppppppppssssssssssssssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppkkkkkkkkpkkkkppppppppkkkkkkkkpkkkkpppppppppppppppppkkkkkppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'signup-02': <DocsBlockFile>[
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/signup-02/signup_02.dart',
      code:
          r'''// The `signup-02` block: a two-column sign-up with a validated form, a
// password strength meter wired to the password field, and a summary aside.
//
// A block is layer 4 of the registry: it may import foundation, theme,
// primitives and components, never another block. Its public widget is the
// preview - the docs page renders it exactly as an app would.
//
// The form and the aside sit side by side from 960px up inside a 1024px
// shell, and stack below that. The content shrink-wraps so the docs frame
// sizes to its intrinsic height, and scrolls internally when the host is
// bounded and shorter than the page.

import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../components/checkbox/checkbox.dart';
import '../../components/form/form.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';
import 'signup_02_aside.dart';
import 'signup_02_form.dart';

/// Values submitted by [Signup02].
class Signup02Data {
  /// Creates the submitted values.
  const Signup02Data({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  /// The validated first name.
  final String firstName;

  /// The validated last name.
  final String lastName;

  /// The validated work email.
  final String email;

  /// The validated password.
  final String password;
}

/// A two-column sign-up: validated form on the left, a plan summary aside.
class Signup02 extends StatefulWidget {
  /// Creates the block.
  const Signup02({super.key, this.onSubmit, this.onSignIn});

  /// Called once with the typed values after a valid submit (after a short
  /// simulated async call). Null keeps the demo success alert.
  final FutureOr<void> Function(Signup02Data data)? onSubmit;

  /// Called when "Sign in" is tapped.
  final VoidCallback? onSignIn;

  @override
  State<Signup02> createState() => _Signup02State();
}

class _Signup02State extends State<Signup02> {
  final FormController _controller = FormController();
  final FormKey<String> _firstNameKey = const FormKey<String>('firstName');
  final FormKey<String> _lastNameKey = const FormKey<String>('lastName');
  final FormKey<String> _emailKey = const FormKey<String>('email');
  final FormKey<String> _passwordKey = const FormKey<String>('password');
  final FormKey<CheckboxValue> _termsKey = const FormKey<CheckboxValue>(
    'terms',
  );
  final FocusNode _firstNameFocus = FocusNode(
    debugLabel: 'signup-02 first name',
  );
  final FocusNode _lastNameFocus = FocusNode(debugLabel: 'signup-02 last name');
  final FocusNode _emailFocus = FocusNode(debugLabel: 'signup-02 email');
  final FocusNode _passwordFocus = FocusNode(debugLabel: 'signup-02 password');
  final TextEditingController _passwordController = TextEditingController();
  CheckboxValue _terms = CheckboxValue.unchecked;
  String _password = '';
  bool _submitting = false;
  bool _succeeded = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_syncPassword);
  }

  void _syncPassword() {
    final String next = _passwordController.text;
    if (next != _password && mounted) {
      setState(() => _password = next);
    }
  }

  @override
  void dispose() {
    _passwordController.removeListener(_syncPassword);
    _passwordController.dispose();
    _controller.dispose();
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
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
          MapEntry<FormKey, FocusNode>(_firstNameKey, _firstNameFocus),
          MapEntry<FormKey, FocusNode>(_lastNameKey, _lastNameFocus),
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
    final Signup02Data data = Signup02Data(
      firstName: values.getValue(_firstNameKey) ?? '',
      lastName: values.getValue(_lastNameKey) ?? '',
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
            final Widget form = Signup02Form(
              controller: _controller,
              onValidSubmit: _handleValidSubmit,
              firstNameKey: _firstNameKey,
              lastNameKey: _lastNameKey,
              emailKey: _emailKey,
              passwordKey: _passwordKey,
              termsKey: _termsKey,
              firstNameFocus: _firstNameFocus,
              lastNameFocus: _lastNameFocus,
              emailFocus: _emailFocus,
              passwordFocus: _passwordFocus,
              passwordController: _passwordController,
              password: _password,
              terms: _terms,
              onTermsChanged: (CheckboxValue value) =>
                  setState(() => _terms = value),
              submitting: _submitting,
              succeeded: _succeeded,
              onSubmit: _submit,
              onSignIn: widget.onSignIn,
            );
            final Widget body;
            if (constraints.maxWidth >= 960) {
              body = Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1024),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(flex: 3, child: form),
                      Gap(theme.spacing.xl),
                      const Expanded(flex: 2, child: Signup02Aside()),
                    ],
                  ),
                ),
              );
            } else {
              body = Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  form,
                  Gap(theme.spacing.lg),
                  const Signup02Aside(),
                ],
              );
            }
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
''',
      tokenClasses:
          'cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccppkkkkkkpsssssssssssspppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpssssssssssssssssssssssssppkkkkkkpssssssssssssssssssssssppkkkkkkpssssssssssssssssssssspppcccccccccccccccccccccccccccccccccccpkkkkkppppppppppppppppppcccccccccccccccccccccccccccccccccpppkkkkkppppppppppppppppppppkkkkkkkkpkkkkppppppppppppppppkkkkkkkkpkkkkpppppppppppppppkkkkkkkkpkkkkppppppppppppkkkkkkkkpkkkkppppppppppppppppppppcccccccccccccccccccccccccccccpppkkkkkppppppppppppppppppppppccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppppcccccccccccccccccccccccccccccpppkkkkkppppppppppppppppppcccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkppppppppppkkkkkkkppppppppppppppppppppccccccccccccccccccccccpppkkkkkpppppppppppkkkkkppppppkkkkpppppppppppkkkkppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppkkkkkppppppppppkkkkppkkkkkkkkppppppppppppppppppppppppppppppppppccccccccccccccccccccccccccccccccccccpppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppssssssssssspppppkkkkkppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppsssssssssspppppkkkkkpppppppppppppppppppppppppppppkkkkkpppppppppppppppppssssssspppppkkkkkppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppsssssssssspppppkkkkkppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppssssssspppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssspppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssspppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssspppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssspppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsspppppppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkpppppppppppppppppkkkkpppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppkkkkppppppppppppkkkkkpppppppkkpppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppkkkkkppppppppppppppkkkpppppppppkkkkkpppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppkkkkkkppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkkpppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkkkppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppkkkkkppppppppkkkkppppppppppkkkkkpppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsspppppppppppppppppppppppppppppppppppppppppppppppppppsspppppppppppppppppppppppppppppppppppppppppppppsspppppppppppppppppppppppppppppppppppppppppppppppppppsspppppppppppppkkkkkppppppppppppppppppppppppppppppppppkkppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/signup-02/signup_02_aside.dart',
      code:
          r'''// The `signup-02` block, part 3: the plan summary aside. Imported by
// `signup_02.dart`; a block never imports another block.

import 'package:flutter/widgets.dart';

import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import '../../components/progress/progress.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/theme.dart';

/// The aside that lists what the trial includes.
class Signup02Aside extends StatelessWidget {
  /// Creates the summary aside.
  const Signup02Aside({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Card(
      padding: EdgeInsets.all(theme.spacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('What you get', style: theme.typography.h3),
          Gap(theme.spacing.lg),
          for (final line in const <String>[
            'Unlimited projects during the trial',
            'All component categories',
            'Priority support',
          ]) ...<Widget>[_Signup02Bullet(line: line), Gap(theme.spacing.md)],
          const Divider(),
          Gap(theme.spacing.lg),
          const Progress(value: 1, height: 8),
          Gap(theme.spacing.sm),
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
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(LucideIcons.check, size: 16, color: theme.colors.primary),
        Gap(theme.spacing.sm),
        Expanded(child: Text(line, style: theme.typography.textSmall)),
      ],
    );
  }
}
''',
      tokenClasses:
          'cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpssssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppcccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppppppppkkkkkkkpppppppppppppppppppppccccccccccccccccccccccccccccccpppkkkkkppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkkkppppppkkpkkkkkpppppppppppppppppppppppsssssssssssssssssssssssssssssssssssssppppppppppppppssssssssssssssssssssssssssppppppppppppppssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppkkkkkkkkpkkkkppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/signup-02/signup_02_form.dart',
      code:
          r'''// The `signup-02` block, part 2: the validated sign-up form with its
// password strength meter. Imported by `signup_02.dart`; a block never
// imports another block.

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../components/alert/alert.dart';
import '../../components/button/button.dart';
import '../../components/checkbox/checkbox.dart';
import '../../components/divider/divider.dart';
import '../../components/form/form.dart';
import '../../components/input/input.dart';
import '../../components/spinner/spinner.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';

/// Scores a password 0-4: length, case mix, digit, special character.
int passwordStrength(String password) {
  var score = 0;
  if (password.length >= 8) {
    score += 1;
  }
  if (RegExp(r'[a-z]').hasMatch(password) &&
      RegExp(r'[A-Z]').hasMatch(password)) {
    score += 1;
  }
  if (RegExp(r'\d').hasMatch(password)) {
    score += 1;
  }
  if (RegExp(r'[\W_]').hasMatch(password)) {
    score += 1;
  }
  return score;
}

/// The sign-up form itself, shared by the signup-02 layouts.
class Signup02Form extends StatelessWidget {
  /// Creates the form column.
  const Signup02Form({
    super.key,
    required this.controller,
    required this.onValidSubmit,
    required this.firstNameKey,
    required this.lastNameKey,
    required this.emailKey,
    required this.passwordKey,
    required this.termsKey,
    required this.firstNameFocus,
    required this.lastNameFocus,
    required this.emailFocus,
    required this.passwordFocus,
    required this.passwordController,
    required this.password,
    required this.terms,
    required this.onTermsChanged,
    required this.submitting,
    required this.succeeded,
    required this.onSubmit,
    required this.onSignIn,
  });

  final FormController controller;
  final FormSubmitCallback onValidSubmit;
  final FormKey<String> firstNameKey;
  final FormKey<String> lastNameKey;
  final FormKey<String> emailKey;
  final FormKey<String> passwordKey;
  final FormKey<CheckboxValue> termsKey;
  final FocusNode firstNameFocus;
  final FocusNode lastNameFocus;
  final FocusNode emailFocus;
  final FocusNode passwordFocus;
  final TextEditingController passwordController;

  /// The current password text; drives the strength meter below the field.
  final String password;
  final CheckboxValue terms;
  final ValueChanged<CheckboxValue> onTermsChanged;
  final bool submitting;
  final bool succeeded;
  final Future<void> Function() onSubmit;
  final VoidCallback? onSignIn;

  static const Set<FormValidationMode> _show = <FormValidationMode>{
    FormValidationMode.changed,
    FormValidationMode.submitted,
  };

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
          Text('Create your account', style: theme.typography.h2),
          Gap(theme.spacing.sm),
          Text(
            'Start your 14-day trial. No credit card required.',
            style: theme.typography.textMuted.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          Gap(theme.spacing.xl),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final Widget first = ShadcnFormField<String>(
                key: firstNameKey,
                label: const Text('First name'),
                validator:
                    const NotEmptyValidator() &
                    const LengthValidator(min: 2, max: 50),
                showErrors: _show,
                child: Input(
                  hintText: 'Ada',
                  textInputAction: TextInputAction.next,
                  focusNode: firstNameFocus,
                  onSubmitted: (_) => lastNameFocus.requestFocus(),
                ),
              );
              final Widget last = ShadcnFormField<String>(
                key: lastNameKey,
                label: const Text('Last name'),
                validator:
                    const NotEmptyValidator() &
                    const LengthValidator(min: 2, max: 50),
                showErrors: _show,
                child: Input(
                  hintText: 'Lovelace',
                  textInputAction: TextInputAction.next,
                  focusNode: lastNameFocus,
                  onSubmitted: (_) => emailFocus.requestFocus(),
                ),
              );
              // Equal-width columns side by side; a single column below
              // 420px so neither field is squeezed on a phone.
              if (constraints.maxWidth >= 420) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(child: first),
                    Gap(theme.spacing.md),
                    Expanded(child: last),
                  ],
                );
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[first, Gap(theme.spacing.md), last],
              );
            },
          ),
          Gap(theme.spacing.md),
          ShadcnFormField<String>(
            key: emailKey,
            label: const Text('Work email'),
            validator: const NotEmptyValidator() & const EmailValidator(),
            showErrors: _show,
            child: Input(
              hintText: 'ada@example.com',
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
            hint: const Text('At least 8 characters.'),
            validator:
                const NotEmptyValidator() & const LengthValidator(min: 8),
            showErrors: _show,
            child: Input(
              controller: passwordController,
              hintText: 'At least 8 characters',
              obscureText: true,
              textInputAction: TextInputAction.done,
              focusNode: passwordFocus,
              onSubmitted: (_) => onSubmit(),
            ),
          ),
          Gap(theme.spacing.sm),
          _Signup02Strength(password: password),
          Gap(theme.spacing.md),
          ShadcnFormField<CheckboxValue>(
            key: termsKey,
            label: const SizedBox.shrink(),
            validator: const _Signup02TermsValidator(),
            showErrors: _show,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Checkbox(value: terms, onChanged: onTermsChanged),
                Gap(theme.spacing.sm),
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 0,
                    children: <Widget>[
                      Text(
                        'I agree to the ',
                        style: theme.typography.textSmall.copyWith(
                          color: theme.colors.mutedForeground,
                        ),
                      ),
                      Button(
                        variant: ButtonVariant.link,
                        onPressed: () {},
                        child: const Text('terms'),
                      ),
                      Text(
                        ' and the ',
                        style: theme.typography.textSmall.copyWith(
                          color: theme.colors.mutedForeground,
                        ),
                      ),
                      Button(
                        variant: ButtonVariant.link,
                        onPressed: () {},
                        child: const Text('privacy policy'),
                      ),
                      Text(
                        '.',
                        style: theme.typography.textSmall.copyWith(
                          color: theme.colors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
                      const Text('Starting trial'),
                    ],
                  )
                : const Text('Start free trial'),
          ),
          if (succeeded) ...<Widget>[
            Gap(theme.spacing.lg),
            Alert(
              content: Text(
                'Trial started — check your inbox to verify it.',
                style: theme.typography.textSmall,
              ),
            ),
          ],
          Gap(theme.spacing.lg),
          const Divider(),
          Gap(theme.spacing.lg),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 4,
            children: <Widget>[
              Text(
                'Already have an account?',
                style: theme.typography.textSmall.copyWith(
                  color: theme.colors.mutedForeground,
                ),
              ),
              Button(
                variant: ButtonVariant.link,
                onPressed: onSignIn ?? () {},
                child: const Text('Sign in'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Fails unless the terms checkbox is checked.
class _Signup02TermsValidator extends Validator<CheckboxValue> {
  const _Signup02TermsValidator();

  @override
  FutureOr<ValidationResult?> validate(
    BuildContext context,
    CheckboxValue? value,
    FormValidationMode lifecycle,
  ) {
    if (value == CheckboxValue.checked) {
      return null;
    }
    return InvalidResult(
      'You must accept the terms to continue.',
      state: lifecycle,
    );
  }
}

/// A four-step strength meter wired to the password field; filled segments
/// use the primary token so the meter re-themes with every preset.
class _Signup02Strength extends StatelessWidget {
  const _Signup02Strength({required this.password});

  final String password;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final int score = password.isEmpty ? 0 : passwordStrength(password);
    const List<String> labels = <String>[
      'Enter a password',
      'Weak',
      'Fair',
      'Good',
      'Strong',
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            for (var i = 0; i < 4; i++) ...<Widget>[
              Expanded(
                child: Container(
                  height: theme.spacing.xs,
                  decoration: BoxDecoration(
                    color: i < score
                        ? theme.colors.primary
                        : theme.colors.muted,
                    borderRadius: theme.borderRadiusXl,
                  ),
                ),
              ),
              if (i < 3) Gap(theme.spacing.sm),
            ],
          ],
        ),
        Gap(theme.spacing.sm),
        Text(
          labels[score],
          style: theme.typography.xSmall.copyWith(
            color: theme.colors.mutedForeground,
          ),
        ),
      ],
    );
  }
}
''',
      tokenClasses:
          'cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccppkkkkkkpsssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppppppppppppppppppppppppppppppppppppkkkppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppsssssssspppppppppppppppppppppppppppppppppppppssssssssppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppsssssppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppssssssssppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkppppppppppppppkkkkkkkpppppppppppppppppppppccccccccccccccccccccccccccccpppkkkkkppppppppppppppppppppkkkkkppppppppppkkkkkkkkpkkkkpppppppppppppppppkkkkkkkkpkkkkppppppppppppppppppppkkkkkkkkpkkkkpppppppppppppppppppkkkkkkkkpkkkkppppppppppppppppppkkkkkkkkpkkkkpppppppppppppppkkkkkkkkpkkkkppppppppppppppppppkkkkkkkkpkkkkpppppppppppppppkkkkkkkkpkkkkpppppppppppppppppppppkkkkkkkkpkkkkppppppppppppppppppppkkkkkkkkpkkkkpppppppppppppppppkkkkkkkkpkkkkppppppppppppppppppppkkkkkkkkpkkkkpppppppppppppppppppppppppkkkkkkkkpkkkkpppppppppppppppkkkkkkkkpkkkkppppppppppppkkkkkkkkpkkkkpppppppppppppppppppppkkkkkkkkpkkkkpppppppppppppppppkkkkkkkkpkkkkppppppppppppppppkkkkkkkkpkkkkpppppppppppppppkkkkkkkkpkkkkppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppkkkkkppppppppppppppppppppkkkkkppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppkkkkkpppppppppppppppppppkkkkkppppppppkkkkppkkkkkkkkpppppppppppppppkkkkkppppppppppppppppppppppppppppkkkkkkpkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccpppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssspppppppppppppppppppppkkkkkppppppssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssspppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssssssssppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssssssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppppppppppppppppppkkkkkkkppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppkkkkkkpkkkkppppppppppppkkkkkkppppppppppppppppppppppssssssssssssssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppkkkkkkkkpkkkkppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppssssssssssssssssssppppppppssssssppppppppssssssppppppppssssssppppppppsssssssspppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'calendar-01': <DocsBlockFile>[
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/calendar-01/calendar_01.dart',
      code: r'''// The `calendar-01` block: a date-range picker card.
//
// A block is layer 4 of the registry: it may import foundation, theme,
// primitives and components, never another block. Its public widget is the
// preview - the docs page renders it exactly as an app would.
//
// A two-month range calendar (one month on a phone), a live range summary
// and footer actions. `Calendar` owns no navigation, so the block drives the
// `CalendarView` itself. The card is capped at 720px and centres itself; the
// content shrink-wraps so the docs frame sizes to its intrinsic height, and
// scrolls internally when the host is bounded.

import 'package:flutter/widgets.dart';

import '../../components/button/button.dart';
import '../../components/calendar/calendar.dart';
import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../primitives/date_math.dart';
import '../../theme/theme.dart';

/// A date-range card: the calendar, a range summary and footer actions.
class Calendar01 extends StatefulWidget {
  /// Creates the block.
  const Calendar01({super.key, this.onApply, this.onClear});

  /// Called with the current range when Apply is tapped.
  final ValueChanged<CalendarValue?>? onApply;

  /// Called when Clear resets the selection.
  final VoidCallback? onClear;

  @override
  State<Calendar01> createState() => _Calendar01State();
}

class _Calendar01State extends State<Calendar01> {
  CalendarView _view = const CalendarView(2026, 10);
  CalendarValue? _value;

  void _shift(int months) {
    setState(() => _view = months < 0 ? _view.previous : _view.next);
  }

  void _clear() {
    setState(() => _value = null);
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final Widget body = Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Card(
          padding: EdgeInsets.all(theme.spacing.lg),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool twoMonths = constraints.maxWidth >= 720;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _Calendar01Header(
                    view: _view,
                    twoMonths: twoMonths,
                    onShift: _shift,
                  ),
                  Gap(theme.spacing.lg),
                  if (twoMonths)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: _Calendar01Month(
                            view: _view,
                            value: _value,
                            onChanged: (CalendarValue? value) =>
                                setState(() => _value = value),
                          ),
                        ),
                        Gap(theme.spacing.xl),
                        Expanded(
                          child: _Calendar01Month(
                            view: _view.next,
                            value: _value,
                            onChanged: (CalendarValue? value) =>
                                setState(() => _value = value),
                          ),
                        ),
                      ],
                    )
                  else
                    _Calendar01Month(
                      view: _view,
                      value: _value,
                      onChanged: (CalendarValue? value) =>
                          setState(() => _value = value),
                    ),
                  Gap(theme.spacing.lg),
                  const Divider(),
                  Gap(theme.spacing.lg),
                  _Calendar01Footer(
                    value: _value,
                    onClear: _clear,
                    onApply: () => widget.onApply?.call(_value),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
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

class _Calendar01Header extends StatelessWidget {
  const _Calendar01Header({
    required this.view,
    required this.twoMonths,
    required this.onShift,
  });

  final CalendarView view;
  final bool twoMonths;
  final ValueChanged<int> onShift;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final String months = twoMonths
        ? '${_monthName(view.month)} - ${_monthName(view.next.month)} '
              '${view.next.year}'
        : '${_monthName(view.month)} ${view.year}';
    return Row(
      children: <Widget>[
        Expanded(child: Text(months, style: theme.typography.textLarge)),
        Gap(theme.spacing.md),
        _Calendar01Step(
          icon: LucideIcons.chevronLeft,
          onPressed: () => onShift(-1),
        ),
        Gap(theme.spacing.sm),
        _Calendar01Step(
          icon: LucideIcons.chevronRight,
          onPressed: () => onShift(1),
        ),
      ],
    );
  }
}

class _Calendar01Step extends StatelessWidget {
  const _Calendar01Step({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Button(
      variant: ButtonVariant.ghost,
      size: ButtonSize.icon,
      onPressed: onPressed,
      child: Icon(icon, size: 16),
    );
  }
}

class _Calendar01Month extends StatelessWidget {
  const _Calendar01Month({
    required this.view,
    required this.value,
    required this.onChanged,
  });

  final CalendarView view;
  final CalendarValue? value;
  final ValueChanged<CalendarValue?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Calendar(
      view: view,
      now: DateTime(2026, 10, 10),
      selectionMode: CalendarSelectionMode.range,
      value: value,
      onChanged: onChanged,
    );
  }
}

class _Calendar01Footer extends StatelessWidget {
  const _Calendar01Footer({
    required this.value,
    required this.onClear,
    required this.onApply,
  });

  final CalendarValue? value;
  final VoidCallback onClear;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            _summary(value),
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
        ),
        Gap(theme.spacing.md),
        Button(
          variant: ButtonVariant.outline,
          onPressed: onClear,
          child: const Text('Clear'),
        ),
        Gap(theme.spacing.sm),
        Button(onPressed: onApply, child: const Text('Apply')),
      ],
    );
  }
}

/// The live range summary for the footer.
String _summary(CalendarValue? value) {
  final CalendarValue? current = value;
  if (current is RangeCalendarValue) {
    final int nights = current.end.difference(current.start).inDays;
    if (nights <= 0) {
      return 'Same-day stay';
    }
    return 'Your stay: $nights night${nights == 1 ? '' : 's'}';
  }
  if (current is SingleCalendarValue) {
    return 'Picked ${_monthName(current.date.month)} ${current.date.day} — '
        'extend it into a range';
  }
  return 'Pick a date range';
}

String _monthName(int month) => switch (month) {
  1 => 'January',
  2 => 'February',
  3 => 'March',
  4 => 'April',
  5 => 'May',
  6 => 'June',
  7 => 'July',
  8 => 'August',
  9 => 'September',
  10 => 'October',
  11 => 'November',
  12 => 'December',
  _ => 'Month $month',
};
''',
      tokenClasses:
          'cccccccccccccccccccccccccccccccccccccccccccccccccccccpccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpssssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkppppppppppppkkkkkkkppppppppppppppppppppccccccccccccccccccccccpppkkkkkpppppppppppppkkkkkppppppkkkkppppppppppkkkkpppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppkkkkkkkppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppppkkkkkkkkpkkkkpppppppppppkkkkkkkkpkkkkppppppppppppppppkkkkkkkkpkkkkpppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkpppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppspppppppppppppppppppppppppsssppppppppppppppppppppppppppppppsspppppppppppppppspppppppppppppppppspppppppppppspppppppppppppppppppppppppsppppppppppppsppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppkkkkkkkkpkkkkpppppppkkkkkkkkpkkkkpppppppppppppppppkkkkkppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppkkkkkkkkpkkkkpppppppppppkkkkkkkkpkkkkppppppppppppkkkkkkkkpkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkpppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppppkkkkkkkkpkkkkppppppppppppkkkkkkkkpkkkkppppppppppppppkkkkkkkkpkkkkpppppppppppppppppppkkkkkpppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssspppppppppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccpppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppkkppppppppppkkpppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppkkkkkkpsssssssssssssssppppppppppppkkkkkkpsssssssssssspppppppssssssppppppppppppppppsspppssspsppppppppkkppppppppppkkppppppppppppppppppppppppppppkkkkkkpsssssssspppppppppppppppppppppppppppppppppspppppppppppppppppppsssspppppppppssssssssssssssssssssssssppppppppkkkkkkpssssssssssssssssssspppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppssssssssspppppppppsssssssssspppppppppssssssspppppppppssssssspppppppppssssspppppppppsssssspppppppppsssssspppppppppsssssssspppppppppsssssssssssppppppppppsssssssssppppppppppssssssssssppppppppppsssssssssspppppppppsssssssppppppsppppp',
    ),
  ],
  'calendar-02': <DocsBlockFile>[
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/calendar-02/calendar_02.dart',
      code: r'''// The `calendar-02` block: a scheduling panel.
//
// A block is layer 4 of the registry: it may import foundation, theme,
// primitives and components, never another block. Its public widget is the
// preview - the docs page renders it exactly as an app would.
//
// A month calendar with the selected day's agenda beside it (below 960px the
// agenda moves under the calendar). Time slots are selectable buttons; the
// Book action enables once a slot is picked. The content shrink-wraps so the
// docs frame sizes to its intrinsic height, and scrolls internally when the
// host is bounded.

import 'package:flutter/widgets.dart';

import '../../components/button/button.dart';
import '../../components/calendar/calendar.dart';
import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../primitives/date_math.dart';
import '../../theme/theme.dart';

/// A scheduling panel: a month calendar and the selected day's agenda.
class Calendar02 extends StatefulWidget {
  /// Creates the block.
  const Calendar02({super.key, this.onBook});

  /// Called with the picked slot label when "Book a meeting" is tapped.
  final ValueChanged<String>? onBook;

  @override
  State<Calendar02> createState() => _Calendar02State();
}

class _Calendar02State extends State<Calendar02> {
  final DateTime _today = DateTime(2026, 10, 10);
  CalendarView _view = const CalendarView(2026, 10);
  CalendarValue? _value;
  String? _slot;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool aside = constraints.maxWidth >= 960;
            final Widget calendar = Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _Calendar02Header(
                    view: _view,
                    onPrevious: () => setState(() => _view = _view.previous),
                    onNext: () => setState(() => _view = _view.next),
                  ),
                  Gap(theme.spacing.lg),
                  Calendar(
                    view: _view,
                    now: _today,
                    selectionMode: CalendarSelectionMode.single,
                    value: _value,
                    onChanged: (CalendarValue? value) =>
                        setState(() => _value = value),
                  ),
                ],
              ),
            );
            final Widget agenda = _Calendar02Agenda(
              slot: _slot,
              onSlot: (String slot) => setState(() => _slot = slot),
              onBook: () {
                final String? picked = _slot;
                if (picked != null) {
                  widget.onBook?.call(picked);
                }
              },
            );
            final Widget body;
            if (!aside) {
              body = Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[calendar, Gap(theme.spacing.lg), agenda],
              );
            } else {
              body = Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1080),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(flex: 3, child: calendar),
                      Gap(theme.spacing.xl),
                      Expanded(flex: 2, child: agenda),
                    ],
                  ),
                ),
              );
            }
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

class _Calendar02Header extends StatelessWidget {
  const _Calendar02Header({
    required this.view,
    required this.onPrevious,
    required this.onNext,
  });

  final CalendarView view;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            '${_monthName(view.month)} ${view.year}',
            style: theme.typography.textLarge,
          ),
        ),
        Gap(theme.spacing.md),
        _Calendar02Step(icon: LucideIcons.chevronLeft, onPressed: onPrevious),
        Gap(theme.spacing.sm),
        _Calendar02Step(icon: LucideIcons.chevronRight, onPressed: onNext),
      ],
    );
  }
}

class _Calendar02Step extends StatelessWidget {
  const _Calendar02Step({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Button(
      variant: ButtonVariant.ghost,
      size: ButtonSize.icon,
      onPressed: onPressed,
      child: Icon(icon, size: 16),
    );
  }
}

class _Calendar02Agenda extends StatelessWidget {
  const _Calendar02Agenda({
    required this.slot,
    required this.onSlot,
    required this.onBook,
  });

  /// The picked slot label, or null when nothing is picked yet.
  final String? slot;
  final ValueChanged<String> onSlot;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text('Saturday, 10 October', style: theme.typography.h3),
          Gap(theme.spacing.sm),
          Text(
            slot == null
                ? 'Four slots left, 30 minutes each. Pick one.'
                : 'Picked $slot, 30 minutes.',
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          Gap(theme.spacing.lg),
          _Calendar02Slots(slot: slot, onSlot: onSlot),
          Gap(theme.spacing.lg),
          const Divider(),
          Gap(theme.spacing.lg),
          Text('Calendar link', style: theme.typography.textSmall),
          Gap(theme.spacing.sm),
          Text(
            'cal.acme.com/ada-lovelace/30min',
            style: theme.typography.inlineCode.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          Gap(theme.spacing.lg),
          // Explicit `enabled: false` while nothing is picked: the block
          // interactivity test whitelists explicit opt-outs on this block.
          Button(
            enabled: slot != null,
            onPressed: onBook,
            child: const Text('Book a meeting'),
          ),
        ],
      ),
    );
  }
}

class _Calendar02Slots extends StatelessWidget {
  const _Calendar02Slots({required this.slot, required this.onSlot});

  final String? slot;
  final ValueChanged<String> onSlot;

  @override
  Widget build(BuildContext context) {
    final double spacing = ShadcnTheme.of(context).spacing.sm;
    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: <Widget>[
        for (final _Calendar02SlotData data in const <_Calendar02SlotData>[
          _Calendar02SlotData('09:00', taken: true),
          _Calendar02SlotData('09:30'),
          _Calendar02SlotData('10:00', taken: true),
          _Calendar02SlotData('10:30'),
          _Calendar02SlotData('11:00'),
          _Calendar02SlotData('11:30', taken: true),
        ])
          _Calendar02Slot(
            time: data.time,
            taken: data.taken,
            selected: slot == data.time,
            onPressed: () => onSlot(data.time),
          ),
      ],
    );
  }
}

class _Calendar02SlotData {
  const _Calendar02SlotData(this.time, {this.taken = false});

  final String time;
  final bool taken;
}

class _Calendar02Slot extends StatelessWidget {
  const _Calendar02Slot({
    required this.time,
    required this.taken,
    required this.selected,
    required this.onPressed,
  });

  final String time;
  final bool taken;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Button(
      variant: taken
          ? ButtonVariant.outline
          : selected
          ? ButtonVariant.primary
          : ButtonVariant.secondary,
      enabled: !taken,
      onPressed: onPressed,
      child: Text(time, style: theme.typography.textSmall),
    );
  }
}

String _monthName(int month) => switch (month) {
  1 => 'January',
  2 => 'February',
  3 => 'March',
  4 => 'April',
  5 => 'May',
  6 => 'June',
  7 => 'July',
  8 => 'August',
  9 => 'September',
  10 => 'October',
  11 => 'November',
  12 => 'December',
  _ => 'Month $month',
};
''',
      tokenClasses:
          'cccccccccccccccccccccccccccccccccccccccccccccccpccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpssssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkppppppppppppkkkkkkkppppppppppppppppppppccccccccccccccccccccccpppkkkkkpppppppppppppkkkkkppppppkkkkppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppkkkkkkkpppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppkkppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppppkkkkkkkkpkkkkpppppppppppkkkkkkkkpkkkkpppppppppppppppppkkkkkkkkpkkkkppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppspppppppppppppppppppppppppsppppppppppppspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppkkkkkkkkpkkkkpppppppkkkkkkkkpkkkkpppppppppppppppppkkkkkppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppppkkkkkkkkpkkkkpppppppppppkkkkkkkkpkkkkpppppppppppppkkkkkkkkpkkkkppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppkkkkkppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppssssssssssssssssssssssssssssssssssssssssssssspppppppppppppppppppsssssssspppppsssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccppppppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppkkkkkkkkpkkkkpppppppkkkkkkkkpkkkkppppppppppppppkkkkkpppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkkkppppppppppppppppppppppppppkkpkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssspppppppppkkkkpppppppppppppppppppppppppppppppppssssssspppppppppppppppppppppppppppppppppssssssspppppppppkkkkpppppppppppppppppppppppppppppppppssssssspppppppppppppppppppppppppppppppppssssssspppppppppppppppppppppppppppppppppssssssspppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkkkppppppppkkkkpppppppppkkkkkpppppppkkkkkppppppppppppppppkkkkkppppppppppppppppkkkkkpppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppkkkkkkkkpkkkkpppppppppppkkkkkkkkpkkkkppppppppppppkkkkkkkkpkkkkpppppppppppppppkkkkkkkkpkkkkpppppppppppppppppppppkkkkkppppppppppppppppkkkkkpppppppppppppppkkkkkppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppssssssssspppppppppsssssssssspppppppppssssssspppppppppssssssspppppppppssssspppppppppsssssspppppppppsssssspppppppppsssssssspppppppppsssssssssssppppppppppsssssssssppppppppppssssssssssppppppppppsssssssssspppppppppsssssssppppppsppppp',
    ),
  ],
  'dashboard-01': <DocsBlockFile>[
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/dashboard-01/dashboard_01.dart',
      code: r'''// The `dashboard-01` block: an analytics dashboard.
//
// A block is layer 4 of the registry: it may import foundation, theme,
// primitives and components, never another block. Its public widget is the
// preview - the docs page renders it exactly as an app would.
//
// Stat tiles in a responsive grid (4 / 2 / 1 columns from the available
// width), a bar chart drawn from theme chart tokens and a recent-orders
// table with a working customer filter. The content shrink-wraps so the docs
// frame sizes to its intrinsic height, and scrolls internally when the host
// is bounded.

import 'package:flutter/widgets.dart';

import '../../components/avatar/avatar.dart';
import '../../components/button/button.dart';
import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import 'dashboard_01_table.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';

/// A dashboard: stat tiles, a twelve-week bar chart and a recent table.
class Dashboard01 extends StatelessWidget {
  /// Creates the block.
  const Dashboard01({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double contentWidth =
                constraints.maxWidth - theme.spacing.lg * 2;
            // Dashboards are full-width by design: no max-width cap here.
            final Widget body = Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const _Dashboard01Header(),
                Gap(theme.spacing.lg),
                _Dashboard01Stats(width: contentWidth),
                Gap(theme.spacing.lg),
                if (constraints.maxWidth >= 1080)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Expanded(flex: 3, child: _Dashboard01Chart()),
                      Gap(theme.spacing.lg),
                      const Expanded(flex: 2, child: _Dashboard01Activity()),
                    ],
                  )
                else ...<Widget>[
                  const _Dashboard01Chart(),
                  Gap(theme.spacing.lg),
                  const _Dashboard01Activity(),
                ],
                Gap(theme.spacing.lg),
                const Dashboard01Recent(),
              ],
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

class _Dashboard01Header extends StatelessWidget {
  const _Dashboard01Header();

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Overview', style: theme.typography.h2),
        Gap(theme.spacing.xs),
        Text(
          'Revenue, subscriptions and the most recent orders.',
          style: theme.typography.textMuted.copyWith(
            color: theme.colors.mutedForeground,
          ),
        ),
      ],
    );
  }
}

/// Stat tiles in a responsive grid: 4 columns from 1080px, 2 from 640px,
/// 1 below that. Every card gets an exact share of the available width, so
/// no tile is ever stretched or squeezed beyond its sensible width.
class _Dashboard01Stats extends StatelessWidget {
  const _Dashboard01Stats({required this.width});

  /// Width available to the grid, so each card gets an exact share.
  final double width;

  @override
  Widget build(BuildContext context) {
    final double spacing = ShadcnTheme.of(context).spacing.lg;
    const List<_Dashboard01Stat> stats = <_Dashboard01Stat>[
      _Dashboard01Stat('Total revenue', '\$45,231.89', '+20.1%'),
      _Dashboard01Stat('Subscriptions', '+2,350', '+180.1%'),
      _Dashboard01Stat('Sales', '+12,234', '+19.0%'),
      _Dashboard01Stat('Active now', '+573', '+2.0%'),
    ];
    final int columns = width >= 1080
        ? 4
        : width >= 640
        ? 2
        : 1;
    final double cardWidth = (width - spacing * (columns - 1)) / columns;
    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: <Widget>[
        for (final _Dashboard01Stat stat in stats)
          SizedBox(
            width: cardWidth,
            child: _Dashboard01StatCard(stat: stat),
          ),
      ],
    );
  }
}

class _Dashboard01Stat {
  const _Dashboard01Stat(this.label, this.value, this.delta);

  final String label;
  final String value;
  final String delta;
}

class _Dashboard01StatCard extends StatelessWidget {
  const _Dashboard01StatCard({required this.stat});

  final _Dashboard01Stat stat;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            stat.label,
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          Gap(theme.spacing.sm),
          Text(stat.value, style: theme.typography.h3),
          Gap(theme.spacing.sm),
          Text(
            '${stat.delta} from last month',
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

class _Dashboard01Chart extends StatelessWidget {
  const _Dashboard01Chart();

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    // One series, one token: every bar uses `chart1`, the way the
    // reference area chart fills a single series.
    const List<double> series = <double>[
      0.34,
      0.52,
      0.41,
      0.68,
      0.58,
      0.79,
      0.62,
      0.88,
      0.71,
      0.94,
      0.83,
      1.0,
    ];
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Revenue by month', style: theme.typography.textLarge),
          Gap(theme.spacing.xs),
          Text(
            'January - June 2026',
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          Gap(theme.spacing.lg),
          SizedBox(
            height: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                for (var i = 0; i < series.length; i++)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: theme.spacing.xs,
                      ),
                      child: Container(
                        height: 180 * series[i],
                        decoration: BoxDecoration(
                          color: theme.colors.chart1,
                          borderRadius: theme.borderRadiusSm,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Dashboard01Activity extends StatelessWidget {
  const _Dashboard01Activity();

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Recent sales', style: theme.typography.textLarge),
          Gap(theme.spacing.lg),
          const _Dashboard01Sale('Olivia Martin', '\$1,999.00'),
          Gap(theme.spacing.md),
          const _Dashboard01Sale('Jackson Lee', '\$39.00'),
          Gap(theme.spacing.md),
          const _Dashboard01Sale('Isabella Nguyen', '\$299.00'),
          Gap(theme.spacing.md),
          const _Dashboard01Sale('William Kim', '\$99.00'),
          Gap(theme.spacing.lg),
          const Divider(),
          Gap(theme.spacing.lg),
          Button(
            variant: ButtonVariant.outline,
            onPressed: () {},
            child: const Text('View all'),
          ),
        ],
      ),
    );
  }
}

class _Dashboard01Sale extends StatelessWidget {
  const _Dashboard01Sale(this.name, this.amount);

  final String name;
  final String amount;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Row(
      children: <Widget>[
        Avatar(initials: _Dashboard01Initials.of(name)),
        Gap(theme.spacing.md),
        Expanded(
          flex: 3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(name, style: theme.typography.textSmall),
              Gap(theme.spacing.xs),
              Text(
                '$amount - card',
                style: theme.typography.textSmall.copyWith(
                  color: theme.colors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Dashboard01Initials {
  const _Dashboard01Initials._();

  /// Two-letter initials for [name]; the second initial is dropped for a
  /// one-word name.
  static String of(String name) {
    final List<String> parts = name.split(' ');
    if (parts.length < 2) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
''',
      tokenClasses:
          'ccccccccccccccccccccccccccccccccccccccccccccccccccccpccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppppppkkkkkkkpppppppppppppppppppppccccccccccccccccccccccpppkkkkkppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppkkkkkkkkpkkkkpppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssppsssssssssssssppssssssssppppppppppppppppppppppppppsssssssssssssssppssssssssppsssssssssppppppppppppppppppppppppppsssssssppsssssssssppssssssssppppppppppppppppppppppppppssssssssssssppssssssppsssssssppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkkkpppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkppppppppppppppppppkkkkppppppppkkkkppppppppkkkkppppppppppppkkkkkpppppppppppppppppkkkkkpppppppppppppppppkkkkkppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppkkkkkkkkpkkkkppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppspppppppppppppssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppccccccccccccccccccccccccccccccccccccccccccccccpppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppsssssssssssssssppssssssssssssppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppsssssssssssssppsssssssssppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppsssssssssssssssssppssssssssssppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppsssssssssssssppsssssssssppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppkkkkpppppppkkkkpppppppppppppkkkkkppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppspppppppsssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppccccccccccccccccccpppkkkkkkppppppppkkppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppssspppppppkkppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpspppppppppppppppppppppppppppppppppspppppppppppppppppppppp',
    ),
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/dashboard-01/dashboard_01_table.dart',
      code:
          r'''// The `dashboard-01` block, part 2: the recent-transactions table and the
// status pill it uses. Imported by `dashboard_01.dart`; a block never imports
// another block.

import 'package:flutter/widgets.dart';

import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import '../../components/input/input.dart';
import '../../components/table/table.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';

class _Dashboard01Order {
  const _Dashboard01Order(this.customer, this.status, this.method, this.amount);

  final String customer;
  final String status;
  final String method;
  final String amount;

  /// Index into `theme.colors.chartColors` for the status pill.
  int get chartIndex => switch (status) {
    'Paid' => 1,
    'Pending' => 2,
    _ => 0,
  };
}

const List<_Dashboard01Order> _dashboard01Orders = <_Dashboard01Order>[
  _Dashboard01Order('Olivia Martin', 'Paid', 'Visa', '\$1,999.00'),
  _Dashboard01Order('Jackson Lee', 'Pending', 'Mastercard', '\$39.00'),
  _Dashboard01Order('Isabella Nguyen', 'Refunded', 'PayPal', '\$299.00'),
  _Dashboard01Order('William Kim', 'Paid', 'Visa', '\$99.00'),
  _Dashboard01Order('Sofia Davis', 'Paid', 'Amex', '\$499.00'),
];

/// Recent transactions with a working customer filter.
class Dashboard01Recent extends StatefulWidget {
  /// Creates the table card.
  const Dashboard01Recent({super.key});

  @override
  State<Dashboard01Recent> createState() => _Dashboard01RecentState();
}

class _Dashboard01RecentState extends State<Dashboard01Recent> {
  String _filter = '';

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final String needle = _filter.trim().toLowerCase();
    final List<_Dashboard01Order> rows = needle.isEmpty
        ? _dashboard01Orders
        : _dashboard01Orders
              .where(
                (_Dashboard01Order order) =>
                    order.customer.toLowerCase().contains(needle),
              )
              .toList();
    return Card(
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(theme.spacing.lg),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final Widget filter = SizedBox(
                  width: 220,
                  child: Input(
                    hintText: 'Filter transactions',
                    onChanged: (String value) =>
                        setState(() => _filter = value),
                  ),
                );
                // The title and the 220px filter share one row from 560px;
                // below that the filter takes its own row instead of
                // squeezing the title off-screen.
                if (constraints.maxWidth >= 560) {
                  return Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Transactions',
                          style: theme.typography.textLarge,
                        ),
                      ),
                      Gap(theme.spacing.lg),
                      filter,
                    ],
                  );
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text('Transactions', style: theme.typography.textLarge),
                    Gap(theme.spacing.md),
                    filter,
                  ],
                );
              },
            ),
          ),
          const Divider(),
          if (rows.isEmpty)
            Padding(
              padding: EdgeInsets.all(theme.spacing.xl),
              child: Text(
                'No transactions match "$_filter".',
                style: theme.typography.textSmall.copyWith(
                  color: theme.colors.mutedForeground,
                ),
              ),
            )
          else
            ShadcnTable(
              defaultRowHeight: const FixedTableSize(48),
              columnWidths: const <int, TableSize>{
                0: FlexTableSize(flex: 2),
                1: FlexTableSize(),
                2: FlexTableSize(),
                3: FixedTableSize(110),
              },
              rows: <ShadcnTableRow>[
                const ShadcnTableHeader(
                  cells: <ShadcnTableCell>[
                    ShadcnTableCell(child: Text('Customer')),
                    ShadcnTableCell(child: Text('Status')),
                    ShadcnTableCell(child: Text('Method')),
                    ShadcnTableCell(child: Text('Amount')),
                  ],
                ),
                for (final _Dashboard01Order order in rows)
                  ShadcnTableRow(
                    cells: <ShadcnTableCell>[
                      ShadcnTableCell(child: Text(order.customer)),
                      ShadcnTableCell(
                        child: _Dashboard01Pill(
                          order.status,
                          chartIndex: order.chartIndex,
                        ),
                      ),
                      ShadcnTableCell(child: Text(order.method)),
                      ShadcnTableCell(child: Text(order.amount)),
                    ],
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

/// A status pill: a chart-token tint on a transparent fill, so it re-themes
/// with the preset instead of hard-coding a colour.
class _Dashboard01Pill extends StatelessWidget {
  const _Dashboard01Pill(this.label, {required this.chartIndex});

  final String label;

  /// Index into `theme.colors.chartColors`.
  final int chartIndex;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.sm,
        vertical: theme.spacing.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colors.chartColors[chartIndex % 5].withValues(alpha: 0.16),
        borderRadius: theme.borderRadiusXl,
        border: Border.all(color: theme.colors.chartColors[chartIndex % 5]),
      ),
      child: Text(
        label,
        style: theme.typography.xSmall.copyWith(
          color: theme.colors.foreground,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
''',
      tokenClasses:
          'ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppkkkkkpppppppppppppppppppppppkkkkkpppppppppppppppppppkkkkpppppppppppkkkkpppppppppkkkkpppppppppkkkkpppppppppppppkkkkkppppppppppppppppppppkkkkkppppppppppppppppppkkkkkppppppppppppppppppkkkkkpppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppkkkpppppppppppppppkkkkkkppppppppppppppppsssssspppppppppppssssssssspppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssppssssssppssssssppsssssssssssspppppppppppppppppppppppsssssssssssssppsssssssssppssssssssssssppssssssssspppppppppppppppppppppppsssssssssssssssssppssssssssssppssssssssppsssssssssspppppppppppppppppppppppsssssssssssssppssssssppssssssppssssssssspppppppppppppppppppppppsssssssssssssppssssssppssssssppsssssssssspppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppppppppppppkkkkkkkppppppppppppppppppppcccccccccccccccccccccccccccpppkkkkkppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppkkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppppppppppccccccccccccccccccccccccccccccccccpppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssppppppppssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkkkpppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppkkkkpppppppppkkkkkkkkpkkkkppppppppppppppppppkkkkkppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'dashboard-02': <DocsBlockFile>[
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/dashboard-02/dashboard_02.dart',
      code: r'''// The `dashboard-02` block: an analytics workspace.
//
// A wider companion to `dashboard-01`: a filter row, a chart card with a
// legend, a device split and a traffic-source list. Breakpoints come from
// `LayoutBuilder`, so the grid collapses from four columns to one.

import 'package:flutter/widgets.dart';

import '../../components/button/button.dart';
import '../../components/card/card.dart';
import '../../components/input/input.dart';
import 'dashboard_02_sections.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';

/// An analytics workspace: chart, device split and traffic sources.
class Dashboard02 extends StatelessWidget {
  /// Creates the block.
  const Dashboard02({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final int columns = constraints.maxWidth >= 1080
                ? 4
                : constraints.maxWidth >= 640
                ? 2
                : 1;
            // Dashboards are full-width by design: no max-width cap here.
            final Widget body = Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const _Dashboard02Filters(),
                Gap(theme.spacing.lg),
                _Dashboard02Tiles(
                  columns: columns,
                  width: constraints.maxWidth - theme.spacing.lg * 2,
                ),
                Gap(theme.spacing.lg),
                const Dashboard02Chart(),
                Gap(theme.spacing.lg),
                if (constraints.maxWidth >= 1080)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Expanded(child: Dashboard02Sources()),
                      Gap(theme.spacing.lg),
                      const Expanded(flex: 2, child: Dashboard02Devices()),
                    ],
                  )
                else ...<Widget>[
                  const Dashboard02Sources(),
                  Gap(theme.spacing.lg),
                  const Dashboard02Devices(),
                ],
              ],
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

class _Dashboard02Filters extends StatelessWidget {
  const _Dashboard02Filters();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Analytics', style: theme.typography.h2),
        Gap(spacing.xs),
        Text(
          'Sessions, devices and where the traffic came from.',
          style: theme.typography.textMuted.copyWith(
            color: theme.colors.mutedForeground,
          ),
        ),
        Gap(spacing.lg),
        Wrap(
          spacing: spacing.md,
          runSpacing: spacing.md,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            const SizedBox(
              width: 240,
              child: Input(hintText: 'Search reports'),
            ),
            Button(
              variant: ButtonVariant.outline,
              onPressed: () {},
              child: const Text('Last 30 days'),
            ),
            Button(
              variant: ButtonVariant.outline,
              onPressed: () {},
              child: const Text('All devices'),
            ),
            Button(onPressed: () {}, child: const Text('Download')),
          ],
        ),
      ],
    );
  }
}

class _Dashboard02Tiles extends StatelessWidget {
  const _Dashboard02Tiles({required this.columns, required this.width});

  final int columns;

  /// Width available to the grid, so each card gets an exact share.
  final double width;

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    const List<_Dashboard02Tile> tiles = <_Dashboard02Tile>[
      _Dashboard02Tile('Sessions', '12,480', 0.42),
      _Dashboard02Tile('Users', '8,910', 0.63),
      _Dashboard02Tile('Bounce rate', '38%', 0.38),
      _Dashboard02Tile('Avg. session', '2m 41s', 0.27),
    ];
    final double cardWidth = (width - spacing.lg * (columns - 1)) / columns;
    return Wrap(
      spacing: spacing.lg,
      runSpacing: spacing.lg,
      children: <Widget>[
        for (final tile in tiles)
          SizedBox(
            width: cardWidth,
            child: _Dashboard02TileCard(tile: tile),
          ),
      ],
    );
  }
}

class _Dashboard02Tile {
  const _Dashboard02Tile(this.label, this.value, this.fill);

  final String label;
  final String value;

  /// Ratio 0..1 drawn as a sparkline fill.
  final double fill;
}

class _Dashboard02TileCard extends StatelessWidget {
  const _Dashboard02TileCard({required this.tile});

  final _Dashboard02Tile tile;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            tile.label,
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          Gap(spacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(child: Text(tile.value, style: theme.typography.h3)),
              SizedBox(
                width: 64,
                height: 28,
                child: CustomPaint(
                  painter: _Dashboard02SparkPainter(
                    fill: tile.fill,
                    color: theme.colors.chart1,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A one-stroke sparkline; the block ships no data, so the shape is derived
/// from a single `fill` ratio instead of a series.
class _Dashboard02SparkPainter extends CustomPainter {
  const _Dashboard02SparkPainter({required this.fill, required this.color});

  final double fill;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final Path path = Path();
    for (var i = 0; i <= 6; i++) {
      final double t = i / 6;
      final double y =
          size.height - (size.height * fill * (0.35 + 0.65 * _wobble(t)));
      if (i == 0) {
        path.moveTo(size.width * t, y);
      } else {
        path.lineTo(size.width * t, y);
      }
    }
    canvas.drawPath(path, stroke);
  }

  double _wobble(double t) => 0.5 + 0.5 * _sin(t * 3.1);

  double _sin(double x) => x - x * x * x / 6;

  @override
  bool shouldRepaint(_Dashboard02SparkPainter oldDelegate) =>
      oldDelegate.fill != fill || oldDelegate.color != color;
}
''',
      tokenClasses:
          'ccccccccccccccccccccccccccccccccccccccccccccccccccccpccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppppppkkkkkkkpppppppppppppppppppppccccccccccccccccccccccpppkkkkkppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppkkkkkkkkpkkkkppppppppppkkkkkkkkpkkkkpppppppppppppkkkkkpppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppkkpppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssppssssssssppppppppppppppppppppppppppppppppsssssssppsssssssppppppppppppppppppppppppppppppppsssssssssssssppsssssppppppppppppppppppppppppppppppppssssssssssssssppssssssssppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkkkppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkppppppppppppppppppkkkkppppppppkkkkppppppppkkkkpppppppppppkkkkkpppppppppppppppppkkkkkppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppkkkkkppppppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppkkkkkkkkpkkkkppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkppppppppppppppppppppppppppkkkkkkkpppppppppppppppppppkkkkkpppppppppppppppppppppppppppkkkkkkkkpkkkkpppppppkkkkkkkkpkkkkpppppppppppppkkkkkppppppppppppppppkkkkkpppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppkkkppkkkpppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/dashboard-02/dashboard_02_sections.dart',
      code:
          r'''// The `dashboard-02` block, part 2: the chart, the traffic-source card, the
// device split and the tab strip. Imported by `dashboard_02.dart`; a block
// never imports another block.

import 'package:flutter/widgets.dart';

import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import '../../components/progress/progress.dart';
import '../../components/tabs/tabs.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';

class Dashboard02Chart extends StatelessWidget {
  const Dashboard02Chart({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    const List<double> series = <double>[
      0.28,
      0.45,
      0.36,
      0.62,
      0.51,
      0.74,
      0.60,
      0.86,
      0.70,
      0.93,
      0.78,
      1.0,
    ];
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text('Visitors', style: theme.typography.textLarge),
              ),
              const Spacer(),
              const _Dashboard02Legend('Desktop', 0),
              Gap(spacing.lg),
              const _Dashboard02Legend('Mobile', 1),
            ],
          ),
          Gap(spacing.lg),
          SizedBox(
            height: 220,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                for (var i = 0; i < series.length; i++)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: spacing.xs),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            height: 220 * series[i],
                            decoration: BoxDecoration(
                              // One series, one token (see dashboard-01).
                              color: theme.colors.chart1,
                              borderRadius: theme.borderRadiusSm,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Dashboard02Legend extends StatelessWidget {
  const _Dashboard02Legend(this.label, this.chartIndex);

  final String label;
  final int chartIndex;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Row(
      children: <Widget>[
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: theme.colors.chartColors[chartIndex],
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const Gap(0, crossAxisExtent: 6),
        Text(
          label,
          style: theme.typography.textSmall.copyWith(
            color: theme.colors.mutedForeground,
          ),
        ),
      ],
    );
  }
}

/// Traffic sources, each with a share bar.
class Dashboard02Sources extends StatelessWidget {
  /// Creates the traffic-source card.
  const Dashboard02Sources({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    const List<_Dashboard02Source> sources = <_Dashboard02Source>[
      _Dashboard02Source('Direct', 0.38),
      _Dashboard02Source('Search', 0.31),
      _Dashboard02Source('Referral', 0.19),
      _Dashboard02Source('Social', 0.12),
    ];
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Traffic sources', style: theme.typography.textLarge),
          Gap(spacing.lg),
          for (final source in sources) ...<Widget>[
            Text(source.label, style: theme.typography.textSmall),
            Gap(spacing.sm),
            Progress(value: source.share, height: spacing.xs),
            Gap(spacing.lg),
          ],
        ],
      ),
    );
  }
}

class _Dashboard02Source {
  const _Dashboard02Source(this.label, this.share);

  final String label;
  final double share;
}

/// Device split as three stacked progress rows.
class Dashboard02Devices extends StatelessWidget {
  /// Creates the device-split card.
  const Dashboard02Devices({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    const List<_Dashboard02Device> devices = <_Dashboard02Device>[
      _Dashboard02Device('Desktop', 0.52, 0),
      _Dashboard02Device('Mobile', 0.41, 1),
      _Dashboard02Device('Tablet', 0.07, 2),
    ];
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('By device', style: theme.typography.textLarge),
          Gap(spacing.lg),
          for (final device in devices) ...<Widget>[
            _Dashboard02DeviceRow(device: device),
            if (device != devices.last) Gap(spacing.lg),
          ],
          Gap(spacing.lg),
          const Divider(),
          Gap(spacing.lg),
          const Dashboard02Tabs(),
        ],
      ),
    );
  }
}

class _Dashboard02Device {
  const _Dashboard02Device(this.label, this.share, this.chartIndex);

  final String label;
  final double share;
  final int chartIndex;
}

class _Dashboard02DeviceRow extends StatelessWidget {
  const _Dashboard02DeviceRow({required this.device});

  final _Dashboard02Device device;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Flexible(
              child: Text(device.label, style: theme.typography.textSmall),
            ),
            const Spacer(),
            Text(
              '${(device.share * 100).round()}%',
              style: theme.typography.textSmall.copyWith(
                color: theme.colors.mutedForeground,
              ),
            ),
          ],
        ),
        Gap(spacing.sm),
        Progress(
          value: device.share,
          height: spacing.xs,
          color: theme.colors.chartColors[device.chartIndex],
        ),
      ],
    );
  }
}

/// A demo tab strip; the selection is local so taps visibly switch tabs.
class Dashboard02Tabs extends StatefulWidget {
  const Dashboard02Tabs({super.key});

  @override
  State<Dashboard02Tabs> createState() => _Dashboard02TabsState();
}

class _Dashboard02TabsState extends State<Dashboard02Tabs> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    // `Tabs` measures its strip at natural width; on a phone the three labels
    // do not fit, so the strip scrolls instead of overflowing.
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Tabs(
        index: _index,
        onChanged: (int value) => setState(() => _index = value),
        children: const <TabItem>[
          TabItem(child: Text('Overview')),
          TabItem(child: Text('Sessions')),
          TabItem(child: Text('Conversions')),
        ],
      ),
    );
  }
}
''',
      tokenClasses:
          'ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppkkkkkppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppkkkkkppppppppppppppppppppssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppkkkkppppppppkkkkpppppppppppppppppkkkkkpppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccpkkkkkppppppppppppppppppppkkkkkkkpppppppppppppppppppppccccccccccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssppppppppppppppppppppppppppppppppppssssssssppppppppppppppppppppppppppppppppppssssssssssppppppppppppppppppppppppppppppppppssssssssppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkkkpkkkkkkpkkppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppkkkkkppppppppppppppppppppkkkkppppppppkkkkppppppppppppkkkkkpppppppppppppppppkkkkkppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkppppppppppppppppppppkkkkkkkpppppppppppppppppppppccccccccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssspppppppppppppppppppppppppppppppppppppsssssssspppppppppppppppppppppppppppppppppppppsssssssspppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkkkppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppkkkkkppppppppppppppppppppkkkkppppppppkkkkppppppppkkkkpppppppppppppppppkkkkkpppppppppppppppppkkkkkpppppppppppppppppkkkkkppppppppppppppppppppkkkkkpppppppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppkkkkkkkkpkkkkppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppspppppppppppppppppppppppppppppppsspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppppppppppkkkkkkkppppppppppppppppppppkkkkkppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppkkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppssssssssssppppppppppppppppppppppppppppppppppssssssssssppppppppppppppppppppppppppppppppppsssssssssssssppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'pricing-01': <DocsBlockFile>[
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/pricing-01/pricing_01.dart',
      code:
          r'''// The `pricing-01` block: a marketing pricing section with a promo-code
// form.
//
// A block is layer 4 of the registry: it may import foundation, theme,
// primitives and components, never another block. Its public widget is the
// preview - the docs page renders it exactly as an app would.
//
// Three plans with a feature list and a highlighted middle tier. From 1080px
// the tiers sit side by side; below that they stack. The highlight uses the
// primary/ring tokens, so it survives a preset switch. The promo-code row is
// a real validated form: a 6-character code, an Apply button with loading,
// and a success alert.

import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../components/badge/badge.dart';
import '../../components/button/button.dart';
import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/theme.dart';
import 'pricing_01_promo.dart';

/// A pricing section: three plans, the middle one highlighted.
class Pricing01 extends StatelessWidget {
  /// Creates the block.
  const Pricing01({super.key, this.onSelectPlan, this.onApplyPromo});

  /// Called with the plan name when a plan button is tapped.
  final ValueChanged<String>? onSelectPlan;

  /// Called once with the typed values after a valid promo submit.
  final FutureOr<void> Function(Pricing01PromoData data)? onApplyPromo;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    // Align loosens the width: a bare ConstrainedBox under the scroll view
    // would receive tight width and its maxWidth cap would be clamped away.
    final Widget body = Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const _Pricing01Heading(),
            Gap(theme.spacing.xxl),
            _Pricing01Plans(onSelectPlan: onSelectPlan),
            Gap(theme.spacing.xxl),
            _Pricing01Faq(onApplyPromo: onApplyPromo),
          ],
        ),
      ),
    );
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
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

class _Pricing01Heading extends StatelessWidget {
  const _Pricing01Heading();

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Badge(
          variant: BadgeVariant.secondary,
          child: Text('Pricing', style: theme.typography.xSmall),
        ),
        Gap(theme.spacing.lg),
        Text(
          'Plans that scale with you',
          style: theme.typography.h2,
          textAlign: TextAlign.center,
        ),
        Gap(theme.spacing.sm),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Text(
            'Start free, upgrade when your team grows. Every plan includes '
            'the full component library and the theme presets.',
            textAlign: TextAlign.center,
            style: theme.typography.textMuted.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
        ),
      ],
    );
  }
}

class _Pricing01Plans extends StatelessWidget {
  const _Pricing01Plans({required this.onSelectPlan});

  final ValueChanged<String>? onSelectPlan;

  @override
  Widget build(BuildContext context) {
    final double spacing = ShadcnTheme.of(context).spacing.lg;
    const List<_Pricing01Plan> plans = <_Pricing01Plan>[
      _Pricing01Plan(
        name: 'Starter',
        price: '\$0',
        cadence: 'per user / month',
        features: <String>[
          'Up to 3 projects',
          'Community support',
          '1 theme preset',
        ],
        cta: 'Get started',
        highlighted: false,
      ),
      _Pricing01Plan(
        name: 'Pro',
        price: '\$20',
        cadence: 'per user / month',
        features: <String>[
          'Unlimited projects',
          'All 42 theme presets',
          'Blocks and charts',
          'Priority support',
        ],
        cta: 'Subscribe',
        highlighted: true,
      ),
      _Pricing01Plan(
        name: 'Enterprise',
        price: 'Custom',
        cadence: 'annual billing',
        features: <String>[
          'SSO and audit log',
          'Dedicated support',
          'Custom themes',
        ],
        cta: 'Contact sales',
        highlighted: false,
      ),
    ];
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 1080) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (final _Pricing01Plan plan in plans) ...<Widget>[
                _Pricing01Card(plan: plan, onSelectPlan: onSelectPlan),
                if (plan != plans.last) Gap(spacing),
              ],
            ],
          );
        }
        // IntrinsicHeight bounds the cross axis before the stretch Row sees
        // it: inside the block's own scroll view the height is unbounded and
        // a bare Row(stretch) hands its Gap separators a tight infinite
        // height, which asserts in debug builds. Cards keep equal heights.
        //
        // Under the unbounded docs frame the Row sizes to its tallest card;
        // IntrinsicHeight needs no bounded host, so this tree is safe both
        // ways. Gap has no intrinsic width contribution issue here because
        // the Row is bounded horizontally.
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              for (final _Pricing01Plan plan in plans) ...<Widget>[
                Expanded(
                  child: _Pricing01Card(plan: plan, onSelectPlan: onSelectPlan),
                ),
                if (plan != plans.last) Gap(spacing),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _Pricing01Plan {
  const _Pricing01Plan({
    required this.name,
    required this.price,
    required this.cadence,
    required this.features,
    required this.cta,
    required this.highlighted,
  });

  final String name;
  final String price;
  final String cadence;
  final List<String> features;
  final String cta;
  final bool highlighted;
}

class _Pricing01Card extends StatelessWidget {
  const _Pricing01Card({required this.plan, required this.onSelectPlan});

  final _Pricing01Plan plan;
  final ValueChanged<String>? onSelectPlan;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    // The highlight is a 2 px primary border on the default card fill, so
    // every text colour stays the card's own (primary-foreground on a card
    // fill would be unreadable after a preset switch).
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: theme.borderRadiusXl,
        border: Border.all(
          color: plan.highlighted ? theme.colors.primary : theme.colors.border,
          width: plan.highlighted ? 2 : 1,
        ),
      ),
      child: Card(
        borderRadius: BorderRadius.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(plan.name, style: theme.typography.textLarge),
                ),
                if (plan.highlighted)
                  Icon(
                    LucideIcons.sparkles,
                    size: 16,
                    color: theme.colors.primary,
                  ),
              ],
            ),
            Gap(theme.spacing.sm),
            Text(plan.price, style: theme.typography.h1),
            Gap(theme.spacing.xs),
            Text(
              plan.cadence,
              style: theme.typography.textSmall.copyWith(
                color: theme.colors.mutedForeground,
              ),
            ),
            Gap(theme.spacing.lg),
            const Divider(),
            Gap(theme.spacing.lg),
            _Pricing01Features(plan: plan),
            Gap(theme.spacing.xl),
            Button(
              variant: plan.highlighted
                  ? ButtonVariant.secondary
                  : ButtonVariant.outline,
              onPressed: () => onSelectPlan?.call(plan.name),
              child: Text(plan.cta),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pricing01Features extends StatelessWidget {
  const _Pricing01Features({required this.plan});

  final _Pricing01Plan plan;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (final String feature in plan.features) ...<Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(LucideIcons.check, size: 16, color: theme.colors.primary),
              Gap(theme.spacing.sm),
              Expanded(child: Text(feature, style: theme.typography.textSmall)),
            ],
          ),
          if (feature != plan.features.last) Gap(theme.spacing.md),
        ],
      ],
    );
  }
}

class _Pricing01Faq extends StatelessWidget {
  const _Pricing01Faq({required this.onApplyPromo});

  final FutureOr<void> Function(Pricing01PromoData data)? onApplyPromo;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text('Questions', style: theme.typography.h3),
        Gap(theme.spacing.lg),
        Wrap(
          spacing: theme.spacing.xl,
          runSpacing: theme.spacing.lg,
          alignment: WrapAlignment.center,
          children: const <Widget>[
            _Pricing01FaqItem(
              question: 'Can I change plans later?',
              answer: 'Yes. Upgrades apply immediately, downgrades next cycle.',
            ),
            _Pricing01FaqItem(
              question: 'Is there a free trial?',
              answer: 'Every plan starts with 14 days, no card required.',
            ),
          ],
        ),
        Gap(theme.spacing.xl),
        const Divider(),
        Gap(theme.spacing.xl),
        Pricing01PromoForm(onApplyPromo: onApplyPromo),
      ],
    );
  }
}

class _Pricing01FaqItem extends StatelessWidget {
  const _Pricing01FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(question, style: theme.typography.textSmall),
          Gap(theme.spacing.sm),
          Text(
            answer,
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}
''',
      tokenClasses:
          'ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccpccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccppkkkkkkpsssssssssssspppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpssssssssssssssssssssssssssssssssssssssssssppkkkkkkpssssssssssssssssssssssssppkkkkkkpssssssssssssssssssssssspppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppppkkkkkkkpppppppppppppppppppppccccccccccccccccccccccpppkkkkkppppppppppppkkkkkppppppkkkkpppppppppppppppkkkkppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppkkkkkppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppkkkkkppppppppppkkkkppkkkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssspppppppppppppsssssssssssssssssssssssssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppkkkkkkkkpkkkkppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssspppppppppppppppppssssspppppppppppppppppppssssssssssssssssssppppppppppppppppppppppppppppppppppppppppssssssssssssssssssppppppppppppsssssssssssssssssssppppppppppppssssssssssssssssppppppppppppppppppppppppppssssssssssssspppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppssssspppppppppppppppppsssssspppppppppppppppppppssssssssssssssssssppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssppppppppppppssssssssssssssssssssssppppppppppppsssssssssssssssssssppppppppppppssssssssssssssssssppppppppppppppppppppppppppssssssssssspppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppsssssssssssspppppppppppppppppsssssssspppppppppppppppppppssssssssssssssssppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssppppppppppppsssssssssssssssssssppppppppppppsssssssssssssssppppppppppppppppppppppppppssssssssssssssspppppppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkkkpppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppccpppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppcccccccccccccccccccccccccccccccccccpppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkkkpppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkkkkpkkkkpppppppppppkkkkkkkkpkkkkppppppppppppkkkkkkkkpkkkkppppppppppppppkkkkkkkkpkkkkpppppppppppppppkkkkkkkkpkkkkppppppppppkkkkkkkkpkkkkpppppppppppppppppppppppkkkkkppppppppppppppppkkkkkpppppppppppppppppkkkkkpppppppppppppppppppkkkkkppppppppppppppppppppppppppkkkkkpppppppppppppppkkkkkppppppppppppppppppppppkkkkkppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppkkkkkkkkpkkkkpppppppkkkkkkkkpkkkkppppppppppppppppppppkkkkkppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppcccccccccccccccccccccccccccccccccccccccccccccccccccpppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppkkkkkkkkpkkkkppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkkkppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppkkkkkkkkpkkkkppppppppppppppppppppkkkkkppppppppppkkkkppkkkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssssssssppppppppppppppppppppppppsssssssssssssssssssssssssssssssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssppppppppppppppppppppppppsssssssssssssssssssssssssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppkkkkkkkkpkkkkpppppppppppkkkkkkkkpkkkkppppppppppppppkkkkkppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/pricing-01/pricing_01_promo.dart',
      code:
          r'''// The `pricing-01` block, part 2: the validated promo-code form.
//
// Imported by `pricing_01.dart`; a block never imports another block.

import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../components/alert/alert.dart';
import '../../components/button/button.dart';
import '../../components/form/form.dart';
import '../../components/input_otp/input_otp.dart';
import '../../components/spinner/spinner.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';

/// Values submitted by the [Pricing01PromoForm] promo-code form.
class Pricing01PromoData {
  /// Creates the submitted values.
  const Pricing01PromoData({required this.code});

  /// The validated 6-character promo code.
  final String code;
}

/// The promo-code form: a validated 6-character code with an Apply action.
class Pricing01PromoForm extends StatefulWidget {
  /// Creates the promo-code form.
  const Pricing01PromoForm({super.key, required this.onApplyPromo});

  /// Called once with the typed values after a valid submit.
  final FutureOr<void> Function(Pricing01PromoData data)? onApplyPromo;

  @override
  State<Pricing01PromoForm> createState() => _Pricing01PromoFormState();
}

class _Pricing01PromoFormState extends State<Pricing01PromoForm> {
  static final Validator<String> _codeValidator =
      const NotEmptyValidator() &
      const LengthValidator(min: 6, max: 6) &
      RegexValidator(RegExp(r'^[A-Za-z0-9]{6}$'));

  final FormController _controller = FormController();
  final FormKey<String> _codeKey = const FormKey<String>('promoCode');
  bool _submitting = false;
  bool _succeeded = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _apply() async {
    if (_submitting) {
      return;
    }
    setState(() {
      _submitting = true;
      _succeeded = false;
    });
    try {
      await _controller.submit(context);
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  Future<void> _handleValidSubmit(FormMapValues values) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final Pricing01PromoData data = Pricing01PromoData(
      code: values.getValue(_codeKey) ?? '',
    );
    await widget.onApplyPromo?.call(data);
    if (!mounted) {
      return;
    }
    setState(() => _succeeded = true);
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 384),
      child: ShadcnForm(
        controller: _controller,
        onSubmit: _handleValidSubmit,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Have a code? Enter it below.',
              textAlign: TextAlign.center,
              style: theme.typography.textSmall.copyWith(
                color: theme.colors.mutedForeground,
              ),
            ),
            Gap(theme.spacing.md),
            ShadcnFormField<String>(
              key: _codeKey,
              label: const Text('Promo code'),
              validator: _codeValidator,
              showErrors: const <FormValidationMode>{
                FormValidationMode.changed,
                FormValidationMode.submitted,
              },
              child: InputOtp(
                length: 6,
                keyboardType: TextInputType.text,
                onSubmitted: (_) => _apply(),
              ),
            ),
            Gap(theme.spacing.lg),
            Button(
              variant: ButtonVariant.outline,
              onPressed: _submitting ? null : _apply,
              child: _submitting
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Spinner(size: 14, color: theme.colors.foreground),
                        Gap(theme.spacing.sm),
                        const Text('Applying'),
                      ],
                    )
                  : const Text('Apply code'),
            ),
            if (_succeeded) ...<Widget>[
              Gap(theme.spacing.lg),
              Alert(
                content: Text(
                  'Code applied — your discount shows at checkout.',
                  style: theme.typography.textSmall,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
''',
      tokenClasses:
          'cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccppkkkkkkpsssssssssssspppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkppppppppppppppppppppppppcccccccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppppkkkkkkkkpkkkkppppppppppppcccccccccccccccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkppppppppppppppppppppkkkkkkkppppppppppppppppppppccccccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppppkkkkkppppppkkkkkkkkpkkkkppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppkkkkkppppppppppkkkkppkkkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppkkkkkkkpppppppppppppppppppppppppppppppkkkkkkpkkkkkppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssspppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppkkkkkpppppppppppppppppsssssssssssppppppppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkpppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppkkkkpppppppppppkkkkkpppppppkkpppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppkkkkkppppppppppppppkkkpppppppppkkkkkppppppppppppppppppppppppppppppppppppkkkkkkkpppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppkkkkkppppppppkkkkppppppppppkkkkkpppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsspppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'account-01': <DocsBlockFile>[
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/account-01/account_01.dart',
      code:
          r'''// The `account-01` block: an account settings screen with validated forms.
//
// A block is layer 4 of the registry: it may import foundation, theme,
// primitives and components, never another block. Its public widget is the
// preview - the docs page renders it exactly as an app would.
//
// The shell is capped at 768px (max-w-3xl). The Profile tab is a validated
// form (name, username pattern, bio max length) in an equal-width 2-column
// grid that collapses to one column below 560px; the Password tab is a
// validated password-change form with a confirm-match check; the Team tab is
// a member list. The content shrink-wraps so the docs frame sizes to its
// intrinsic height, and scrolls internally when the host is bounded.

import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../components/tabs/tabs.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';
import 'account_01_password.dart';
import 'account_01_profile.dart';
import 'account_01_team.dart';

/// Values submitted by the [Account01] profile form.

/// An account settings screen: tabbed profile, password and team sections.
class Account01 extends StatefulWidget {
  /// Creates the block.
  const Account01({
    super.key,
    this.onSubmitProfile,
    this.onSubmitPassword,
    this.onUploadAvatar,
    this.onInvite,
  });

  /// Called once with the typed values after a valid profile submit.
  final FutureOr<void> Function(Account01ProfileData data)? onSubmitProfile;

  /// Called once with the typed values after a valid password submit.
  final FutureOr<void> Function(Account01PasswordData data)? onSubmitPassword;

  /// Called when "Upload image" is tapped.
  final VoidCallback? onUploadAvatar;

  /// Called when "Invite member" is tapped.
  final VoidCallback? onInvite;

  @override
  State<Account01> createState() => _Account01State();
}

class _Account01State extends State<Account01> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    // Align loosens the width: a bare ConstrainedBox under the scroll view
    // would receive tight width and its maxWidth cap would be clamped away.
    final Widget body = Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 768),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Settings', style: theme.typography.h2),
            Gap(theme.spacing.xs),
            Text(
              'Manage your account settings and set your email preferences.',
              style: theme.typography.textMuted.copyWith(
                color: theme.colors.mutedForeground,
              ),
            ),
            Gap(theme.spacing.lg),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Tabs(
                index: _tab,
                onChanged: (int value) => setState(() => _tab = value),
                children: const <TabItem>[
                  TabItem(child: Text('Profile')),
                  TabItem(child: Text('Password')),
                  TabItem(child: Text('Team')),
                ],
              ),
            ),
            Gap(theme.spacing.lg),
            switch (_tab) {
              0 => Account01ProfileForm(
                onSubmit: widget.onSubmitProfile,
                onUploadAvatar: widget.onUploadAvatar,
              ),
              1 => Account01PasswordForm(onSubmit: widget.onSubmitPassword),
              _ => Account01Team(onInvite: widget.onInvite),
            },
          ],
        ),
      ),
    );
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
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
''',
      tokenClasses:
          'cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccppkkkkkkpsssssssssssspppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpssssssssssssssssssssssssppkkkkkkpssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssspppcccccccccccccccccccccccccccccccccccccccccccccccccccccppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppppkkkkkkkppppppppppppppppppppccccccccccccccccccccccpppkkkkkpppppppppppppppppkkkkkppppppppppkkkkppppppppppppppppppppppkkkkpppppppppppppppppppppppkkkkpppppppppppppppppppppkkkkppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppkkkkkppppppppppkkkkppkkkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppkkkkkppppppppppkkkkppkkkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccpppkkkkkppppppppppppppppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccpppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppkkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssppppppppppppppppppppppppppppppppppppppppppssssssssssppppppppppppppppppppppppppppppppppppppppppssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/account-01/account_01_password.dart',
      code:
          r'''// The `account-01` block, part 2: the validated password-change form.
//
// Imported by `account_01.dart`; a block never imports another block.

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
import '../../theme/theme.dart';

/// Values submitted by the [Account01PasswordForm] password form.
class Account01PasswordData {
  /// Creates the submitted values.
  const Account01PasswordData({
    required this.currentPassword,
    required this.newPassword,
  });

  /// The current password.
  final String currentPassword;

  /// The validated new password.
  final String newPassword;
}

/// The password form: current, new (min 8) and a confirm-match check.
class Account01PasswordForm extends StatefulWidget {
  /// Creates the password form.
  const Account01PasswordForm({super.key, required this.onSubmit});

  /// Called once with the typed values after a valid submit.
  final FutureOr<void> Function(Account01PasswordData data)? onSubmit;

  @override
  State<Account01PasswordForm> createState() => _Account01PasswordFormState();
}

class _Account01PasswordFormState extends State<Account01PasswordForm> {
  final FormController _controller = FormController();
  final FormKey<String> _currentKey = const FormKey<String>('currentPassword');
  final FormKey<String> _newKey = const FormKey<String>('newPassword');
  final FormKey<String> _confirmKey = const FormKey<String>('confirmPassword');
  final FocusNode _currentFocus = FocusNode(
    debugLabel: 'account-01 current password',
  );
  final FocusNode _newFocus = FocusNode(debugLabel: 'account-01 new');
  final FocusNode _confirmFocus = FocusNode(debugLabel: 'account-01 confirm');
  bool _submitting = false;
  bool _succeeded = false;

  Validator<String> get _confirmValidator =>
      const NotEmptyValidator() &
      const CompareWith<String>.equal(
        FormKey<String>('newPassword'),
        message: 'Passwords do not match.',
      );

  @override
  void dispose() {
    _controller.dispose();
    _currentFocus.dispose();
    _newFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  Future<void> _submit([BuildContext? submitContext]) async {
    if (_submitting) {
      return;
    }
    setState(() {
      _submitting = true;
      _succeeded = false;
    });
    try {
      final SubmissionResult result = await _controller.submit(
        submitContext ?? context,
      );
      if (!mounted) {
        return;
      }
      if (!result.isValid) {
        for (final MapEntry<FormKey, FocusNode> entry
            in <MapEntry<FormKey, FocusNode>>[
              MapEntry<FormKey, FocusNode>(_currentKey, _currentFocus),
              MapEntry<FormKey, FocusNode>(_newKey, _newFocus),
              MapEntry<FormKey, FocusNode>(_confirmKey, _confirmFocus),
            ]) {
          if (result.errors.containsKey(entry.key)) {
            entry.value.requestFocus();
            return;
          }
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
    final Account01PasswordData data = Account01PasswordData(
      currentPassword: values.getValue(_currentKey) ?? '',
      newPassword: values.getValue(_newKey) ?? '',
    );
    await widget.onSubmit?.call(data);
    if (!mounted) {
      return;
    }
    setState(() => _succeeded = true);
  }

  static const Set<FormValidationMode> _show = <FormValidationMode>{
    FormValidationMode.changed,
    FormValidationMode.submitted,
  };

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Card(
      child: ShadcnForm(
        controller: _controller,
        onSubmit: _handleValidSubmit,
        // The Builder hands the form's inner context to every submit call:
        // cross-field validators (CompareWith) resolve the other field
        // through FormController.maybeOf, which only sees a context under
        // the ShadcnForm, not the State context above it.
        child: Builder(
          builder: (BuildContext formContext) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text('Password', style: theme.typography.textLarge),
                Gap(theme.spacing.sm),
                Text(
                  'At least 8 characters. Changing it signs you out elsewhere.',
                  style: theme.typography.textSmall.copyWith(
                    color: theme.colors.mutedForeground,
                  ),
                ),
                Gap(theme.spacing.lg),
                const Divider(),
                Gap(theme.spacing.lg),
                ShadcnFormField<String>(
                  key: _currentKey,
                  label: const Text('Current password'),
                  validator: const NotEmptyValidator(),
                  showErrors: _show,
                  child: Input(
                    hintText: '••••••••',
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    focusNode: _currentFocus,
                    onSubmitted: (_) => _newFocus.requestFocus(),
                  ),
                ),
                Gap(theme.spacing.lg),
                ShadcnFormField<String>(
                  key: _newKey,
                  label: const Text('New password'),
                  hint: const Text('At least 8 characters.'),
                  validator:
                      const NotEmptyValidator() & const LengthValidator(min: 8),
                  showErrors: _show,
                  child: Input(
                    hintText: '••••••••',
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    focusNode: _newFocus,
                    onSubmitted: (_) => _confirmFocus.requestFocus(),
                  ),
                ),
                Gap(theme.spacing.lg),
                ShadcnFormField<String>(
                  key: _confirmKey,
                  label: const Text('Confirm new password'),
                  validator: _confirmValidator,
                  showErrors: _show,
                  child: Input(
                    hintText: '••••••••',
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    focusNode: _confirmFocus,
                    onSubmitted: (_) => _submit(formContext),
                  ),
                ),
                Gap(theme.spacing.xl),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Button(
                    onPressed: _submitting ? null : () => _submit(formContext),
                    child: _submitting
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Spinner(
                                size: 14,
                                color: theme.colors.primaryForeground,
                              ),
                              Gap(theme.spacing.sm),
                              const Text('Updating'),
                            ],
                          )
                        : const Text('Update password'),
                  ),
                ),
                if (_succeeded) ...<Widget>[
                  Gap(theme.spacing.lg),
                  Alert(
                    content: Text(
                      'Password updated.',
                      style: theme.typography.textSmall,
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
''',
      tokenClasses:
          'ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccppkkkkkkpsssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppppppppppppkkkkkkkkpkkkkppppppppppppppppppppppkkkkkkkkpkkkkpppppppppppppppppppppppcccccccccccccccccccccccccpppkkkkkppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccpppkkkkkppppppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppppppppppppppppkkkkkkkppppppppppppppppppppccccccccccccccccccccccccccccccpppkkkkkppppppppppppppppppppppppkkkkkppppppkkkkkkkkpkkkkppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppkkkkkppppppppppkkkkppkkkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppkkkkkkkppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppkkkkkpppppppppppppppppssssssssssssssssspppppkkkkkpppppppppppppppppppppppppppkkkkkpppppppppppppppppssssssssssssspppppkkkkkpppppppppppppppppppppppppppppppkkkkkpppppppppppppppppssssssssssssssssspppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssssspppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssspppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssppppppppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkpppppppppppppppppppppppkkkppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssppppppppppppppppppppsssssssssssssssssssssssssppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppkkkkkpppppppkkpppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppkkkkkppppppppppppppkkkpppppppppkkkkkpppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppkkkkkkppppppppppppppppkkpppppppppppppppppppppppppppppkkkppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppkkkkkkkpppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppkkkkkppppppppkkkkppppppppppkkkkkpppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsspppppppppppppppppppppppppppppppppppppppppppppppppsspppppppppppppkkkkkppppppppppppppppppppppppppppppppppkkppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppkkkkppppppppppkkkkkkpkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssssssssppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssspppppppppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssssssspppppppppppppppppppppppppppkkkkkppppppssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssspppppppppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssspppppppppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/account-01/account_01_profile.dart',
      code: r'''// The `account-01` block, part 2: the validated profile form.
//
// Imported by `account_01.dart`; a block never imports another block.

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../components/alert/alert.dart';
import '../../components/avatar/avatar.dart';
import '../../components/button/button.dart';
import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import '../../components/form/form.dart';
import '../../components/input/input.dart';
import '../../components/spinner/spinner.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';

class Account01ProfileData {
  /// Creates the submitted values.
  const Account01ProfileData({
    required this.name,
    required this.username,
    required this.bio,
  });

  /// The validated display name.
  final String name;

  /// The validated username.
  final String username;

  /// The validated bio.
  final String bio;
}

/// The profile form: avatar row, an equal-width name/username grid, bio.
class Account01ProfileForm extends StatefulWidget {
  /// Creates the profile form.
  const Account01ProfileForm({
    super.key,
    required this.onSubmit,
    required this.onUploadAvatar,
  });

  final FutureOr<void> Function(Account01ProfileData data)? onSubmit;
  final VoidCallback? onUploadAvatar;

  @override
  State<Account01ProfileForm> createState() => Account01ProfileFormState();
}

class Account01ProfileFormState extends State<Account01ProfileForm> {
  static final Validator<String> _usernameValidator =
      const NotEmptyValidator() &
      const LengthValidator(min: 2, max: 30) &
      RegexValidator(RegExp(r'^[a-z0-9_]+$'));

  final FormController _controller = FormController();
  final FormKey<String> _nameKey = const FormKey<String>('name');
  final FormKey<String> _usernameKey = const FormKey<String>('username');
  final FormKey<String> _bioKey = const FormKey<String>('bio');
  final FocusNode _nameFocus = FocusNode(debugLabel: 'account-01 name');
  final FocusNode _usernameFocus = FocusNode(debugLabel: 'account-01 username');
  final FocusNode _bioFocus = FocusNode(debugLabel: 'account-01 bio');
  bool _submitting = false;
  bool _succeeded = false;

  @override
  void dispose() {
    _controller.dispose();
    _nameFocus.dispose();
    _usernameFocus.dispose();
    _bioFocus.dispose();
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
        for (final MapEntry<FormKey, FocusNode> entry
            in <MapEntry<FormKey, FocusNode>>[
              MapEntry<FormKey, FocusNode>(_nameKey, _nameFocus),
              MapEntry<FormKey, FocusNode>(_usernameKey, _usernameFocus),
              MapEntry<FormKey, FocusNode>(_bioKey, _bioFocus),
            ]) {
          if (result.errors.containsKey(entry.key)) {
            entry.value.requestFocus();
            return;
          }
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
    final Account01ProfileData data = Account01ProfileData(
      name: values.getValue(_nameKey) ?? '',
      username: values.getValue(_usernameKey) ?? '',
      bio: values.getValue(_bioKey) ?? '',
    );
    await widget.onSubmit?.call(data);
    if (!mounted) {
      return;
    }
    setState(() => _succeeded = true);
  }

  static const Set<FormValidationMode> _show = <FormValidationMode>{
    FormValidationMode.changed,
    FormValidationMode.submitted,
  };

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Card(
      child: ShadcnForm(
        controller: _controller,
        onSubmit: _handleValidSubmit,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Profile', style: theme.typography.textLarge),
            Gap(theme.spacing.sm),
            Text(
              'This is how others will see you on the site.',
              style: theme.typography.textSmall.copyWith(
                color: theme.colors.mutedForeground,
              ),
            ),
            Gap(theme.spacing.lg),
            const Divider(),
            Gap(theme.spacing.lg),
            Row(
              children: <Widget>[
                const Avatar(initials: 'AL', size: 56),
                Gap(theme.spacing.lg),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Your avatar', style: theme.typography.textSmall),
                      Gap(theme.spacing.sm),
                      Button(
                        variant: ButtonVariant.outline,
                        onPressed: widget.onUploadAvatar ?? () {},
                        child: const Text('Upload image'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Gap(theme.spacing.lg),
            const Divider(),
            Gap(theme.spacing.lg),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final Widget name = ShadcnFormField<String>(
                  key: _nameKey,
                  label: const Text('Name'),
                  validator:
                      const NotEmptyValidator() &
                      const LengthValidator(min: 2, max: 50),
                  showErrors: _show,
                  child: Input(
                    hintText: 'Ada Lovelace',
                    textInputAction: TextInputAction.next,
                    focusNode: _nameFocus,
                    onSubmitted: (_) => _usernameFocus.requestFocus(),
                  ),
                );
                final Widget username = ShadcnFormField<String>(
                  key: _usernameKey,
                  label: const Text('Username'),
                  hint: const Text('Lowercase letters, digits, underscores.'),
                  validator: _usernameValidator,
                  showErrors: _show,
                  child: Input(
                    hintText: 'ada',
                    textInputAction: TextInputAction.next,
                    focusNode: _usernameFocus,
                    onSubmitted: (_) => _bioFocus.requestFocus(),
                  ),
                );
                // Equal-width columns; a single column below 560px so no
                // control is ever squeezed beyond its sensible width.
                if (constraints.maxWidth >= 560) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(child: name),
                      Gap(theme.spacing.lg),
                      Expanded(child: username),
                    ],
                  );
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[name, Gap(theme.spacing.lg), username],
                );
              },
            ),
            Gap(theme.spacing.lg),
            ShadcnFormField<String>(
              key: _bioKey,
              label: const Text('Bio'),
              hint: const Text('Up to 160 characters.'),
              validator: const LengthValidator(max: 160),
              showErrors: _show,
              // `Input` (not `TextArea`) so the field reports into the form.
              child: Input(
                hintText: 'Tell us a little bit about yourself',
                minLines: 3,
                maxLines: 5,
                maxLength: 160,
                focusNode: _bioFocus,
                onSubmitted: (_) => _submit(),
              ),
            ),
            Gap(theme.spacing.lg),
            const Divider(),
            Gap(theme.spacing.lg),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Email',
                  style: theme.typography.textSmall.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Gap(theme.spacing.sm),
                Text(
                  'ada@example.com',
                  style: theme.typography.textSmall.copyWith(
                    color: theme.colors.mutedForeground,
                  ),
                ),
              ],
            ),
            Gap(theme.spacing.xl),
            Align(
              alignment: Alignment.centerLeft,
              child: Button(
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
                          const Text('Saving'),
                        ],
                      )
                    : const Text('Save changes'),
              ),
            ),
            if (_succeeded) ...<Widget>[
              Gap(theme.spacing.lg),
              Alert(
                content: Text(
                  'Profile saved.',
                  style: theme.typography.textSmall,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
''',
      tokenClasses:
          'ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccppkkkkkkpsssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppkkkkkppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccpppkkkkkppppppppppppppppppppppppppppkkkkkkkkpkkkkpppppppppppkkkkkkkkpkkkkpppppppppppppppkkkkkkkkpkkkkpppppppppppppppcccccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppcccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppppccccccccccccccccccccccpppkkkkkppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkppppppppppppppppppppppkkkkkkkppppppppppppppppppppcccccccccccccccccccccccccccccpppkkkkkppppppppppppppppppppppppppppkkkkkppppppppppkkkkkkkkpkkkkpppppppppppppppkkkkkkkkpkkkkppppppppppppppppppppppppppkkkkkppppppppppkkkkppkkkkkkkkpppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppkkkkkkkpppppppppppppppppppppppppppppppppkkkkkkpkkkkkppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssspppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppkkkkkpppppppppppppppppsssssspppppkkkkkppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppsssssssssspppppkkkkkpppppppppppppppppppppppppppkkkkkpppppppppppppppppssssspppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssspppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssspppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssppppppppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkpppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppkkkkppppppppppppkkkkkpppppppkkpppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppkkkkkppppppppppppppkkkpppppppppkkkkkpppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppkkkkkkppppppppppppppppkkpppppppppppppppppppppppppppppkkkppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppkkkkkkkpppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppkkkkkppppppppkkkkppppppppppkkkkkpppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsspppppppppppppppppppppppppppppppppppppppppppppppppppsspppppppppppppppppppppppppppppppppppppppppsspppppppppppppkkkkkppppppppppppppppppppppppppppppppppkkppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppkkkkppppppppppkkkkkkpkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssspppppppppppppppppppppppppppkkkkkppppppssssssssssssssssssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssspppppppppppppppppppppppkkkkkppppppsssssssssssssssssssssssppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/account-01/account_01_team.dart',
      code: r'''// The `account-01` block, part 3: the team tab.
//
// Imported by `account_01.dart`; a block never imports another block.

import 'package:flutter/widgets.dart';

import '../../components/avatar/avatar.dart';
import '../../components/button/button.dart';
import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';

/// The team tab: member rows and an invite action.
class Account01Team extends StatelessWidget {
  /// Creates the team tab.
  const Account01Team({super.key, required this.onInvite});

  /// Called when "Invite member" is tapped.
  final VoidCallback? onInvite;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    const List<(String, String, String)> members = <(String, String, String)>[
      ('AL', 'Ada Lovelace', 'Owner'),
      ('BK', 'Bjarne Kern', 'Admin'),
      ('SD', 'Sofia Davis', 'Member'),
    ];
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text('Team', style: theme.typography.textLarge),
          Gap(theme.spacing.sm),
          Text(
            'Everyone with access to this workspace.',
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          Gap(theme.spacing.lg),
          const Divider(),
          Gap(theme.spacing.lg),
          for (final (String initials, String name, String role)
              in members) ...<Widget>[
            Row(
              children: <Widget>[
                Avatar(initials: initials),
                Gap(theme.spacing.md),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(name, style: theme.typography.textSmall),
                      Gap(theme.spacing.xs),
                      Text(
                        role,
                        style: theme.typography.xSmall.copyWith(
                          color: theme.colors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Gap(theme.spacing.md),
          ],
          Gap(theme.spacing.sm),
          Align(
            alignment: Alignment.centerLeft,
            child: Button(
              variant: ButtonVariant.outline,
              onPressed: onInvite ?? () {},
              child: const Text('Invite member'),
            ),
          ),
        ],
      ),
    );
  }
}
''',
      tokenClasses:
          'ccccccccccccccccccccccccccccccccccccccccccccccccpccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppcccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppppppppkkkkkkkpppppppppppppppppppppcccccccccccccccccccccccccpppkkkkkppppppppppppppppkkkkkppppppkkkkkkkkpkkkkppppppppppppppppccccccccccccccccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssppssssssssssssssppsssssssppppppppppssssppsssssssssssssppsssssssppppppppppssssppsssssssssssssppssssssssppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'account-02': <DocsBlockFile>[
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/account-02/account_02.dart',
      code:
          r'''// The `account-02` block: a notifications preferences screen backed by a
// real form.
//
// A block is layer 4 of the registry: it may import foundation, theme,
// primitives and components, never another block. Its public widget is the
// preview - the docs page renders it exactly as an app would.
//
// Every switch reports into a `ShadcnForm` (value-only fields — a preference
// has no invalid state), so Save validates the form, shows loading, then a
// success alert, and Reset restores the defaults. The shell is capped at
// 768px (max-w-3xl). The content shrink-wraps so the docs frame sizes to its
// intrinsic height, and scrolls internally when the host is bounded.

import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../components/alert/alert.dart';
import '../../components/breadcrumb/breadcrumb.dart';
import '../../components/button/button.dart';
import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import '../../components/form/form.dart';
import '../../components/spinner/spinner.dart';
import '../../components/switch/switch.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';

/// Values submitted by [Account02].
class Account02Data {
  /// Creates the submitted values.
  const Account02Data({
    required this.email,
    required this.push,
    required this.quietHours,
    required this.weeklyDigest,
  });

  /// Per-channel email preferences, keyed by channel label.
  final Map<String, bool> email;

  /// Per-channel push preferences, keyed by channel label.
  final Map<String, bool> push;

  /// Whether quiet hours are on.
  final bool quietHours;

  /// Whether the weekly digest is on.
  final bool weeklyDigest;

  @override
  String toString() =>
      'Account02Data(email: $email, push: $push, '
      'quietHours: $quietHours, weeklyDigest: $weeklyDigest)';
}

/// A notifications preferences screen: per-channel rows plus a digest card.
class Account02 extends StatefulWidget {
  /// Creates the block.
  const Account02({super.key, this.onSubmit});

  /// Called once with the typed values after Save (after a short simulated
  /// async call). Null keeps the demo success alert.
  final FutureOr<void> Function(Account02Data data)? onSubmit;

  @override
  State<Account02> createState() => _Account02State();
}

class _Account02State extends State<Account02> {
  static const List<String> _channels = <String>[
    'Everything',
    'Mentions and replies',
    'Product updates',
    'Marketing',
  ];

  static Map<String, bool> _defaults() => <String, bool>{
    'Everything': true,
    'Mentions and replies': true,
    'Product updates': true,
    'Marketing': false,
  };

  final FormController _controller = FormController();
  late Map<String, bool> _email = _defaults();
  late Map<String, bool> _push = _defaults();
  bool _quietHours = true;
  bool _digest = true;
  bool _submitting = false;
  bool _succeeded = false;

  FormKey<bool> _key(String channel, String prefix) =>
      FormKey<bool>('$prefix.$channel');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_submitting) {
      return;
    }
    setState(() {
      _submitting = true;
      _succeeded = false;
    });
    try {
      await _controller.submit(context);
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  Future<void> _handleValidSubmit(FormMapValues values) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final Account02Data data = Account02Data(
      email: Map<String, bool>.unmodifiable(_email),
      push: Map<String, bool>.unmodifiable(_push),
      quietHours: _quietHours,
      weeklyDigest: _digest,
    );
    await widget.onSubmit?.call(data);
    if (!mounted) {
      return;
    }
    setState(() => _succeeded = true);
  }

  void _reset() {
    setState(() {
      _email = _defaults();
      _push = _defaults();
      _quietHours = true;
      _digest = true;
      _succeeded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    // Align loosens the width: a bare ConstrainedBox under the scroll view
    // would receive tight width and its maxWidth cap would be clamped away.
    final Widget body = Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 768),
        child: ShadcnForm(
          controller: _controller,
          onSubmit: _handleValidSubmit,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Breadcrumb(
                children: <Widget>[
                  Text('Settings'),
                  Gap(0, crossAxisExtent: 8),
                  Text('Notifications'),
                ],
              ),
              Gap(theme.spacing.md),
              Text('Notifications', style: theme.typography.h2),
              Gap(theme.spacing.xs),
              Text(
                'Choose what you want to hear about, and where.',
                style: theme.typography.textMuted.copyWith(
                  color: theme.colors.mutedForeground,
                ),
              ),
              Gap(theme.spacing.lg),
              _Account02Card(
                title: 'Email notifications',
                subtitle: 'Sent to ada@example.com',
                children: <Widget>[
                  for (final String channel in _channels)
                    _Account02SwitchRow(
                      formKey: _key(channel, 'email'),
                      title: 'Email · $channel',
                      value: _email[channel]!,
                      onChanged: (bool value) =>
                          setState(() => _email[channel] = value),
                    ),
                ],
              ),
              Gap(theme.spacing.lg),
              _Account02Card(
                title: 'Push notifications',
                subtitle: 'Delivered to your devices',
                children: <Widget>[
                  for (final String channel in _channels)
                    _Account02SwitchRow(
                      formKey: _key(channel, 'push'),
                      title: 'Push · $channel',
                      value: _push[channel]!,
                      onChanged: (bool value) =>
                          setState(() => _push[channel] = value),
                    ),
                  Gap(theme.spacing.lg),
                  const Divider(),
                  Gap(theme.spacing.lg),
                  _Account02SwitchRow(
                    formKey: const FormKey<bool>('quietHours'),
                    title: 'Quiet hours',
                    subtitle: '22:00 – 07:00, your local time',
                    value: _quietHours,
                    onChanged: (bool value) =>
                        setState(() => _quietHours = value),
                  ),
                ],
              ),
              Gap(theme.spacing.lg),
              _Account02Card(
                title: 'Weekly digest',
                subtitle:
                    'One email every Monday with everything that happened.',
                children: <Widget>[
                  _Account02SwitchRow(
                    formKey: const FormKey<bool>('weeklyDigest'),
                    title: 'Weekly digest',
                    value: _digest,
                    onChanged: (bool value) => setState(() => _digest = value),
                  ),
                ],
              ),
              Gap(theme.spacing.lg),
              Wrap(
                spacing: theme.spacing.md,
                runSpacing: theme.spacing.md,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Button(
                    onPressed: _submitting ? null : _save,
                    child: _submitting
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Spinner(
                                size: 14,
                                color: theme.colors.primaryForeground,
                              ),
                              Gap(theme.spacing.sm),
                              const Text('Saving'),
                            ],
                          )
                        : const Text('Save preferences'),
                  ),
                  Button(
                    variant: ButtonVariant.outline,
                    onPressed: _reset,
                    child: const Text('Reset'),
                  ),
                ],
              ),
              if (_succeeded) ...<Widget>[
                Gap(theme.spacing.lg),
                Alert(
                  content: Text(
                    'Preferences saved.',
                    style: theme.typography.textSmall,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
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

class _Account02Card extends StatelessWidget {
  const _Account02Card({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(title, style: theme.typography.textLarge),
          Gap(theme.spacing.xs),
          Text(
            subtitle,
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          Gap(theme.spacing.lg),
          for (var i = 0; i < children.length; i++) ...<Widget>[
            children[i],
            if (i != children.length - 1) Gap(theme.spacing.md),
          ],
        ],
      ),
    );
  }
}

/// One preference row: title (and optional subtitle) with a form-bound
/// switch. The field label stays empty — the row is the label.
class _Account02SwitchRow extends StatelessWidget {
  const _Account02SwitchRow({
    required this.formKey,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  final FormKey<bool> formKey;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return ShadcnFormField<bool>(
      key: formKey,
      label: const SizedBox.shrink(),
      showErrors: const <FormValidationMode>{
        FormValidationMode.changed,
        FormValidationMode.submitted,
      },
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: theme.typography.textSmall),
                if (subtitle != null) ...<Widget>[
                  Gap(theme.spacing.xs),
                  Text(
                    subtitle!,
                    style: theme.typography.textSmall.copyWith(
                      color: theme.colors.mutedForeground,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Gap(theme.spacing.md),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
''',
      tokenClasses:
          'cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccpccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccppkkkkkkpsssssssssssspppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppccccccccccccccccccccccccccccccccccccpkkkkkpppppppppppppppppppcccccccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppppkkkkkkkkpkkkkppppppppppppkkkkkkkkpkkkkpppppppppppkkkkkkkkpkkkkpppppppppppppppppkkkkkkkkpkkkkppppppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppkkkkkppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppppccccccccccccccccccccccccccccccccccccpppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssppppppsssssssspppppssspppppppssssssssssssspppppppppppsssssssssssssssspppppppppppppsspppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppppkkkkkkkppppppppppppppppppppccccccccccccccccccccccpppkkkkkppppppppppppkkkkkppppppkkkkppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppcccccccccccccccccccccccccccccccccccccccccccccccccccpppkkkkkppppppppppkkkkppkkkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppkkkkkkkppppppppppppppppppppppkkkkkkpkkkkkppppppppppppppppppppppppppppppppppppppppssssssssssssppppppssssssssssssssssssssssppppppsssssssssssssssssppppppsssssssssssppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssppkkkkppppppssssssssssssssssssssssppkkkkppppppsssssssssssssssssppkkkkppppppsssssssssssppkkkkkppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppkkkkpppppppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppspppppppsppppppppsppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppkkkkppppppppppkkkkkpppppppkkpppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppkkkkkppppppppppppppkkkpppppppppkkkkkppppppppppppppppppppppppppppppppppppkkkkkkkpppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppkkkkkppppppppkkkkppppppppppkkkkkpppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppkkppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppkkkkppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppppppppkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssssssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssppppppppppppppppppppppppppppsssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkkkppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssppppppppppppppppppppppppppppppppsssssssssppppppppsppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssppppppppppppppppppppppppppppsssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkkkppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssppppppppppppppppppppppppppppppppssssssssppppppppspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppssssssssssssppppppppppppppppppppppppppppppsssssssssssssppppppppppppppppppppppppppppppppsssssssssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssssssssssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppssssssssssssssppppppppppppppppppppppppppppppssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkkkkpkkkkppppppppppppkkkkkkkkpkkkkpppppppppppppppkkkkkkkkpkkkkppppppppppppppppppppkkkkkpppppppppppppppppkkkkkppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppppppkkkkkkkkpkkkkppppppppppppppkkkkkkkkpkkkkppppppppppppkkkkkkkkpkkkkppppppppppppkkkkkkkkpkkkkppppppppppppppppkkkkppppppppppppppppppppkkkkkppppppppppppppppppppppppppkkkkkpppppppppppppppppkkkkkpppppppppppppppppppppkkkkkpppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'sidebar-01': <DocsBlockFile>[
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/sidebar-01/sidebar_01.dart',
      code:
          r'''// The `sidebar-01` block: a collapsible icon rail beside a mailbox screen.
//
// A block is layer 4 of the registry: it may import foundation, theme,
// primitives and components, never another block. Its public widget is the
// preview - the docs page renders it exactly as an app would.
//
// The rail reads the sidebar tokens (`sidebar`, `sidebarAccent`, …), so it
// re-themes with every preset. From 720px the rail sits beside the content;
// below that a menu button opens the navigation as a drawer. The content is
// a sample mailbox with stats and activity. The layout shrink-wraps so the
// docs frame sizes to its intrinsic height, and scrolls internally when the
// host is bounded.

import 'package:flutter/widgets.dart';

import '../../components/button/button.dart';
import '../../components/drawer/drawer.dart';
import 'sidebar_01_content.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/theme.dart';

/// A navigation rail that collapses to icons, with a sample content area.
class Sidebar01 extends StatefulWidget {
  /// Creates the block.
  const Sidebar01({super.key});

  @override
  State<Sidebar01> createState() => _Sidebar01State();
}

class _Sidebar01State extends State<Sidebar01> {
  int _selected = 0;

  void _openNav() {
    openDrawer(
      context: context,
      position: OverlayPosition.start,
      builder: (BuildContext context) => _Sidebar01DrawerNav(
        selected: _selected,
        onSelected: (int index) {
          setState(() => _selected = index);
          closeDrawer(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool vertical = constraints.maxWidth >= 720;
            final Widget content = Sidebar01Content(selected: _selected);
            final Widget body;
            if (!vertical) {
              body = Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _Sidebar01Bar(selected: _selected, onMenu: _openNav),
                  Gap(theme.spacing.lg),
                  content,
                ],
              );
            } else {
              body = Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _Sidebar01Rail(
                    selected: _selected,
                    onSelected: (int index) =>
                        setState(() => _selected = index),
                  ),
                  Gap(theme.spacing.lg),
                  Expanded(child: content),
                ],
              );
            }
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

/// The icon rail (desktop): one 40px button per destination.
class _Sidebar01Rail extends StatelessWidget {
  const _Sidebar01Rail({required this.selected, required this.onSelected});

  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Container(
      padding: EdgeInsets.all(theme.spacing.sm),
      decoration: BoxDecoration(
        color: theme.colors.sidebar,
        borderRadius: theme.borderRadiusLg,
        border: Border.all(color: theme.colors.sidebarBorder),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (var i = 0; i < sidebar01Items.length; i++)
            _Sidebar01RailButton(
              item: sidebar01Items[i],
              selected: i == selected,
              onPressed: () => onSelected(i),
            ),
        ],
      ),
    );
  }
}

class _Sidebar01RailButton extends StatelessWidget {
  const _Sidebar01RailButton({
    required this.item,
    required this.selected,
    required this.onPressed,
  });

  final Sidebar01Item item;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Semantics(
        label: item.label,
        selected: selected,
        button: true,
        child: GestureDetector(
          onTap: onPressed,
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? theme.colors.sidebarAccent : null,
              borderRadius: theme.borderRadiusMd,
            ),
            child: Icon(
              item.icon,
              size: 18,
              color: selected
                  ? theme.colors.sidebarAccentForeground
                  : theme.colors.sidebarForeground,
            ),
          ),
        ),
      ),
    );
  }
}

/// The mobile bar: a menu trigger plus the current destination title.
class _Sidebar01Bar extends StatelessWidget {
  const _Sidebar01Bar({required this.selected, required this.onMenu});

  final int selected;
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.md,
        vertical: theme.spacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colors.sidebar,
        borderRadius: theme.borderRadiusLg,
        border: Border.all(color: theme.colors.sidebarBorder),
      ),
      child: Row(
        children: <Widget>[
          Button(
            variant: ButtonVariant.ghost,
            size: ButtonSize.icon,
            onPressed: onMenu,
            child: const Icon(LucideIcons.menu, size: 18),
          ),
          Gap(theme.spacing.md),
          Expanded(
            child: Text(
              sidebar01Items[selected].label,
              style: theme.typography.textSmall.copyWith(
                color: theme.colors.sidebarForeground,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The drawer navigation (mobile): full-width labelled rows.
class _Sidebar01DrawerNav extends StatelessWidget {
  const _Sidebar01DrawerNav({required this.selected, required this.onSelected});

  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return ColoredBox(
      color: theme.colors.sidebar,
      child: Padding(
        padding: EdgeInsets.all(theme.spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Acme Inc',
              style: theme.typography.textSmall.copyWith(
                color: theme.colors.sidebarForeground,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gap(theme.spacing.lg),
            for (var i = 0; i < sidebar01Items.length; i++)
              _Sidebar01DrawerRow(
                item: sidebar01Items[i],
                selected: i == selected,
                onPressed: () => onSelected(i),
              ),
          ],
        ),
      ),
    );
  }
}

class _Sidebar01DrawerRow extends StatelessWidget {
  const _Sidebar01DrawerRow({
    required this.item,
    required this.selected,
    required this.onPressed,
  });

  final Sidebar01Item item;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final Color foreground = selected
        ? theme.colors.sidebarAccentForeground
        : theme.colors.sidebarForeground;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.only(bottom: theme.spacing.xs),
        padding: EdgeInsets.symmetric(
          horizontal: theme.spacing.md,
          vertical: theme.spacing.sm,
        ),
        decoration: BoxDecoration(
          color: selected ? theme.colors.sidebarAccent : null,
          borderRadius: theme.borderRadiusSm,
        ),
        child: Row(
          children: <Widget>[
            Icon(item.icon, size: 16, color: foreground),
            Gap(theme.spacing.sm),
            Text(
              item.label,
              style: theme.typography.textSmall.copyWith(color: foreground),
            ),
          ],
        ),
      ),
    );
  }
}
''',
      tokenClasses:
          'cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpssssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppppkkkkkkkppppppppppppppppppppccccccccccccccccccccccpppkkkkkppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppkkkkkkkppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppkkkkkkkkpkkkkpppppppppppkkkkkkkkpkkkkppppppppppppppppppkkkkkpppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppppppkkkkkkkkpkkkkpppppppppppkkkkkkkkpkkkkpppppppppppppppkkkkkkkkpkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppkkkkkppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkpppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppkkkkkkkkpkkkkpppppppppppkkkkkkkkpkkkkppppppppppppppkkkkkpppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkkkkpkkkkpppppppppppkkkkkkkkpkkkkppppppppppppppppppkkkkkpppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppppppkkkkkkkkpkkkkpppppppppppkkkkkkkkpkkkkpppppppppppppppkkkkkkkkpkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppkkkkkppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/sidebar-01/sidebar_01_content.dart',
      code:
          r'''// The `sidebar-01` block, part 2: the destinations and the sample mailbox
// screen. Imported by `sidebar_01.dart`; a block never imports another
// block.

import 'package:flutter/widgets.dart';

import '../../components/button/button.dart';
import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/theme.dart';

/// One rail destination.
class Sidebar01Item {
  /// Creates a destination.
  const Sidebar01Item(this.label, this.icon);

  /// Visible label.
  final String label;

  /// Rail icon.
  final IconData icon;
}

/// The rail destinations, shared by the rail, the bar and the drawer.
const List<Sidebar01Item> sidebar01Items = <Sidebar01Item>[
  Sidebar01Item('Home', LucideIcons.house),
  Sidebar01Item('Inbox', LucideIcons.inbox),
  Sidebar01Item('Calendar', LucideIcons.calendarDays),
  Sidebar01Item('Search', LucideIcons.search),
  Sidebar01Item('Settings', LucideIcons.settings),
];

/// The sample content that sits next to the rail: stats, the mailbox and
/// recent activity.
class Sidebar01Content extends StatelessWidget {
  /// Creates the content area.
  const Sidebar01Content({super.key, required this.selected});

  /// Index of the selected destination; drives the heading.
  final int selected;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(sidebar01Items[selected].label, style: theme.typography.h2),
        Gap(theme.spacing.xs),
        Text(
          'Everything in one place, at arm’s reach.',
          style: theme.typography.textMuted.copyWith(
            color: theme.colors.mutedForeground,
          ),
        ),
        Gap(theme.spacing.lg),
        const _Sidebar01Stats(),
        Gap(theme.spacing.lg),
        Card(
          padding: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _Sidebar01Row(
                'Design review',
                'Kara — 2 hours ago',
                'Can we move the sidebar review to Thursday?',
              ),
              const Divider(),
              _Sidebar01Row(
                'Invoice 4821',
                'Billing — yesterday',
                'Your receipt for the annual plan is attached.',
              ),
              const Divider(),
              _Sidebar01Row(
                'Welcome aboard',
                'Team — Monday',
                'Here is everything you need to get started.',
              ),
            ],
          ),
        ),
        Gap(theme.spacing.lg),
        const _Sidebar01Activity(),
        Gap(theme.spacing.lg),
        Wrap(
          spacing: theme.spacing.md,
          runSpacing: theme.spacing.md,
          children: <Widget>[
            Button(
              variant: ButtonVariant.outline,
              onPressed: () {},
              child: const Text('Mark all read'),
            ),
            Button(onPressed: () {}, child: const Text('Compose')),
          ],
        ),
      ],
    );
  }
}

class _Sidebar01Stats extends StatelessWidget {
  const _Sidebar01Stats();

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final int columns = constraints.maxWidth >= 640 ? 3 : 1;
        final double gap = theme.spacing.lg;
        final double cardWidth = columns == 1
            ? constraints.maxWidth
            : (constraints.maxWidth - gap * (columns - 1)) / columns;
        const List<(String, String)> stats = <(String, String)>[
          ('Unread', '12'),
          ('Starred', '4'),
          ('Snoozed', '2'),
        ];
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: <Widget>[
            for (final (String, String) stat in stats)
              SizedBox(
                width: cardWidth,
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        stat.$1,
                        style: theme.typography.textSmall.copyWith(
                          color: theme.colors.mutedForeground,
                        ),
                      ),
                      Gap(theme.spacing.sm),
                      Text(stat.$2, style: theme.typography.h3),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _Sidebar01Activity extends StatelessWidget {
  const _Sidebar01Activity();

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    const List<(String, String)> events = <(String, String)>[
      ('Kara moved Design review to Thursday', '2h ago'),
      ('Billing sent Invoice 4821', 'Yesterday'),
      ('Ada shared Welcome aboard with you', 'Monday'),
    ];
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Activity', style: theme.typography.textLarge),
          Gap(theme.spacing.lg),
          for (final (String, String) event in events) ...<Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(event.$1, style: theme.typography.textSmall),
                ),
                Gap(theme.spacing.md),
                Text(
                  event.$2,
                  style: theme.typography.xSmall.copyWith(
                    color: theme.colors.mutedForeground,
                  ),
                ),
              ],
            ),
            if (event != events.last) Gap(theme.spacing.md),
          ],
        ],
      ),
    );
  }
}

class _Sidebar01Row extends StatelessWidget {
  const _Sidebar01Row(this.title, this.author, this.preview);

  final String title;
  final String author;
  final String preview;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Padding(
      padding: EdgeInsets.all(theme.spacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: theme.typography.textSmall),
          Gap(theme.spacing.xs),
          Text(
            author,
            style: theme.typography.xSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          Gap(theme.spacing.sm),
          Text(preview, style: theme.typography.textSmall),
        ],
      ),
    );
  }
}
''',
      tokenClasses:
          'ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpssssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppcccccccccccccccccccccccccpkkkkkpppppppppppppppppppccccccccccccccccccccccccccpppkkkkkpppppppppppppppkkkkppppppppkkkkpppppppppppccccccccccccccccccpppkkkkkppppppppppppppppppccccccccccccccpppkkkkkpppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssppppppppppppppppppppppppppppppppppppppsssssssppppppppppppppppppppppppppppppppppppppsssssssssspppppppppppppppppppppppppppppppppppppppppppppsssssssspppppppppppppppppppppppppppppppppppppppsssssssssspppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccpkkkkkppppppppppppppppppkkkkkkkpppppppppppppppppppppcccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppkkkkkppppppkkkkkkkkpkkkkppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssppppppppppppppppppssssssssssssssssssssppppppppppppppppppssssssssssssssssssssssssssssssssssssssssssssspppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssppppppppppppppppppsssssssssssssssssssssppppppppppppppppppssssssssssssssssssssssssssssssssssssssssssssssspppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssppppppppppppppppppsssssssssssssssppppppppppppppppppssssssssssssssssssssssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssppssssppppppppppppppsssssssssppsssppppppppppppppsssssssssppsssppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkkkpppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssssssssssssssppssssssssppppppppppsssssssssssssssssssssssssssppsssssssssssppppppppppssssssssssssssssssssssssssssssssssssppssssssssppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkkkppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppkkkkppppppppkkkkpppppppppkkkkppppppppppppppkkkkkpppppppppppppppppkkkkkppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'sidebar-02': <DocsBlockFile>[
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/sidebar-02/sidebar_02.dart',
      code:
          r'''// The `sidebar-02` block: an inset sidebar with grouped navigation.
//
// A block is layer 4 of the registry: it may import foundation, theme,
// primitives and components, never another block. Its public widget is the
// preview - the docs page renders it exactly as an app would.
//
// The sidebar is inset (rounded, with a gutter to the page background) and
// its navigation is grouped by section. The search field filters the
// navigation live. From 840px the sidebar sits beside the content; below
// that a menu button opens it as a drawer. The content is a sample
// playground screen with stats, files and activity. The layout shrink-wraps
// so the docs frame sizes to its intrinsic height, and scrolls internally
// when the host is bounded.

import 'package:flutter/widgets.dart';

import '../../components/button/button.dart';
import '../../components/drawer/drawer.dart';
import 'sidebar_02_content.dart';
import 'sidebar_02_panel.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/theme.dart';

/// A grouped, inset sidebar shell around a sample content area.
class Sidebar02 extends StatefulWidget {
  /// Creates the block.
  const Sidebar02({super.key});

  @override
  State<Sidebar02> createState() => _Sidebar02State();
}

class _Sidebar02State extends State<Sidebar02> {
  int _selected = 0;

  void _openNav() {
    openDrawer(
      context: context,
      position: OverlayPosition.start,
      builder: (BuildContext context) => SingleChildScrollView(
        child: Sidebar02Panel(
          selected: _selected,
          onSelected: (int index) {
            setState(() => _selected = index);
            closeDrawer(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final Widget content = Sidebar02Content(selected: _selected);
            final Widget body;
            if (constraints.maxWidth >= 840) {
              body = Padding(
                padding: EdgeInsets.all(theme.spacing.md),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 260,
                      child: Sidebar02Panel(
                        selected: _selected,
                        onSelected: (int index) =>
                            setState(() => _selected = index),
                      ),
                    ),
                    Gap(theme.spacing.md),
                    Expanded(child: content),
                  ],
                ),
              );
            } else {
              body = Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _Sidebar02Bar(onMenu: _openNav),
                  Gap(theme.spacing.lg),
                  content,
                ],
              );
            }
            if (!constraints.maxHeight.isFinite) {
              return Padding(
                padding: EdgeInsets.all(theme.spacing.md),
                child: body,
              );
            }
            return SingleChildScrollView(
              padding: EdgeInsets.all(theme.spacing.md),
              child: body,
            );
          },
        ),
      ),
    );
  }
}

/// The mobile bar: a menu trigger plus the product mark.
class _Sidebar02Bar extends StatelessWidget {
  const _Sidebar02Bar({required this.onMenu});

  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.md,
        vertical: theme.spacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colors.sidebar,
        borderRadius: theme.borderRadiusLg,
        border: Border.all(color: theme.colors.sidebarBorder),
      ),
      child: Row(
        children: <Widget>[
          Button(
            variant: ButtonVariant.ghost,
            size: ButtonSize.icon,
            onPressed: onMenu,
            child: const Icon(LucideIcons.menu, size: 18),
          ),
          Gap(theme.spacing.md),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: theme.colors.sidebarPrimary,
              borderRadius: theme.borderRadiusSm,
            ),
            child: Icon(
              LucideIcons.command,
              size: 16,
              color: theme.colors.sidebarPrimaryForeground,
            ),
          ),
          Gap(theme.spacing.sm),
          Text(
            'Acme Inc',
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.sidebarForeground,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
''',
      tokenClasses:
          'ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpssssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppppkkkkkkkppppppppppppppppppppccccccccccccccccccccccpppkkkkkppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppkkkkkkkppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppkkkkkkkkpkkkkppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/sidebar-02/sidebar_02_content.dart',
      code:
          r'''// The `sidebar-02` block, part 2: the sample content area. Imported by
// `sidebar_02.dart`; a block never imports another block.

import 'package:flutter/widgets.dart';

import '../../components/avatar/avatar.dart';
import '../../components/badge/badge.dart';
import '../../components/button/button.dart';
import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import '../../components/progress/progress.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';

/// The sample content area: stats, usage, files and activity.
class Sidebar02Content extends StatelessWidget {
  /// Creates the content area.
  const Sidebar02Content({super.key, required this.selected});

  /// Index of the selected navigation link; drives the heading.
  final int selected;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(_sidebar02Title(selected), style: theme.typography.h2),
        Gap(theme.spacing.xs),
        Text(
          'Experiment with the API before you ship it.',
          style: theme.typography.textMuted.copyWith(
            color: theme.colors.mutedForeground,
          ),
        ),
        Gap(theme.spacing.lg),
        const Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            Badge(variant: BadgeVariant.secondary, child: Text('Stable')),
            Badge(variant: BadgeVariant.outline, child: Text('Beta channel')),
            Badge(variant: BadgeVariant.primary, child: Text('New: batches')),
          ],
        ),
        Gap(theme.spacing.lg),
        const _Sidebar02Stats(),
        Gap(theme.spacing.lg),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Usage this month', style: theme.typography.textLarge),
              Gap(theme.spacing.lg),
              const Progress(value: 0.68),
              Gap(theme.spacing.sm),
              Text(
                '2,040,000 of 3,000,000 tokens',
                style: theme.typography.textSmall.copyWith(
                  color: theme.colors.mutedForeground,
                ),
              ),
              Gap(theme.spacing.lg),
              const Divider(),
              Gap(theme.spacing.lg),
              Button(onPressed: () {}, child: const Text('Upgrade plan')),
            ],
          ),
        ),
        Gap(theme.spacing.lg),
        const _Sidebar02Files(),
        Gap(theme.spacing.lg),
        const _Sidebar02Activity(),
      ],
    );
  }
}

String _sidebar02Title(int selected) => switch (selected) {
  1 => 'Models',
  2 => 'Documentation',
  3 => 'Design system',
  4 => 'Marketing site',
  _ => 'Playground',
};

class _Sidebar02Stats extends StatelessWidget {
  const _Sidebar02Stats();

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final int columns = constraints.maxWidth >= 560 ? 3 : 1;
        final double gap = theme.spacing.lg;
        final double cardWidth = columns == 1
            ? constraints.maxWidth
            : (constraints.maxWidth - gap * (columns - 1)) / columns;
        const List<(String, String)> stats = <(String, String)>[
          ('Projects', '12'),
          ('Members', '8'),
          ('Deploys', '1,204'),
        ];
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: <Widget>[
            for (final (String, String) stat in stats)
              SizedBox(
                width: cardWidth,
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        stat.$1,
                        style: theme.typography.textSmall.copyWith(
                          color: theme.colors.mutedForeground,
                        ),
                      ),
                      Gap(theme.spacing.sm),
                      Text(stat.$2, style: theme.typography.h3),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _Sidebar02Files extends StatelessWidget {
  const _Sidebar02Files();

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    const List<(String, String, String)> files = <(String, String, String)>[
      ('SM', 'Summer lookbook.pdf', '2.4 MB · edited 3m ago'),
      ('BR', 'Brand tokens.json', '18 KB · edited 1h ago'),
      ('RD', 'Roadmap Q4.md', '44 KB · edited yesterday'),
    ];
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Recent files', style: theme.typography.textLarge),
          Gap(theme.spacing.lg),
          for (final (String, String, String) file in files) ...<Widget>[
            Row(
              children: <Widget>[
                Avatar(initials: file.$1, size: 32),
                Gap(theme.spacing.md),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(file.$2, style: theme.typography.textSmall),
                      Gap(theme.spacing.xs),
                      Text(
                        file.$3,
                        style: theme.typography.xSmall.copyWith(
                          color: theme.colors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (file != files.last) Gap(theme.spacing.md),
          ],
        ],
      ),
    );
  }
}

class _Sidebar02Activity extends StatelessWidget {
  const _Sidebar02Activity();

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    const List<(String, String)> events = <(String, String)>[
      ('Ada deployed Marketing site to production', '12m ago'),
      ('Bjarne invited Sofia to Design system', '1h ago'),
      ('Nightly backup completed', '6h ago'),
    ];
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Activity', style: theme.typography.textLarge),
          Gap(theme.spacing.lg),
          for (final (String, String) event in events) ...<Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(event.$1, style: theme.typography.textSmall),
                ),
                Gap(theme.spacing.md),
                Text(
                  event.$2,
                  style: theme.typography.xSmall.copyWith(
                    color: theme.colors.mutedForeground,
                  ),
                ),
              ],
            ),
            if (event != events.last) Gap(theme.spacing.md),
          ],
        ],
      ),
    );
  }
}
''',
      tokenClasses:
          'cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkppppppppppppppppppkkkkkkkpppppppppppppppppppppcccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppkkkkkppppppkkkkkkkkpkkkkppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppsssssssspppppppppssssssssssssssspppppppppssssssssssssssspppppppppsssssssssssssssspppppppppssssssssssssppppppkkkkkpppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssppssssppppppppppppppsssssssssppsssppppppppppppppsssssssssppsssssssppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkkkpppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssppsssssssssssssssssssssppssssssssssssssssssssssssppppppppppssssppsssssssssssssssssssppsssssssssssssssssssssssppppppppppssssppsssssssssssssssppssssssssssssssssssssssssssppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkkkpppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssssssssssssssssssssssssppsssssssssppppppppppsssssssssssssssssssssssssssssssssssssssppssssssssppppppppppssssssssssssssssssssssssssppssssssssppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkkkppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/sidebar-02/sidebar_02_panel.dart',
      code: r'''// The `sidebar-02` block, part 2: the inset sidebar panel.
//
// Imported by `sidebar_02.dart`; a block never imports another block.

import 'package:flutter/widgets.dart';

import '../../components/avatar/avatar.dart';
import '../../components/divider/divider.dart';
import '../../components/input/input.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/theme.dart';

/// The inset sidebar panel: product mark, live-filter search, grouped
/// navigation and the user row. Shared by the desktop layout and the mobile
/// drawer, so both stay identical.
class Sidebar02Panel extends StatefulWidget {
  /// Creates the panel.
  const Sidebar02Panel({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  /// Index of the selected link across both groups.
  final int selected;

  /// Called with the tapped link index.
  final ValueChanged<int> onSelected;

  @override
  State<Sidebar02Panel> createState() => _Sidebar02PanelState();
}

class _Sidebar02PanelState extends State<Sidebar02Panel> {
  static const List<String> _platform = <String>[
    'Playground',
    'Models',
    'Documentation',
  ];
  static const List<String> _projects = <String>[
    'Design system',
    'Marketing site',
  ];

  String _query = '';

  List<String> get _links => <String>[..._platform, ..._projects];

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final String needle = _query.trim().toLowerCase();
    List<String> match(List<String> items) => needle.isEmpty
        ? items
        : items
              .where((String item) => item.toLowerCase().contains(needle))
              .toList();
    final List<String> platform = match(_platform);
    final List<String> projects = match(_projects);
    return Container(
      decoration: BoxDecoration(
        color: theme.colors.sidebar,
        borderRadius: theme.borderRadiusXl,
        border: Border.all(color: theme.colors.sidebarBorder),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(theme.spacing.lg),
            child: Row(
              children: <Widget>[
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: theme.colors.sidebarPrimary,
                    borderRadius: theme.borderRadiusSm,
                  ),
                  child: Icon(
                    LucideIcons.command,
                    size: 16,
                    color: theme.colors.sidebarPrimaryForeground,
                  ),
                ),
                Gap(theme.spacing.sm),
                Text(
                  'Acme Inc',
                  style: theme.typography.textSmall.copyWith(
                    color: theme.colors.sidebarForeground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  'v1.2',
                  style: theme.typography.xSmall.copyWith(
                    color: theme.colors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: theme.spacing.lg),
            child: _Sidebar02Search(
              onChanged: (String value) => setState(() => _query = value),
            ),
          ),
          Gap(theme.spacing.lg),
          if (platform.isNotEmpty)
            _Sidebar02Group(
              label: 'Platform',
              items: platform,
              links: _links,
              selected: widget.selected,
              onSelected: widget.onSelected,
            ),
          if (platform.isNotEmpty && projects.isNotEmpty) Gap(theme.spacing.md),
          if (projects.isNotEmpty)
            _Sidebar02Group(
              label: 'Projects',
              items: projects,
              links: _links,
              selected: widget.selected,
              onSelected: widget.onSelected,
            ),
          if (platform.isEmpty && projects.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: theme.spacing.lg),
              child: Text(
                'No matches for "$_query".',
                style: theme.typography.textSmall.copyWith(
                  color: theme.colors.mutedForeground,
                ),
              ),
            ),
          Gap(theme.spacing.lg),
          const Divider(),
          Gap(theme.spacing.lg),
          const _Sidebar02User(),
        ],
      ),
    );
  }
}

class _Sidebar02Search extends StatelessWidget {
  const _Sidebar02Search({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Input(hintText: 'Search', onChanged: onChanged);
  }
}

class _Sidebar02Group extends StatelessWidget {
  const _Sidebar02Group({
    required this.label,
    required this.items,
    required this.links,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final List<String> items;

  /// Every link in order; the index is the selection identity.
  final List<String> links;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: theme.spacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            label,
            style: theme.typography.xSmall.copyWith(
              color: theme.colors.mutedForeground,
              fontWeight: FontWeight.w600,
            ),
          ),
          Gap(theme.spacing.sm),
          for (var i = 0; i < items.length; i++) ...<Widget>[
            _Sidebar02NavItem(
              label: items[i],
              selected: links.indexOf(items[i]) == selected,
              onPressed: () => onSelected(links.indexOf(items[i])),
            ),
            if (i != items.length - 1) Gap(theme.spacing.xs),
          ],
        ],
      ),
    );
  }
}

class _Sidebar02NavItem extends StatelessWidget {
  const _Sidebar02NavItem({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: theme.spacing.sm,
          vertical: theme.spacing.xs,
        ),
        decoration: BoxDecoration(
          color: selected ? theme.colors.sidebarAccent : null,
          borderRadius: theme.borderRadiusSm,
        ),
        child: Text(
          label,
          style: theme.typography.textSmall.copyWith(
            color: selected
                ? theme.colors.sidebarAccentForeground
                : theme.colors.sidebarForeground,
            fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _Sidebar02User extends StatelessWidget {
  const _Sidebar02User();

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Padding(
      padding: EdgeInsets.all(theme.spacing.lg),
      child: Row(
        children: <Widget>[
          const Avatar(initials: 'SD'),
          Gap(theme.spacing.sm),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'shadcn',
                  style: theme.typography.textSmall.copyWith(
                    color: theme.colors.sidebarForeground,
                  ),
                ),
                Gap(theme.spacing.xs),
                Text(
                  'm@example.com',
                  style: theme.typography.xSmall.copyWith(
                    color: theme.colors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
''',
      tokenClasses:
          'cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpssssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccpkkkkkppppppppppppppppkkkkkkkppppppppppppppppppppccccccccccccccccccccccpppkkkkkppppppppppppppppppppppkkkkkppppppppppkkkkkkkkpkkkkpppppppppppppppkkkkkkkkpkkkkppppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccpppkkkkkppppppppppppppppppccccccccccccccccccccccccccccccccccccccpppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkkkpppppppppppppppppppppppppppkkkkkkpkkkkkppppppppppppppppppppppppppppppppppppppppssssssssssssppppppssssssssppppppssssssssssssssspppppppppkkkkkkpkkkkkppppppppppppppppppppppppppppppppppppppppsssssssssssssssppppppssssssssssssssssppppppppppppppppppppppppppssppppppppppppppppppkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssspppppppssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppkkkkkkkkpkkkkpppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppssssssssppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppkkkkkkkkpkkkkppppppppppppkkkkkkkkpkkkkppppppppppppkkkkkkkkpkkkkppppppppppppkkkkkkkkpkkkkpppppppppppppppkkkkkkkkpkkkkppppppppppppppppppppppkkkkkpppppppppppppppppkkkkkppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppppppkkkkkpppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppppkkkkkkkkpkkkkppppppppppppkkkkkkkkpkkkkpppppppppppppppkkkkkkkkpkkkkpppppppppppppppppppppkkkkkpppppppppppppppppkkkkkppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppsssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'sidebar-03': <DocsBlockFile>[
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/sidebar-03/sidebar_03.dart',
      code:
          r'''// The `sidebar-03` block: a whole app shell — header, grouped sidebar,
// content.
//
// A block is layer 4 of the registry: it may import foundation, theme,
// primitives and components, never another block. Its public widget is the
// preview - the docs page renders it exactly as an app would.
//
// From 840px the shell is a header row over a grouped sidebar beside the
// content; below that a menu button in the header opens the sidebar as a
// drawer. The content is a sample workspace with stats, projects and
// activity. The layout shrink-wraps so the docs frame sizes to its intrinsic
// height, and scrolls internally when the host is bounded.

import 'package:flutter/widgets.dart';

import '../../components/avatar/avatar.dart';
import '../../components/badge/badge.dart';
import '../../components/breadcrumb/breadcrumb.dart';
import '../../components/button/button.dart';
import '../../components/divider/divider.dart';
import '../../components/drawer/drawer.dart';
import '../../components/input/input.dart';
import '../../components/progress/progress.dart';
import 'sidebar_03_content.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/theme.dart';

/// A complete application shell: header, sidebar and a sample screen.
class Sidebar03 extends StatefulWidget {
  /// Creates the block.
  const Sidebar03({super.key});

  @override
  State<Sidebar03> createState() => _Sidebar03State();
}

class _Sidebar03State extends State<Sidebar03> {
  int _selected = 0;

  void _openNav() {
    openDrawer(
      context: context,
      position: OverlayPosition.start,
      builder: (BuildContext context) => SingleChildScrollView(
        child: Sidebar03Sidebar(
          selected: _selected,
          onSelected: (int index) {
            setState(() => _selected = index);
            closeDrawer(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool inset = constraints.maxWidth >= 840;
            final Widget content = Sidebar03Content(selected: _selected);
            final Widget body;
            if (!inset) {
              body = Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _Sidebar03Header(selected: _selected, onMenu: _openNav),
                  Gap(theme.spacing.md),
                  content,
                ],
              );
            } else {
              body = Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _Sidebar03Header(selected: _selected),
                  Gap(theme.spacing.md),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 260,
                        child: Sidebar03Sidebar(
                          selected: _selected,
                          onSelected: (int index) =>
                              setState(() => _selected = index),
                        ),
                      ),
                      Gap(theme.spacing.md),
                      Expanded(child: content),
                    ],
                  ),
                ],
              );
            }
            if (!constraints.maxHeight.isFinite) {
              return Padding(
                padding: EdgeInsets.all(theme.spacing.md),
                child: body,
              );
            }
            return SingleChildScrollView(
              padding: EdgeInsets.all(theme.spacing.md),
              child: body,
            );
          },
        ),
      ),
    );
  }
}

class _Sidebar03Header extends StatelessWidget {
  const _Sidebar03Header({required this.selected, this.onMenu});

  static const List<String> _titles = <String>[
    'Dashboard',
    'Documents',
    'Reports',
    'Settings',
  ];

  final int selected;

  /// When non-null (mobile), a menu trigger replaces the product mark.
  final VoidCallback? onMenu;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.md,
        vertical: theme.spacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colors.card,
        borderRadius: theme.borderRadiusLg,
        border: Border.all(color: theme.colors.border),
      ),
      // The 200 px search field collapses below 500 px (like the reference
      // header), so the trigger, breadcrumb and avatar always fit a phone.
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool showSearch = constraints.maxWidth >= 500;
          final VoidCallback? onMenu = this.onMenu;
          return Row(
            children: <Widget>[
              if (onMenu != null) ...<Widget>[
                Button(
                  variant: ButtonVariant.ghost,
                  size: ButtonSize.icon,
                  onPressed: onMenu,
                  child: const Icon(LucideIcons.menu, size: 18),
                ),
                Gap(theme.spacing.md),
              ] else ...<Widget>[
                Icon(
                  LucideIcons.command,
                  size: 18,
                  color: theme.colors.foreground,
                ),
                Gap(theme.spacing.md),
              ],
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Breadcrumb(
                    children: <Widget>[
                      Text(
                        'Acme',
                        style: theme.typography.textSmall.copyWith(
                          color: theme.colors.mutedForeground,
                        ),
                      ),
                      const Gap(0, crossAxisExtent: 8),
                      Text(
                        _titles[selected],
                        style: theme.typography.textSmall,
                      ),
                    ],
                  ),
                ),
              ),
              if (showSearch) ...<Widget>[
                Gap(theme.spacing.md),
                const SizedBox(width: 200, child: Input(hintText: 'Search')),
              ],
              Gap(theme.spacing.md),
              const Avatar(initials: 'AC'),
            ],
          );
        },
      ),
    );
  }
}

const List<_Sidebar03Link> _sidebar03Links = <_Sidebar03Link>[
  _Sidebar03Link('Dashboard', LucideIcons.layoutDashboard),
  _Sidebar03Link('Documents', LucideIcons.fileText),
  _Sidebar03Link('Reports', LucideIcons.chartBar),
  _Sidebar03Link('Settings', LucideIcons.settings),
];

/// The sidebar panel: grouped navigation plus a storage meter. Shared by the
/// desktop layout and the mobile drawer, so both stay identical.
class Sidebar03Sidebar extends StatelessWidget {
  /// Creates the sidebar panel.
  const Sidebar03Sidebar({super.key, this.selected = 0, this.onSelected});

  /// Index of the selected link; drives the highlight.
  final int selected;

  /// Called with the tapped link index; null leaves the panel static.
  final ValueChanged<int>? onSelected;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colors.sidebar,
        borderRadius: theme.borderRadiusXl,
        border: Border.all(color: theme.colors.sidebarBorder),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(theme.spacing.lg),
            child: Text(
              'Navigation',
              style: theme.typography.textLarge.copyWith(
                color: theme.colors.sidebarForeground,
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: EdgeInsets.all(theme.spacing.sm),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                for (var i = 0; i < _sidebar03Links.length; i++)
                  _Sidebar03NavRow(
                    link: _sidebar03Links[i],
                    selected: i == selected,
                    onPressed: onSelected == null ? null : () => onSelected!(i),
                  ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: EdgeInsets.all(theme.spacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Storage',
                  style: theme.typography.xSmall.copyWith(
                    color: theme.colors.mutedForeground,
                  ),
                ),
                Gap(theme.spacing.sm),
                Text(
                  '12.4 GB of 20 GB',
                  style: theme.typography.textSmall.copyWith(
                    color: theme.colors.sidebarForeground,
                  ),
                ),
                Gap(theme.spacing.sm),
                const _Sidebar03Bar(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Sidebar03Link {
  const _Sidebar03Link(this.label, this.icon);

  final String label;
  final IconData icon;
}

class _Sidebar03NavRow extends StatelessWidget {
  const _Sidebar03NavRow({
    required this.link,
    required this.selected,
    required this.onPressed,
  });

  final _Sidebar03Link link;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final Color foreground = selected
        ? theme.colors.sidebarAccentForeground
        : theme.colors.sidebarForeground;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: theme.spacing.md,
          vertical: theme.spacing.sm,
        ),
        decoration: BoxDecoration(
          color: selected ? theme.colors.sidebarAccent : null,
          borderRadius: theme.borderRadiusSm,
        ),
        child: Row(
          children: <Widget>[
            Icon(link.icon, size: 16, color: foreground),
            Gap(theme.spacing.sm),
            Expanded(
              child: Text(
                link.label,
                style: theme.typography.textSmall.copyWith(
                  color: foreground,
                  fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ),
            if (link.label == 'Settings')
              Badge(
                variant: BadgeVariant.secondary,
                child: Text('3', style: theme.typography.xSmall),
              ),
          ],
        ),
      ),
    );
  }
}

class _Sidebar03Bar extends StatelessWidget {
  const _Sidebar03Bar();

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Progress(
      value: 0.62,
      height: theme.spacing.xs,
      color: theme.colors.sidebarPrimary,
      backgroundColor: theme.colors.muted,
    );
  }
}
''',
      tokenClasses:
          'cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccpccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpssssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppppkkkkkkkppppppppppppppppppppccccccccccccccccccccccpppkkkkkppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppkkkkkkkppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppkkkkkkkkpkkkkpppppppppppkkkkppppppppppppppkkkkkkpkkkkkppppppppppppppppppppppppppppppppppppppsssssssssssppppppsssssssssssppppppsssssssssppppppssssssssssppppppppppkkkkkppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppkkkkpppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppsssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssppppppppppppppppppppppppppppppppppppppppppsssssssssppppppppppppppppppppppppppppppppppppppppppsssssssssspppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkppppppppppppppppppkkkkkkkpppppppppppppppppppppccccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppkkkkkppppppkkkkpppppppppppppppkkkkppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccpppkkkkkppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkpppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppkkkkkppppppppppppppppkkkkppppppppkkkkpppppppppppkkkkkpppppppppppppppppkkkkkpppppppppppppppppppkkkkkppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppkkkkkkkkpkkkkpppppppppppkkkkkkkkpkkkkpppppppppppppppkkkkkkkkpkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppkkkkkppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/sidebar-03/sidebar_03_content.dart',
      code:
          r'''// The `sidebar-03` block, part 2: the sample screen inside the shell.
// Imported by `sidebar_03.dart`; a block never imports another block.

import 'package:flutter/widgets.dart';

import '../../components/badge/badge.dart';
import '../../components/button/button.dart';
import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';

/// The sample screen inside the shell: stats, projects and activity.
class Sidebar03Content extends StatelessWidget {
  /// Creates the content area.
  const Sidebar03Content({super.key, required this.selected});

  /// Index of the selected navigation link; drives the heading.
  final int selected;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(_sidebar03Title(selected), style: theme.typography.h2),
        Gap(theme.spacing.xs),
        Text(
          'Four shared workspaces, updated today.',
          style: theme.typography.textMuted.copyWith(
            color: theme.colors.mutedForeground,
          ),
        ),
        Gap(theme.spacing.lg),
        const _Sidebar03Stats(),
        Gap(theme.spacing.lg),
        Wrap(
          spacing: theme.spacing.lg,
          runSpacing: theme.spacing.lg,
          children: const <Widget>[
            SizedBox(width: 280, child: Sidebar03ProjectCard('Atlas')),
            SizedBox(width: 280, child: Sidebar03ProjectCard('Beacon')),
            SizedBox(width: 280, child: Sidebar03ProjectCard('Cobalt')),
          ],
        ),
        Gap(theme.spacing.lg),
        const _Sidebar03Activity(),
      ],
    );
  }
}

String _sidebar03Title(int selected) => switch (selected) {
  1 => 'Documents',
  2 => 'Reports',
  3 => 'Settings',
  _ => 'Recent projects',
};

class _Sidebar03Stats extends StatelessWidget {
  const _Sidebar03Stats();

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final int columns = constraints.maxWidth >= 640 ? 4 : 2;
        final double gap = theme.spacing.lg;
        final double cardWidth =
            (constraints.maxWidth - gap * (columns - 1)) / columns;
        const List<(String, String)> stats = <(String, String)>[
          ('Workspaces', '4'),
          ('Shared with you', '11'),
          ('Storage used', '12.4 GB'),
          ('Members', '8'),
        ];
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: <Widget>[
            for (final (String, String) stat in stats)
              SizedBox(
                width: cardWidth,
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        stat.$1,
                        style: theme.typography.textSmall.copyWith(
                          color: theme.colors.mutedForeground,
                        ),
                      ),
                      Gap(theme.spacing.sm),
                      Text(stat.$2, style: theme.typography.h3),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// One project card.
class Sidebar03ProjectCard extends StatelessWidget {
  /// Creates one project card.
  const Sidebar03ProjectCard(this.name, {super.key});

  /// The project name.
  final String name;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: Text(name, style: theme.typography.textLarge)),
              Badge(
                variant: BadgeVariant.secondary,
                child: Text('Live', style: theme.typography.xSmall),
              ),
            ],
          ),
          Gap(theme.spacing.sm),
          Text(
            'Shared with 4 people · edited 3 minutes ago',
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          Gap(theme.spacing.lg),
          Button(
            variant: ButtonVariant.outline,
            onPressed: () {},
            child: const Text('Open'),
          ),
        ],
      ),
    );
  }
}

class _Sidebar03Activity extends StatelessWidget {
  const _Sidebar03Activity();

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    const List<(String, String)> events = <(String, String)>[
      ('Ada pushed 3 commits to Atlas', '3m ago'),
      ('Bjarne commented on Beacon specs', '26m ago'),
      ('Sofia published Cobalt v2.1', '2h ago'),
      ('Nightly backup completed', '6h ago'),
    ];
    return Card(
      padding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(theme.spacing.lg),
            child: Text('Activity', style: theme.typography.textLarge),
          ),
          const Divider(),
          for (final (String, String) event in events) ...<Widget>[
            Padding(
              padding: EdgeInsets.all(theme.spacing.md),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(event.$1, style: theme.typography.textSmall),
                  ),
                  Gap(theme.spacing.md),
                  Text(
                    event.$2,
                    style: theme.typography.xSmall.copyWith(
                      color: theme.colors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
            if (event != events.last) const Divider(),
          ],
        ],
      ),
    );
  }
}
''',
      tokenClasses:
          'ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkppppppppppppppppppkkkkkkkpppppppppppppppppppppcccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppkkkkkppppppkkkkkkkkpkkkkppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppssssssssssspppppppppssssssssspppppppppsssssssssspppppppppsssssssssssssssssppppppkkkkkpppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssppsssppppppppppppppsssssssssssssssssppssssppppppppppppppssssssssssssssppsssssssssppppppppppppppsssssssssppsssppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkkkpppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccpkkkkkppppppppppppppppppppppkkkkkkkpppppppppppppppppppppcccccccccccccccccccccccccccccpppkkkkkppppppppppppppppppppppkkkkppppppppkkkkkpppppppppppcccccccccccccccccccccpppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssssssssssssppssssssssppppppppppssssssssssssssssssssssssssssssssssppsssssssssppppppppppsssssssssssssssssssssssssssssppssssssssppppppppppssssssssssssssssssssssssssppssssssssppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppkkkppkkkkkppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
};
