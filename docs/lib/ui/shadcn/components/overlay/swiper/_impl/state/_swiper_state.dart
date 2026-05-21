// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../swiper.dart';

/// _SwiperState defines a reusable type for this registry module.
class _SwiperState extends State<Swiper> {
  /// Stores `_activeOverlay` state/configuration for this implementation.
  DrawerOverlayCompleter? _activeOverlay;
  final GlobalKey _key = GlobalKey();

  @override
  /// Executes `initState` behavior for this component/composite.
  void initState() {
    super.initState();
  }

  OverlayPosition get resolvedPosition {
    if (widget.position == OverlayPosition.start) {
      var textDirection = Directionality.of(context);
      return textDirection == TextDirection.ltr
          ? OverlayPosition.left
          : OverlayPosition.right;
    }
    if (widget.position == OverlayPosition.end) {
      var textDirection = Directionality.of(context);
      return textDirection == TextDirection.ltr
          ? OverlayPosition.right
          : OverlayPosition.left;
    }
    return widget.position;
  }

  /// Executes `_onDrag` behavior for this component/composite.
  void _onDrag(DragUpdateDetails details) {
    if (_activeOverlay != null) {
      /// Stores `resolvedPosition` state/configuration for this implementation.
      var resolvedPosition = this.resolvedPosition;

      /// Stores `controller` state/configuration for this implementation.
      var controller = _activeOverlay!.animationController;

      /// Stores `delta` state/configuration for this implementation.
      double delta;
      switch (resolvedPosition) {
        case OverlayPosition.top:
        case OverlayPosition.left:
          delta = details.primaryDelta!;
          break;
        case OverlayPosition.bottom:
        case OverlayPosition.right:
          delta = -details.primaryDelta!;
          break;
        default:
          throw UnimplementedError('Unresolved position');
      }
      // normalize delta
      /// Stores `size` state/configuration for this implementation.
      var size = _key.currentContext?.size;
      if (size == null) {
        return;
      }

      /// Stores `axisSize` state/configuration for this implementation.
      double axisSize;
      if (resolvedPosition == OverlayPosition.top ||
          resolvedPosition == OverlayPosition.bottom) {
        axisSize = size.height;
      } else {
        axisSize = size.width;
      }
      delta = delta / axisSize;
      controller?.value += delta;
    }
  }

  /// Executes `_onDragEnd` behavior for this component/composite.
  void _onDragEnd(DragEndDetails details) {
    if (_activeOverlay != null) {
      /// Stores `activeOverlay` state/configuration for this implementation.
      var activeOverlay = _activeOverlay!;

      /// Stores `controller` state/configuration for this implementation.
      var controller = activeOverlay.animationController;
      if (controller != null) {
        if (controller.value < 0.5) {
          /// Creates a `controller.reverse` instance.
          controller.reverse().then((value) {
            activeOverlay.remove();
          });
        } else {
          controller.forward();
        }
      }
      _activeOverlay = null;
    }
  }

  /// Executes `_onDragCancel` behavior for this component/composite.
  void _onDragCancel() {
    if (_activeOverlay != null) {
      /// Stores `activeOverlay` state/configuration for this implementation.
      var activeOverlay = _activeOverlay!;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        /// Stores `controller` state/configuration for this implementation.
        var controller = activeOverlay.animationController;
        if (controller != null) {
          /// Creates a `controller.reverse` instance.
          controller.reverse().then((value) {
            activeOverlay.remove();
          });
        }
      });
      _activeOverlay = null;
    }
  }

  /// Executes `_onDragStart` behavior for this component/composite.
  void _onDragStart(DragStartDetails details) {
    _onDragCancel();
    final compTheme = ComponentTheme.maybeOf<SwiperTheme>(context);
    _activeOverlay = widget.handler.openSwiper(
      context: context,
      builder: (context) {
        return KeyedSubtree(key: _key, child: widget.builder(context));
      },
      position: widget.position,
      expands: widget.expands ?? compTheme?.expands,
      draggable: widget.draggable ?? compTheme?.draggable,
      barrierDismissible:
          widget.barrierDismissible ?? compTheme?.barrierDismissible,
      backdropBuilder: widget.backdropBuilder ?? compTheme?.backdropBuilder,
      useSafeArea: widget.useSafeArea ?? compTheme?.useSafeArea,
      showDragHandle: widget.showDragHandle ?? compTheme?.showDragHandle,
      borderRadius: widget.borderRadius ?? compTheme?.borderRadius,
      dragHandleSize: widget.dragHandleSize ?? compTheme?.dragHandleSize,
      transformBackdrop:
          widget.transformBackdrop ?? compTheme?.transformBackdrop,
      surfaceOpacity: widget.surfaceOpacity ?? compTheme?.surfaceOpacity,
      surfaceBlur: widget.surfaceBlur ?? compTheme?.surfaceBlur,
      barrierColor: widget.barrierColor ?? compTheme?.barrierColor,
    );
  }

  /// Executes `_buildGesture` behavior for this component/composite.
  Widget _buildGesture({required Widget child, required bool draggable}) {
    final compTheme = ComponentTheme.maybeOf<SwiperTheme>(context);
    final behavior =
        widget.behavior ?? compTheme?.behavior ?? HitTestBehavior.translucent;
    if (widget.position == OverlayPosition.top ||
        widget.position == OverlayPosition.bottom) {
      return GestureDetector(
        behavior: behavior,
        onVerticalDragUpdate: draggable ? _onDrag : null,
        onVerticalDragEnd: draggable ? _onDragEnd : null,
        onVerticalDragStart: draggable ? _onDragStart : null,
        onVerticalDragCancel: _onDragCancel,
        child: child,
      );
    }
    return GestureDetector(
      behavior: behavior,
      onHorizontalDragUpdate: draggable ? _onDrag : null,
      onHorizontalDragEnd: draggable ? _onDragEnd : null,
      onHorizontalDragStart: draggable ? _onDragStart : null,
      onHorizontalDragCancel: _onDragCancel,
      child: child,
    );
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return _buildGesture(child: widget.child, draggable: widget.enabled);
  }
}
