// The `signup-02` block, part 2: the validated sign-up form with its
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
