// The `sidebar-02` block, part 2: the sample content area. Imported by
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
