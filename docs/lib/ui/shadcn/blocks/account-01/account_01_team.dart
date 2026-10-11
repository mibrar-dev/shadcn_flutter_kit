// The `account-01` block, part 3: the team tab.
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
