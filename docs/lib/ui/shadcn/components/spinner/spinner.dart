// The `spinner` component: an indeterminate circular indicator drawn with a
// rotating arc.
//
// Widgets-only `CustomPaint` + the `animation` primitive's repeating builder;
// the old Material `CircularProgressIndicator` import is gone. Absorbs the
// old `circular_progress_indicator`'s indeterminate mode (see P4-B03 report).

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../primitives/animation.dart';
import 'spinner_style.dart';

export 'spinner_style.dart';

/// One full rotation.
const Duration _spinnerDuration = Duration(milliseconds: 900);

/// Fraction of the circle covered by the arc.
const double _spinnerSweep = 0.75;

/// An indeterminate circular indicator.
///
/// ```dart
/// const Spinner();
/// const Spinner(size: 16, strokeWidth: 2);
/// ```
///
/// The arc rotates continuously; the widget has no determinate mode by
/// design. Use `Progress` for a value-bearing indicator.
class Spinner extends StatelessWidget {
  /// Creates a spinner.
  const Spinner({
    super.key,
    this.size,
    this.strokeWidth,
    this.color,
    this.semanticsLabel,
    this.theme,
  });

  /// Diameter override; null uses [SpinnerTheme.size] then `24 * scaling`.
  final double? size;

  /// Arc thickness override; null uses [SpinnerTheme.strokeWidth] then
  /// `size / 12`.
  final double? strokeWidth;

  /// Arc colour override.
  final Color? color;

  /// Semantic label, e.g. `'Loading'`.
  final String? semanticsLabel;

  /// Widget-leg theme override, merged on top of the other legs.
  final SpinnerTheme? theme;

  @override
  Widget build(BuildContext context) {
    final SpinnerSurface surface = resolveSpinnerSurface(
      context,
      widgetTheme: theme,
      size: size,
      strokeWidth: strokeWidth,
      color: color,
    );

    return Semantics(
      label: semanticsLabel,
      child: SizedBox(
        width: surface.size,
        height: surface.size,
        child: RepeatedAnimationBuilder(
          start: 0,
          end: 1,
          duration: _spinnerDuration,
          builder: (context, t, child) {
            return Transform.rotate(
              angle: t * 2 * math.pi,
              child: CustomPaint(
                size: Size.square(surface.size),
                painter: _SpinnerPainter(
                  color: surface.color,
                  strokeWidth: surface.strokeWidth,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Paints one round-capped arc.
class _SpinnerPainter extends CustomPainter {
  const _SpinnerPainter({required this.color, required this.strokeWidth});

  /// Arc colour.
  final Color color;

  /// Arc thickness.
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = color;
    canvas.drawArc(
      rect.deflate(strokeWidth / 2),
      -math.pi / 2,
      _spinnerSweep * 2 * math.pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _SpinnerPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }
}
