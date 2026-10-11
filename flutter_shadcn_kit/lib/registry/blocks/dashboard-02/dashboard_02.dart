// The `dashboard-02` block: an analytics workspace.
//
// A wider companion to `dashboard-01`: a filter row, a chart card with a
// legend, a device split and a traffic-source list. Breakpoints come from
// `LayoutBuilder`, so the grid collapses from four columns to one.

import 'package:flutter/widgets.dart';

import '../../components/button/button.dart';
import '../../components/card/card.dart';
import '../../components/input/input.dart';
import 'dashboard_02_sections.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';

/// An analytics workspace: chart, device split and traffic sources.
class Dashboard02 extends StatelessWidget {
  /// Creates the block.
  const Dashboard02({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final int columns = constraints.maxWidth >= 1080
                ? 4
                : constraints.maxWidth >= 640
                ? 2
                : 1;
            // Dashboards are full-width by design: no max-width cap here.
            final Widget body = Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const _Dashboard02Filters(),
                Gap(theme.spacing.lg),
                _Dashboard02Tiles(
                  columns: columns,
                  width: constraints.maxWidth - theme.spacing.lg * 2,
                ),
                Gap(theme.spacing.lg),
                const Dashboard02Chart(),
                Gap(theme.spacing.lg),
                if (constraints.maxWidth >= 1080)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Expanded(child: Dashboard02Sources()),
                      Gap(theme.spacing.lg),
                      const Expanded(flex: 2, child: Dashboard02Devices()),
                    ],
                  )
                else ...<Widget>[
                  const Dashboard02Sources(),
                  Gap(theme.spacing.lg),
                  const Dashboard02Devices(),
                ],
              ],
            );
            if (!constraints.maxHeight.isFinite) {
              return Padding(
                padding: EdgeInsets.all(theme.spacing.lg),
                child: body,
              );
            }
            return SingleChildScrollView(
              padding: EdgeInsets.all(theme.spacing.lg),
              child: body,
            );
          },
        ),
      ),
    );
  }
}

class _Dashboard02Filters extends StatelessWidget {
  const _Dashboard02Filters();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Analytics', style: theme.typography.h2),
        Gap(spacing.xs),
        Text(
          'Sessions, devices and where the traffic came from.',
          style: theme.typography.textMuted.copyWith(
            color: theme.colors.mutedForeground,
          ),
        ),
        Gap(spacing.lg),
        Wrap(
          spacing: spacing.md,
          runSpacing: spacing.md,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            const SizedBox(
              width: 240,
              child: Input(hintText: 'Search reports'),
            ),
            Button(
              variant: ButtonVariant.outline,
              onPressed: () {},
              child: const Text('Last 30 days'),
            ),
            Button(
              variant: ButtonVariant.outline,
              onPressed: () {},
              child: const Text('All devices'),
            ),
            Button(onPressed: () {}, child: const Text('Download')),
          ],
        ),
      ],
    );
  }
}

class _Dashboard02Tiles extends StatelessWidget {
  const _Dashboard02Tiles({required this.columns, required this.width});

  final int columns;

  /// Width available to the grid, so each card gets an exact share.
  final double width;

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    const List<_Dashboard02Tile> tiles = <_Dashboard02Tile>[
      _Dashboard02Tile('Sessions', '12,480', 0.42),
      _Dashboard02Tile('Users', '8,910', 0.63),
      _Dashboard02Tile('Bounce rate', '38%', 0.38),
      _Dashboard02Tile('Avg. session', '2m 41s', 0.27),
    ];
    final double cardWidth = (width - spacing.lg * (columns - 1)) / columns;
    return Wrap(
      spacing: spacing.lg,
      runSpacing: spacing.lg,
      children: <Widget>[
        for (final tile in tiles)
          SizedBox(
            width: cardWidth,
            child: _Dashboard02TileCard(tile: tile),
          ),
      ],
    );
  }
}

class _Dashboard02Tile {
  const _Dashboard02Tile(this.label, this.value, this.fill);

  final String label;
  final String value;

  /// Ratio 0..1 drawn as a sparkline fill.
  final double fill;
}

class _Dashboard02TileCard extends StatelessWidget {
  const _Dashboard02TileCard({required this.tile});

  final _Dashboard02Tile tile;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            tile.label,
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          Gap(spacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(child: Text(tile.value, style: theme.typography.h3)),
              SizedBox(
                width: 64,
                height: 28,
                child: CustomPaint(
                  painter: _Dashboard02SparkPainter(
                    fill: tile.fill,
                    color: theme.colors.chart1,
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

/// A one-stroke sparkline; the block ships no data, so the shape is derived
/// from a single `fill` ratio instead of a series.
class _Dashboard02SparkPainter extends CustomPainter {
  const _Dashboard02SparkPainter({required this.fill, required this.color});

  final double fill;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final Path path = Path();
    for (var i = 0; i <= 6; i++) {
      final double t = i / 6;
      final double y =
          size.height - (size.height * fill * (0.35 + 0.65 * _wobble(t)));
      if (i == 0) {
        path.moveTo(size.width * t, y);
      } else {
        path.lineTo(size.width * t, y);
      }
    }
    canvas.drawPath(path, stroke);
  }

  double _wobble(double t) => 0.5 + 0.5 * _sin(t * 3.1);

  double _sin(double x) => x - x * x * x / 6;

  @override
  bool shouldRepaint(_Dashboard02SparkPainter oldDelegate) =>
      oldDelegate.fill != fill || oldDelegate.color != color;
}
