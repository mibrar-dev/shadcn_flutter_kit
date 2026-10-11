// The `sidebar-03` block: a whole app shell — header, grouped sidebar,
// content.
//
// A block is layer 4 of the registry: it may import foundation, theme,
// primitives and components, never another block. Its public widget is the
// preview - the docs page renders it exactly as an app would.
//
// From 840px the shell is a header row over a grouped sidebar beside the
// content; below that a menu button in the header opens the sidebar as a
// drawer. The content is a sample workspace with stats, projects and
// activity. The layout shrink-wraps so the docs frame sizes to its intrinsic
// height, and scrolls internally when the host is bounded.

import 'package:flutter/widgets.dart';

import '../../components/avatar/avatar.dart';
import '../../components/badge/badge.dart';
import '../../components/breadcrumb/breadcrumb.dart';
import '../../components/button/button.dart';
import '../../components/divider/divider.dart';
import '../../components/drawer/drawer.dart';
import '../../components/input/input.dart';
import '../../components/progress/progress.dart';
import 'sidebar_03_content.dart';
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

  void _openNav() {
    openDrawer(
      context: context,
      position: OverlayPosition.start,
      builder: (BuildContext context) => SingleChildScrollView(
        child: Sidebar03Sidebar(
          selected: _selected,
          onSelected: (int index) {
            setState(() => _selected = index);
            closeDrawer(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool inset = constraints.maxWidth >= 840;
            final Widget content = Sidebar03Content(selected: _selected);
            final Widget body;
            if (!inset) {
              body = Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _Sidebar03Header(selected: _selected, onMenu: _openNav),
                  Gap(theme.spacing.md),
                  content,
                ],
              );
            } else {
              body = Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _Sidebar03Header(selected: _selected),
                  Gap(theme.spacing.md),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 260,
                        child: Sidebar03Sidebar(
                          selected: _selected,
                          onSelected: (int index) =>
                              setState(() => _selected = index),
                        ),
                      ),
                      Gap(theme.spacing.md),
                      Expanded(child: content),
                    ],
                  ),
                ],
              );
            }
            if (!constraints.maxHeight.isFinite) {
              return Padding(
                padding: EdgeInsets.all(theme.spacing.md),
                child: body,
              );
            }
            return SingleChildScrollView(
              padding: EdgeInsets.all(theme.spacing.md),
              child: body,
            );
          },
        ),
      ),
    );
  }
}

class _Sidebar03Header extends StatelessWidget {
  const _Sidebar03Header({required this.selected, this.onMenu});

  static const List<String> _titles = <String>[
    'Dashboard',
    'Documents',
    'Reports',
    'Settings',
  ];

  final int selected;

  /// When non-null (mobile), a menu trigger replaces the product mark.
  final VoidCallback? onMenu;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.md,
        vertical: theme.spacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colors.card,
        borderRadius: theme.borderRadiusLg,
        border: Border.all(color: theme.colors.border),
      ),
      // The 200 px search field collapses below 500 px (like the reference
      // header), so the trigger, breadcrumb and avatar always fit a phone.
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool showSearch = constraints.maxWidth >= 500;
          final VoidCallback? onMenu = this.onMenu;
          return Row(
            children: <Widget>[
              if (onMenu != null) ...<Widget>[
                Button(
                  variant: ButtonVariant.ghost,
                  size: ButtonSize.icon,
                  onPressed: onMenu,
                  child: const Icon(LucideIcons.menu, size: 18),
                ),
                Gap(theme.spacing.md),
              ] else ...<Widget>[
                Icon(
                  LucideIcons.command,
                  size: 18,
                  color: theme.colors.foreground,
                ),
                Gap(theme.spacing.md),
              ],
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
                Gap(theme.spacing.md),
                const SizedBox(width: 200, child: Input(hintText: 'Search')),
              ],
              Gap(theme.spacing.md),
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

/// The sidebar panel: grouped navigation plus a storage meter. Shared by the
/// desktop layout and the mobile drawer, so both stay identical.
class Sidebar03Sidebar extends StatelessWidget {
  /// Creates the sidebar panel.
  const Sidebar03Sidebar({super.key, this.selected = 0, this.onSelected});

  /// Index of the selected link; drives the highlight.
  final int selected;

  /// Called with the tapped link index; null leaves the panel static.
  final ValueChanged<int>? onSelected;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
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
            padding: EdgeInsets.all(theme.spacing.lg),
            child: Text(
              'Navigation',
              style: theme.typography.textLarge.copyWith(
                color: theme.colors.sidebarForeground,
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: EdgeInsets.all(theme.spacing.sm),
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
            padding: EdgeInsets.all(theme.spacing.lg),
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
                Gap(theme.spacing.sm),
                Text(
                  '12.4 GB of 20 GB',
                  style: theme.typography.textSmall.copyWith(
                    color: theme.colors.sidebarForeground,
                  ),
                ),
                Gap(theme.spacing.sm),
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
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final Color foreground = selected
        ? theme.colors.sidebarAccentForeground
        : theme.colors.sidebarForeground;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: theme.spacing.md,
          vertical: theme.spacing.sm,
        ),
        decoration: BoxDecoration(
          color: selected ? theme.colors.sidebarAccent : null,
          borderRadius: theme.borderRadiusSm,
        ),
        child: Row(
          children: <Widget>[
            Icon(link.icon, size: 16, color: foreground),
            Gap(theme.spacing.sm),
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
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Progress(
      value: 0.62,
      height: theme.spacing.xs,
      color: theme.colors.sidebarPrimary,
      backgroundColor: theme.colors.muted,
    );
  }
}
