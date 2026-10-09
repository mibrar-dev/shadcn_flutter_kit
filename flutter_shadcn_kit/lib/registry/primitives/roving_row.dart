// One focusable row in a `RovingGroup`: owns its focus node, registers its
// traversal slot and paints the shared menu row (hover/focus highlight,
// disabled at half opacity). Split out of `menu_rows.dart` in B20/F1 when
// that file passed the 400-line budget; `menu_rows.dart` re-exports it.
//
// Theme-free by design: callers resolve their theme legs and pass concrete
// values. Submenu behaviour (open on hover/ArrowRight) stays with the caller
// through `onHover`/`onOpen`.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../foundation/data.dart';
import '../foundation/icons/lucide_icons.dart';
import '../theme/theme.dart';
import 'clickable.dart';
import 'menu_nav.dart';

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
    this.highlightFill,
    this.foreground,
    this.highlightForeground,
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

  /// Resolved fill while hovered/focused/pressed; null resolves the `accent`
  /// token. Rows always show a hover/focus highlight (shadcn
  /// `focus:bg-accent`).
  final Color? highlightFill;

  /// Resolved label/icon colour; null resolves the `foreground` token.
  final Color? foreground;

  /// Resolved label/icon colour while hovered/focused/pressed; null resolves
  /// the `accentForeground` token (shadcn `focus:text-accent-foreground`).
  final Color? highlightForeground;

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
    final Color baseForeground = widget.foreground ?? app.colors.foreground;
    final Color highlightForeground =
        widget.highlightForeground ?? app.colors.accentForeground;
    final Color highlightFill = widget.highlightFill ?? app.colors.accent;
    final BorderRadius resolvedRadius =
        widget.radius ?? app.borderRadiusSm.resolve(Directionality.of(context));
    final TextStyle text = widget.textStyle ?? const TextStyle(fontSize: 14);
    // `minHeight` is a border-box total: the Clickable padding wraps the
    // ConstrainedBox, so a plain minimum would measure padding + minHeight
    // (44 instead of the shadcn h-8 = 32). The inner minimum reserves the
    // padding, like the button component's `_innerMin`.
    final EdgeInsets resolvedPadding =
        (widget.padding ??
                const EdgeInsets.symmetric(horizontal: 8, vertical: 6))
            .resolve(Directionality.of(context));
    bool active(Set<WidgetState> states) =>
        states.contains(WidgetState.hovered) ||
        states.contains(WidgetState.focused) ||
        states.contains(WidgetState.pressed);
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
        decoration: WidgetStateProperty.resolveWith<Decoration?>((states) {
          final Color? color = active(states) ? highlightFill : widget.fill;
          return color == null
              ? null
              : BoxDecoration(color: color, borderRadius: resolvedRadius);
        }),
        padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(resolvedPadding),
        textStyle: WidgetStateProperty.resolveWith<TextStyle?>(
          (states) => text.copyWith(
            color: active(states) ? highlightForeground : baseForeground,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData?>(
          (states) => IconThemeData(
            color: active(states) ? highlightForeground : baseForeground,
          ),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: (widget.minHeight - resolvedPadding.vertical).clamp(
              0,
              double.infinity,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ?_resolvedLeading,
              if (_resolvedLeading != null) const SizedBox(width: 8),
              Flexible(child: widget.child),
              if (widget.trailing != null || widget.showChevron)
                const SizedBox(width: 8),
              ?widget.trailing,
              if (widget.trailing == null && widget.showChevron)
                const Icon(LucideIcons.chevronRight, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
