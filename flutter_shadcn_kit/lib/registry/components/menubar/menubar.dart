// The `menubar` component: a horizontal bar of menu triggers anchored to
// submenu popovers. Rows, surfaces and keyboard traversal come from `menu`;
// this file is the bar container and its `MenubarTheme` resolution.
//
// The old module owned a public `MenubarState` that had drifted from the
// menu copy; the new bar is a stateless container and `menu` owns the theme.

import 'package:flutter/widgets.dart';

import '../../theme/density.dart';
import '../../theme/theme.dart';
import '../menu/menu.dart';

/// Bar contract (shadcn menubar: `rounded-md border bg-background p-1`,
/// radius md) resolved through widget > tree > app > defaults.
///
/// Every row inside the bar resolves the menu's `MenuTheme`, so menus opened
/// from the bar match that component.
class Menubar extends StatelessWidget {
  /// Creates a menubar.
  const Menubar({
    super.key,
    required this.children,
    this.border,
    this.popoverOffset,
    this.theme,
  });

  /// Top-level menu triggers, usually [MenuButton]s with a `subMenu`.
  ///
  /// Any widget works: non-[MenuItem] content (labels, separators) renders
  /// without taking part in traversal, like a [MenuGroup].
  final List<Widget> children;

  /// Whether the bar draws its border, background and padding; null resolves
  /// `MenubarTheme.border` (true).
  final bool? border;

  /// Submenu offset; null resolves `MenubarTheme.subMenuOffset`
  /// (`Offset(-4, 8)`), matching shadcn's submenu placement below the bar.
  final Offset? popoverOffset;

  /// Widget-leg theme override, merged over the component/app/defaults legs.
  final MenubarTheme? theme;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final MenubarTheme style =
        resolveComponentStyle<MenubarTheme, MenubarTheme>(
          context,
          widget: theme,
          select: (t) => t,
          defaults: menubarDefaults,
        );
    final bool bordered = border ?? style.border ?? true;
    final Offset offset =
        popoverOffset ?? style.subMenuOffset ?? const Offset(-4, 8);

    Widget bar = MenuGroup(
      // Horizontal root: submenu levels open below the trigger's start
      // edge (see MenuButton); nested groups always reset to vertical.
      direction: Axis.horizontal,
      subMenuOffset: offset,
      autofocus: false,
      builder: (context, rows) => IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: rows,
        ),
      ),
      children: children,
    );

    if (!bordered) {
      return bar;
    }
    final Color? background = style.background?.resolve(ambient.colors);
    final Color? borderColor = style.borderColor?.resolve(ambient.colors);
    final double borderWidth = style.borderWidth ?? 1;
    bar = Padding(
      padding: resolveEdgeInsets(
        style.padding ?? menubarDefaults.padding!,
        ambient.density.baseContentPadding * ambient.scaling,
      ),
      child: bar,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: style.borderRadius ?? ambient.borderRadiusMd,
        border: borderColor == null || borderWidth <= 0
            ? null
            : Border.all(color: borderColor, width: borderWidth),
      ),
      child: bar,
    );
  }
}
