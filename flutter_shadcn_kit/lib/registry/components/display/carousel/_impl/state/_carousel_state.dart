// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../carousel.dart';

/// _CarouselState holds mutable state for the carousel implementation.
class _CarouselState extends State<Carousel>
    with SingleTickerProviderStateMixin {
  late CarouselController _controller;

  Duration? _startTime;

  late Ticker _ticker;

  bool hovered = false;

  bool dragging = false;

  late double _lastDragValue;

  double _dragVelocity = 0;

  late int _currentIndex;

  CarouselTheme? _theme;

  /// Recomputes derived values when inherited dependencies change.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _theme = ComponentTheme.maybeOf<CarouselTheme>(context);
  }

  CarouselAlignment get _alignment => styleValue(
    widgetValue: widget.alignment,
    themeValue: _theme?.alignment,
    defaultValue: CarouselAlignment.center,
  );

  Axis get _direction => styleValue(
    widgetValue: widget.direction,
    themeValue: _theme?.direction,
    defaultValue: Axis.horizontal,
  );

  bool get _wrap => styleValue(
    widgetValue: widget.wrap,
    themeValue: _theme?.wrap,
    defaultValue: true,
  );

  bool get _pauseOnHover => styleValue(
    widgetValue: widget.pauseOnHover,
    themeValue: _theme?.pauseOnHover,
    defaultValue: true,
  );

  Duration? get _autoplaySpeed => styleValue(
    widgetValue: widget.autoplaySpeed,
    themeValue: _theme?.autoplaySpeed,
    defaultValue: null,
  );

  bool get _draggable => styleValue(
    widgetValue: widget.draggable,
    themeValue: _theme?.draggable,
    defaultValue: true,
  );

  Duration get _speed => styleValue(
    widgetValue: widget.speed,
    themeValue: _theme?.speed,
    defaultValue: const Duration(milliseconds: 200),
  );

  Curve get _curve => styleValue(
    widgetValue: widget.curve,
    themeValue: _theme?.curve,
    defaultValue: Curves.easeInOut,
  );

  Duration? get _currentSlideDuration {
    double currentIndex = _controller.getCurrentIndex(widget.itemCount);
    final int index = currentIndex.floor();
    Duration? duration = widget.durationBuilder?.call(index) ?? widget.duration;
    if (duration != null && _autoplaySpeed != null) {
      duration += _autoplaySpeed!;
    }
    return duration;
  }

  /// Initializes controllers and listeners required by carousel.
  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_tick);
    _controller = widget.controller ?? CarouselController();
    _controller.addListener(_onControllerChange);
    _currentIndex = _controller.getCurrentIndex(widget.itemCount).round();
    _dispatchControllerChange();
  }

  /// Implements `_check` behavior for carousel.
  void _check() {
    bool shouldStart = false;
    if (_controller.shouldAnimate) {
      shouldStart = true;
    }
    if (!shouldStart) {
      if (_currentSlideDuration != null) {
        if (!_pauseOnHover || !hovered) {
          shouldStart = true;
        }
      }
    }
    if (!shouldStart) {
      if (_dragVelocity.abs() > 0.0001) {
        shouldStart = true;
      }
    }
    if (shouldStart) {
      if (!_ticker.isActive) {
        _lastTime = null;
        _startTime = null;
        _ticker.start();
      }
    } else {
      if (_ticker.isActive) {
        _ticker.stop();
        _startTime = null;
        _lastTime = null;
      }
    }
  }

  Duration? _lastTime;

  /// Implements `_tick` behavior for carousel.
  void _tick(Duration elapsed) {
    Duration delta = _lastTime == null ? Duration.zero : elapsed - _lastTime!;
    _lastTime = elapsed;

    int deltaMillis = delta.inMilliseconds;
    _controller.tick(delta);

    bool shouldAutoPlay = false;
    if (_currentSlideDuration != null) {
      if (_startTime == null) {
        _startTime = elapsed;
        shouldAutoPlay = !widget.waitOnStart;
      } else {
        Duration elapsedDuration = elapsed - _startTime!;
        if (elapsedDuration >= _currentSlideDuration!) {
          shouldAutoPlay = true;
          _startTime = null;
        }
      }
    }
    if (shouldAutoPlay) {
      if (!_wrap &&
          widget.itemCount != null &&
          _controller.value >= widget.itemCount! - 1) {
        _controller.animateTo(0, _autoplaySpeed ?? _speed, _curve);
      } else if (!_wrap && widget.itemCount != null && _controller.value <= 0) {
        _controller.animateTo(
          widget.itemCount! - 1,
          _autoplaySpeed ?? _speed,
          _curve,
        );
      } else if (widget.autoplayReverse) {
        _controller.animatePrevious(_autoplaySpeed ?? _speed, _curve);
      } else {
        _controller.animateNext(_autoplaySpeed ?? _speed, _curve);
      }
    }
    if (_dragVelocity.abs() > 0.01 && !dragging) {
      var targetValue = progressedValue + _dragVelocity;
      _controller.jumpTo(targetValue);
      _dragVelocity *= pow(0.2, deltaMillis / 100);
      if (_dragVelocity.abs() < 0.01) {
        _dragVelocity = 0;
        if (widget.disableOverheadScrolling) {
          if (_lastDragValue < targetValue) {
            _controller.animateTo(
              _lastDragValue.floorToDouble() + 1,
              _speed,
              _curve,
            );
          } else {
            _controller.animateTo(
              _lastDragValue.floorToDouble() - 1,
              _speed,
              _curve,
            );
          }
        } else {
          _controller.animateSnap(_speed, _curve);
        }
      }
    }

    _check();
  }

  /// Updates internal state when carousel configuration changes.
  @override
  void didUpdateWidget(covariant Carousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_onControllerChange);
      _controller = widget.controller ?? CarouselController();
      _controller.addListener(_onControllerChange);
      _dispatchControllerChange();
    }
  }

  /// Implements `_onControllerChange` behavior for carousel.
  void _onControllerChange() {
    /// Implements `setState` behavior for carousel.
    setState(() {});
    if (!_wrap && widget.itemCount != null) {
      if (_controller.value < 0) {
        _controller._controller.value = 0;
      } else if (_controller.value >= widget.itemCount!) {
        _controller._controller.value = widget.itemCount!.toDouble() - 1;
      }
    }
    _dispatchControllerChange();
  }

  /// Implements `_dispatchControllerChange` behavior for carousel.
  void _dispatchControllerChange() {
    _check();
    int index = _controller.getCurrentIndex(widget.itemCount).round();
    if (index != _currentIndex) {
      _currentIndex = index;
      widget.onIndexChanged?.call(index);
    }
  }

  /// Disposes resources allocated by this carousel state.
  @override
  void dispose() {
    _controller.removeListener(_onControllerChange);
    _ticker.dispose();
    super.dispose();
  }

  /// Builds the widget tree for carousel.
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        hovered = true;
        _check();
      },
      onExit: (event) {
        hovered = false;
        _check();
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          var carouselWidget = buildCarousel(context, constraints);
          if (_draggable) {
            if (_direction == Axis.horizontal) {
              carouselWidget = buildHorizontalDragger(
                context,
                carouselWidget,
                constraints,
              );
            } else {
              carouselWidget = buildVerticalDragger(
                context,
                carouselWidget,
                constraints,
              );
            }
          }
          return carouselWidget;
        },
      ),
    );
  }

  Widget buildHorizontalDragger(
    BuildContext context,
    Widget carouselWidget,
    BoxConstraints constraints,
  ) {
    double size;
    if (widget.sizeConstraint is CarouselFixedConstraint) {
      size = (widget.sizeConstraint as CarouselFixedConstraint).size;
    } else if (widget.sizeConstraint is CarouselFractionalConstraint) {
      size =
          constraints.maxHeight *
          (widget.sizeConstraint as CarouselFractionalConstraint).fraction;
    } else {
      size = constraints.maxHeight;
    }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: carouselWidget,
      onHorizontalDragStart: (details) {
        dragging = true;
        _lastDragValue = progressedValue;
        _dragVelocity = 0;
      },
      onHorizontalDragUpdate: (details) {
        if (_draggable) {
          /// Implements `setState` behavior for carousel.
          setState(() {
            var increment = -details.primaryDelta! / size;
            _controller.jumpTo(progressedValue + increment);
          });
        }
      },
      onHorizontalDragEnd: (details) {
        dragging = false;
        if (widget.disableDraggingVelocity) {
          _dragVelocity = 0;
        } else {
          _dragVelocity = -details.primaryVelocity! / size / 100.0;
        }
        _controller.animateSnap(_speed, _curve);
        _check();
      },
    );
  }

  Widget buildVerticalDragger(
    BuildContext context,
    Widget carouselWidget,
    BoxConstraints constraints,
  ) {
    double size;
    if (widget.sizeConstraint is CarouselFixedConstraint) {
      size = (widget.sizeConstraint as CarouselFixedConstraint).size;
    } else if (widget.sizeConstraint is CarouselFractionalConstraint) {
      size =
          constraints.maxWidth *
          (widget.sizeConstraint as CarouselFractionalConstraint).fraction;
    } else {
      size = constraints.maxWidth;
    }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: carouselWidget,
      onVerticalDragStart: (details) {
        dragging = true;
        _lastDragValue = progressedValue;
        _dragVelocity = 0;
      },
      onVerticalDragUpdate: (details) {
        if (_draggable) {
          /// Implements `setState` behavior for carousel.
          setState(() {
            var increment = -details.primaryDelta! / size;
            _controller.jumpTo(progressedValue + increment);
          });
        }
      },
      onVerticalDragEnd: (details) {
        dragging = false;
        if (widget.disableDraggingVelocity) {
          _dragVelocity = 0;
        } else {
          _dragVelocity = -details.primaryVelocity! / size / 100.0;
        }
        _controller.animateSnap(_speed, _curve);
        _check();
      },
    );
  }

  double get progressedValue {
    if (!_wrap && widget.itemCount != null) {
      return _controller.value.clamp(0.0, widget.itemCount!.toDouble() - 1);
    } else {
      return _controller.value;
    }
  }

  /// Implements `buildCarousel` behavior for carousel.
  Widget buildCarousel(BuildContext context, BoxConstraints constraints) {
    return Stack(
      children: widget.transition.layout(
        context,
        progress: progressedValue,
        constraints: constraints,
        alignment: _alignment,
        direction: _direction,
        sizeConstraint: widget.sizeConstraint,
        progressedIndex: progressedValue,
        wrap: _wrap,
        itemCount: widget.itemCount,
        itemBuilder: widget.itemBuilder,
        reverse: widget.reverse,
      ),
    );
  }
}
