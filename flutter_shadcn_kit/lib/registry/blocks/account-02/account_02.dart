// The `account-02` block: a notifications preferences screen.
//
// Grouped switch rows, a channel grid and a quiet-hours range. Every control
// reads the ambient theme; the state is local so the block can be dropped
// into a scaffold as-is.

import 'package:flutter/widgets.dart';

import '../../components/breadcrumb/breadcrumb.dart';
import '../../components/button/button.dart';
import '../../components/card/card.dart';
import '../../components/checkbox/checkbox.dart';
import '../../components/divider/divider.dart';
import '../../components/switch/switch.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';

/// A notifications preferences screen: per-channel rows plus a digest summary.
class Account02 extends StatefulWidget {
  /// Creates the block.
  const Account02({super.key});

  @override
  State<Account02> createState() => _Account02State();
}

class _Account02State extends State<Account02> {
  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(spacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
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
                Gap(spacing.md),
                Text('Notifications', style: theme.typography.h2),
                Gap(spacing.xs),
                Text(
                  'Choose what you want to hear about, and where.',
                  style: theme.typography.textMuted.copyWith(
                    color: theme.colors.mutedForeground,
                  ),
                ),
                Gap(spacing.lg),
                const _Account02EmailCard(),
                Gap(spacing.lg),
                const _Account02MobileCard(),
                Gap(spacing.lg),
                const _Account02Digest(),
                Gap(spacing.lg),
                const _Account02Actions(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Account02EmailCard extends StatelessWidget {
  const _Account02EmailCard();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text('Email notifications', style: theme.typography.textLarge),
          Gap(spacing.xs),
          Text(
            'Sent to ada@example.com',
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          Gap(spacing.lg),
          const _Account02Rows(prefix: 'Email'),
        ],
      ),
    );
  }
}

class _Account02MobileCard extends StatelessWidget {
  const _Account02MobileCard();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text('Push notifications', style: theme.typography.textLarge),
          Gap(spacing.xs),
          Text(
            'Delivered to your devices',
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          Gap(spacing.lg),
          const _Account02Rows(prefix: 'Push'),
          Gap(spacing.lg),
          const Divider(),
          Gap(spacing.lg),
          const _Account02QuietHours(),
        ],
      ),
    );
  }
}

class _Account02Rows extends StatefulWidget {
  const _Account02Rows({required this.prefix});

  final String prefix;

  @override
  State<_Account02Rows> createState() => _Account02RowsState();
}

class _Account02RowsState extends State<_Account02Rows> {
  final Set<String> _off = <String>{'Marketing'};

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    const List<_Account02Channel> channels = <_Account02Channel>[
      _Account02Channel('Everything'),
      _Account02Channel('Mentions and replies'),
      _Account02Channel('Product updates'),
      _Account02Channel('Marketing'),
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (final channel in channels) ...<Widget>[
          _Account02Row(
            title: '${widget.prefix} · ${channel.label}',
            value: !_off.contains(channel.label),
            onChanged: (bool value) => setState(() {
              if (value) {
                _off.remove(channel.label);
              } else {
                _off.add(channel.label);
              }
            }),
          ),
          if (channel != channels.last) Gap(spacing.md),
        ],
      ],
    );
  }
}

class _Account02Channel {
  const _Account02Channel(this.label);

  final String label;
}

class _Account02Row extends StatelessWidget {
  const _Account02Row({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Row(
      children: <Widget>[
        Expanded(child: Text(title, style: theme.typography.textSmall)),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}

class _Account02QuietHours extends StatelessWidget {
  const _Account02QuietHours();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Quiet hours', style: theme.typography.textSmall),
              Gap(spacing.sm),
              Text(
                '22:00 - 07:00, your local time',
                style: theme.typography.textSmall.copyWith(
                  color: theme.colors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
        Gap(spacing.md),
        const Checkbox(value: CheckboxValue.checked),
      ],
    );
  }
}

class _Account02Digest extends StatelessWidget {
  const _Account02Digest();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Weekly digest', style: theme.typography.textLarge),
          Gap(spacing.sm),
          Text(
            'One email every Monday with everything that happened.',
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

class _Account02Actions extends StatelessWidget {
  const _Account02Actions();

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return Wrap(
      spacing: spacing.md,
      runSpacing: spacing.md,
      children: const <Widget>[
        Button(child: Text('Save preferences')),
        Button(variant: ButtonVariant.outline, child: Text('Reset')),
      ],
    );
  }
}
