// The `switch` component: [Switch], a boolean control with two modes
// (controlled and controller-driven) and form participation through
// [FormValueSupplier].
//
// The old module had two widgets (`Switch` + `ControlledSwitch`) plus a
// hand-rolled `GestureDetector` + `FocusableActionDetector` pair, a
// `FocusOutline` wrapper and a `SwitchController`. The adapter is gone (one
// widget, two modes) and interaction moved to the `Clickable` primitive, which
// also propagates the hover/press/focus states the old table could not reach.

import 'package:flutter/widgets.dart';

import '../../foundation/data.dart';
import '../../foundation/gap.dart';
import '../../primitives/clickable.dart';
import '../../primitives/widget_states.dart';
import '../../primitives/form_core/form_value.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'switch_style.dart';

export 'switch_style.dart';

/// Opacity applied to the whole switch while disabled (shadcn
/// `opacity-50`).
const double _switchDisabledOpacity = 0.5;

/// Cursor for an enabled switch; the system arrow while disabled.
const _switchMouseCursor = StateValue<MouseCursor>(
  rest: SystemMouseCursors.click,
  disabled: SystemMouseCursors.basic,
);

/// Curve of the thumb travel.
const Curve _switchTravelCurve = Curves.easeInOut;

/// Transparent padding around the row so the focus ring never clips.
const double switchHitPadding = 2;

/// Lookup key of the switch track surface.
const ValueKey<String> kSwitchTrackKey = ValueKey<String>(
  'shadcn.switch.track',
);

/// Lookup key of the sliding switch thumb.
const ValueKey<String> kSwitchThumbKey = ValueKey<String>(
  'shadcn.switch.thumb',
);

/// Holds the value of an uncontrolled [Switch].
class SwitchController extends ValueNotifier<bool> {
  /// Creates a controller, off by default.
  SwitchController([super.value = false]);

  /// Flips the value.
  void toggle() => value = !value;
}

/// An on/off switch.
///
/// Two modes:
/// * uncontrolled — pass a [controller]; `value`/`onChanged` must be null;
/// * controlled — pass `value` and `onChanged` (null `onChanged` disables).
///
/// Separate from `Toggle`: `Toggle` is a momentary button that keeps a
/// selected look, `Switch` is a dedicated setting control with a sliding
/// thumb (PLAN §4 rule 2).
class Switch extends StatefulWidget {
  /// Creates a switch.
  const Switch({
    super.key,
    this.value = false,
    this.controller,
    this.onChanged,
    this.enabled,
    this.label,
    this.focusNode,
    this.autofocus = false,
    this.onHover,
    this.onFocusChange,
    this.theme,
  }) : assert(
         controller == null || (value == false && onChanged == null),
         'A controller-driven Switch must not also receive value/onChanged',
       );

  /// Current value in controlled mode.
  final bool value;

  /// Controller mode: the controller owns the value.
  final SwitchController? controller;

  /// Called with the next value in controlled mode.
  final ValueChanged<bool>? onChanged;

  /// Overrides the enabled state; null means "interactive when controlled or
  /// controller-driven".
  final bool? enabled;

  /// Text shown next to the switch.
  final Widget? label;

  /// Focus node. A node is created internally when [autofocus] is true and
  /// this is null.
  final FocusNode? focusNode;

  /// Whether the switch requests focus when first built.
  final bool autofocus;

  /// Called when the hover state changes.
  final ValueChanged<bool>? onHover;

  /// Called when the focus state changes.
  final ValueChanged<bool>? onFocusChange;

  /// Widget-leg override, merged over the component/app/defaults.
  final SwitchStyle? theme;

  @override
  State<Switch> createState() => _SwitchState();
}

class _SwitchState extends State<Switch> with FormValueSupplier<bool, Switch> {
  FocusNode? _ownedFocusNode;

  FocusNode? get _focusNode => widget.focusNode ?? _ownedFocusNode;

  bool get _isOn => widget.controller?.value ?? widget.value;

  bool get _isEnabled =>
      widget.enabled ?? (widget.controller != null || widget.onChanged != null);

  @override
  void initState() {
    super.initState();
    _syncAutofocus();
  }

