// The `star_rating` component: [StarRating] with controlled and
// controller-driven modes, keyboard stepping, form participation and a
// token-driven star row.
//
// The old module had two widgets (`StarRating` + `ControlledStarRating`), a
// controller, two intents and a `StarBorder`-based paint that pulled
// `package:flutter/material.dart` and hard-coded `Colors.white`. The adapter
// is folded into the widget, the colours/size/shape live in the mergeable
// [StarRatingStyle], and the stars paint through `StarBorder` from
// `package:flutter/painting.dart` (widgets-only).

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../primitives/clickable.dart';
import '../../primitives/form_core/form_control.dart';
import '../../primitives/form_core/form_value.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'star_rating_style.dart';

export 'star_rating_style.dart';

/// Cursor for an enabled rating; the system arrow while disabled.
const _starRatingMouseCursor = StateValue<MouseCursor>(
  rest: SystemMouseCursors.click,
  disabled: SystemMouseCursors.basic,
);

const Duration _starRatingStepDuration = Duration(milliseconds: 150);

/// Opacity of the whole control while disabled (shadcn `opacity-50`).
const double _starRatingDisabledOpacity = 0.5;

class StarRatingController extends ValueNotifier<double>
    with ComponentController<double> {
  StarRatingController([super.value = 0]);
}

/// An interactive star rating.
///
/// Two modes:
/// * uncontrolled — pass a [controller]; `value`/`onChanged` must be null;
/// * controlled — pass `value` and `onChanged` (null `onChanged` renders a
///   read-only row).
///
/// Drag across the row to update the value; arrow keys step by [step] while
/// focused.
class StarRating extends StatefulWidget {
  /// Creates a star rating.
  const StarRating({
    super.key,
    this.value,
    this.controller,
    this.onChanged,
    this.enabled,
    this.step = 0.5,
    this.max = 5,
    this.direction = Axis.horizontal,
    this.focusNode,
    this.autofocus = false,
    this.onHover,
    this.onFocusChange,
    this.theme,
  }) : assert(
         controller == null || (value == null && onChanged == null),
         'A controller-driven StarRating must not also receive value/onChanged',
       ),
       assert(step > 0, 'step must be positive'),
       assert(max > 0, 'max must be positive');

  final double? value;

  final StarRatingController? controller;

  final ValueChanged<double>? onChanged;

  final bool? enabled;

  final double step;

  final double max;

  final Axis direction;

  final FocusNode? focusNode;

  final bool autofocus;

  final ValueChanged<bool>? onHover;

  final ValueChanged<bool>? onFocusChange;

  final StarRatingStyle? theme;

  @override
  State<StarRating> createState() => _StarRatingState();
}

class _StepStarIntent extends Intent {
  const _StepStarIntent(this.delta);

  final double delta;
}

