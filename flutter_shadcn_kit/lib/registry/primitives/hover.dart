// Hover primitives: delayed show/hide (`Hover`) and raw enter/exit tracking
// (`HoverActivity`), plus their shared theme.
//
// Ported from `shared/primitives/hover.dart` + `_impl/**`.

import 'dart:async';

import 'package:flutter/widgets.dart';

import '../foundation/style_value.dart';
import '../theme/color_tokens.dart';
import '../theme/theme.dart';

/// Timing and hit-test configuration for the hover primitives.
class HoverTheme extends ComponentThemeData implements Mergeable<HoverTheme> {
  /// Debounce duration for repeated hover events.
  final Duration? debounceDuration;

  /// Hit-test behavior used by [HoverActivity].
  final HitTestBehavior? hitTestBehavior;

  /// Delay before hover feedback is shown.
  final Duration? waitDuration;

  /// Minimum time hover feedback stays visible after leaving.
  final Duration? minDuration;

  /// Duration of the hide animation after [minDuration].
  final Duration? showDuration;

  /// Creates a [HoverTheme].
  const HoverTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.debounceDuration,
    this.hitTestBehavior,
    this.waitDuration,
    this.minDuration,
    this.showDuration,
  });

  /// Returns a copy with the given fields replaced.
  HoverTheme copyWith({
    ValueGetter<Duration?>? debounceDuration,
    ValueGetter<HitTestBehavior?>? hitTestBehavior,
    ValueGetter<Duration?>? waitDuration,
    ValueGetter<Duration?>? minDuration,
    ValueGetter<Duration?>? showDuration,
  }) {
    return HoverTheme(
      debounceDuration: debounceDuration == null
          ? this.debounceDuration
          : debounceDuration(),
      hitTestBehavior: hitTestBehavior == null
          ? this.hitTestBehavior
          : hitTestBehavior(),
      waitDuration: waitDuration == null ? this.waitDuration : waitDuration(),
      minDuration: minDuration == null ? this.minDuration : minDuration(),
      showDuration: showDuration == null ? this.showDuration : showDuration(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  HoverTheme merge(HoverTheme? fallback) {
    if (fallback == null) return this;
    return HoverTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      debounceDuration: debounceDuration ?? fallback.debounceDuration,
      hitTestBehavior: hitTestBehavior ?? fallback.hitTestBehavior,
      waitDuration: waitDuration ?? fallback.waitDuration,
      minDuration: minDuration ?? fallback.minDuration,
      showDuration: showDuration ?? fallback.showDuration,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is HoverTheme &&
        other.debounceDuration == debounceDuration &&
        other.hitTestBehavior == hitTestBehavior &&
        other.waitDuration == waitDuration &&
        other.minDuration == minDuration &&
        other.showDuration == showDuration;
  }

  @override
  int get hashCode => Object.hash(
    debounceDuration,
    hitTestBehavior,
    waitDuration,
    minDuration,
    showDuration,
  );
}

/// Tracks mouse hover state and triggers delayed show/hide callbacks.
class Hover extends StatefulWidget {
  /// The child tracked for hover.
  final Widget child;

  /// Delay before `onHover(true)` fires. Defaults to 300 ms.
  final Duration? waitDuration;

  /// Minimum time hover feedback stays visible. Defaults to zero.
  final Duration? minDuration;

  /// Duration added after [minDuration] before `onHover(false)` fires.
  final Duration? showDuration;

  /// Called with `true` after [waitDuration] of hovering, `false` after
  /// leaving.
  final ValueChanged<bool>? onHover;

  /// Creates a [Hover] widget.
  const Hover({
    super.key,
    required this.child,
    this.waitDuration,
    this.minDuration,
    this.showDuration,
    this.onHover,
  });

  @override
  State<Hover> createState() => _HoverState();
}

class _HoverState extends State<Hover> {
  bool _hovered = false;
  bool _showed = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = resolveComponentStyle<HoverTheme, HoverTheme>(
      context,
      select: (t) => t,
      defaults: const HoverTheme(),
    );
    final waitDuration = styleValue(
      widgetValue: widget.waitDuration,
      themeValue: theme.waitDuration,
      defaultValue: const Duration(milliseconds: 300),
    );
    final minDuration = styleValue(
      widgetValue: widget.minDuration,
      themeValue: theme.minDuration,
      defaultValue: const Duration(milliseconds: 0),
    );
    final showDuration = styleValue(
      widgetValue: widget.showDuration,
      themeValue: theme.showDuration,
      defaultValue: const Duration(milliseconds: 150),
    );

    return HoverActivity(
      hitTestBehavior: HitTestBehavior.deferToChild,
      onEnter: () {
        _hovered = true;
        _timer?.cancel();
        _timer = Timer(waitDuration, () {
          if (_hovered) {
            widget.onHover?.call(true);
            _showed = true;
          }
        });
      },
      onExit: () {
        _hovered = false;
        if (_showed) {
          _timer?.cancel();
          _timer = Timer(minDuration + showDuration, () {
            _showed = false;
            widget.onHover?.call(false);
          });
        }
      },
      child: widget.child,
    );
  }
}

/// Reports raw mouse enter/exit and repeatedly ticks a debounce controller
/// while hovered (`onHover` fires on every tick).
class HoverActivity extends StatefulWidget {
  /// The child tracked for hover.
  final Widget child;

  /// Called on each debounce tick while hovered.
  final VoidCallback? onHover;

  /// Called when the pointer leaves.
  final VoidCallback? onExit;

  /// Called when the pointer enters.
  final VoidCallback? onEnter;

  /// Tick duration of the internal debounce controller. Defaults to 100 ms.
  final Duration? debounceDuration;

  /// Hit-test behavior. Defaults to [HitTestBehavior.deferToChild].
  final HitTestBehavior? hitTestBehavior;

  /// Creates a [HoverActivity] widget.
  const HoverActivity({
    super.key,
    required this.child,
    this.onHover,
    this.onExit,
    this.onEnter,
    this.hitTestBehavior,
    this.debounceDuration,
  });

  @override
  State<HoverActivity> createState() => _HoverActivityState();
}

class _HoverActivityState extends State<HoverActivity>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.debounceDuration,
    );
    _controller.addStatusListener(_onStatusChanged);
  }

  void _onStatusChanged(AnimationStatus status) {
    widget.onHover?.call();
  }

  @override
  void didUpdateWidget(covariant HoverActivity oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.duration = widget.debounceDuration;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = resolveComponentStyle<HoverTheme, HoverTheme>(
      context,
      select: (t) => t,
      defaults: const HoverTheme(),
    );
    final debounceDuration = styleValue(
      widgetValue: widget.debounceDuration,
      themeValue: theme.debounceDuration,
      defaultValue: const Duration(milliseconds: 100),
    );
    final behavior = styleValue(
      widgetValue: widget.hitTestBehavior,
      themeValue: theme.hitTestBehavior,
      defaultValue: HitTestBehavior.deferToChild,
    );
    _controller.duration = debounceDuration;
    return MouseRegion(
      hitTestBehavior: behavior,
      onEnter: (_) {
        widget.onEnter?.call();
        _controller.repeat(reverse: true);
      },
      onExit: (_) {
        _controller.stop();
        widget.onExit?.call();
      },
      child: widget.child,
    );
  }
}
