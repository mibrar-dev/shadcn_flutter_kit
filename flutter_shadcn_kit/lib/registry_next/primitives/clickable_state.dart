// State implementation of [Clickable]: state controller wiring, keyboard
// activation, double-tap counting and animated container construction.

import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../foundation/constants.dart';
import '../foundation/data.dart';
import '../foundation/platform.dart';
import '../theme/theme.dart';
import 'animated_value_builder.dart';
import 'clickable.dart';
import 'focus_outline.dart';
import 'widget_states.dart';

/// State of [Clickable].
///
/// Framework-internal: public only so the widget can create it across files.
class ClickableState extends State<Clickable> {
  late FocusNode _focusNode;
  late WidgetStatesController _controller;
  DateTime? _lastTap;
  int _tapCount = 0;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.statesController ?? WidgetStatesController();
    _controller.update(WidgetState.disabled, !widget.enabled);
  }

  @override
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

  /// Emits the tap semantics event and plays the platform click sound on
  /// mobile.
  static Future<void> feedbackForTap(BuildContext context) async {
    final currentPlatform = ShadcnTheme.of(context).platform;
    context.findRenderObject()!.sendSemanticsEvent(const TapSemanticEvent());
    if (isMobile(currentPlatform)) {
      return SystemSound.play(SystemSoundType.click);
    }
    return Future<void>.value();
  }

  void _onPressed() {
    if (!widget.enabled) return;
    final Duration? deltaTap = _lastTap == null
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

  void _updateState(WidgetState state, bool value) {
    if (!mounted) return;
    // Avoid notifying listeners during a build; defer to next frame if needed.
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
  Widget build(BuildContext context) {
    final enabled = widget.enabled;
    return WidgetStatesProvider(
      controller: _controller,
      states: {if (!enabled) WidgetState.disabled},
      child: ListenableBuilder(listenable: _controller, builder: _builder),
    );
  }

  Widget _builder(BuildContext context, Widget? _) {
    final theme = ShadcnTheme.of(context);
    final enabled = widget.enabled;
    var widgetStates = Data.maybeOf<WidgetStatesData>(context)?.states ?? {};
    widgetStates = widgetStates.union(_controller.value);
    final Decoration? decoration = widget.decoration?.resolve(widgetStates);

    final BorderRadiusGeometry borderRadius;
    if (decoration is BoxDecoration) {
      borderRadius = decoration.borderRadius ?? theme.borderRadiusMd;
    } else {
      borderRadius = theme.borderRadiusMd;
    }
    final buttonContainer = _buildContainer(context, decoration, widgetStates);
    return FocusOutline(
      focused:
          widget.focusOutline &&
          widgetStates.contains(WidgetState.focused) &&
          !widget.disableFocusOutline,
      borderRadius: borderRadius,
      child: GestureDetector(
        behavior: widget.behavior,
        onTap: widget.onPressed != null ? _onPressed : null,
        onLongPress: widget.onLongPress,
        // onDoubleTap is handled by _onPressed's own tap counter.
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
                  _updateState(WidgetState.hovered, true);
                }
                _updateState(WidgetState.pressed, true);
                widget.onTapDown?.call(details);
              }
            : widget.onTapDown,
        onTapUp: widget.onPressed != null
            ? (details) {
                if (widget.enableFeedback) {
                  _updateState(WidgetState.hovered, false);
                }
                _updateState(WidgetState.pressed, false);
                widget.onTapUp?.call(details);
              }
            : widget.onTapUp,
        onTapCancel: widget.onPressed != null
            ? () {
                if (widget.enableFeedback) {
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
            LogicalKeySet(LogicalKeyboardKey.enter): const ActivateIntent(),
            LogicalKeySet(LogicalKeyboardKey.space): const ActivateIntent(),
            LogicalKeySet(LogicalKeyboardKey.arrowUp):
                const DirectionalFocusIntent(TraversalDirection.up),
            LogicalKeySet(LogicalKeyboardKey.arrowDown):
                const DirectionalFocusIntent(TraversalDirection.down),
            LogicalKeySet(LogicalKeyboardKey.arrowLeft):
                const DirectionalFocusIntent(TraversalDirection.left),
            LogicalKeySet(LogicalKeyboardKey.arrowRight):
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
                _focusNode.focusInDirection(e.direction);
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
              data:
                  widget.iconTheme?.resolve(widgetStates) ??
                  const IconThemeData(),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return AnimatedValueBuilder<Matrix4?>(
                    value: widget.transform?.resolve(widgetStates),
                    duration: const Duration(milliseconds: 50),
                    lerp: lerpMatrix4,
                    builder: (context, value, child) {
                      return Transform(
                        alignment: Alignment.center,
                        transform: value ?? Matrix4.identity(),
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
      return Matrix4.identity();
    }
    return Matrix4Tween(
      begin: a ?? Matrix4.identity(),
      end: b ?? Matrix4.identity(),
    ).transform(t);
  }

  Widget _buildContainer(
    BuildContext context,
    Decoration? decoration,
    Set<WidgetState> widgetStates,
  ) {
    final resolvedMargin = widget.margin?.resolve(widgetStates);
    final resolvedPadding = widget.padding?.resolve(widgetStates);
    if (widget.disableTransition) {
      Widget container = Container(
        clipBehavior: Clip.antiAlias,
        margin: resolvedMargin,
        decoration: decoration,
        padding: resolvedPadding,
        child: widget.child,
      );
      if (widget.marginAlignment != null) {
        container = Align(alignment: widget.marginAlignment!, child: container);
      }
      return container;
    }
    Widget animatedContainer = AnimatedContainer(
      clipBehavior: decoration == null ? Clip.none : Clip.antiAlias,
      margin: resolvedMargin,
      duration: kDefaultDuration,
      decoration: decoration,
      padding: resolvedPadding,
      child: widget.child,
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
}
