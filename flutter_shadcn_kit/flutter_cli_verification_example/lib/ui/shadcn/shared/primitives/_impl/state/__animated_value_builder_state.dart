part of '../../animated_value_builder.dart';

class _AnimatedValueBuilderState<T> extends State<AnimatedValueBuilder<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  T? _from;
  T? _to;
  T? _lastNonNullValue;

  @override
  void initState() {
    super.initState();
    _from = widget.initialValue ?? widget.value;
    _to = widget.value;
    _cacheIfNonNull(_from);
    _cacheIfNonNull(_to);
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
    if (widget.duration == Duration.zero) {
      _controller.value = 1;
    } else {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedValueBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
    if (widget.curve != oldWidget.curve) {
      _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
    }
    if (widget.value != _to || widget.initialValue != oldWidget.initialValue) {
      _from = _currentValue;
      _cacheIfNonNull(_from);
      _to = widget.value;
      _cacheIfNonNull(_to);
      if (widget.duration == Duration.zero) {
        _controller.value = 1;
        widget.onEnd?.call(_to);
      } else {
        _controller
          ..reset()
          ..forward().whenComplete(() {
            widget.onEnd?.call(_to);
          });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  T _lerpValue(T? a, T? b, double t) {
    if (widget.lerp != null) {
      final value = widget.lerp!(a, b, t);
      if (value != null) {
        _cacheIfNonNull(value);
        return value;
      }
      final fallback = b ?? a ?? widget.value ?? widget.initialValue;
      if (fallback != null) {
        _cacheIfNonNull(fallback);
        return fallback;
      }
      if (a != null || b != null) {
        final resolved = (t < 0.5 ? a : b) as T;
        _cacheIfNonNull(resolved);
        return resolved;
      }
      return _resolveValueOrFallback(
        reason:
            'AnimatedValueBuilder custom lerp returned null with null endpoints.',
      );
    }
    final start = a ?? b;
    final end = b ?? a ?? start;
    if (start == null || end == null) {
      final fallback = b ?? a ?? widget.value ?? widget.initialValue;
      if (fallback != null) {
        _cacheIfNonNull(fallback);
        return fallback;
      }
      return _resolveValueOrFallback(
        reason: 'AnimatedValueBuilder requires a value while animating.',
      );
    }
    if (start is num && end is num) {
      final value = (start + (end - start) * t) as T;
      _cacheIfNonNull(value);
      return value;
    }
    if (start is Color && end is Color) {
      final value = Color.lerp(start, end, t) as T;
      _cacheIfNonNull(value);
      return value;
    }
    if (start is Offset && end is Offset) {
      final value = Offset.lerp(start, end, t) as T;
      _cacheIfNonNull(value);
      return value;
    }
    if (start is Size && end is Size) {
      final value = Size.lerp(start, end, t) as T;
      _cacheIfNonNull(value);
      return value;
    }
    if (start is Rect && end is Rect) {
      final value = Rect.lerp(start, end, t) as T;
      _cacheIfNonNull(value);
      return value;
    }
    if (start is EdgeInsets && end is EdgeInsets) {
      final value = EdgeInsets.lerp(start, end, t) as T;
      _cacheIfNonNull(value);
      return value;
    }
    if (start is BorderRadius && end is BorderRadius) {
      final value = BorderRadius.lerp(start, end, t) as T;
      _cacheIfNonNull(value);
      return value;
    }
    if (start is Matrix4 && end is Matrix4) {
      final value = Matrix4Tween(begin: start, end: end).lerp(t) as T;
      _cacheIfNonNull(value);
      return value;
    }
    final value = t < 1.0 ? start : end;
    _cacheIfNonNull(value);
    return value;
  }

  T get _currentValue {
    if (_controller.isCompleted || widget.duration == Duration.zero) {
      return _resolveValueOrFallback(
        reason: 'AnimatedValueBuilder has no value to build with.',
      );
    }
    return _lerpValue(_from, _to, _animation.value);
  }

  T _resolveValueOrFallback({required String reason}) {
    final resolved =
        _to ??
        _from ??
        widget.value ??
        widget.initialValue ??
        _lastNonNullValue;
    if (resolved != null) {
      _cacheIfNonNull(resolved);
      return resolved;
    }
    if (_isNullableType) {
      return null as dynamic;
    }
    final defaultValue = _defaultValueForType();
    if (defaultValue != null) {
      _cacheIfNonNull(defaultValue);
      return defaultValue;
    }
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(reason),
      ErrorDescription(
        'T is non-nullable and no fallback/default value is available.',
      ),
    ]);
  }

  bool get _isNullableType => null is T;

  void _cacheIfNonNull(T? value) {
    if (value != null) {
      _lastNonNullValue = value;
    }
  }

  T? _defaultValueForType() {
    if (T == int) {
      return 0 as T;
    }
    if (T == double || T == num) {
      return 0.0 as T;
    }
    if (T == Color) {
      return const Color(0x00000000) as T;
    }
    if (T == Offset) {
      return Offset.zero as T;
    }
    if (T == Size) {
      return Size.zero as T;
    }
    if (T == Rect) {
      return Rect.zero as T;
    }
    if (T == EdgeInsets) {
      return EdgeInsets.zero as T;
    }
    if (T == BorderRadius) {
      return BorderRadius.zero as T;
    }
    if (T == Matrix4) {
      return Matrix4.identity() as T;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        return widget.builder(context, _currentValue, child);
      },
    );
  }
}
