// The `refresh_trigger` component: [RefreshTrigger] and
// [DefaultRefreshIndicator] (stage types in `refresh_trigger_style.dart`).
//
// Ported from `components/overlay/refresh_trigger`: no `material.dart`, dead
// `checkbox` import and empty physics deleted, null `onRefresh` disables
// pulling, zero `minExtent` guarded, no `rendering.dart` direction tracking.

import 'dart:async';
import 'dart:math' show pi;

import 'package:flutter/widgets.dart';

import '../../foundation/constants.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../primitives/animated_value_builder.dart';
import '../../primitives/localizations/localizations.dart';
import '../../theme/theme.dart';
import '../card/card.dart';
import 'refresh_trigger_style.dart';

export 'refresh_trigger_style.dart';

/// Pull-to-refresh wrapper; null [onRefresh] disables pulling.
class RefreshTrigger extends StatefulWidget {
  const RefreshTrigger({
    super.key,
    this.minExtent,
    this.maxExtent,
    this.onRefresh,
    this.direction = Axis.vertical,
    this.reverse = false,
    this.indicatorBuilder,
    this.curve,
    this.completeDuration,
    required this.child,
    this.theme,
  });

  final double? minExtent;
  final double? maxExtent;
  final Future<void> Function()? onRefresh;
  final Axis direction;
  final bool reverse;
  final RefreshIndicatorBuilder? indicatorBuilder;
  final Curve? curve;
  final Duration? completeDuration;
  final Widget child;

  final RefreshTriggerTheme? theme;

  /// Default pill indicator (arrow, spinner, check + labels).
  static Widget defaultIndicatorBuilder(
    BuildContext context,
    RefreshTriggerStage stage,
  ) {
    return DefaultRefreshIndicator(stage: stage);
  }

  @override
  State<RefreshTrigger> createState() => RefreshTriggerState();
}

class RefreshTriggerState extends State<RefreshTrigger> {
  double _extent = 0;
  bool _scrolling = false;
  TriggerStage _stage = TriggerStage.idle;
  Future<void>? _currentFuture;
  int _futureCount = 0;
  late double _minExtent;
  late double _maxExtent;
  late RefreshIndicatorBuilder _indicatorBuilder;
  late Curve _curve;
  late Duration _completeDuration;

