// The generic navigation row: a styled, selectable `Clickable` with an
// optional label that collapses, positions and overflows, plus roving-group
// registration.
//
// Ported from `components/navigation/navigation_bar/_impl/core/navigation_item.dart`,
// `_navigation_labeled.dart` and `_abstract_navigation_button_state.dart`. It
// lives in `primitives/navigation/` (P4-B22, Q7): the row is generic
// selectable-item machinery (any nav/menu surface can use it) and the
// `navigation_bar` component cannot fit its three-Dart-file folder otherwise.
//
// It imports no component on purpose: the caller wraps the label for marquee
// or tooltip presentation (`wrapLabel`), and provides the roving registry
// through `RovingGroupScope`.

import '../../foundation/geometry.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/data.dart';
import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';
import '../clickable.dart';
import 'navigation_theme.dart';
import '../hidden.dart';
import '../roving_group.dart';

/// The layout/interaction half of one navigation item.
///
/// The caller resolves the theme slices (`background`, `foreground`, ...) and
/// passes plain values, so this file never reads a component theme.
class NavigationItemRow extends StatefulWidget {
  /// Creates a navigation row.
  const NavigationItemRow({
    super.key,
    required this.child,
    this.label,
    this.selected = false,
    this.enabled = true,
    this.showLabel = false,
    this.position = NavigationLabelPosition.bottom,
    this.spacing = 8,
    this.labelStyle,
    this.overflow = TextOverflow.clip,
    this.wrapLabel,
    this.background,
    this.foreground,
    this.borderColor,
    this.borderWidth = 1,
    this.padding,
    this.minHeight,
    this.textStyle,
    this.onPressed,
    this.focusNode,
    this.registryValue,
  });

  /// Main content (usually an icon).
  final Widget child;

  /// Optional label.
  final Widget? label;

  /// Whether the row is the current selection.
  final bool selected;

  /// Whether the row accepts input.
  final bool enabled;

  /// Whether the label is expanded; it collapses with an animation otherwise.
  final bool showLabel;

  /// Label position relative to [child].
  final NavigationLabelPosition position;

  /// Space between the icon and the label.
  final double spacing;

  /// Label text style; its colour is taken from [foreground].
  final TextStyle? labelStyle;

  /// Label text overflow when no [wrapLabel] handles it.
  final TextOverflow overflow;

  /// Extra wrapper for the label (marquee, tooltip); null uses [overflow].
  final Widget Function(Widget label)? wrapLabel;

  /// Per-state fill.
  final StateValue<ThemedColor>? background;

  /// Per-state foreground for the content and label.
  final StateValue<ThemedColor>? foreground;

  /// Per-state border; null draws none.
  final StateValue<ThemedColor>? borderColor;

  /// Border width used when [borderColor] resolves non-null.
  final double borderWidth;

  /// Row padding; null resolves `navigationItemDefaultPadding` (12x8).
  final EdgeInsetsGeometry? padding;

  /// Content box minimum height; null adds none.
  final double? minHeight;

  /// Text style before the foreground colour is applied.
  final TextStyle? textStyle;

  /// Called when the row is pressed.
  final VoidCallback? onPressed;

  /// Focus node; one is created and disposed when null.
  final FocusNode? focusNode;

  /// Value registered with the nearest `RovingGroupRegistry<int>`; null skips
  /// registration.
  final int? registryValue;

  @override
  State<NavigationItemRow> createState() => _NavigationItemRowState();
}

class _NavigationItemRowState extends State<NavigationItemRow> {
  final WidgetStatesController _states = WidgetStatesController();
  FocusNode? _ownedFocusNode;
  RovingGroupRegistry<int>? _registry;

