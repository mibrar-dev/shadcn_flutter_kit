// The `sidebar-02` block: an inset sidebar with grouped navigation.
//
// A block is layer 4 of the registry: it may import foundation, theme,
// primitives and components, never another block. Its public widget is the
// preview - the docs page renders it exactly as an app would.
//
// The sidebar is inset (rounded, with a gutter to the page background) and
// its navigation is grouped by section. The search field filters the
// navigation live. From 840px the sidebar sits beside the content; below
// that a menu button opens it as a drawer. The content is a sample
// playground screen with stats, files and activity. The layout shrink-wraps
// so the docs frame sizes to its intrinsic height, and scrolls internally
// when the host is bounded.

import 'package:flutter/widgets.dart';

import '../../components/button/button.dart';
import '../../components/drawer/drawer.dart';
import 'sidebar_02_content.dart';
import 'sidebar_02_panel.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/theme.dart';

/// A grouped, inset sidebar shell around a sample content area.
class Sidebar02 extends StatefulWidget {
  /// Creates the block.
  const Sidebar02({super.key});

  @override
  State<Sidebar02> createState() => _Sidebar02State();
}

class _Sidebar02State extends State<Sidebar02> {
  int _selected = 0;

  void _openNav() {
    openDrawer(
      context: context,
      position: OverlayPosition.start,
      builder: (BuildContext context) => SingleChildScrollView(
        child: Sidebar02Panel(
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
            final Widget content = Sidebar02Content(selected: _selected);
            final Widget body;
            if (constraints.maxWidth >= 840) {
              body = Padding(
                padding: EdgeInsets.all(theme.spacing.md),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 260,
                      child: Sidebar02Panel(
                        selected: _selected,
                        onSelected: (int index) =>
                            setState(() => _selected = index),
                      ),
                    ),
                    Gap(theme.spacing.md),
                    Expanded(child: content),
                  ],
                ),
              );
            } else {
              body = Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _Sidebar02Bar(onMenu: _openNav),
                  Gap(theme.spacing.lg),
                  content,
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

/// The mobile bar: a menu trigger plus the product mark.
class _Sidebar02Bar extends StatelessWidget {
  const _Sidebar02Bar({required this.onMenu});

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
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: theme.colors.sidebarPrimary,
              borderRadius: theme.borderRadiusSm,
            ),
            child: Icon(
              LucideIcons.command,
              size: 16,
              color: theme.colors.sidebarPrimaryForeground,
            ),
          ),
          Gap(theme.spacing.sm),
          Text(
            'Acme Inc',
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.sidebarForeground,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
