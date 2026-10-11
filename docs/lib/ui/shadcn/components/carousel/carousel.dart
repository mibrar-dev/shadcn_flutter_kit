// The `carousel` component: a paged [Carousel] driven by a [CarouselController].
// `carousel_style.dart` holds the theme rows, the controller and the layout
// math. The old bugs this port fixed are listed in README.md.

import 'package:flutter/scheduler.dart' show Ticker;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import 'carousel_style.dart';

export 'carousel_style.dart';

/// Builds one page of the carousel.
typedef CarouselItemBuilder = Widget Function(BuildContext context, int index);

/// Keyboard step for [Carousel]: `delta` is +1 (forward) or -1 (back); the
/// widget mirrors the direction in RTL.
class _CarouselStepIntent extends Intent {
  /// Creates a step intent.
  const _CarouselStepIntent(this.delta);

  /// Signed step.
  final int delta;
}

/// A paged carousel; a [CarouselController] drives the fractional page position.
class Carousel extends StatefulWidget {
  /// Creates a carousel.
  const Carousel({
    super.key,
    required this.itemBuilder,
    this.itemCount,
    this.controller,
    this.transition,
    this.alignment,
    this.direction,
    this.viewportFraction,
    this.itemExtent,
    this.gap,
    this.speed,
    this.curve,
    this.autoplayInterval,
    this.autoplayReverse = false,
    this.onIndexChanged,
    this.onPageChanged,
    this.theme,
  }) : assert(itemCount == null || itemCount > 0, 'itemCount must be > 0');

  /// Builds the page at [index].
  final CarouselItemBuilder itemBuilder;

  /// Number of pages; null means unbounded.
  final int? itemCount;

  /// Controller driving the page position; the carousel creates and disposes
  /// its own when null.
  final CarouselController? controller;

  /// Page transition; null resolves sliding.
  final CarouselTransition? transition;

  /// Page alignment; null resolves center.
  final CarouselAlignment? alignment;

  /// Scroll axis; null resolves horizontal.
  final Axis? direction;

  /// Viewport fraction per page; null resolves 1.
  final double? viewportFraction;

  /// Fixed page extent; wins over [viewportFraction].
  final double? itemExtent;

  /// Gap between two pages.
  final double? gap;

  /// Page-change duration; null resolves 150 ms.
  final Duration? speed;

  /// Page-change curve; null resolves easeInOut.
  final Curve? curve;

  /// Hold time per page; null disables autoplay.
  final Duration? autoplayInterval;

  /// Whether autoplay walks backwards.
  final bool autoplayReverse;

  /// Called with the rounded page index whenever it changes.
  final ValueChanged<int>? onIndexChanged;

  /// Called with the fractional page position on every change.
  final ValueChanged<double>? onPageChanged;