class _StarRatingState extends State<StarRating>
    with FormValueSupplier<double, StarRating> {
  FocusNode? _ownedFocusNode;

  /// Geometry of the last build, read by [_dragAt].
  double _resolvedStarSize = 24;
  double _resolvedSpacing = 5;

  FocusNode? get _focusNode => widget.focusNode ?? _ownedFocusNode;

  double get _value =>
      (widget.controller?.value ?? widget.value ?? 0).clamp(0.0, widget.max);

  bool get _isEnabled =>
      widget.enabled ?? (widget.controller != null || widget.onChanged != null);

  @override
  void initState() {
    super.initState();
    _syncAutofocus();
  }

  @override
  void didUpdateWidget(covariant StarRating oldWidget) {
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
      final FocusNode node = FocusNode(debugLabel: 'StarRating');
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

  double _snap(double value) {
    final double snapped = (value / widget.step).round() * widget.step;
    return snapped.clamp(0.0, widget.max);
  }

  void _setValue(double value) {
    final double next = _snap(value);
    final StarRatingController? controller = widget.controller;
    if (controller != null) {
      controller.value = next;
    } else {
      widget.onChanged?.call(next);
    }
  }

  @override
  void didReplaceFormValue(double value) => _setValue(value);

  double _valueForPosition(Offset position, double starSize, double spacing) {
    final int count = widget.max.ceil();
    final double total = count * starSize + (count - 1) * spacing;
    if (total <= 0) {
      return 0;
    }
    final bool horizontal = widget.direction == Axis.horizontal;
    final bool rtl = Directionality.of(context) == TextDirection.rtl;
    double fraction = (horizontal ? position.dx : position.dy) / total;
    if (horizontal && rtl) {
      fraction = 1 - fraction;
    }
    return _snap(fraction.clamp(0.0, 1.0) * widget.max);
  }

  @override
  Widget build(BuildContext context) {
    // Report the current value to the nearest form; a no-op without one.
    formValue = _value;
    final StarRatingController? controller = widget.controller;
    return controller == null
        ? _build(context)
        : ListenableBuilder(
            listenable: controller,
            builder: (context, _) => _build(context),
          );
  }

  Widget _build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final StarRatingStyle style =
        resolveComponentStyle<StarRatingTheme, StarRatingStyle>(
          context,
          widget: widget.theme,
          select: (t) => t.style,
          defaults: starRatingDefaults.style!,
        );
    final double starSize = style.size ?? 24;
    final double spacing = style.spacing ?? 5;
    _resolvedStarSize = starSize;
    _resolvedSpacing = spacing;
    final bool enabled = _isEnabled;
    final Color activeColor =
        style.activeColor?.resolve(theme.colors) ?? theme.colors.primary;
    final Color inactiveColor =
        style.inactiveColor?.resolve(theme.colors) ?? theme.colors.muted;

    void nudge(double delta) {
      if (enabled) {
        _setValue(_value + delta);
      }
    }

    final Map<LogicalKeySet, Intent> shortcuts = <LogicalKeySet, Intent>{
      LogicalKeySet(LogicalKeyboardKey.arrowRight): _StepStarIntent(
        widget.step,
      ),
      LogicalKeySet(LogicalKeyboardKey.arrowUp): _StepStarIntent(widget.step),
      LogicalKeySet(LogicalKeyboardKey.arrowLeft): _StepStarIntent(
        -widget.step,
      ),
      LogicalKeySet(LogicalKeyboardKey.arrowDown): _StepStarIntent(
        -widget.step,
      ),
    };
    final Map<Type, Action<Intent>> actions = <Type, Action<Intent>>{
      _StepStarIntent: CallbackAction<_StepStarIntent>(
        onInvoke: (intent) {
          nudge(intent.delta);
          return null;
        },
      ),
    };

    final bool horizontal = widget.direction == Axis.horizontal;
    final bool rtl = Directionality.of(context) == TextDirection.rtl;
    final double displayValue = _value;

    Widget starsFor(double value) => _StarRow(
      value,
      horizontal,
      rtl,
      widget.max.ceil(),
      style,
      activeColor,
      inactiveColor,
    );

    final Widget stars = TweenAnimationBuilder<double>(
      tween: Tween<double>(end: displayValue),
      duration: _starRatingStepDuration,
      curve: Curves.easeOut,
      builder: (context, animated, _) => starsFor(animated),
    );

    return Opacity(
      opacity: enabled ? 1 : _starRatingDisabledOpacity,
      child: Semantics(
        slider: true,
        enabled: enabled,
        value: _value.toStringAsFixed(1),
        increasedValue: _snap(_value + widget.step).toStringAsFixed(1),
        decreasedValue: _snap(_value - widget.step).toStringAsFixed(1),
        onIncrease: enabled ? () => nudge(widget.step) : null,
        onDecrease: enabled ? () => nudge(-widget.step) : null,
        child: Clickable(
          enabled: enabled,
          focusNode: _focusNode,
          onHover: widget.onHover,
          onFocus: widget.onFocusChange,
          mouseCursor: _starRatingMouseCursor,
          shortcuts: shortcuts,
          actions: actions,
          onTapUp: (details) {
            if (enabled) {
              _setValue(
                _valueForPosition(details.localPosition, starSize, spacing),
              );
            }
          },
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragStart: horizontal ? _dragStart : null,
            onHorizontalDragUpdate: horizontal ? _dragUpdate : null,
            onVerticalDragStart: horizontal ? null : _dragStart,
            onVerticalDragUpdate: horizontal ? null : _dragUpdate,
            child: stars,
          ),
        ),
      ),
    );
  }

  void _dragStart(DragStartDetails details) => _dragAt(details.localPosition);

  void _dragUpdate(DragUpdateDetails details) => _dragAt(details.localPosition);

  void _dragAt(Offset position) {
    if (_isEnabled) {
      _setValue(
        _valueForPosition(position, _resolvedStarSize, _resolvedSpacing),
      );
    }
  }
}

class _StarRow extends StatelessWidget {
  /// (value, horizontal, rtl, count, style, activeColor, inactiveColor)
  const _StarRow(
    this.value,
    this.horizontal,
    this.rtl,
    this.count,
    this.style,
    this.activeColor,
    this.inactiveColor,
  );

  final double value;
  final bool horizontal;
  final bool rtl;
  final int count;
  final StarRatingStyle style;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    final AlignmentGeometry begin = rtl
        ? Alignment.centerRight
        : Alignment.centerLeft;
    final double size = style.size ?? 24;

    Widget star(int index) {
      final double fill = (value - index).clamp(0.0, 1.0);
      return SizedBox(
        width: size,
        height: size,
        child: ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: <Color>[activeColor, inactiveColor],
              stops: <double>[fill, fill],
              begin: begin,
              end: rtl ? Alignment.centerLeft : Alignment.centerRight,
            ).createShader(bounds);
          },
          child: DecoratedBox(
            // The paint colour only supplies coverage; the mask recolours it.
            decoration: ShapeDecoration(
              color: const Color(0xFFFFFFFF),
              shape: StarBorder(
                points: style.points ?? 5,
                pointRounding: style.pointRounding ?? 0,
                valleyRounding: style.valleyRounding ?? 0,
                squash: style.squash ?? 0,
                innerRadiusRatio: style.innerRadiusRatio ?? 0.4,
                rotation: style.rotation ?? 0,
              ),
            ),
          ),
        ),
      );
    }

    final List<Widget> stars = <Widget>[
      for (int i = 0; i < count; i += 1) ...<Widget>[
        if (i > 0) Gap(style.spacing ?? 5),
        star(i),
      ],
    ];
    return horizontal
        ? Row(mainAxisSize: MainAxisSize.min, children: stars)
        : Column(mainAxisSize: MainAxisSize.min, children: stars);
  }
}