  FocusNode get _focusNode =>
      widget.focusNode ?? (_ownedFocusNode ??= FocusNode());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _registry = Data.maybeOf<RovingGroupRegistry<int>>(context);
  }

  @override
  void dispose() {
    _registry?.unregister(this);
    _ownedFocusNode?.dispose();
    _states.dispose();
    super.dispose();
  }

  void _register() {
    final RovingGroupRegistry<int>? registry = _registry;
    final int? value = widget.registryValue;
    if (registry == null || value == null) {
      return;
    }
    registry.register(
      RovingItem<int>(
        key: this,
        value: value,
        enabled: widget.enabled,
        selected: widget.selected,
        requestFocus: () => _focusNode.requestFocus(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _register();
    return Clickable(
      enabled: widget.enabled,
      focusNode: _focusNode,
      statesController: _states,
      onPressed: widget.onPressed,
      shortcuts: _registry?.shortcuts,
      actions: _registry?.actions,
      child: ListenableBuilder(
        listenable: _states,
        builder: (BuildContext context, Widget? child) => _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final Set<WidgetState> states = <WidgetState>{
      ..._states.value,
      if (!widget.enabled) WidgetState.disabled,
      if (widget.selected) WidgetState.selected,
    };
    final Color? background = widget.background
        ?.resolve(states)
        ?.resolve(ambient.colors);
    final Color? border = widget.borderColor
        ?.resolve(states)
        ?.resolve(ambient.colors);
    final Color? foreground = widget.foreground
        ?.resolve(states)
        ?.resolve(ambient.colors);
    final TextStyle textStyle = (widget.textStyle ?? const TextStyle())
        .copyWith(color: foreground);
    final double borderWidth = widget.borderWidth;
    final bool hasBorder = widget.borderColor != null && borderWidth > 0;
    // `navigationItemDefaults` stores density multipliers; the widget leg
    // passes through `resolveEdgeInsets` unchanged, so both spellings work.
    final EdgeInsets resolvedPadding = resolveEdgeInsets(
      widget.padding ?? navigationItemDefaultPadding,
      ambient.density.baseContentPadding * ambient.scaling,
    ).resolve(Directionality.of(context));
    // The border is decoration padding and adds layout; inset the row padding
    // by its width so a bordered row keeps its size-table height (F1).
    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: ambient.borderRadiusMd,
        border: hasBorder
            ? Border.all(
                color: border ?? const Color(0x00000000),
                width: borderWidth,
              )
            : null,
      ),
      padding: hasBorder
          ? insetBorder(resolvedPadding, borderWidth)
          : resolvedPadding,
      child: DefaultTextStyle.merge(
        style: textStyle,
        child: IconTheme.merge(
          data: IconThemeData(color: foreground, size: 16 * ambient.scaling),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: (widget.minHeight ?? 0) * ambient.scaling,
            ),
            child: _labeled(),
          ),
        ),
      ),
    );
  }

  Widget _labeled() {
    final Widget? label = widget.label;
    if (label == null) {
      return widget.child;
    }
    final Axis axis =
        widget.position == NavigationLabelPosition.top ||
            widget.position == NavigationLabelPosition.bottom
        ? Axis.vertical
        : Axis.horizontal;
    final bool before =
        widget.position == NavigationLabelPosition.start ||
        widget.position == NavigationLabelPosition.top;
    final double spacing = widget.spacing;
    final Widget expanded = Hidden(
      hidden: !widget.showLabel,
      direction: axis,
      reverse: before,
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          top: widget.position == NavigationLabelPosition.bottom ? spacing : 0,
          bottom: widget.position == NavigationLabelPosition.top ? spacing : 0,
          start: widget.position == NavigationLabelPosition.end ? spacing : 0,
          end: widget.position == NavigationLabelPosition.start ? spacing : 0,
        ),
        child: DefaultTextStyle.merge(
          style: widget.labelStyle,
          maxLines: 1,
          overflow: widget.overflow,
          child: widget.wrapLabel?.call(label) ?? label,
        ),
      ),
    );
    return Flex(
      direction: axis,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (before) Flexible(child: expanded),
        widget.child,
        if (!before) Flexible(child: expanded),
      ],
    );
  }
}
