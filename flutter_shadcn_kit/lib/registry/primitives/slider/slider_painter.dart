// Paints a slider control: track, fill, marks and thumbs, from plain
// geometry and colours. Generic: shared by the `slider` component and by
// the B04 colour sliders (alpha, hsl, hsv). No component theme types.

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'slider_logic.dart';

/// Thumb forms painted by [SliderPainter].
enum SliderThumbShape {
  /// Rounded vertical bar.
  bar,

  /// Filled circle with a coloured border.
  circle,
}

/// Which marks [SliderPainter] paints over the track.
enum SliderMarksStyle {
  /// No marks.
  none,

  /// Per-step dots (old `stepsDots` preset).
  dots,

  /// Audio-wave bars (old `waveform` preset).
  wave,
}

/// Paints track, fill, variant marks and thumbs. Replaces the old Material
/// `Slider` render path; the whole control is `CustomPaint`, no Material.
class SliderPainter extends CustomPainter {
  const SliderPainter({
    required this.view,
    required this.marksStyle,
    required this.thumbShape,
    required this.trackColor,
    required this.fillColor,
    required this.thumbColor,
    required this.thumbBorderColor,
    required this.markColor,
    required this.focused,
    required this.ringColor,
  });

  final SliderView view;
  final SliderMarksStyle marksStyle;
  final SliderThumbShape thumbShape;
  final Color trackColor;
  final Color fillColor;
  final Color thumbColor;
  final Color thumbBorderColor;
  final Color markColor;
  final bool focused;
  final Color ringColor;

  double _xForT(double t) {
    final inset = view.thumbInset;
    final usable = math.max(0.0, view.trackRect.width - inset * 2);
    final minX = view.trackRect.left + inset;
    final maxX = view.trackRect.right - inset;
    return view.textDirection == TextDirection.rtl
        ? maxX - usable * t
        : minX + usable * t;
  }

  bool _isFilled(SliderMark mark) {
    if (view.isRange) {
      final t0 = view.thumbs[0].t;
      final t1 = view.thumbs[1].t;
      return mark.t >= math.min(t0, t1) && mark.t <= math.max(t0, t1);
    }
    final t = view.thumbs.first.t;
    return view.textDirection == TextDirection.rtl ? mark.t >= t : mark.t <= t;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final radius = Radius.circular(view.trackRadius);
    // Track.
    canvas.drawRRect(
      RRect.fromRectAndRadius(view.trackRect, radius),
      Paint()..color = trackColor,
    );
    // Fill.
    final fill = view.isRange ? view.activeRect : view.fillRect;
    if (fill != null && fill.width > 0) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(fill, radius),
        Paint()..color = fillColor,
      );
    }
    // Variant marks.
    if (marksStyle != SliderMarksStyle.none) {
      for (var i = 0; i < view.marks.length; i++) {
        final mark = view.marks[i];
        final x = _xForT(mark.t);
        final filled = _isFilled(mark);
        final color = filled ? fillColor : markColor;
        if (marksStyle == SliderMarksStyle.dots) {
          canvas.drawCircle(
            Offset(x, view.trackRect.center.dy),
            math.max(1.5, view.trackRect.height / 4),
            Paint()..color = color,
          );
        } else {
          final height =
              view.trackRect.height * 2 + 4 * (0.5 + 0.5 * math.sin(i * 2.7));
          final rect = Rect.fromCenter(
            center: Offset(x, view.trackRect.center.dy),
            width: 2,
            height: height.clamp(4.0, 24.0),
          );
          canvas.drawRRect(
            RRect.fromRectAndRadius(rect, const Radius.circular(1)),
            Paint()..color = color.withValues(alpha: 0.8),
          );
        }
      }
    }
    // Thumbs.
    for (final thumb in view.thumbs) {
      switch (thumbShape) {
        case SliderThumbShape.bar:
          final w = math.min(thumb.size.width * 0.6, 12.0);
          final rect = Rect.fromCenter(
            center: thumb.center,
            width: w,
            height: thumb.size.height,
          );
          canvas.drawRRect(
            RRect.fromRectAndRadius(rect, Radius.circular(w / 2)),
            Paint()..color = thumbColor,
          );
        case SliderThumbShape.circle:
          final r = thumb.size.width / 2;
          canvas.drawCircle(thumb.center, r, Paint()..color = thumbColor);
          canvas.drawCircle(
            thumb.center,
            r,
            Paint()
              ..color = thumbBorderColor
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2,
          );
      }
      // Focus ring on the active thumb, like Clickable's FocusRing.
      if (focused && thumb.index == (view.activeThumb ?? 0)) {
        canvas.drawCircle(
          thumb.center,
          thumb.size.width / 2 + 3,
          Paint()
            ..color = ringColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant SliderPainter oldDelegate) {
    return oldDelegate.view != view ||
        oldDelegate.marksStyle != marksStyle ||
        oldDelegate.thumbShape != thumbShape ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.thumbColor != thumbColor ||
        oldDelegate.thumbBorderColor != thumbBorderColor ||
        oldDelegate.markColor != markColor ||
        oldDelegate.focused != focused ||
        oldDelegate.ringColor != ringColor;
  }
}
