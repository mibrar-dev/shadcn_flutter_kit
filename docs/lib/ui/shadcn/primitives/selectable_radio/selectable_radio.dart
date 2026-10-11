// The selectable row of a single-select group: [RadioItem] and the
// [RadioIndicator] circle it leads with.
//
// Split out of `components/radio_group` because the machinery is shared: the
// `select`, `menu` and `tabs` components (waves C and D) all need a themed
// selectable row, and re-deriving it would put a fourth copy of the same
// widget in the registry. Layer 2, so it can be used by any component — which
// is also why the *card* item lives with `radio_group` instead: a card is a
// component-layer surface, and a layer 2 file may not import one.

import 'package:flutter/widgets.dart';

import '../../foundation/data.dart';
import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';
import '../clickable.dart';
import '../roving_group.dart';
import 'selectable_radio_theme.dart';

export 'selectable_radio_theme.dart';

/// Opacity applied to a whole item while disabled (shadcn `opacity-50`).
const double selectableItemDisabledOpacity = 0.5;

/// Cursor for an enabled item; the system arrow while disabled.
const _radioMouseCursor = StateValue<MouseCursor>(
  rest: SystemMouseCursors.click,
  disabled: SystemMouseCursors.basic,
);

/// One option of a single-select group.
///
/// The group owns the selection; an item only reads it.
class RadioItem<T> extends StatefulWidget {
  /// Creates a row item.
  const RadioItem({
    super.key,
    required this.value,
    this.label,
    this.trailing,
    this.enabled = true,
    this.focusNode,
    this.autofocus = false,
    this.theme,
  });

  /// The value this item stands for.
  final T value;

  /// Label shown after the indicator.
  final Widget? label;

  /// Widget shown after the label.
  final Widget? trailing;

  /// Whether this item accepts input.
  final bool enabled;

  /// Focus node; created internally when [autofocus] is true and this is null.
  final FocusNode? focusNode;

  /// Whether the item takes focus when first built.
  final bool autofocus;

  /// Widget-leg style override.
  final SelectableRadioTheme? theme;

  @override
  State<RadioItem<T>> createState() => _RadioItemState<T>();
}

/// The `RadioItem` state.
class _RadioItemState<T> extends State<RadioItem<T>> {
  FocusNode? _ownedFocusNode;

  FocusNode? get _focusNode => widget.focusNode ?? _ownedFocusNode;

