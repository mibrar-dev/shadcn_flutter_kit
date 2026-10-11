// The `signup-02` block, part 3: the plan summary aside. Imported by
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
