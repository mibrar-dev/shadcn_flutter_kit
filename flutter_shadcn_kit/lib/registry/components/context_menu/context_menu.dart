// The `context_menu` component: a menu shown at the pointer on right-click
// (and long-press on touch platforms). Rows, traversal and the popup surface
// come from `menu`; this file adds the pointer gesture and the positioned
// show helper.

import 'package:flutter/widgets.dart';

import '../../primitives/overlay.dart';
import '../../primitives/popover.dart';
import '../../primitives/sheet_overlay.dart';
import '../../theme/theme.dart';
import '../menu/menu.dart';

/// Wraps [child] so a secondary-click (and a long-press on touch platforms)
/// opens [items] as a menu at the pointer.
///
/// The menu is non-modal: tapping outside closes it, and the rows use the
/// menu's traversal engine (arrows, Enter/Space, Escape, typeahead). A
/// secondary click on a disabled menu does nothing.
class ContextMenu extends StatelessWidget {
  /// Creates a context menu.
  const ContextMenu({
    super.key,
    required this.child,
    required this.items,
    this.behavior = HitTestBehavior.translucent,
    this.direction = Axis.vertical,
    this.enabled = true,
    this.theme = const MenuTheme(),
    this.popupTheme,
  });

  /// The widget that triggers the menu.
  final Widget child;

  /// The menu rows.
  final List<Widget> items;

  /// Hit-test behavior of the trigger area.
  final HitTestBehavior behavior;

  /// Row layout of the menu.
  final Axis direction;

  /// Whether the menu can open.
  final bool enabled;

  /// Widget-leg row theme override, applied inside the popup.
  final MenuTheme theme;

  /// Widget-leg surface override, merged over the popup theme legs.
  final MenuPopupTheme? popupTheme;

  @override
  Widget build(BuildContext context) {
    final TargetPlatform platform = ShadcnTheme.of(context).platform;
    final bool touch =
        platform == TargetPlatform.iOS ||
        platform == TargetPlatform.android ||
        platform == TargetPlatform.fuchsia;
    void open(Offset position) {
      // The pointer offset is physical: mirror it in RTL so the menu still
      // opens just past the pointer on the reading side.
      final bool rtl = Directionality.of(context) == TextDirection.rtl;
      showShadcnContextMenu<void>(
        context: context,
        position: position + Offset(rtl ? -8 : 8, 0),
        children: items,
        direction: direction,
        theme: theme,
        popupTheme: popupTheme,
      );
    }

    return GestureDetector(
      behavior: behavior,
      onSecondaryTapDown: enabled
          ? (details) => open(details.globalPosition)
          : null,
      onLongPressStart: enabled && touch
          ? (details) => open(details.globalPosition)
          : null,
      child: child,
    );
  }
}

/// Shows [children] as a context menu at [position] (global coordinates).
///
/// The menu opens just right of the pointer, is non-modal, keeps submenu
/// levels working and completes when a row closes it or a tap lands outside.
/// The opened menu takes focus so keyboard traversal works immediately.
Future<T?> showShadcnContextMenu<T>({
  required BuildContext context,
  required Offset position,
  required List<Widget> children,
  Axis direction = Axis.vertical,
  MenuTheme theme = const MenuTheme(),
  MenuPopupTheme? popupTheme,
}) {
  return showPopover<T>(
    context: context,
    handler: OverlayHandler.popover,
    // [position] already includes the reading-side gap applied by the caller.
    position: position,
    alignment: Alignment.topLeft,
    modal: false,
    consumeOutsideTaps: false,
    dismissBackdropFocus: false,
    follow: false,
    builder: (context) {
      final ShadcnThemeData ambient = ShadcnTheme.of(context);
      final EdgeInsets itemPadding = SheetOverlayHandler.isSheetOverlay(context)
          ? EdgeInsets.symmetric(horizontal: ambient.spacing.sm)
          : EdgeInsets.zero;
      return MenuPopup(
        theme: popupTheme,
        children: <Widget>[
          ComponentTheme<MenuTheme>(
            data: theme,
            child: MenuGroup(
              autofocus: true,
              direction: direction,
              itemPadding: itemPadding,
              subMenuOffset: const Offset(8, -4),
              onDismissed: () => closeOverlay(context),
              children: children,
            ),
          ),
        ],
      );
    },
  ).future;
}