  /// Widget leg of [CarouselTheme].
  final CarouselTheme? theme;
  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel>
    with SingleTickerProviderStateMixin {
  late CarouselController _controller;
  late bool _ownsController;
  late Ticker _ticker;

  Duration? _heldSince;
  bool _hovered = false;
  bool _dragging = false;
  int _lastReportedIndex = 0;
  Duration? _lastElapsed;

  /// The four theme legs resolved by the last build.
  ///
  /// Cached because the controller listener runs outside a build phase and
  /// must not register an inherited dependency there.
  late CarouselTheme _resolved;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_tick);
    _attachController();
  }

  void _attachController() {
    final CarouselController? external = widget.controller;
    _ownsController = external == null;
    _controller = external ?? CarouselController();
    _controller.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(covariant Carousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _controller.removeListener(_handleControllerChanged);
      if (_ownsController) {
        _controller.dispose();
      }
      _attachController();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);
    _ticker.dispose();
    // Only a controller the widget created may be disposed here.
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  void _clampIfNeeded() {
    final int? count = widget.itemCount;
    if (count == null || _resolved.wrap! || _controller.isAnimating) {
      // A running animation is left alone: clamping its live value would clear
      // the queue (the very bug this replaced) and freeze the slide halfway.
      return;
    }
    final double clamped = _controller.value.clamp(0.0, count - 1);
    if (clamped != _controller.value) {
      _controller.jumpTo(clamped);
    }
  }

  /// Resolves the four theme legs once per frame: a plain widget update (say
  /// `alignment:`) never schedules `didChangeDependencies`, which would leave
  /// a cached slice there one frame stale.
  CarouselTheme _resolve() {
    return resolveComponentStyle<CarouselTheme, CarouselTheme>(
      context,
      widget: widget.theme?.merge(_widgetLeg()) ?? _widgetLeg(),
      select: (t) => t,
      defaults: carouselDefaults,
    );
  }

  /// The named arguments, as one style leg under `widget.theme`. The
  /// behavioural knobs (`wrap`, `draggable`, `pauseOnHover`) are theme rows
  /// only: they have no widget argument.
  CarouselTheme _widgetLeg() => CarouselTheme(
    transition: widget.transition,
    alignment: widget.alignment,
    direction: widget.direction,
    viewportFraction: widget.viewportFraction,
    itemExtent: widget.itemExtent,
    gap: widget.gap,
    speed: widget.speed,
    curve: widget.curve,
    autoplayInterval: widget.autoplayInterval,
  );

  void _handleControllerChanged() {
    if (!mounted) return;
    setState(() {});
    _clampIfNeeded();
    _report();
    _syncTicker();
  }

  void _report() {
    final double page = _controller.resolvedIndex(
      itemCount: widget.itemCount,
      wrap: _resolved.wrap!,
    );
    widget.onPageChanged?.call(page);
    final int index = page.round();
    if (index != _lastReportedIndex) {
      _lastReportedIndex = index;
      widget.onIndexChanged?.call(index);
    }
  }

  void _syncTicker() {
    final CarouselTheme theme = _resolved;
    final bool paused = _dragging || ((theme.pauseOnHover ?? true) && _hovered);
    final bool shouldRun =
        !paused && (theme.autoplayInterval != null || _controller.isAnimating);
    if (shouldRun && !_ticker.isActive) {
      _lastElapsed = null;
      _heldSince = null;
      _ticker.start();
    } else if (!shouldRun && _ticker.isActive) {
      _ticker.stop();
      _lastElapsed = null;
      _heldSince = null;
    }
  }

  void _tick(Duration elapsed) {
    final Duration delta = _lastElapsed == null
        ? Duration.zero
        : elapsed - _lastElapsed!;
    _lastElapsed = elapsed;
    _controller.tick(delta);
    final CarouselTheme theme = _resolved;
    final Duration? hold = theme.autoplayInterval;
    if (hold == null) return;
    _heldSince ??= elapsed;
    if (elapsed - _heldSince! < hold) return;
    _heldSince = elapsed;
    _step(theme);
  }

  void _step(CarouselTheme theme) {
    final double target = carouselStepTarget(
      value: _controller.value,
      itemCount: widget.itemCount,
      wrap: theme.wrap!,
      reverse: widget.autoplayReverse,
    );
    _controller.animateTo(target, theme.speed!, theme.curve!);
  }

  void _handleHover(bool hovered) {
    if (_hovered == hovered) return;
    _hovered = hovered;
    _syncTicker();
  }

  void _handleDragStart() {
    _dragging = true;
    _syncTicker();
  }

  void _handleDragUpdate(DragUpdateDetails details, double pageExtent) {
    final double? delta = details.primaryDelta;
    if (delta == null || pageExtent <= 0) return;
    _controller.jumpTo(_controller.value - delta / pageExtent);
  }

  void _handleDragEnd(DragEndDetails details, double pageExtent) {
    _dragging = false;
    final CarouselTheme theme = _resolved;
    final double extent = pageExtent > 0 ? pageExtent : 1;
    // `primaryVelocity` is null whenever the gesture was cancelled.
    // `primaryVelocity` is null whenever the gesture was cancelled.
    final double target = carouselSnapTarget(
      value: _controller.value,
      // A cancelled gesture reports a null `primaryVelocity`.
      velocity: details.primaryVelocity ?? 0,
      extent: extent,
      itemCount: widget.itemCount,
      wrap: theme.wrap!,
    );
    _controller.animateTo(target, theme.speed!, theme.curve!);
    _syncTicker();
  }

  @override
  Widget build(BuildContext context) {
    final CarouselTheme theme = _resolve();
    _resolved = theme;
    _syncTicker();
    final bool horizontal = theme.direction == Axis.horizontal;
    final bool rtl =
        horizontal && Directionality.of(context) == TextDirection.rtl;
    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double viewport = horizontal
              ? constraints.maxWidth
              : constraints.maxHeight;
          // The cross axis needs its own finite bound: reusing the along-axis
          // `viewport` here stretched horizontal pages to `maxWidth` tall.
          final double cross = horizontal
              ? constraints.maxHeight
              : constraints.maxWidth;
          if (!viewport.isFinite || !cross.isFinite) {
            // A carousel pages a bounded stage; without one there is
            // nothing to lay out instead of a NaN crash downstream.
            return const SizedBox.shrink();
          }
          final double extent =
              theme.itemExtent ?? viewport * (theme.viewportFraction ?? 1);
          final Widget stack = Stack(
            clipBehavior: Clip.none,
            children: _pages(theme, extent, viewport, cross, rtl),
          );
          final Widget keyed = FocusableActionDetector(
            shortcuts: <ShortcutActivator, Intent>{
              const SingleActivator(LogicalKeyboardKey.arrowLeft):
                  const _CarouselStepIntent(-1),
              const SingleActivator(LogicalKeyboardKey.arrowRight):
                  const _CarouselStepIntent(1),
              const SingleActivator(LogicalKeyboardKey.arrowUp):
                  const _CarouselStepIntent(-1),
              const SingleActivator(LogicalKeyboardKey.arrowDown):
                  const _CarouselStepIntent(1),
            },
            actions: <Type, Action<Intent>>{
              _CarouselStepIntent: CallbackAction<_CarouselStepIntent>(
                onInvoke: (intent) => _stepBy(intent.delta, rtl: rtl),
              ),
            },
            child: Semantics(
              container: true,
              explicitChildNodes: true,
              value: _semanticsValue(),
              child: stack,
            ),
          );
          if (!theme.draggable!) {
            return keyed;
          }
          void start(DragStartDetails details) => _handleDragStart();
          void update(DragUpdateDetails details) =>
              _handleDragUpdate(details, extent);
          void end(DragEndDetails details) => _handleDragEnd(details, extent);
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragStart: horizontal ? start : null,
            onHorizontalDragUpdate: horizontal ? update : null,
            onHorizontalDragEnd: horizontal ? end : null,
            onVerticalDragStart: horizontal ? null : start,
            onVerticalDragUpdate: horizontal ? null : update,
            onVerticalDragEnd: horizontal ? null : end,
            child: keyed,
          );
        },
      ),
    );
  }

  /// Screen-reader position, e.g. `Page 2 of 5`; null when unbounded.
  String? _semanticsValue() {
    final int? count = widget.itemCount;
    if (count == null) {
      return null;
    }
    final int index = _controller
        .resolvedIndex(itemCount: count, wrap: _resolved.wrap!)
        .round()
        .clamp(0, count - 1);
    return 'Page ${index + 1} of $count';
  }

  /// Steps one page for keyboard input; left/up go back in LTR and forward
  /// in RTL, mirroring the mirrored layout.
  void _stepBy(int delta, {required bool rtl}) {
    final CarouselTheme theme = _resolved;
    final double target = carouselStepTarget(
      value: _controller.value,
      itemCount: widget.itemCount,
      wrap: theme.wrap!,
      reverse: rtl ? delta > 0 : delta < 0,
    );
    _controller.animateTo(target, theme.speed!, theme.curve!);
  }

  /// One positioned child per visible page, dispatched on the transition.
  List<Widget> _pages(
    CarouselTheme theme,
    double extent,
    double viewport,
    double cross,
    bool rtl,
  ) => switch (theme.transition!) {
    CarouselTransition.sliding => _sliding(theme, extent, viewport, cross, rtl),
    CarouselTransition.fading => _fading(theme, extent, viewport, cross, rtl),
  };

  Widget _place(
    CarouselTheme theme,
    double along,
    double extent,
    double cross,
    bool rtl,
    Widget child,
  ) {
    final double? page = extent > 0 ? extent : null;
    if (theme.direction == Axis.horizontal) {
      // In RTL the leading edge is the right one, so the offset pins `right`.
      return Positioned(
        left: rtl ? null : along,
        right: rtl ? along : null,
        width: page,
        height: cross,
        child: child,
      );
    }
    return Positioned(top: along, width: cross, height: page, child: child);
  }

  List<Widget> _sliding(
    CarouselTheme theme,
    double extent,
    double viewport,
    double cross,
    bool rtl,
  ) {
    final (int before, int after) = carouselVisibleRange(
      theme,
      extent,
      viewport,
    );
    final int current = _controller.value.floor();
    int start = current - before;
    int end = current + after;
    final int? count = widget.itemCount;
    if (count != null && !theme.wrap!) {
      start = start.clamp(0, count - 1);
      end = end.clamp(0, count - 1);
    }
    final double free = (viewport - extent) * theme.alignment!.alignment;
    return <Widget>[
      for (var i = start; i <= end; i++)
        _place(
          theme,
          free + (i - current) * (extent + theme.gap!),
          extent,
          cross,
          rtl,
          widget.itemBuilder(context, carouselPageAt(i, widget.itemCount)),
        ),
    ];
  }

  List<Widget> _fading(
    CarouselTheme theme,
    double extent,
    double viewport,
    double cross,
    bool rtl,
  ) {
    final int current = _controller.value.round();
    final double free = (viewport - extent) * theme.alignment!.alignment;
    final double value = _controller.value;
    return <Widget>[
      for (final int i in <int>[current - 1, current, current + 1])
        if (carouselPageVisible(i, widget.itemCount, theme.wrap!))
          _place(
            theme,
            free,
            extent,
            cross,
            rtl,
            Opacity(
              opacity: (1 - (value - i).abs()).clamp(0.0, 1.0),
              child: widget.itemBuilder(
                context,
                carouselPageAt(i, widget.itemCount),
              ),
            ),
          ),
    ];
  }
}
