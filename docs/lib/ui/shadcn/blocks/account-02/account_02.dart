// The `account-02` block: a notifications preferences screen backed by a
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
