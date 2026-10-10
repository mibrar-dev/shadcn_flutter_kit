// The `sidebar-01` block: a collapsible icon rail.
//
// The rail is a navigation strip of icon buttons that collapses to its icons
// only. It reads the sidebar tokens (`sidebar`, `sidebarAccent`, …), so it
// re-themes with every preset, and below 720px it flips to a horizontal strip
// on top of the content instead of overflowing.

import 'package:flutter/widgets.dart';

import '../../components/button/button.dart';
import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/theme.dart';

/// A navigation rail that collapses to icons, with a sample content area.
class Sidebar01 extends StatefulWidget {
  /// Creates the block.
  const Sidebar01({super.key});

  @override
  State<Sidebar01> createState() => _Sidebar01State();
}

class _Sidebar01State extends State<Sidebar01> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool vertical = constraints.maxWidth >= 720;
            final Widget rail = _Sidebar01Rail(
              vertical: vertical,
              selected: _selected,
              onSelected: (int index) => setState(() => _selected = index),
            );
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (!vertical) ...<Widget>[rail, Gap(spacing.lg)],
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(spacing.lg),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (vertical) rail,
                        if (vertical) Gap(spacing.lg),
                        const Expanded(child: Sidebar01Content()),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Sidebar01Rail extends StatelessWidget {
  const _Sidebar01Rail({
    required this.vertical,
    required this.selected,
    required this.onSelected,
  });

  final bool vertical;
  final int selected;
  final ValueChanged<int> onSelected;

  static const List<_Sidebar01Item> _items = <_Sidebar01Item>[
    _Sidebar01Item('Home', LucideIcons.house),
    _Sidebar01Item('Inbox', LucideIcons.inbox),
    _Sidebar01Item('Calendar', LucideIcons.calendarDays),
    _Sidebar01Item('Search', LucideIcons.search),
    _Sidebar01Item('Settings', LucideIcons.settings),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    final List<Widget> buttons = <Widget>[
      for (var i = 0; i < _items.length; i++)
        _Sidebar01RailButton(
          item: _items[i],
          vertical: vertical,
          selected: i == selected,
          onPressed: () => onSelected(i),
        ),
    ];
    final Widget content = vertical
        ? Column(mainAxisSize: MainAxisSize.min, children: buttons)
        : Row(mainAxisSize: MainAxisSize.min, children: buttons);
    return Container(
      padding: EdgeInsets.all(spacing.sm),
      decoration: BoxDecoration(
        color: theme.colors.sidebar,
        borderRadius: theme.borderRadiusLg,
        border: Border.all(color: theme.colors.sidebarBorder),
      ),
      child: content,
    );
  }
}

class _Sidebar01Item {
  const _Sidebar01Item(this.label, this.icon);

  final String label;
  final IconData icon;
}

class _Sidebar01RailButton extends StatelessWidget {
  const _Sidebar01RailButton({
    required this.item,
    required this.vertical,
    required this.selected,
    required this.onPressed,
  });

  final _Sidebar01Item item;

  /// Whether the rail runs vertically (margin below) or horizontally.
  final bool vertical;

  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Semantics(
      label: item.label,
      selected: selected,
      button: true,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 40,
          height: 40,
          margin: vertical
              ? const EdgeInsets.only(bottom: 4)
              : const EdgeInsets.only(right: 4),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? theme.colors.sidebarAccent : null,
            borderRadius: theme.borderRadiusMd,
          ),
          child: Icon(
            item.icon,
            size: 18,
            color: selected
                ? theme.colors.sidebarAccentForeground
                : theme.colors.sidebarForeground,
          ),
        ),
      ),
    );
  }
}

/// The sample content that sits next to the rail.
class Sidebar01Content extends StatelessWidget {
  /// Creates the content area.
  const Sidebar01Content({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text('Mailbox', style: theme.typography.h2),
        Gap(spacing.xs),
        Text(
          'Everything in one place, at arm’s reach.',
          style: theme.typography.textMuted.copyWith(
            color: theme.colors.mutedForeground,
          ),
        ),
        Gap(spacing.lg),
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
        Gap(spacing.lg),
        Wrap(
          spacing: spacing.md,
          runSpacing: spacing.md,
          children: const <Widget>[
            Button(
              variant: ButtonVariant.outline,
              child: Text('Mark all read'),
            ),
            Button(child: Text('Compose')),
          ],
        ),
      ],
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
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Padding(
      padding: EdgeInsets.all(spacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: theme.typography.textSmall),
          Gap(spacing.xs),
          Text(
            author,
            style: theme.typography.xSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          Gap(spacing.sm),
          Text(preview, style: theme.typography.textSmall),
        ],
      ),
    );
  }
}
