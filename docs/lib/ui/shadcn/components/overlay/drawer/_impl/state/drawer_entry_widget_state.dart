// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../drawer.dart';

/// DrawerEntryWidgetState defines a reusable type for this registry module.
class DrawerEntryWidgetState<T> extends State<DrawerEntryWidget<T>>
    with SingleTickerProviderStateMixin {
  /// Notifier for additional offset applied during drag gestures.
  late ValueNotifier<double> additionalOffset = ValueNotifier(0);

  /// Stores `_controller` state/configuration for this implementation.
  late AnimationController _controller;

  /// Stores `_controlledAnimation` state/configuration for this implementation.
  late ControlledAnimation _controlledAnimation;
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  @override
  /// Executes `initState` behavior for this component/composite.
  void initState() {
    super.initState();
    _controller =
        widget.animationController ??
        /// Creates a `AnimationController` instance.
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 350),
        );

    _controlledAnimation = ControlledAnimation(_controller);
    if (widget.animationController == null && widget.autoOpen) {
      _controlledAnimation.forward(1, Curves.easeOut);
    }
    // discard any focus that was previously set
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  /// Executes `dispose` behavior for this component/composite.
  void dispose() {
    if (widget.animationController == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  /// Executes `didUpdateWidget` behavior for this component/composite.
  void didUpdateWidget(covariant DrawerEntryWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animationController != oldWidget.animationController) {
      if (oldWidget.animationController == null) {
        _controller.dispose();
      }
      _controller =
          widget.animationController ??
          /// Creates a `AnimationController` instance.
          AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 350),
          );
    }
  }

  /// Closes the drawer with an optional result value.
  ///
  /// Animates the drawer out using an ease-out cubic curve, then completes
  /// the completer with the provided result.
  ///
  /// Parameters:
  /// - [result] (T?): Optional result to return when drawer closes
  ///
  /// Returns a [Future] that completes when the close animation finishes.
  Future<void> close([T? result]) {
    return _controlledAnimation.forward(0, Curves.easeOutCubic).then((value) {
      widget.completer.complete(result);
    });
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    /// Stores `alignment` state/configuration for this implementation.
    AlignmentGeometry alignment;

    /// Stores `startFractionalOffset` state/configuration for this implementation.
    Offset startFractionalOffset;

    /// Stores `position` state/configuration for this implementation.
    var position = widget.position;
    final textDirection = Directionality.of(context);
    if (position == OverlayPosition.start) {
      position = textDirection == TextDirection.ltr
          ? OverlayPosition.left
          : OverlayPosition.right;
    } else if (position == OverlayPosition.end) {
      position = textDirection == TextDirection.ltr
          ? OverlayPosition.right
          : OverlayPosition.left;
    }

    /// Stores `padTop` state/configuration for this implementation.
    bool padTop = widget.useSafeArea && position != OverlayPosition.top;

    /// Stores `padBottom` state/configuration for this implementation.
    bool padBottom = widget.useSafeArea && position != OverlayPosition.bottom;

    /// Stores `padLeft` state/configuration for this implementation.
    bool padLeft = widget.useSafeArea && position != OverlayPosition.left;

    /// Stores `padRight` state/configuration for this implementation.
    bool padRight = widget.useSafeArea && position != OverlayPosition.right;
    switch (position) {
      case OverlayPosition.left:
        alignment = Alignment.centerLeft;
        startFractionalOffset = const Offset(-1, 0);
        break;
      case OverlayPosition.right:
        alignment = Alignment.centerRight;
        startFractionalOffset = const Offset(1, 0);
        break;
      case OverlayPosition.top:
        alignment = Alignment.topCenter;
        startFractionalOffset = const Offset(0, -1);
        break;
      case OverlayPosition.bottom:
        alignment = Alignment.bottomCenter;
        startFractionalOffset = const Offset(0, 1);
        break;
      default:
        throw UnimplementedError('Unknown position');
    }
    return FocusScope(
      node: _focusScopeNode,
      child: CapturedWrapper(
        themes: widget.themes,
        data: widget.data,
        child: Data.inherit(
          data: _MountedOverlayEntryData(this),
          child: Builder(
            builder: (context) {
              Widget barrier =
                  (widget.modal
                      ? widget.barrierBuilder(
                          context,
                          widget.backdrop,
                          _controlledAnimation,
                          widget.stackIndex,
                        )
                      : null) ??
                  /// Creates a `Positioned` instance.
                  Positioned(
                    top: -9999,
                    left: -9999,
                    right: -9999,
                    bottom: -9999,
                    child: GestureDetector(
                      onTap: () {
                        close();
                      },
                    ),
                  );
              final extraSize = Data.maybeOf<BackdropTransformData>(
                context,
              )?.sizeDifference;

              /// Stores `additionalSize` state/configuration for this implementation.
              Size additionalSize;

              /// Stores `additionalOffset` state/configuration for this implementation.
              Offset additionalOffset;
              bool insetTop =
                  widget.useSafeArea && position == OverlayPosition.top;
              bool insetBottom =
                  widget.useSafeArea && position == OverlayPosition.bottom;
              bool insetLeft =
                  widget.useSafeArea && position == OverlayPosition.left;
              bool insetRight =
                  widget.useSafeArea && position == OverlayPosition.right;
              MediaQueryData mediaQueryData = MediaQuery.of(context);
              EdgeInsets padding =
                  mediaQueryData.padding + mediaQueryData.viewInsets;
              if (extraSize == null) {
                additionalSize = Size.zero;
                additionalOffset = Offset.zero;
              } else {
                switch (position) {
                  case OverlayPosition.left:
                    additionalSize = Size(extraSize.width / 2, 0);
                    additionalOffset = Offset(-additionalSize.width, 0);
                    break;
                  case OverlayPosition.right:
                    additionalSize = Size(extraSize.width / 2, 0);
                    additionalOffset = Offset(additionalSize.width, 0);
                    break;
                  case OverlayPosition.top:
                    additionalSize = Size(0, extraSize.height / 2);
                    additionalOffset = Offset(0, -additionalSize.height);
                    break;
                  case OverlayPosition.bottom:
                    additionalSize = Size(0, extraSize.height / 2);
                    additionalOffset = Offset(0, additionalSize.height);
                    break;
                  default:
                    throw UnimplementedError('Unknown position');
                }
              }
              return Stack(
                clipBehavior: Clip.none,
                fit: StackFit.passthrough,
                children: [
                  /// Creates a `IgnorePointer` instance.
                  IgnorePointer(
                    child: widget.backdropBuilder(
                      context,
                      widget.backdrop,
                      _controlledAnimation,
                      widget.stackIndex,
                    ),
                  ),
                  barrier,

                  /// Creates a `Positioned.fill` instance.
                  Positioned.fill(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return MediaQuery(
                          data: widget.useSafeArea
                              ? mediaQueryData.removePadding(
                                  removeTop: true,
                                  removeBottom: true,
                                  removeLeft: true,
                                  removeRight: true,
                                )
                              : mediaQueryData,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: padTop ? padding.top : 0,
                              bottom: padBottom ? padding.bottom : 0,
                              left: padLeft ? padding.left : 0,
                              right: padRight ? padding.right : 0,
                            ),
                            child: Align(
                              alignment: alignment,
                              child: AnimatedBuilder(
                                animation: _controlledAnimation,
                                builder: (context, child) {
                                  return FractionalTranslation(
                                    translation:
                                        startFractionalOffset *
                                        (1 - _controlledAnimation.value),
                                    child: child,
                                  );
                                },
                                child: Transform.translate(
                                  offset: additionalOffset / kBackdropScaleDown,
                                  child: widget.builder(
                                    context,
                                    additionalSize,
                                    constraints.biggest,

                                    /// Creates a `EdgeInsets.only` instance.
                                    EdgeInsets.only(
                                      top: insetTop ? padding.top : 0,
                                      bottom: insetBottom ? padding.bottom : 0,
                                      left: insetLeft ? padding.left : 0,
                                      right: insetRight ? padding.right : 0,
                                    ),
                                    widget.stackIndex,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Builder function for drawer backdrop transformations.
///
/// Creates a widget that wraps the backdrop content, applying transformations
/// during drawer animations.
///
/// Parameters:
/// - [context] (BuildContext): Build context
/// - [child] (Widget): Backdrop widget to transform
/// - [animation] (`Animation<double>`): Animation value from 0 (closed) to 1 (open)
/// - [stackIndex] (int): Index of the drawer in the stack
///
/// Returns the transformed backdrop widget.
