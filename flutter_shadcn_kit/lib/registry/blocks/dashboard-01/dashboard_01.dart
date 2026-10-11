// The `dashboard-01` block: an analytics dashboard.
//
// A block is layer 4 of the registry: it may import foundation, theme,
// primitives and components, never another block. Its public widget is the
// preview - the docs page renders it exactly as an app would.
//
// Stat tiles in a responsive grid (4 / 2 / 1 columns from the available
// width), a bar chart drawn from theme chart tokens and a recent-orders
// table with a working customer filter. The content shrink-wraps so the docs
// frame sizes to its intrinsic height, and scrolls internally when the host
// is bounded.

import 'package:flutter/widgets.dart';

import '../../components/avatar/avatar.dart';
import '../../components/button/button.dart';
import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import 'dashboard_01_table.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';

/// A dashboard: stat tiles, a twelve-week bar chart and a recent table.
class Dashboard01 extends StatelessWidget {
  /// Creates the block.
  const Dashboard01({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double contentWidth =
                constraints.maxWidth - theme.spacing.lg * 2;
            // Dashboards are full-width by design: no max-width cap here.
            final Widget body = Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const _Dashboard01Header(),
                Gap(theme.spacing.lg),
                _Dashboard01Stats(width: contentWidth),
                Gap(theme.spacing.lg),
                if (constraints.maxWidth >= 1080)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Expanded(flex: 3, child: _Dashboard01Chart()),
                      Gap(theme.spacing.lg),
                      const Expanded(flex: 2, child: _Dashboard01Activity()),
                    ],
                  )
                else ...<Widget>[
                  const _Dashboard01Chart(),
                  Gap(theme.spacing.lg),
                  const _Dashboard01Activity(),
                ],
                Gap(theme.spacing.lg),
                const Dashboard01Recent(),
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

class _Dashboard01Header extends StatelessWidget {
  const _Dashboard01Header();

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Overview', style: theme.typography.h2),
        Gap(theme.spacing.xs),
        Text(
          'Revenue, subscriptions and the most recent orders.',
          style: theme.typography.textMuted.copyWith(
            color: theme.colors.mutedForeground,
          ),
        ),
      ],
    );
  }
}

/// Stat tiles in a responsive grid: 4 columns from 1080px, 2 from 640px,
/// 1 below that. Every card gets an exact share of the available width, so
/// no tile is ever stretched or squeezed beyond its sensible width.
class _Dashboard01Stats extends StatelessWidget {
  const _Dashboard01Stats({required this.width});

  /// Width available to the grid, so each card gets an exact share.
  final double width;

  @override
  Widget build(BuildContext context) {
    final double spacing = ShadcnTheme.of(context).spacing.lg;
    const List<_Dashboard01Stat> stats = <_Dashboard01Stat>[
      _Dashboard01Stat('Total revenue', '\$45,231.89', '+20.1%'),
      _Dashboard01Stat('Subscriptions', '+2,350', '+180.1%'),
      _Dashboard01Stat('Sales', '+12,234', '+19.0%'),
      _Dashboard01Stat('Active now', '+573', '+2.0%'),
    ];
    final int columns = width >= 1080
        ? 4
        : width >= 640
        ? 2
        : 1;
    final double cardWidth = (width - spacing * (columns - 1)) / columns;
    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: <Widget>[
        for (final _Dashboard01Stat stat in stats)
          SizedBox(
            width: cardWidth,
            child: _Dashboard01StatCard(stat: stat),
          ),
      ],
    );
  }
}

class _Dashboard01Stat {
  const _Dashboard01Stat(this.label, this.value, this.delta);

  final String label;
  final String value;
  final String delta;
}

class _Dashboard01StatCard extends StatelessWidget {
  const _Dashboard01StatCard({required this.stat});

  final _Dashboard01Stat stat;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            stat.label,
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          Gap(theme.spacing.sm),
          Text(stat.value, style: theme.typography.h3),
          Gap(theme.spacing.sm),
          Text(
            '${stat.delta} from last month',
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

class _Dashboard01Chart extends StatelessWidget {
  const _Dashboard01Chart();

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    // One series, one token: every bar uses `chart1`, the way the
    // reference area chart fills a single series.
    const List<double> series = <double>[
      0.34,
      0.52,
      0.41,
      0.68,
      0.58,
      0.79,
      0.62,
      0.88,
      0.71,
      0.94,
      0.83,
      1.0,
    ];
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Revenue by month', style: theme.typography.textLarge),
          Gap(theme.spacing.xs),
          Text(
            'January - June 2026',
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          Gap(theme.spacing.lg),
          SizedBox(
            height: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                for (var i = 0; i < series.length; i++)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: theme.spacing.xs,
                      ),
                      child: Container(
                        height: 180 * series[i],
                        decoration: BoxDecoration(
                          color: theme.colors.chart1,
                          borderRadius: theme.borderRadiusSm,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Dashboard01Activity extends StatelessWidget {
  const _Dashboard01Activity();

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Recent sales', style: theme.typography.textLarge),
          Gap(theme.spacing.lg),
          const _Dashboard01Sale('Olivia Martin', '\$1,999.00'),
          Gap(theme.spacing.md),
          const _Dashboard01Sale('Jackson Lee', '\$39.00'),
          Gap(theme.spacing.md),
          const _Dashboard01Sale('Isabella Nguyen', '\$299.00'),
          Gap(theme.spacing.md),
          const _Dashboard01Sale('William Kim', '\$99.00'),
          Gap(theme.spacing.lg),
          const Divider(),
          Gap(theme.spacing.lg),
          Button(
            variant: ButtonVariant.outline,
            onPressed: () {},
            child: const Text('View all'),
          ),
        ],
      ),
    );
  }
}

class _Dashboard01Sale extends StatelessWidget {
  const _Dashboard01Sale(this.name, this.amount);

  final String name;
  final String amount;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Row(
      children: <Widget>[
        Avatar(initials: _Dashboard01Initials.of(name)),
        Gap(theme.spacing.md),
        Expanded(
          flex: 3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(name, style: theme.typography.textSmall),
              Gap(theme.spacing.xs),
              Text(
                '$amount - card',
                style: theme.typography.textSmall.copyWith(
                  color: theme.colors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Dashboard01Initials {
  const _Dashboard01Initials._();

  /// Two-letter initials for [name]; the second initial is dropped for a
  /// one-word name.
  static String of(String name) {
    final List<String> parts = name.split(' ');
    if (parts.length < 2) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
