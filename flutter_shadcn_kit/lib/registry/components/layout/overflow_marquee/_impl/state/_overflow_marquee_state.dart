// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../overflow_marquee.dart';

/// _OverflowMarqueeState defines a reusable type for this registry module.
class _OverflowMarqueeState extends State<OverflowMarquee>
    with SingleTickerProviderStateMixin {
  /// Stores `_ticker` state/configuration for this implementation.
  late Ticker _ticker;

  /// Stores `elapsed` state/configuration for this implementation.
  Duration elapsed = Duration.zero;

  @override
  /// Executes `initState` behavior for this component/composite.
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      if (mounted) {
        /// Creates a `setState` instance.
        setState(() {
          this.elapsed = elapsed;
        });
      }
    });
    _ticker.start();
  }

  @override
  /// Executes `dispose` behavior for this component/composite.
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context);
    final compTheme = ComponentTheme.maybeOf<OverflowMarqueeTheme>(context);
    final direction = styleValue(
      widgetValue: widget.direction,
      themeValue: compTheme?.direction,
      defaultValue: Axis.horizontal,
    );
    final fadePortion = styleValue(
      widgetValue: widget.fadePortion,
      themeValue: compTheme?.fadePortion,
      defaultValue: 25.0,
    );
    final duration = styleValue(
      widgetValue: widget.duration,
      themeValue: compTheme?.duration,
      defaultValue: const Duration(seconds: 1),
    );
    final delayDuration = styleValue(
      widgetValue: widget.delayDuration,
      themeValue: compTheme?.delayDuration,
      defaultValue: const Duration(milliseconds: 500),
    );
    final step = styleValue(
      widgetValue: widget.step,
      themeValue: compTheme?.step,
      defaultValue: 100.0,
    );

    /// Stores `curve` state/configuration for this implementation.
    final curve = widget.curve ?? compTheme?.curve ?? Curves.linear;
    return ClipRect(
      child: _OverflowMarqueeLayout(
        direction: direction,
        fadePortion: fadePortion,
        duration: duration,
        delayDuration: delayDuration,
        ticker: _ticker,
        elapsed: elapsed,
        step: step,
        textDirection: textDirection,
        curve: curve,
        child: widget.child,
      ),
    );
  }
}
