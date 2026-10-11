// The `sidebar-01` block, part 2: the destinations and the sample mailbox
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
