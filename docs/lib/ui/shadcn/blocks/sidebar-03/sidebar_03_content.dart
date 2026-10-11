// The `sidebar-03` block, part 2: the sample screen inside the shell.
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
