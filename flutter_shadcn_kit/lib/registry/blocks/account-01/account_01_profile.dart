// The `account-01` block, part 2: the validated profile form.
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
