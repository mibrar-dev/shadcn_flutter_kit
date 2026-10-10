// The `sidebar-03` block: a whole app shell — header, grouped sidebar, content.
//
// This is the "shell" variant of the blocks set: it wires the pieces a real
// app needs (a header row with breadcrumb + search + avatar, a grouped
// sidebar that stacks above the content below 840px, and a content column)
// so a project can adopt the layout and drop its own screens inside.

import 'package:flutter/widgets.dart';

import '../../components/avatar/avatar.dart';
import '../../components/badge/badge.dart';
import '../../components/breadcrumb/breadcrumb.dart';
import '../../components/button/button.dart';
import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import '../../components/input/input.dart';
import '../../components/progress/progress.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/theme.dart';

/// A complete application shell: header, sidebar and a sample screen.
class Sidebar03 extends StatefulWidget {
  /// Creates the block.
  const Sidebar03({super.key});

  @override
  State<Sidebar03> createState() => _Sidebar03State();
}

class _Sidebar03State extends State<Sidebar03> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    final background = ShadcnTheme.of(context).colors.background;
    return ColoredBox(
      color: background,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool inset = constraints.maxWidth >= 840;
            final Widget header = _Sidebar03Header(selected: _selected);
            if (!inset) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(spacing.md),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    header,
                    Gap(spacing.md),
                    Sidebar03Sidebar(
                      selected: _selected,
                      onSelected: (int index) =>
                          setState(() => _selected = index),
                    ),
                    Gap(spacing.md),
                    const Sidebar03Content(),
                  ],
                ),
              );
            }
            return Padding(
              padding: EdgeInsets.all(spacing.md),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  header,
                  Gap(spacing.md),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const SizedBox(width: 260, child: Sidebar03Sidebar()),
                        Gap(spacing.md),
                        const Expanded(child: Sidebar03Content()),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Sidebar03Header extends StatelessWidget {
  const _Sidebar03Header({required this.selected});

  static const List<String> _titles = <String>[
    'Dashboard',
    'Documents',
    'Reports',
    'Settings',
  ];

  final int selected;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colors.card,
        borderRadius: theme.borderRadiusLg,
        border: Border.all(color: theme.colors.border),
      ),
      // The 200 px search field collapses below 500 px (like the reference
      // header), so the icon, breadcrumb and avatar always fit a phone.
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool showSearch = constraints.maxWidth >= 500;
          return Row(
            children: <Widget>[
              Icon(
                LucideIcons.command,
                size: 18,
                color: theme.colors.foreground,
              ),
              Gap(spacing.md),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Breadcrumb(
                    children: <Widget>[
                      Text(
                        'Acme',
                        style: theme.typography.textSmall.copyWith(
                          color: theme.colors.mutedForeground,
                        ),
                      ),
                      const Gap(0, crossAxisExtent: 8),
                      Text(
                        _titles[selected],
                        style: theme.typography.textSmall,
                      ),
                    ],
                  ),
                ),
              ),
              if (showSearch) ...<Widget>[
                Gap(spacing.md),
                const SizedBox(width: 200, child: Input(hintText: 'Search')),
              ],
              Gap(spacing.md),
              const Avatar(initials: 'AC'),
            ],
          );
        },
      ),
    );
  }
}

const List<_Sidebar03Link> _sidebar03Links = <_Sidebar03Link>[
  _Sidebar03Link('Dashboard', LucideIcons.layoutDashboard),
  _Sidebar03Link('Documents', LucideIcons.fileText),
  _Sidebar03Link('Reports', LucideIcons.chartBar),
  _Sidebar03Link('Settings', LucideIcons.settings),
];

/// The sidebar panel: grouped navigation plus a storage meter.
class Sidebar03Sidebar extends StatelessWidget {
  /// Creates the sidebar panel.
  const Sidebar03Sidebar({super.key, this.selected = 0, this.onSelected});

  /// Index of the selected link; drives the highlight.
  final int selected;

  /// Called with the tapped link index; null leaves the panel static.
  final ValueChanged<int>? onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Container(
      decoration: BoxDecoration(
        color: theme.colors.sidebar,
        borderRadius: theme.borderRadiusXl,
        border: Border.all(color: theme.colors.sidebarBorder),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(spacing.lg),
            child: Text('Navigation', style: theme.typography.textLarge),
          ),
          const Divider(),
          Padding(
            padding: EdgeInsets.all(spacing.sm),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                for (var i = 0; i < _sidebar03Links.length; i++)
                  _Sidebar03NavRow(
                    link: _sidebar03Links[i],
                    selected: i == selected,
                    onPressed: onSelected == null ? null : () => onSelected!(i),
                  ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: EdgeInsets.all(spacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Storage',
                  style: theme.typography.xSmall.copyWith(
                    color: theme.colors.mutedForeground,
                  ),
                ),
                Gap(spacing.sm),
                Text('12.4 GB of 20 GB', style: theme.typography.textSmall),
                Gap(spacing.sm),
                const _Sidebar03Bar(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Sidebar03Link {
  const _Sidebar03Link(this.label, this.icon);

  final String label;
  final IconData icon;
}

class _Sidebar03NavRow extends StatelessWidget {
  const _Sidebar03NavRow({
    required this.link,
    required this.selected,
    required this.onPressed,
  });

  final _Sidebar03Link link;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    final foreground = selected
        ? theme.colors.sidebarAccentForeground
        : theme.colors.sidebarForeground;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.md,
          vertical: spacing.sm,
        ),
        decoration: BoxDecoration(
          color: selected ? theme.colors.sidebarAccent : null,
          borderRadius: theme.borderRadiusSm,
        ),
        child: Row(
          children: <Widget>[
            Icon(link.icon, size: 16, color: foreground),
            Gap(spacing.sm),
            Expanded(
              child: Text(
                link.label,
                style: theme.typography.textSmall.copyWith(
                  color: foreground,
                  fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ),
            if (link.label == 'Settings')
              Badge(
                variant: BadgeVariant.secondary,
                child: Text('3', style: theme.typography.xSmall),
              ),
          ],
        ),
      ),
    );
  }
}

class _Sidebar03Bar extends StatelessWidget {
  const _Sidebar03Bar();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Progress(
      value: 0.62,
      height: theme.spacing.xs,
      color: theme.colors.sidebarPrimary,
      backgroundColor: theme.colors.muted,
    );
  }
}

/// The sample screen inside the shell.
class Sidebar03Content extends StatelessWidget {
  /// Creates the content area.
  const Sidebar03Content({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text('Recent projects', style: theme.typography.h2),
        Gap(spacing.xs),
        Text(
          'Four shared workspaces, updated today.',
          style: theme.typography.textMuted.copyWith(
            color: theme.colors.mutedForeground,
          ),
        ),
        Gap(spacing.lg),
        Wrap(
          spacing: spacing.lg,
          runSpacing: spacing.lg,
          children: const <Widget>[
            SizedBox(width: 280, child: Sidebar03ProjectCard('Atlas')),
            SizedBox(width: 280, child: Sidebar03ProjectCard('Beacon')),
            SizedBox(width: 280, child: Sidebar03ProjectCard('Cobalt')),
          ],
        ),
      ],
    );
  }
}

class Sidebar03ProjectCard extends StatelessWidget {
  /// Creates one project card.
  const Sidebar03ProjectCard(this.name, {super.key});

  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
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
          Gap(spacing.sm),
          Text(
            'Shared with 4 people · edited 3 minutes ago',
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          Gap(spacing.lg),
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
