// Docs-only painters for the Theme Studio canvas (spec §2.7).
//
// The registry has no `chart` component (see P6_SHADCN_SITE_SPEC §2.10), so the
// three charts the reference `/create` preview shows — a contribution bar
// chart, a sparkline and a QR tile — are painted here with `CustomPainter` on
// theme tokens only. Every colour, radius and stroke width is read from the
// live `ShadcnThemeData`, so they re-paint with the rail edits exactly like a
// registry component would.
//
// These are docs-app painters, not registry primitives: they are neither
// installable nor reusable, and they must never be copied into `primitives/`.

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../ui/shadcn/theme/theme.dart';

/// One bar of the contribution chart.
class ContributionBar {
  /// Creates a bar.
  const ContributionBar({required this.label, required this.value});

  /// The month caption under the bar (`Dec`).
  final String label;

  /// Height of the bar in 0..1 of the tallest value.
  final double value;
}

/// The `Contribution History` bar chart: six themed columns with captions.
class StudioContributionChart extends StatelessWidget {
  /// Creates the chart from [bars].
  const StudioContributionChart({super.key, required this.bars});

  /// The bars, left to right.
  final List<ContributionBar> bars;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 96,
            width: double.infinity,
            child: CustomPaint(
              painter: _ContributionPainter(
                color: theme.colors.primary,
                track: theme.colors.muted,
                values: <double>[for (final ContributionBar b in bars) b.value],
                radius: math.max(0, theme.radiusXs),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              for (final ContributionBar bar in bars)
                Expanded(
                  child: Text(
                    bar.label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.typography.xSmall.copyWith(
                      color: theme.colors.mutedForeground,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContributionPainter extends CustomPainter {
  const _ContributionPainter({
    required this.values,
    required this.color,
    required this.track,
    required this.radius,
  });

  final List<double> values;
  final Color color;
  final Color track;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) {
      return;
    }
    final double gap = 8;
    final double slot = size.width / values.length;
    final double barWidth = math.max(4, slot - gap);
    final Paint fill = Paint()..color = color;
    final Paint faint = Paint()..color = track;
    final Paint barPaint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < values.length; i++) {
      final double fraction = values[i].clamp(0.0, 1.0);
      final double height = fraction * size.height;
      final double left = i * slot + (slot - barWidth) / 2;
      final RRect trackRect = RRect.fromRectAndCorners(
        Rect.fromLTWH(left, 0, barWidth, size.height),
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
      );
      canvas.drawRRect(trackRect, faint);
      if (height <= 0) {
        continue;
      }
      final RRect barRect = RRect.fromRectAndCorners(
        Rect.fromLTWH(left, size.height - height, barWidth, height),
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
      );
      barPaint.color = Color.lerp(color, track, 1 - fraction)!;
      canvas.drawRRect(barRect, fraction > 0.9 ? fill : barPaint);
    }
  }

  @override
  bool shouldRepaint(_ContributionPainter old) =>
      old.color != color || old.track != track || old.radius != radius;
}

/// The `Yearly Activity` sparkline: a filled area plus its top stroke.
class StudioSparkline extends StatelessWidget {
  /// Creates the sparkline from [values] (any positive scale).
  const StudioSparkline({super.key, required this.values});

  /// The samples, left to right.
  final List<double> values;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: CustomPaint(
        painter: _SparklinePainter(values: values, color: theme.colors.primary),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  const _SparklinePainter({required this.values, required this.color});

  final List<double> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) {
      return;
    }
    final double maxValue = values.reduce(math.max);
    final double minValue = values.reduce(math.min);
    final double span = (maxValue - minValue).abs() < 0.0001
        ? 1
        : maxValue - minValue;
    final double stepX = size.width / (values.length - 1);
    final Path line = Path()..moveTo(0, size.height);
    for (int i = 0; i < values.length; i++) {
      final double x = i * stepX;
      final double y =
          size.height - ((values[i] - minValue) / span) * (size.height - 6) - 3;
      line.lineTo(x, y);
    }
    final Path stroke = Path()..moveTo(0, line.getBounds().top);
    for (int i = 0; i < values.length; i++) {
      stroke.lineTo(
        i * stepX,
        size.height - ((values[i] - minValue) / span) * (size.height - 6) - 3,
      );
    }

    line.lineTo(size.width, size.height);
    line.close();
    canvas.drawPath(
      line,
      Paint()
        ..color = color.withValues(alpha: 0.16)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      stroke,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_SparklinePainter old) =>
      old.color != color ||
      old.values.length != values.length ||
      !_sameValues(old.values, values);

  bool _sameValues(List<double> a, List<double> b) {
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }
    return true;
  }
}

/// A deterministic pseudo-QR tile (the reference's "Scan to connect" card).
///
/// Not a real QR code — a stable pseudo-random module grid painted from the
/// theme tokens, which is what the reference shows as decoration.
class StudioQrTile extends StatelessWidget {
  /// Creates the tile.
  const StudioQrTile({super.key, this.size = 108, this.seed = 7});

  /// Edge length in logical pixels.
  final double size;

  /// Seed of the pseudo-random module grid.
  final int seed;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: theme.colors.background,
        borderRadius: math.max(0, theme.radiusSm) > 0
            ? BorderRadius.circular(math.max(0, theme.radiusSm))
            : null,
        border: Border.all(color: theme.colors.border),
      ),
      child: CustomPaint(
        painter: _QrPainter(color: theme.colors.foreground, seed: seed),
      ),
    );
  }
}

class _QrPainter extends CustomPainter {
  const _QrPainter({required this.color, required this.seed});

  final Color color;
  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    const int modules = 21;
    final double cell = size.width / modules;
    final Paint paint = Paint()..color = color;
    for (int y = 0; y < modules; y++) {
      for (int x = 0; x < modules; x++) {
        if (_isFinder(x: x, y: y, modules: modules)) {
          canvas.drawRect(Rect.fromLTWH(x * cell, y * cell, cell, cell), paint);
          continue;
        }
        final int hash = (x * 73856093) ^ (y * 19349663) ^ (seed * 83492791);
        final bool on = (hash % 11) < 4;
        if (on) {
          canvas.drawRect(Rect.fromLTWH(x * cell, y * cell, cell, cell), paint);
        }
      }
    }
  }

  bool _isFinder({required int x, required int y, required int modules}) {
    const int size = 7;
    bool inBlock(int x0, int y0) =>
        x >= x0 && x < x0 + size && y >= y0 && y < y0 + size;
    return inBlock(0, 0) ||
        inBlock(modules - size, 0) ||
        inBlock(0, modules - size);
  }

  @override
  bool shouldRepaint(_QrPainter old) => old.color != color || old.seed != seed;
}