  @override
  void didUpdateWidget(covariant Switch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.autofocus != oldWidget.autofocus ||
        widget.focusNode != oldWidget.focusNode) {
      _syncAutofocus();
    }
  }

  @override
  void dispose() {
    _ownedFocusNode?.dispose();
    super.dispose();
  }

  void _syncAutofocus() {
    final bool needsOwnNode = widget.autofocus && widget.focusNode == null;
    if (needsOwnNode && _ownedFocusNode == null) {
      final FocusNode node = FocusNode(debugLabel: 'Switch');
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

  void _handleToggle() {
    final SwitchController? controller = widget.controller;
    if (controller != null) {
      controller.toggle();
    } else {
      widget.onChanged?.call(!_isOn);
    }
  }

  /// Form validation asked for a different value.
  @override
  void didReplaceFormValue(bool value) {
    final SwitchController? controller = widget.controller;
    if (controller != null) {
      controller.value = value;
    } else {
      widget.onChanged?.call(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Report the current value to the nearest form; a no-op without one.
    formValue = _isOn;
    final SwitchController? controller = widget.controller;
    if (controller == null) {
      return _build(context);
    }
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => _build(context),
    );
  }

  Widget _build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final bool isOn = _isOn;
    final bool enabled = _isEnabled;
    final SwitchTheme container =
        resolveComponentStyle<SwitchTheme, SwitchTheme>(
          context,
          select: (t) => t,
          defaults: switchDefaults,
        );
    final SwitchStyle resolved = (widget.theme ?? const SwitchStyle()).merge(
      container.forValue(isOn),
    );
    final Size track = resolved.trackSize ?? switchDefaultTrackSize;
    final double thumb = resolved.thumbSize ?? switchDefaultThumbSize;
    final double borderWidth = resolved.borderWidth ?? 0;
    final double travel =
        resolved.travel ?? (track.width - thumb - borderWidth * 2);
    final double gap = resolved.gap ?? 8;
    final TextStyle labelStyle =
        (resolved.labelStyle ?? container.labelStyle ?? switchDefaultLabelStyle)
            .copyWith(color: ambient.colors.foreground);
    // The whole row (track plus label) is the tap target, so the track paints
    // itself from the states `Clickable` publishes instead of using the
    // clickable's own decoration.
    final Widget trackWidget = _SwitchTrack(
      size: track,
      thumbSize: thumb,
      travel: travel,
      borderWidth: borderWidth,
      isOn: isOn,
      background: resolved.trackColor,
      borderColor: resolved.borderColor,
      thumbColor: resolved.thumbColor,
      colors: ambient.colors,
    );

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        trackWidget,
        if (widget.label != null) ...<Widget>[
          Gap(gap),
          Flexible(
            child: DefaultTextStyle.merge(
              style: labelStyle,
              child: widget.label!,
            ),
          ),
        ],
      ],
    );
    content = Padding(
      padding: const EdgeInsets.all(switchHitPadding),
      child: content,
    );

    return Semantics(
      toggled: isOn,
      enabled: enabled,
      label: widget.label is Text ? (widget.label! as Text).data : null,
      child: Opacity(
        opacity: enabled ? 1 : _switchDisabledOpacity,
        child: Clickable(
          enabled: enabled,
          onPressed: enabled ? _handleToggle : null,
          onHover: widget.onHover,
          onFocus: widget.onFocusChange,
          focusNode: _focusNode,
          mouseCursor: _switchMouseCursor,
          // The row paints no surface of its own; `Clickable` owns only the
          // interaction and the focus ring.
          padding: const WidgetStatePropertyAll<EdgeInsetsGeometry?>(null),
          decoration: const WidgetStatePropertyAll<Decoration?>(null),
          child: content,
        ),
      ),
    );
  }
}

/// The switch track and its sliding thumb.
///
/// Reads the states `Clickable` publishes so the hover, press and focus rows
/// of the resolved style reach the track without the clickable's own
/// decoration (the row carries the label, which must not be filled).
class _SwitchTrack extends StatelessWidget {
  const _SwitchTrack({
    required this.size,
    required this.thumbSize,
    required this.travel,
    required this.borderWidth,
    required this.isOn,
    required this.background,
    required this.borderColor,
    required this.thumbColor,
    required this.colors,
  });

  final Size size;
  final double thumbSize;
  final double travel;
  final double borderWidth;
  final bool isOn;
  final StateValue<ThemedColor>? background;
  final StateValue<ThemedColor>? borderColor;
  final StateValue<ThemedColor>? thumbColor;
  final ShadcnColors colors;

  @override
  Widget build(BuildContext context) {
    final Set<WidgetState> states =
        Data.maybeOf<WidgetStatesData>(context)?.states ??
        const <WidgetState>{};
    Color? colorFor(StateValue<ThemedColor>? value) =>
        value?.resolve(states)?.resolve(colors);
    final Color? border = colorFor(borderColor);
    // The thumb keeps its own height and centers vertically: pinning top and
    // bottom to 0 would stretch a 16px thumb to the full 18.4px track.
    // Clamped at zero so an oversized themed thumb overflows instead of
    // inverting the insets.
    final double verticalInset = ((size.height - thumbSize) / 2)
        .clamp(0, size.height / 2)
        .toDouble();
    return AnimatedContainer(
      key: kSwitchTrackKey,
      duration: switchDefaultDuration,
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        color: colorFor(background),
        border: border == null || borderWidth <= 0
            ? null
            : Border.all(color: border, width: borderWidth),
        borderRadius: BorderRadius.circular(size.height / 2),
      ),
      child: Stack(
        children: <Widget>[
          AnimatedPositioned(
            duration: switchDefaultDuration,
            curve: _switchTravelCurve,
            left: isOn ? travel : 0,
            top: verticalInset,
            bottom: verticalInset,
            width: thumbSize,
            child: DecoratedBox(
              key: kSwitchThumbKey,
              decoration: BoxDecoration(
                color: colorFor(thumbColor),
                borderRadius: BorderRadius.circular(thumbSize / 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
