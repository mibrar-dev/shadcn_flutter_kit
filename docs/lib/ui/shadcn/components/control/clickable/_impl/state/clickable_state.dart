// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:data_widget/data_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../../../../shared/primitives/animated_value_builder.dart';
import '../../../../../shared/primitives/focus_outline.dart';
import '../../../../../shared/theme/theme.dart';
import '../../../../../shared/utils/constants.dart';
import '../../../../../shared/utils/platform_utils.dart';
import '../core/clickable_widget.dart';
import '../core/overflow_decorated_box.dart';
import 'widget_states_data.dart';
import 'widget_states_provider.dart';

/// Minimum time interval between taps to be considered a double tap.
///
/// Taps that occur within this duration (300ms) of a previous tap are counted
/// as part of a multi-tap gesture sequence. Used internally by [Clickable] to
/// detect double-tap gestures.
const kDoubleTapMinTime = Duration(milliseconds: 300);

/// ClickableState defines a reusable type for this registry module.
class ClickableState extends State<Clickable> {
  /// Stores `_focusNode` state/configuration for this implementation.
  late FocusNode _focusNode;

  /// Stores `_controller` state/configuration for this implementation.
  late WidgetStatesController _controller;

  /// Stores `_lastTap` state/configuration for this implementation.
  DateTime? _lastTap;

  /// Stores `_tapCount` state/configuration for this implementation.
  int _tapCount = 0;

