// The `account-01` block: an account settings screen with a profile form.
//
// A tab strip (Profile / Password / Teams), a two-field profile form and a
// save row. The form uses the plain `Input`/`Text` pair rather than the `form`
// component so the block stays copy-paste small.

import 'package:flutter/widgets.dart';

import '../../components/alert/alert.dart';
import '../../components/avatar/avatar.dart';
import '../../components/button/button.dart';
import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import '../../components/input/input.dart';
import '../../components/tabs/tabs.dart';
import '../../components/text_area/text_area.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';

/// An account settings screen: profile form, avatar row and a save action.
class Account01 extends StatefulWidget {
  /// Creates the block.
  const Account01({super.key});

  @override
  State<Account01> createState() => _Account01State();
}

class _Account01State extends State<Account01> {
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
            constraints: const BoxConstraints(maxWidth: 880),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text('Settings', style: theme.typography.h2),
                Gap(spacing.xs),
                Text(
                  'Manage your account settings and set your email preferences.',
                  style: theme.typography.textMuted.copyWith(
                    color: theme.colors.mutedForeground,
                  ),
                ),
                Gap(spacing.lg),
                const _Account01Tabs(),
                Gap(spacing.lg),
                const _Account01Profile(),
                Gap(spacing.lg),
                const _Account01SaveRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Account01Tabs extends StatefulWidget {
  const _Account01Tabs();

  @override
  State<_Account01Tabs> createState() => _Account01TabsState();
}

class _Account01TabsState extends State<_Account01Tabs> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Tabs(
        index: _index,
        onChanged: (int value) => setState(() => _index = value),
        children: const <TabItem>[
          TabItem(child: Text('Profile')),
          TabItem(child: Text('Password')),
          TabItem(child: Text('Team')),
        ],
      ),
    );
  }
}

class _Account01Profile extends StatelessWidget {
  const _Account01Profile();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text('Profile', style: theme.typography.textLarge),
          Gap(spacing.sm),
          Text(
            'This is how others will see you on the site.',
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          Gap(spacing.lg),
          const Divider(),
          Gap(spacing.lg),
          Row(
            children: <Widget>[
              const Avatar(initials: 'AL', size: 56),
              Gap(spacing.lg),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Your avatar', style: theme.typography.textSmall),
                    Gap(spacing.sm),
                    Button(
                      variant: ButtonVariant.outline,
                      onPressed: () {},
                      child: const Text('Upload image'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(spacing.lg),
          const Divider(),
          Gap(spacing.lg),
          const _Account01Fields(),
        ],
      ),
    );
  }
}

class _Account01Fields extends StatelessWidget {
  const _Account01Fields();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Wrap(
          spacing: spacing.lg,
          runSpacing: spacing.md,
          children: const <Widget>[
            SizedBox(
              width: 340,
              child: _Account01Field(label: 'Name', hint: 'Ada Lovelace'),
            ),
            SizedBox(
              width: 340,
              child: _Account01Field(label: 'Username', hint: 'ada'),
            ),
          ],
        ),
        Gap(spacing.lg),
        Text(
          'Bio',
          style: theme.typography.textSmall.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        Gap(spacing.sm),
        const TextArea(
          hintText: 'Tell us a little bit about yourself',
          minLines: 3,
          maxLines: 6,
        ),
        Gap(spacing.lg),
        const Divider(),
        Gap(spacing.lg),
        const _Account01EmailRow(),
      ],
    );
  }
}

class _Account01EmailRow extends StatelessWidget {
  const _Account01EmailRow();

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
        Text(
          'ada@example.com',
          style: theme.typography.textSmall.copyWith(
            color: theme.colors.mutedForeground,
          ),
        ),
      ],
    );
  }
}

class _Account01Field extends StatelessWidget {
  const _Account01Field({required this.label, required this.hint});

  final String label;
  final String hint;

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
        Input(hintText: hint),
      ],
    );
  }
}

class _Account01SaveRow extends StatelessWidget {
  const _Account01SaveRow();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Row(
      children: <Widget>[
        Expanded(
          child: Alert(
            variant: AlertVariant.base,
            content: Text(
              'Changes are saved automatically.',
              style: theme.typography.textSmall,
            ),
          ),
        ),
        Gap(spacing.lg),
        Button(onPressed: () {}, child: const Text('Save changes')),
      ],
    );
  }
}
