// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../pinned_sheet.dart';

/// State for [PinnedSheet].
///
/// Registry adaptation: upstream drives the slide through a dedicated render
/// object with overscroll physics; this port drives an equivalent pixel
/// [currentOffset] with an [AnimationController] + drag gestures and snaps
/// to the nearest configured stage on release. All public state members
/// consumed by [SheetController]/[_AttachedSheetStage] keep upstream names.
class _PinnedSheetState extends State<PinnedSheet>
    with TickerProviderStateMixin {
  AnimationController? _animation;
  double _offset = 0;
  double _axisExtent = 0;
  bool _settledInitial = false;

  OverlayPosition _resolvePosition(BuildContext context) {
    final direction = Directionality.of(context);
    return switch (widget.position) {
      OverlayPosition.start => direction == TextDirection.rtl
          ? OverlayPosition.right
          : OverlayPosition.left,
      OverlayPosition.end => direction == TextDirection.rtl
          ? OverlayPosition.left
          : OverlayPosition.right,
      _ => widget.position,
    };
  }

  bool _isVertical(OverlayPosition position) {
    return position == OverlayPosition.top ||
        position == OverlayPosition.bottom;
  }

  /// The sheet's content size for stage resolution (axis extent measured
  /// from layout; cross extent unbounded-safe).
  Size _contentSize(bool vertical) {
    if (_axisExtent <= 0) return Size.zero;
    return vertical
        ? Size(double.infinity, _axisExtent)
        : Size(_axisExtent, double.infinity);
  }

  /// The current stage resolution context.
  SheetStageResolution get resolution {
    final position = _resolvePosition(context);
    return SheetStageResolution(
      size: _contentSize(_isVertical(position)),
      position: position,
      dragHandleExtent: widget.showDragHandle
          ? ((widget.dragHandleSize?.height ?? 16))
          : 0,
    );
  }

  /// The current visible extent of the sheet, in logical pixels.
  double get currentOffset => _offset;

  /// The current visible extent as a fraction (0..1) of the axis.
  double get currentFraction {
    if (_axisExtent <= 0) return 0;
    return (_offset / _axisExtent).clamp(0.0, 1.0);
  }

  /// The current backdrop transform value (0..1).
  double get currentBackdropTransform => currentFraction;

  double _targetFor(SheetStage stage) {
    final target = stage.resolveDragOffset(resolution);
    if (_axisExtent <= 0) return 0;
    return target.clamp(0.0, _axisExtent);
  }

  /// Animates the sheet to [stage].
  Future<void> animateToStage(
    SheetStage stage, {
    Duration duration = kDefaultDuration,
    Curve curve = Curves.linear,
  }) {
    final target = _targetFor(stage);
    _animation?.dispose();
    _animation = AnimationController(vsync: this, duration: duration);
    final tween = Tween<double>(begin: _offset, end: target);
    final curved = CurvedAnimation(parent: _animation!, curve: curve);
    _animation!.addListener(() {
      _offset = tween.evaluate(curved);
      widget.controller?._notify();
      if (mounted) setState(() {});
    });
    return _animation!.forward().then((_) {
      _offset = target;
      widget.controller?._notify();
      if (mounted) setState(() {});
    });
  }

  /// Immediately jumps the sheet to [stage] with no animation.
  void jumpToStage(SheetStage stage) {
    _animation?.stop();
    _offset = _targetFor(stage);
    widget.controller?._notify();
    if (mounted) setState(() {});
  }

  void _settleInitial() {
    if (_settledInitial) return;
    _settledInitial = true;
    final initial = widget.initialStage ??
        (widget.stages.isNotEmpty
            ? widget.stages.first
            : const SheetStage.closed());
    jumpToStage(initial);
  }

  @override
  void initState() {
    super.initState();
    widget.controller?._attach(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _settleInitial();
    });
  }

  @override
  void didUpdateWidget(covariant PinnedSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach(this);
      widget.controller?._attach(this);
    }
  }

  @override
  void dispose() {
    widget.controller?._detach(this);
    _animation?.dispose();
    super.dispose();
  }

  void _applyDragDelta(OverlayPosition position, double dx, double dy) {
    final delta = switch (position) {
      OverlayPosition.bottom => -dy,
      OverlayPosition.top => dy,
      OverlayPosition.right => -dx,
      OverlayPosition.left => dx,
      _ => 0.0,
    };
    if (delta == 0) return;
    _animation?.stop();
    _offset = (_offset + delta).clamp(
      0.0,
      _axisExtent <= 0 ? 0.0 : _axisExtent,
    );
    widget.controller?._notify();
    setState(() {});
  }

  void _snapToNearest() {
    if (widget.stages.isEmpty || _axisExtent <= 0) return;
    SheetStage nearest = widget.stages.first;
    double nearestDistance =
        (_targetFor(nearest) - _offset).abs();
    for (final stage in widget.stages.skip(1)) {
      final distance = (_targetFor(stage) - _offset).abs();
      if (distance < nearestDistance) {
        nearest = stage;
        nearestDistance = distance;
      }
    }
    animateToStage(nearest, duration: widget.duration, curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    final position = _resolvePosition(context);
    final vertical = _isVertical(position);
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxExtent = vertical
            ? (constraints.hasBoundedHeight ? constraints.maxHeight : 0.0)
            : (constraints.hasBoundedWidth ? constraints.maxWidth : 0.0);
        if (maxExtent != _axisExtent) {
          _axisExtent = maxExtent;
          if (!_settledInitial && maxExtent > 0) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _settleInitial();
            });
          } else if (_settledInitial && maxExtent > 0) {
            _offset = _offset.clamp(0.0, maxExtent);
          }
        }

        final t = currentFraction;
        final hiddenShift = (1 - t) * _axisExtent;
        final slideOffset = switch (position) {
          OverlayPosition.bottom => Offset(0, hiddenShift),
          OverlayPosition.top => Offset(0, -hiddenShift),
          OverlayPosition.right => Offset(hiddenShift, 0),
          OverlayPosition.left => Offset(-hiddenShift, 0),
          _ => Offset(0, hiddenShift),
        };

        final containerData = DrawerContainerData(
          position: position,
          size: Size(
            constraints.hasBoundedWidth
                ? constraints.maxWidth
                : _axisExtent,
            constraints.hasBoundedHeight
                ? constraints.maxHeight
                : _axisExtent,
          ),
          stackIndex: 0,
          expands: widget.expands,
          draggable: widget.draggable,
          showDragHandle: widget.showDragHandle,
          dragHandleSize: widget.dragHandleSize,
          borderRadius: widget.borderRadius,
          surfaceOpacity: widget.surfaceOpacity,
          surfaceBlur: widget.surfaceBlur,
          barrierColor: widget.barrierColor,
          constraints: widget.constraints,
        );

        Widget chrome = Data.inherit(
          data: containerData,
          child: widget.child,
        );
        if (widget.contentExpands && _axisExtent > 0) {
          final visible = _offset.clamp(0.0, _axisExtent);
          chrome = SizedBox(
            width: vertical ? double.infinity : visible,
            height: vertical ? visible : double.infinity,
            child: ClipRect(child: chrome),
          );
        }
        if (widget.constraints != null) {
          chrome = ConstrainedBox(
            constraints: widget.constraints!,
            child: chrome,
          );
        }

        final edgeAlignment = switch (position) {
          OverlayPosition.bottom => Alignment.bottomCenter,
          OverlayPosition.top => Alignment.topCenter,
          OverlayPosition.right => Alignment.centerRight,
          OverlayPosition.left => Alignment.centerLeft,
          _ => Alignment.bottomCenter,
        };

        Widget sliding = Align(
          alignment: edgeAlignment,
          child: Transform.translate(offset: slideOffset, child: chrome),
        );
        if (widget.draggable) {
          sliding = GestureDetector(
            behavior: HitTestBehavior.translucent,
            onVerticalDragUpdate: vertical
                ? (details) =>
                    _applyDragDelta(position, details.delta.dx, details.delta.dy)
                : null,
            onHorizontalDragUpdate: vertical
                ? null
                : (details) =>
                    _applyDragDelta(position, details.delta.dx, details.delta.dy),
            onVerticalDragEnd:
                vertical ? (_) => _snapToNearest() : null,
            onHorizontalDragEnd:
                vertical ? null : (_) => _snapToNearest(),
            child: sliding,
          );
        }

        final transformedBackdrop = widget.backdrop == null
            ? null
            : (widget.backdropTransform?.wrapBackdrop(
                      context,
                      widget.backdrop!,
                      t,
                    ) ??
                widget.backdrop!);
        Widget? backdrop = transformedBackdrop;
        if (widget.draggableBackdrop && backdrop != null) {
          backdrop = GestureDetector(
            behavior: HitTestBehavior.translucent,
            onVerticalDragUpdate: vertical
                ? (details) =>
                    _applyDragDelta(position, details.delta.dx, details.delta.dy)
                : null,
            onHorizontalDragUpdate: vertical
                ? null
                : (details) =>
                    _applyDragDelta(position, details.delta.dx, details.delta.dy),
            onVerticalDragEnd:
                vertical ? (_) => _snapToNearest() : null,
            onHorizontalDragEnd:
                vertical ? null : (_) => _snapToNearest(),
            child: backdrop,
          );
        }

        final showBarrier =
            widget.modal && widget.barrierColor != null && t > 0;
        return Stack(
          fit: StackFit.passthrough,
          children: [
            if (backdrop != null) Positioned.fill(child: backdrop),
            if (showBarrier)
              Positioned.fill(
                child: GestureDetector(
                  onTap: widget.barrierDismissible
                      ? () => animateToStage(
                            const SheetStage.closed(),
                            duration: widget.duration,
                            curve: Curves.easeOut,
                          )
                      : null,
                  child: ColoredBox(
                    color: widget.barrierColor!.withValues(alpha: t),
                  ),
                ),
              ),
            Positioned.fill(child: sliding),
          ],
        );
      },
    );
  }
}
