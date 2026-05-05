part of '../../clickable.dart';

/// _ClickableState defines a reusable type for this registry module.
class _ClickableState extends State<Clickable> {
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

/// Executes `_updateState` behavior for this component/composite.
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
    Decoration? decoration = widget.decoration?.resolve(widgetStates);
/// Stores `borderRadius` state/configuration for this implementation.
    BorderRadiusGeometry borderRadius;
    if (decoration is BoxDecoration) {
      borderRadius = decoration.borderRadius ?? theme.borderRadiusMd;
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
/// Creates a `_updateState` instance.
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
/// Creates a `IconThemeData` instance.
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