  /// Cached in [didChangeDependencies]: `dispose` runs after the element has
  /// been deactivated, so reading an inherited widget from `context` there
  /// would assert.
  RovingGroupRegistry<T>? _registry;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _registry = Data.maybeOf<RovingGroupRegistry<T>>(context);
    _syncRegistration();
  }

  bool get _interactive {
    final SelectableData<T>? group = Data.maybeOf<SelectableData<T>>(context);
    return widget.enabled && (group?.enabled ?? false);
  }

  @override
  void initState() {
    super.initState();
    _syncAutofocus();
  }

  @override
  void didUpdateWidget(covariant RadioItem<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.autofocus != oldWidget.autofocus ||
        widget.focusNode != oldWidget.focusNode) {
      _syncAutofocus();
    }
  }

  @override
  void dispose() {
    _registry?.unregister(this);
    _ownedFocusNode?.dispose();
    super.dispose();
  }

  /// Tells the group about this item so the arrow keys can walk onto it.
  void _syncRegistration() {
    final RovingGroupRegistry<T>? registry = _registry;
    if (registry == null) {
      return;
    }
    final SelectableData<T>? group = Data.maybeOf<SelectableData<T>>(context);
    registry.register(
      RovingItem<T>(
        key: this,
        value: widget.value,
        enabled: widget.enabled && (group?.enabled ?? false),
        selected: group?.selected == widget.value,
        requestFocus: () => _focusNode?.requestFocus(),
      ),
    );
  }

  void _syncAutofocus() {
    final bool needsOwnNode = widget.autofocus && widget.focusNode == null;
    if (needsOwnNode && _ownedFocusNode == null) {
      final FocusNode node = FocusNode(debugLabel: 'RadioItem');
      _ownedFocusNode = node;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          node.requestFocus();
        }
      });
      return;
    }
    if (!needsOwnNode && _ownedFocusNode != null) {
      _ownedFocusNode!.dispose();
      _ownedFocusNode = null;
    }
  }

  void _select() {
    Data.maybeOf<SelectableData<T>>(context)?.select(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final SelectableData<T> group =
        Data.maybeOf<SelectableData<T>>(context) ??
        SelectableData<T>(selected: null, enabled: false);
    final SelectableRadioTheme container =
        resolveComponentStyle<SelectableRadioTheme, SelectableRadioTheme>(
          context,
          widget: widget.theme,
          select: (t) => t,
          defaults: selectableRadioDefaults,
        );
    final bool selected = group.selected == widget.value;
    final bool enabled = _interactive;
    // Registration is data, not layout: it must stay current for the arrow
    // keys even when the row itself did not change.
    _syncRegistration();
    final RadioIndicatorStyle indicator =
        (container.indicator ?? const RadioIndicatorStyle()).merge(
          container.forValue(selected),
        );
    return Semantics(
      inMutuallyExclusiveGroup: true,
      selected: selected,
      enabled: enabled,
      child: Opacity(
        opacity: enabled ? 1 : selectableItemDisabledOpacity,
        child: Clickable(
          enabled: enabled,
          onPressed: enabled ? _select : null,
          focusNode: _focusNode,
          mouseCursor: _radioMouseCursor,
          // Handed the group's traversal map so it wins over `Clickable`'s own
          // arrow-key binding to directional focus.
          shortcuts: _registry?.shortcuts,
          actions: _registry?.actions,
          padding: const WidgetStatePropertyAll<EdgeInsetsGeometry?>(null),
          decoration: const WidgetStatePropertyAll<Decoration?>(null),
          child: _buildRow(context, container, indicator, selected),
        ),
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    SelectableRadioTheme container,
    RadioIndicatorStyle indicator,
    bool selected,
  ) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final double gap =
        (container.gap ?? 8) * theme.density.scale * theme.scaling;
    final Widget? label = widget.label;
    return Padding(
      padding: resolveEdgeInsets(
        container.itemPadding ?? selectableRadioDefaults.itemPadding!,
        theme.density.baseContentPadding * theme.scaling,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          RadioIndicator(style: indicator, selected: selected),
          if (label != null) ...<Widget>[
            Gap(gap),
            Flexible(
              child: DefaultTextStyle.merge(
                style: (container.labelStyle ?? radioDefaultTextStyle).copyWith(
                  color: theme.colors.foreground,
                ),
                child: label,
              ),
            ),
          ],
          if (widget.trailing != null) ...<Widget>[Gap(gap), widget.trailing!],
        ],
      ),
    );
  }
}

/// The circle that shows whether a radio item is selected.
class RadioIndicator extends StatelessWidget {
  /// Creates an indicator.
  const RadioIndicator({super.key, this.style, this.selected = false});

  /// Widget-leg style override.
  final RadioIndicatorStyle? style;

  /// Whether the dot is drawn.
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final RadioIndicatorStyle resolved = style ?? const RadioIndicatorStyle();
    final double size = resolved.size ?? radioDefaultIndicatorSize;
    final double dotSize = resolved.dotSize ?? size / 2;
    final Duration duration = resolved.duration ?? radioDefaultDuration;
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return AnimatedContainer(
      key: kRadioIndicatorKey,
      duration: duration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: resolved.background?.resolve(<WidgetState>{})?.resolve(colors),
        border: Border.all(
          color:
              resolved.borderColor?.resolve(<WidgetState>{})?.resolve(colors) ??
              const Color(0x00000000),
          width: resolved.borderWidth ?? 0,
        ),
      ),
      child: Center(
        child: AnimatedContainer(
          key: kRadioIndicatorDotKey,
          duration: duration,
          width: selected ? dotSize : 0,
          height: selected ? dotSize : 0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: resolved.dotColor?.resolve(colors),
          ),
        ),
      ),
    );
  }
}

/// Lookup key of the radio indicator circle.
const ValueKey<String> kRadioIndicatorKey = ValueKey<String>(
  'shadcn.radio_group.indicator',
);

/// Lookup key of the radio indicator dot.
const ValueKey<String> kRadioIndicatorDotKey = ValueKey<String>(
  'shadcn.radio_group.dot',
);

/// A single-select group of radio items.
