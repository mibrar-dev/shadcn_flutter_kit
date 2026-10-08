// Shared row/submenu machinery for the menu family (round 2): resolved
// values in, painted rows out. Wave-D consumers reuse rows and levels.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../foundation/data.dart';
import '../foundation/icons/lucide_icons.dart';
import '../theme/theme.dart';
import 'clickable.dart';
import 'menu_nav.dart';
import 'overlay.dart';
import 'popover_controller.dart';

/// Intent bound to the arrows to shadow the `Clickable` framework traversal.
///
/// Unbound, so the key reports ignored and bubbles to [RovingGroup]. (An
/// action override cannot work: `toKeyEventResult` reads `consumesKey`.)
class _BubbleIntent extends Intent {
  /// Creates a bubbling intent.
  const _BubbleIntent();
}

/// Arrow bindings rerouted to [_BubbleIntent].
final Map<LogicalKeySet, Intent> _bubbleArrows = <LogicalKeySet, Intent>{
  LogicalKeySet(LogicalKeyboardKey.arrowUp): const _BubbleIntent(),
  LogicalKeySet(LogicalKeyboardKey.arrowDown): const _BubbleIntent(),
  LogicalKeySet(LogicalKeyboardKey.arrowLeft): const _BubbleIntent(),
  LogicalKeySet(LogicalKeyboardKey.arrowRight): const _BubbleIntent(),
};

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

/// One focusable row in a [RovingGroup]: owns its focus node, registers its
/// traversal slot, and paints the row from resolved values.
///
/// Theme-free by design: callers resolve their four theme legs and pass
/// concrete colours. Submenu behaviour (open on hover/ArrowRight) stays with
/// the caller through [onHover]/[onOpen].
class RovingRow extends StatefulWidget {
  /// Creates a roving row.
  const RovingRow({
    super.key,
    required this.child,
    this.leading,
    this.trailing,
    this.showChevron = false,
    this.reserveLeading = false,
    this.enabled = true,
    this.focusNode,
    this.onPressed,
    this.onHover,
    this.fill,
    this.foreground,
    this.radius,
    this.padding,
    this.textStyle,
    this.minHeight = 32,
    this.label,
    this.onOpen,
    this.onClose,
    this.isOpen,
  });

  /// Row content.
  final Widget child;

  /// Leading widget (indicator, icon or gutter spacer).
  final Widget? leading;

  /// Trailing widget.
  final Widget? trailing;

  /// Whether a submenu chevron follows [trailing].
  final bool showChevron;

  /// Whether to reserve a 16px leading gutter when [leading] is null.
  final bool reserveLeading;

  /// Whether the row interacts and takes part in traversal.
  final bool enabled;

  /// Focus node; owned internally when null.
  final FocusNode? focusNode;

  /// Called on tap and on Enter/Space while focused.
  final VoidCallback? onPressed;

  /// Called when the hover state changes.
  final ValueChanged<bool>? onHover;

  /// Resolved row fill; null draws none.
  final Color? fill;

  /// Resolved label/icon colour; null resolves the foreground token.
  final Color? foreground;

  /// Resolved corner radius; null resolves `borderRadiusSm`.
  final BorderRadius? radius;

  /// Resolved inner padding; null resolves px-2 py-1.5.
  final EdgeInsetsGeometry? padding;

  /// Resolved label style; its colour is ignored.
  final TextStyle? textStyle;

  /// Minimum row height.
  final double minHeight;

  /// Typeahead text; null falls back to a `Text` child's data.
  final String? label;

  /// Opens the row's nested level (ArrowRight).
  final VoidCallback? onOpen;

  /// Closes the row's nested level, if any.
  final VoidCallback? onClose;

  /// Whether the row's nested level is open.
  final bool Function()? isOpen;
  @override
  State<RovingRow> createState() => _RovingRowState();
}

/// Typeahead text of [child] when it is a `Text`, else null.
String? _textOf(Widget child) => child is Text ? child.data : null;

class _RovingRowState extends State<RovingRow> {
  MenuGroupData? _group;
  FocusNode? _ownedNode;
  FocusNode get _node => widget.focusNode ?? (_ownedNode ??= FocusNode());

  /// Leading with the 16px box and gutter reservation applied.
  Widget? get _resolvedLeading {
    if (widget.leading != null) {
      return SizedBox(width: 16, height: 16, child: widget.leading);
    }
    return widget.reserveLeading ? const SizedBox(width: 16, height: 16) : null;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final MenuGroupData? group = Data.maybeFind<MenuGroupData>(context);
      assert(group != null, 'RovingRow must be a child of RovingGroup');
      if (group == null) return;
      _group = group;
      group.slots.add(
        MenuNavSlot(
          node: _node,
          enabled: widget.enabled,
          label: widget.label ?? _textOf(widget.child),
          onOpen: widget.onOpen,
          onClose: widget.onClose,
          isOpen: widget.isOpen,
        ),
      );
    });
  }

  @override
  void dispose() {
    _group?.slots.removeWhere((s) => s.node == _node);
    _ownedNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData app = ShadcnTheme.of(context);
    final Color fg = widget.foreground ?? app.colors.foreground;
    final BorderRadius resolvedRadius =
        widget.radius ?? app.borderRadiusSm.resolve(Directionality.of(context));
    final TextStyle text = (widget.textStyle ?? const TextStyle(fontSize: 14))
        .copyWith(color: fg);
    return Opacity(
      opacity: widget.enabled ? 1 : 0.5,
      child: Clickable(
        enabled: widget.enabled,
        focusNode: _node,
        onPressed: widget.enabled ? widget.onPressed : null,
        onHover: widget.enabled && widget.onHover != null
            ? (hovered) {
                if (hovered) _node.requestFocus();
                widget.onHover!(hovered);
              }
            : null,
        shortcuts: _bubbleArrows,
        decoration: WidgetStatePropertyAll<Decoration?>(
          widget.fill == null
              ? null
              : BoxDecoration(color: widget.fill, borderRadius: resolvedRadius),
        ),
        padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
          widget.padding ??
              const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        ),
        textStyle: WidgetStatePropertyAll<TextStyle?>(text),
        iconTheme: WidgetStatePropertyAll<IconThemeData?>(
          IconThemeData(color: fg),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: widget.minHeight),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ?_resolvedLeading,
              if (_resolvedLeading != null) const SizedBox(width: 8),
              Flexible(
                child: DefaultTextStyle(style: text, child: widget.child),
              ),
              if (widget.trailing != null || widget.showChevron)
                const SizedBox(width: 8),
              ?widget.trailing,
              if (widget.trailing == null && widget.showChevron)
                Icon(LucideIcons.chevronRight, size: 16, color: fg),
            ],
          ),
        ),
      ),
    );
  }
}