  TriggerStage get stage => _stage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolve();
  }

  @override
  void didUpdateWidget(covariant RefreshTrigger oldWidget) {
    super.didUpdateWidget(oldWidget);
    _resolve();
  }

  void _resolve() {
    final double scale = ShadcnTheme.of(context).scaling;
    final RefreshTriggerTheme style =
        resolveComponentStyle<RefreshTriggerTheme, RefreshTriggerTheme>(
          context,
          widget: widget.theme,
          select: (t) => t,
          defaults: refreshTriggerDefaults,
        );
    _minExtent = (widget.minExtent ?? style.minExtent ?? 75) * scale;
    _maxExtent = (widget.maxExtent ?? style.maxExtent ?? 150) * scale;
    _indicatorBuilder =
        widget.indicatorBuilder ??
        style.indicatorBuilder ??
        RefreshTrigger.defaultIndicatorBuilder;
    _curve = widget.curve ?? style.curve ?? Curves.easeOutSine;
    _completeDuration =
        widget.completeDuration ??
        style.completeDuration ??
        const Duration(milliseconds: 500);
  }

  double _clampExtent(double extent, double arm) {
    if (widget.reverse) extent = -extent;
    if (extent <= arm) return extent;
    final double range = _maxExtent - arm;
    if (range <= 0) return arm;
    final double relative = extent - arm;
    final double normalized = (range - relative) / range;
    return _maxExtent -
        Curves.decelerate.transform(normalized.clamp(0, 1)) *
            (range - relative);
  }

  bool _handleScroll(ScrollNotification notification) {
    if (notification.depth != 0 || widget.onRefresh == null) return false;
    if (notification is ScrollEndNotification && _scrolling) {
      final double extent = widget.reverse ? -_extent : _extent;
      setState(() {
        _scrolling = false;
        if (extent >= _minExtent) {
          refresh();
        } else {
          _stage = TriggerStage.idle;
          _extent = 0;
        }
      });
    } else if (notification is ScrollUpdateNotification) {
      final double? delta = notification.scrollDelta;
      if (delta == null) return false;
      final AxisDirection axis = notification.metrics.axisDirection;
      final double out =
          (axis == AxisDirection.down || axis == AxisDirection.right)
          ? -delta
          : delta;
      final bool atEdge = widget.reverse
          ? notification.metrics.extentAfter == 0
          : notification.metrics.extentBefore == 0;
      if (_stage == TriggerStage.idle && atEdge && out > 0) {
        setState(() {
          _extent = 0;
          _scrolling = true;
          _stage = TriggerStage.pulling;
        });
      } else if (_stage == TriggerStage.pulling) {
        setState(() => _extent += widget.reverse ? -out : out);
      }
    } else if (notification is OverscrollNotification) {
      final AxisDirection axis = notification.metrics.axisDirection;
      final double over =
          (axis == AxisDirection.down || axis == AxisDirection.right)
          ? -notification.overscroll
          : notification.overscroll;
      if (over > 0) {
        setState(() {
          if (_stage == TriggerStage.idle) {
            _extent = 0;
            _scrolling = true;
            _stage = TriggerStage.pulling;
          } else {
            _extent += over;
          }
        });
      }
    }
    return false;
  }

  Future<void> refresh([Future<void> Function()? callback]) async {
    _scrolling = false;
    final int count = ++_futureCount;
    if (_currentFuture != null) await _currentFuture;
    if (!mounted) return;
    setState(() {
      _stage = TriggerStage.refreshing;
      _currentFuture = (callback ?? widget.onRefresh)?.call() ?? Future.value();
    });
    return _currentFuture!.whenComplete(() {
      if (!mounted || count != _futureCount) return;
      setState(() {
        _currentFuture = null;
        _stage = TriggerStage.completed;
        Timer(_completeDuration, () {
          if (!mounted) return;
          setState(() {
            _stage = TriggerStage.idle;
            _extent = 0;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double arm = _minExtent <= 0 ? 1 : _minExtent;
    final bool vertical = widget.direction == Axis.vertical;
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScroll,
      child: AnimatedValueBuilder<double>(
        value:
            _stage == TriggerStage.refreshing ||
                _stage == TriggerStage.completed
            ? _minExtent
            : _extent,
        duration: _scrolling ? Duration.zero : kDefaultDuration,
        curve: _curve,
        builder: (context, value, _) {
          final RefreshTriggerStage stage = RefreshTriggerStage(
            _stage,
            AlwaysStoppedAnimation<double>(value / arm),
            widget.direction,
            widget.reverse,
          );
          final double slide = _clampExtent(value, arm);
          final Offset offscreen = vertical
              ? (widget.reverse ? const Offset(0, 1) : const Offset(0, -1))
              : (widget.reverse ? const Offset(1, 0) : const Offset(-1, 0));
          final Offset shift = vertical ? Offset(0, slide) : Offset(slide, 0);
          final Positioned indicator = vertical
              ? Positioned(
                  top: !widget.reverse ? 0 : null,
                  bottom: !widget.reverse ? null : 0,
                  left: 0,
                  right: 0,
                  child: _sliding(offscreen, shift, stage),
                )
              : Positioned(
                  top: 0,
                  bottom: 0,
                  left: widget.reverse ? null : 0,
                  right: widget.reverse ? 0 : null,
                  child: _sliding(offscreen, shift, stage),
                );
          return Stack(
            fit: StackFit.passthrough,
            children: <Widget>[
              widget.child,
              Positioned.fill(
                child: ClipRect(child: Stack(children: <Widget>[indicator])),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Indicator translated from off-screen by the pull [shift].
  Widget _sliding(Offset offscreen, Offset shift, RefreshTriggerStage stage) {
    return FractionalTranslation(
      translation: offscreen,
      child: Transform.translate(
        offset: shift,
        child: _indicatorBuilder(context, stage),
      ),
    );
  }
}

/// Default refresh pill on a card surface.
class DefaultRefreshIndicator extends StatelessWidget {
  const DefaultRefreshIndicator({super.key, required this.stage});

  final RefreshTriggerStage stage;

  @override
  Widget build(BuildContext context) {
    final ShadcnLocalizations strings = ShadcnLocalizations.of(context);
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final double pull = stage.extentValue.clamp(0, 1);
    final double angle = stage.direction == Axis.vertical
        ? -pi * pull
        : -pi / 2 - pi * pull;
    final Widget content = switch (stage.stage) {
      TriggerStage.refreshing => _row(
        Text(strings.refreshTriggerRefreshing),
        _SpinIcon(color: ambient.colors.foreground),
      ),
      TriggerStage.completed => _row(
        Text(strings.refreshTriggerComplete),
        CustomPaint(
          size: const Size(16, 12),
          painter: _CheckPainter(ambient.colors.foreground),
        ),
      ),
      TriggerStage.pulling || TriggerStage.idle => _row(
        Text(
          stage.extentValue < 1
              ? strings.refreshTriggerPull
              : strings.refreshTriggerRelease,
        ),
        Transform.rotate(
          angle: angle,
          child: const Icon(LucideIcons.arrowDown, size: 16),
        ),
      ),
    };
    return Center(
      child: Card(
        padding: EdgeInsets.symmetric(
          horizontal: ambient.density.baseContentPadding * 0.75,
          vertical: ambient.density.baseGap * 0.5,
        ),
        borderRadius: ambient.borderRadiusXl,
        child: AnimatedSwitcher(
          duration: kDefaultDuration,
          child: KeyedSubtree(
            key: ValueKey<TriggerStage>(stage.stage),
            child: Padding(
              padding: EdgeInsets.all(
                ambient.density.baseGap * ambient.scaling * 0.5,
              ),
              child: content,
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(Widget label, Widget icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(child: label),
        const Gap(8),
        icon,
      ],
    );
  }
}

class _SpinIcon extends StatefulWidget {
  const _SpinIcon({required this.color});

  final Color color;

  @override
  State<_SpinIcon> createState() => _SpinIconState();
}

class _SpinIconState extends State<_SpinIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Icon(LucideIcons.loaderCircle, size: 16, color: widget.color),
    );
  }
}

class _CheckPainter extends CustomPainter {
  const _CheckPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.15, size.height * 0.55)
        ..lineTo(size.width * 0.45, size.height * 0.85)
        ..lineTo(size.width * 0.9, size.height * 0.1),
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _CheckPainter old) => old.color != color;
}
