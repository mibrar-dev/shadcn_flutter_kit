// The `dropdown_menu` component: a menu surface anchored below the widget
// that opened it. Rows, traversal and the popup surface come from `menu`;
// this file adds the anchored show helper and the standalone surface.

import 'package:flutter/widgets.dart';

import '../../primitives/overlay.dart';
import '../../primitives/popover.dart';
import '../../primitives/sheet_overlay.dart';
import '../../theme/theme.dart';
import '../menu/menu.dart';

/// A menu surface for a dropdown: the menu's rows inside a [MenuPopup],
/// dismissing the overlay it is shown in when a row closes the menu.
///
/// Inline surfaces never take focus on mount; overlay helpers pass
/// `autofocus: true` for the opened menu.
class DropdownMenu extends StatelessWidget {
  /// Creates a dropdown menu surface.
  const DropdownMenu({
    super.key,
    required this.children,
    this.theme,
    this.autofocus = false,
  });

  /// The menu rows.
  final List<Widget> children;

  /// Widget-leg surface override, merged over the popup theme legs.
  final MenuPopupTheme? theme;

  /// Whether the group takes focus on mount; true for opened overlays.
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    // Inside a sheet overlay the menu keeps the sheet's horizontal gutter.
    final EdgeInsets itemPadding = SheetOverlayHandler.isSheetOverlay(context)
        ? EdgeInsets.symmetric(horizontal: ambient.spacing.sm)
        : EdgeInsets.zero;
    return MenuPopup(
      theme: theme,
      children: <Widget>[
        MenuGroup(
          autofocus: autofocus,
          itemPadding: itemPadding,
          subMenuOffset: const Offset(8, -4),
          onDismissed: () => closeOverlay(context),
          children: children,
        ),
      ],
    );
  }
}

/// Shows [children] as a dropdown menu anchored to [context].
///
/// The menu is non-modal: tapping outside closes it, taps do not reach the
/// content behind it while it is open, and submenu levels keep working
/// through the menu's own traversal engine. The opened menu takes focus so
/// keyboard traversal works immediately. Completes with the value passed
/// to [closeOverlay] or `null` when dismissed.
Future<T?> showShadcnDropdown<T>({
  required BuildContext context,
  required List<Widget> children,
  AlignmentGeometry alignment = AlignmentDirectional.topStart,
  AlignmentGeometry anchorAlignment = AlignmentDirectional.bottomStart,
  Offset offset = const Offset(0, 4),
  PopoverConstraint widthConstraint = PopoverConstraint.anchorFixedSize,
  PopoverConstraint heightConstraint = PopoverConstraint.flexible,
  MenuPopupTheme? theme,
}) {
  return showPopover<T>(
    context: context,
    handler: OverlayHandler.popover,
    alignment: alignment,
    anchorAlignment: anchorAlignment,
    offset: offset,
    widthConstraint: widthConstraint,
    heightConstraint: heightConstraint,
    modal: false,
    consumeOutsideTaps: false,
    dismissBackdropFocus: false,
    builder: (context) =>
        DropdownMenu(autofocus: true, theme: theme, children: children),
  ).future;
}
