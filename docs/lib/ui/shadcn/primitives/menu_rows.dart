// Shared row/submenu machinery for the menu family (round 2): resolved
// values in, painted rows out. Wave-D consumers reuse rows and levels.

import 'package:flutter/widgets.dart';

import '../theme/theme.dart';
import 'overlay.dart';
import 'popover_controller.dart';

export 'roving_row.dart';

/// The popup surface rows are presented on, from resolved values.
class MenuPopupSurface extends StatelessWidget {
  /// Creates a menu popup surface.
  const MenuPopupSurface({
    super.key,
    required this.children,
    this.fill,
    this.foreground,
    this.borderColor,
    this.borderWidth = 1,
    this.borderRadius,
    this.padding,
    this.minWidth = 192,
  });

  /// The rows.
  final List<Widget> children;

  /// Resolved surface fill; null resolves the popover token.
  final Color? fill;

  /// Resolved content colour; null resolves popoverForeground.
  final Color? foreground;

  /// Resolved border colour; null resolves the border token.
  final Color? borderColor;

  /// Border width.
  final double borderWidth;

  /// Resolved corner radius; null resolves `borderRadiusMd`.
  final BorderRadius? borderRadius;

  /// Resolved inner padding; null resolves all 4.
  final EdgeInsetsGeometry? padding;

  /// Minimum popup width (12rem).
  final double minWidth;
  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData app = ShadcnTheme.of(context);
    final Color fg = foreground ?? app.colors.popoverForeground;
    final BorderRadius radius =
        borderRadius ?? app.borderRadiusMd.resolve(Directionality.of(context));
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minWidth),
      child: Container(
        padding: padding ?? const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: fill ?? app.colors.popover,
          border: Border.all(
            color: borderColor ?? app.colors.border,
            width: borderWidth,
          ),
          borderRadius: radius,
        ),
        child: DefaultTextStyle(
          style: TextStyle(color: fg),
          child: IconTheme.merge(
            data: IconThemeData(color: fg),
            child: SingleChildScrollView(
              child: IntrinsicWidth(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Opens one menu level as a non-modal popover anchored to [context].
///
/// The popover never dismisses itself: siblings close through the caller's
/// `MenuGroupData.closeOthers()` first, the whole menu through `closeAll()`.
/// Themes stay live through the handler's captured themes.
Future<T?> showMenuPopover<T>({
  required BuildContext context,
  required PopoverController controller,
  required WidgetBuilder popupBuilder,
  Offset? offset,
  AlignmentGeometry alignment = Alignment.topLeft,
  AlignmentGeometry anchorAlignment = Alignment.topRight,
}) {
  return controller.show<T>(
    context: context,
    handler: OverlayHandler.popover,
    modal: false,
    consumeOutsideTaps: false,
    dismissBackdropFocus: false,
    alignment: alignment,
    anchorAlignment: anchorAlignment,
    offset: offset ?? const Offset(8, -4),
    builder: popupBuilder,
  );
}

/// A non-interactive section header (shadcn `font-semibold`).
///
/// Plain widget on purpose: headers never take focus, so they stay out of
/// the `MenuItem` traversal contract and compose into any row list.
class MenuLabel extends StatelessWidget {
  /// Creates a menu label.
  const MenuLabel({super.key, required this.child});

  /// Label content.
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData app = ShadcnTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: DefaultTextStyle(
        style: app.typography.small.copyWith(
          color: app.colors.foreground,
          fontWeight: FontWeight.w600,
        ),
        child: child,
      ),
    );
  }
}

/// A keyboard-shortcut hint: text-xs, widest tracking, muted, end-aligned
/// (compose as a row's trailing).
class MenuShortcut extends StatelessWidget {
  /// Creates a shortcut hint.
  const MenuShortcut({super.key, required this.shortcut});

  /// Hint text, e.g. '⇧⌘P'.
  final String shortcut;
  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData app = ShadcnTheme.of(context);
    return Text(
      shortcut,
      style: app.typography.small.copyWith(
        fontSize: 12,
        letterSpacing: 1.2,
        color: app.colors.mutedForeground,
      ),
    );
  }
}

/// A 1px separator between rows. Never focusable, like [MenuLabel].
class MenuSeparator extends StatelessWidget {
  /// Creates a menu separator.
  const MenuSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(height: 1, color: ShadcnTheme.of(context).colors.border),
    );
  }
}

/// Default vertical stretcher layout for [RovingGroup] menus.
Widget columnMenuBuilder(BuildContext context, List<Widget> rows) => Column(
  mainAxisSize: MainAxisSize.min,
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: rows,
);