  @override
  /// Executes `initState` behavior for this component/composite.
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.statesController ?? WidgetStatesController();
    _controller.update(WidgetState.disabled, !widget.enabled);
  }

  @override
  /// Executes `didUpdateWidget` behavior for this component/composite.
  void didUpdateWidget(covariant Clickable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.statesController != oldWidget.statesController) {
      _controller = widget.statesController ?? WidgetStatesController();
    }
    _controller.update(WidgetState.disabled, !widget.enabled);
    if (widget.focusNode != oldWidget.focusNode) {
      _focusNode = widget.focusNode ?? FocusNode();
    }
    if (widget.disableHoverEffect) {
      _controller.update(WidgetState.hovered, false);
    }
  }

  static Future<void> feedbackForTap(BuildContext context) async {
    final currentPlatform = Theme.of(context).platform;
    context.findRenderObject()!.sendSemanticsEvent(const TapSemanticEvent());
    if (isMobile(currentPlatform)) {
      return SystemSound.play(SystemSoundType.click);
    }
    return Future<void>.value();
  }

  /// Executes `_onPressed` behavior for this component/composite.
  void _onPressed() {
    if (!widget.enabled) return;
    Duration? deltaTap = _lastTap == null
        ? null
        : DateTime.now().difference(_lastTap!);
    _lastTap = DateTime.now();
    if (deltaTap != null && deltaTap < kDoubleTapMinTime) {
      _tapCount++;
    } else {
      _tapCount = 1;
    }

    if (_tapCount == 2 && widget.onDoubleTap != null) {
      widget.onDoubleTap!();
      _tapCount = 0;
    } else {
      if (widget.onPressed != null) {
        widget.onPressed!();
        if (widget.enableFeedback) {
          feedbackForTap(context);
        }
      }
    }
  }

  /// Updates controller state, deferring past build phase.
  ///
  /// Avoids notifying listeners during a build by deferring to the next
  /// frame when the scheduler is in persistent callbacks (matches
  /// upstream, prevents setState-during-build errors from gesture and
  /// hover callbacks that fire mid-build).
  void _updateState(WidgetState state, bool value) {
    if (!mounted) return;
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _controller.update(state, value);
      });
      return;
    }
    _controller.update(state, value);
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    /// Stores `enabled` state/configuration for this implementation.
    var enabled = widget.enabled;
    return WidgetStatesProvider(
      controller: _controller,
      states: {if (!enabled) WidgetState.disabled},
      child: ListenableBuilder(listenable: _controller, builder: _builder),
    );
  }

  /// Executes `_builder` behavior for this component/composite.
  Widget _builder(BuildContext context, Widget? _) {
    final theme = Theme.of(context);

    /// Stores `enabled` state/configuration for this implementation.
    final enabled = widget.enabled;
    var widgetStates = Data.maybeOf<WidgetStatesData>(context)?.states ?? {};
    widgetStates = widgetStates.union(_controller.value);
    final IconThemeData resolvedIconTheme =
        widget.iconTheme?.resolve(widgetStates) ?? const IconThemeData();
    Decoration? decoration = widget.decoration?.resolve(widgetStates);

    /// Stores `borderRadius` state/configuration for this implementation.
    BorderRadiusGeometry borderRadius;
    BoxShape shape = BoxShape.rectangle;
    if (decoration is BoxDecoration) {
      borderRadius = decoration.borderRadius ?? theme.borderRadiusMd;
      shape = decoration.shape;
    } else {
      borderRadius = theme.borderRadiusMd;
    }
    var buttonContainer = _buildContainer(context, decoration, widgetStates);
    return FocusOutline(
      focused:
          widget.focusOutline &&
          /// Creates a `widgetStates.contains` instance.
          widgetStates.contains(WidgetState.focused) &&
          !widget.disableFocusOutline,
      shape: shape,
      borderRadius: borderRadius,
      child: GestureDetector(
        behavior: widget.behavior,
        onTap: widget.onPressed != null ? _onPressed : null,
        onLongPress: widget.onLongPress,
        // onDoubleTap: widget.onDoubleTap, HANDLED CUSTOMLY
        onSecondaryTapDown: widget.onSecondaryTapDown,
        onSecondaryTapUp: widget.onSecondaryTapUp,
        onSecondaryTapCancel: widget.onSecondaryTapCancel,
        onTertiaryTapDown: widget.onTertiaryTapDown,
        onTertiaryTapUp: widget.onTertiaryTapUp,
        onTertiaryTapCancel: widget.onTertiaryTapCancel,
        onLongPressStart: widget.onLongPressStart,
        onLongPressUp: widget.onLongPressUp,
        onLongPressMoveUpdate: widget.onLongPressMoveUpdate,
        onLongPressEnd: widget.onLongPressEnd,
        onSecondaryLongPress: widget.onSecondaryLongPress,
        onTertiaryLongPress: widget.onTertiaryLongPress,
        onTapDown: widget.onPressed != null
            ? (details) {
                if (widget.enableFeedback) {
                  // also dispatch hover
                  _updateState(WidgetState.hovered, true);
                }
                _updateState(WidgetState.pressed, true);
                widget.onTapDown?.call(details);
              }
            : widget.onTapDown,
        onTapUp: widget.onPressed != null
            ? (details) {
                if (widget.enableFeedback) {
                  // also dispatch hover
                  _updateState(WidgetState.hovered, false);
                }
                _updateState(WidgetState.pressed, false);
                widget.onTapUp?.call(details);
              }
            : widget.onTapUp,
        onTapCancel: widget.onPressed != null
            ? () {
                if (widget.enableFeedback) {
                  // also dispatch hover
                  _updateState(WidgetState.hovered, false);
                }
                _updateState(WidgetState.pressed, false);
                widget.onTapCancel?.call();
              }
            : widget.onTapCancel,
        child: FocusableActionDetector(
          enabled: enabled,
          focusNode: _focusNode,
          shortcuts: {
            /// Creates a `LogicalKeySet` instance.
            LogicalKeySet(LogicalKeyboardKey.enter): const ActivateIntent(),

            /// Creates a `LogicalKeySet` instance.
            LogicalKeySet(LogicalKeyboardKey.space): const ActivateIntent(),

            /// Creates a `LogicalKeySet` instance.
            LogicalKeySet(LogicalKeyboardKey.arrowUp):
                /// Creates a `DirectionalFocusIntent` instance.
                const DirectionalFocusIntent(TraversalDirection.up),

            /// Creates a `LogicalKeySet` instance.
            LogicalKeySet(LogicalKeyboardKey.arrowDown):
                /// Creates a `DirectionalFocusIntent` instance.
                const DirectionalFocusIntent(TraversalDirection.down),

            /// Creates a `LogicalKeySet` instance.
            LogicalKeySet(LogicalKeyboardKey.arrowLeft):
                /// Creates a `DirectionalFocusIntent` instance.
                const DirectionalFocusIntent(TraversalDirection.left),

            /// Creates a `LogicalKeySet` instance.
            LogicalKeySet(LogicalKeyboardKey.arrowRight):
                /// Creates a `DirectionalFocusIntent` instance.
                const DirectionalFocusIntent(TraversalDirection.right),
            ...?widget.shortcuts,
          },
          actions: {
            ActivateIntent: CallbackAction(
              onInvoke: (e) {
                _onPressed();
                return null;
              },
            ),
            DirectionalFocusIntent: CallbackAction<DirectionalFocusIntent>(
              onInvoke: (e) {
                /// Stores `direction` state/configuration for this implementation.
                final direction = e.direction;

                /// Stores `focus` state/configuration for this implementation.
                final focus = _focusNode;
                switch (direction) {
                  case TraversalDirection.up:
                    focus.focusInDirection(TraversalDirection.up);
                    break;
                  case TraversalDirection.down:
                    focus.focusInDirection(TraversalDirection.down);
                    break;
                  case TraversalDirection.left:
                    focus.focusInDirection(TraversalDirection.left);
                    break;
                  case TraversalDirection.right:
                    focus.focusInDirection(TraversalDirection.right);
                    break;
                }
                return null;
              },
            ),
            ...?widget.actions,
          },
          onShowHoverHighlight: (value) {
            _updateState(
              WidgetState.hovered,
              value && !widget.disableHoverEffect,
            );
            widget.onHover?.call(value);
          },
          onShowFocusHighlight: (value) {
            _updateState(WidgetState.focused, value);
            widget.onFocus?.call(value);
          },
          mouseCursor:
              widget.mouseCursor?.resolve(widgetStates) ?? MouseCursor.defer,
          child: DefaultTextStyle.merge(
            style: widget.textStyle?.resolve(widgetStates),
            child: IconTheme.merge(
              data: resolvedIconTheme,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return AnimatedValueBuilder(
                    value: widget.transform?.resolve(widgetStates),
                    duration: const Duration(milliseconds: 50),
                    lerp: lerpMatrix4,
                    builder: (context, value, child) {
                      return Transform(
                        alignment: Alignment.center,
                        transform: value,
                        child: child,
                      );
                    },
                    child: child,
                  );
                },
                child: buttonContainer,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Matrix4? lerpMatrix4(Matrix4? a, Matrix4? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    Matrix4Tween tween = Matrix4Tween(
      begin: a ?? Matrix4.identity(),
      end: b ?? Matrix4.identity(),
    );
    return tween.transform(t);
  }

  Widget _buildContainer(
    BuildContext context,
    Decoration? decoration,
    Set<WidgetState> widgetStates,
  ) {
    var resolvedMargin = widget.margin?.resolve(widgetStates);
    var resolvedPadding = widget.padding?.resolve(widgetStates);
    var textDirection = Directionality.of(context);
    var expands = EdgeInsets.zero;
    if (resolvedMargin != null) {
      var margin = resolvedMargin.resolve(textDirection);
      // Ensure non-negative margins, because negative margins are possible
      // and used as BoxDecoration overflow paint
      resolvedMargin = EdgeInsets.only(
        left: margin.left < 0 ? 0 : margin.left,
        top: margin.top < 0 ? 0 : margin.top,
        right: margin.right < 0 ? 0 : margin.right,
        bottom: margin.bottom < 0 ? 0 : margin.bottom,
      );
      expands = -EdgeInsets.only(
        left: margin.left < 0 ? margin.left : 0,
        top: margin.top < 0 ? margin.top : 0,
        right: margin.right < 0 ? margin.right : 0,
        bottom: margin.bottom < 0 ? margin.bottom : 0,
      );
    }
    if (widget.disableTransition) {
      Widget container = Container(
        margin: resolvedMargin,
        child: decoration == null
            ? widget.child
            : OverflowDecoratedBox(
                decoration: decoration,
                expands: expands,
                child: Padding(
                  padding: resolvedPadding ?? EdgeInsets.zero,
                  child: widget.child,
                ),
              ),
      );
      if (widget.marginAlignment != null) {
        container = Align(alignment: widget.marginAlignment!, child: container);
      }
      return container;
    }
    if (decoration is BoxDecoration && decoration.shape == BoxShape.circle) {
      decoration = decoration.copyWith(borderRadius: null);
    }
    Widget animatedContainer = AnimatedContainer(
      margin: resolvedMargin,
      duration: kDefaultDuration,
      child: decoration == null
          ? widget.child
          : AnimatedValueBuilder<Decoration?>(
              value: decoration,
              duration: kDefaultDuration,
              lerp: _lerpDecoration,
              builder: (context, value, child) {
                if (value == null) {
                  return child!;
                }
                return OverflowDecoratedBox(
                  decoration: value,
                  expands: expands,
                  child: child,
                );
              },
              child: AnimatedPadding(
                duration: kDefaultDuration,
                padding: resolvedPadding ?? EdgeInsets.zero,
                child: widget.child,
              ),
            ),
    );
    if (widget.marginAlignment != null) {
      animatedContainer = AnimatedAlign(
        duration: kDefaultDuration,
        alignment: widget.marginAlignment!,
        child: animatedContainer,
      );
    }
    return animatedContainer;
  }

  /// Lerps decorations with a premultiplied-alpha fill fix.
  ///
  /// `Decoration.lerp` blends fills with `Color.lerp`, which is wrong
  /// whenever the two states differ in alpha — a hover tint fading in over
  /// an opaque surface visibly darkens on the way through. The fill is
  /// redone in premultiplied space (matches upstream).
  static Decoration? _lerpDecoration(Decoration? a, Decoration? b, double t) {
    if (t == 0.0) {
      return a;
    }
    if (t == 1.0) {
      return b;
    }
    if (a is BoxDecoration && b is BoxDecoration) {
      if (a.shape != b.shape &&
          a.backgroundBlendMode == null &&
          b.backgroundBlendMode == null) {
        ShapeBorder shapeA;
        if (a.shape == BoxShape.circle) {
          shapeA = const CircleBorder();
        } else {
          shapeA = RoundedRectangleBorder(
            borderRadius: a.borderRadius ?? BorderRadius.zero,
          );
        }
        ShapeBorder shapeB;
        if (b.shape == BoxShape.circle) {
          shapeB = const CircleBorder();
        } else {
          shapeB = RoundedRectangleBorder(
            borderRadius: b.borderRadius ?? BorderRadius.zero,
          );
        }
        if (a.border is Border) {
          shapeA = (shapeA as OutlinedBorder).copyWith(
            side: (a.border as Border).top,
          );
        }
        if (b.border is Border) {
          shapeB = (shapeB as OutlinedBorder).copyWith(
            side: (b.border as Border).top,
          );
        }
        return ShapeDecoration.lerp(
          ShapeDecoration(
            color: a.color,
            image: a.image,
            shadows: a.boxShadow,
            gradient: a.gradient,
            shape: shapeA,
          ),
          ShapeDecoration(
            color: b.color,
            image: b.image,
            shadows: b.boxShadow,
            gradient: b.gradient,
            shape: shapeB,
          ),
          t,
        );
      }
    }
    var lerped = Decoration.lerp(a, b, t);
    if (lerped is BoxDecoration && a is BoxDecoration && b is BoxDecoration) {
      lerped = lerped.copyWith(
        color: _lerpColorPremultiplied(a.color, b.color, t),
      );
    } else if (lerped is ShapeDecoration &&
        a is ShapeDecoration &&
        b is ShapeDecoration) {
      lerped = ShapeDecoration(
        color: _lerpColorPremultiplied(a.color, b.color, t),
        image: lerped.image,
        gradient: lerped.gradient,
        shadows: lerped.shadows,
        shape: lerped.shape,
      );
    }
    if (lerped is BoxDecoration &&
        lerped.shape == BoxShape.circle &&
        lerped.borderRadius != null) {
      return lerped.copyWith(borderRadius: null);
    }
    return lerped;
  }
}

/// Blends two colors in premultiplied space.
///
/// A null end is fully transparent, but it has no colour of its own, so it
/// fades out the other end rather than dragging it towards black
/// (matches upstream `lerpColorPremultiplied`).
Color? _lerpColorPremultiplied(Color? a, Color? b, double t) {
  if (a == null && b == null) return null;
  final start = a ?? (b!.withValues(alpha: 0));
  final end = b ?? (a!.withValues(alpha: 0));
  double mix(double from, double to) => from + (to - from) * t;
  final alpha = mix(start.a, end.a);
  if (alpha <= 0) return start.withValues(alpha: 0);
  double channel(double from, double to) =>
      mix(from * start.a, to * end.a) / alpha;
  return Color.from(
    alpha: alpha,
    red: channel(start.r, end.r),
    green: channel(start.g, end.g),
    blue: channel(start.b, end.b),
    colorSpace: start.colorSpace,
  );
}
