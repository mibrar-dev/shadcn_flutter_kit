// The `sidebar-01` block: a collapsible icon rail beside a mailbox screen.
//
// A block is layer 4 of the registry: it may import foundation, theme,
// primitives and components, never another block. Its public widget is the
// preview - the docs page renders it exactly as an app would.
//
// The rail reads the sidebar tokens (`sidebar`, `sidebarAccent`, …), so it
// re-themes with every preset. From 720px the rail sits beside the content;
// below that a menu button opens the navigation as a drawer. The content is
// a sample mailbox with stats and activity. The layout shrink-wraps so the
// docs frame sizes to its intrinsic height, and scrolls internally when the
// host is bounded.

import 'package:flutter/widgets.dart';

import '../../components/button/button.dart';
import '../../components/drawer/drawer.dart';
import 'sidebar_01_content.dart';
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

  void _openNav() {
    openDrawer(
      context: context,
      position: OverlayPosition.start,
      builder: (BuildContext context) => _Sidebar01DrawerNav(
        selected: _selected,
        onSelected: (int index) {
          setState(() => _selected = index);
          closeDrawer(context);
        },
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
            final bool vertical = constraints.maxWidth >= 720;
            final Widget content = Sidebar01Content(selected: _selected);
            final Widget body;
            if (!vertical) {
              body = Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _Sidebar01Bar(selected: _selected, onMenu: _openNav),
                  Gap(theme.spacing.lg),
                  content,
                ],
              );
            } else {
              body = Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _Sidebar01Rail(
                    selected: _selected,
                    onSelected: (int index) =>
                        setState(() => _selected = index),
                  ),
                  Gap(theme.spacing.lg),
                  Expanded(child: content),
                ],
              );
            }
            if (!constraints.maxHeight.isFinite) {
              return Padding(
                padding: EdgeInsets.all(theme.spacing.lg),
                child: body,
              );
            }
            return SingleChildScrollView(
              padding: EdgeInsets.all(theme.spacing.lg),
              child: body,
            );
          },
        ),
      ),
    );
  }
}

/// The icon rail (desktop): one 40px button per destination.
class _Sidebar01Rail extends StatelessWidget {
  const _Sidebar01Rail({required this.selected, required this.onSelected});

  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Container(
      padding: EdgeInsets.all(theme.spacing.sm),
      decoration: BoxDecoration(
        color: theme.colors.sidebar,
        borderRadius: theme.borderRadiusLg,
        border: Border.all(color: theme.colors.sidebarBorder),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (var i = 0; i < sidebar01Items.length; i++)
            _Sidebar01RailButton(
              item: sidebar01Items[i],
              selected: i == selected,
              onPressed: () => onSelected(i),
            ),
        ],
      ),
    );
  }
}

class _Sidebar01RailButton extends StatelessWidget {
  const _Sidebar01RailButton({
    required this.item,
    required this.selected,
    required this.onPressed,
  });

  final Sidebar01Item item;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Semantics(
        label: item.label,
        selected: selected,
        button: true,
        child: GestureDetector(
          onTap: onPressed,
          child: Container(
            width: 40,
            height: 40,
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
      ),
    );
  }
}

/// The mobile bar: a menu trigger plus the current destination title.
class _Sidebar01Bar extends StatelessWidget {
  const _Sidebar01Bar({required this.selected, required this.onMenu});

  final int selected;
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.md,
        vertical: theme.spacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colors.sidebar,
        borderRadius: theme.borderRadiusLg,
        border: Border.all(color: theme.colors.sidebarBorder),
      ),
      child: Row(
        children: <Widget>[
          Button(
            variant: ButtonVariant.ghost,
            size: ButtonSize.icon,
            onPressed: onMenu,
            child: const Icon(LucideIcons.menu, size: 18),
          ),
          Gap(theme.spacing.md),
          Expanded(
            child: Text(
              sidebar01Items[selected].label,
              style: theme.typography.textSmall.copyWith(
                color: theme.colors.sidebarForeground,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The drawer navigation (mobile): full-width labelled rows.
class _Sidebar01DrawerNav extends StatelessWidget {
  const _Sidebar01DrawerNav({required this.selected, required this.onSelected});

  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return ColoredBox(
      color: theme.colors.sidebar,
      child: Padding(
        padding: EdgeInsets.all(theme.spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Acme Inc',
              style: theme.typography.textSmall.copyWith(
                color: theme.colors.sidebarForeground,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gap(theme.spacing.lg),
            for (var i = 0; i < sidebar01Items.length; i++)
              _Sidebar01DrawerRow(
                item: sidebar01Items[i],
                selected: i == selected,
                onPressed: () => onSelected(i),
              ),
          ],
        ),
      ),
    );
  }
}

class _Sidebar01DrawerRow extends StatelessWidget {
  const _Sidebar01DrawerRow({
    required this.item,
    required this.selected,
    required this.onPressed,
  });

  final Sidebar01Item item;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final Color foreground = selected
        ? theme.colors.sidebarAccentForeground
        : theme.colors.sidebarForeground;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.only(bottom: theme.spacing.xs),
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
            Icon(item.icon, size: 16, color: foreground),
            Gap(theme.spacing.sm),
            Text(
              item.label,
              style: theme.typography.textSmall.copyWith(color: foreground),
            ),
          ],
        ),
      ),
    );
  }
}
