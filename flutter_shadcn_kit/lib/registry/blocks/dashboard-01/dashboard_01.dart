// The `dashboard-01` block: an analytics dashboard.
//
// Stat tiles, a bar chart drawn from theme chart tokens and a recent-orders
// table. Everything is laid out from `LayoutBuilder` breakpoints so the same
// widget works at 375px (one column) and 1440px (stat row + chart + table).

import 'package:flutter/widgets.dart';

import '../../components/avatar/avatar.dart';
import '../../components/button/button.dart';
import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import 'dashboard_01_table.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';

/// A dashboard: four stat tiles, a twelve-week bar chart and a recent table.
class Dashboard01 extends StatelessWidget {
  /// Creates the block.
  const Dashboard01({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool wide = constraints.maxWidth >= 1080;
            return SingleChildScrollView(
              padding: EdgeInsets.all(spacing.lg),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1440),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const _Dashboard01Header(),
                    Gap(spacing.lg),
                    _Dashboard01Stats(wide: wide),
                    Gap(spacing.lg),
                    if (wide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Expanded(flex: 3, child: _Dashboard01Chart()),
                          Gap(spacing.lg),
                          const Expanded(
                            flex: 2,
                            child: _Dashboard01Activity(),
                          ),
                        ],
                      )
                    else ...<Widget>[
                      const _Dashboard01Chart(),
                      Gap(spacing.lg),
                      const _Dashboard01Activity(),
                    ],
                    Gap(spacing.lg),
                    const Dashboard01Recent(),
                  ],
                ),
              ),
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
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Overview', style: theme.typography.h2),
        Gap(spacing.xs),
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

class _Dashboard01Stats extends StatelessWidget {
  const _Dashboard01Stats({required this.wide});

  final bool wide;

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    const List<_Dashboard01Stat> stats = <_Dashboard01Stat>[
      _Dashboard01Stat('Total revenue', '\$45,231.89', '+20.1%'),
      _Dashboard01Stat('Subscriptions', '+2,350', '+180.1%'),
      _Dashboard01Stat('Sales', '+12,234', '+19.0%'),
      _Dashboard01Stat('Active now', '+573', '+2.0%'),
    ];
    if (wide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          for (final stat in stats) ...<Widget>[
            Expanded(child: _Dashboard01StatCard(stat: stat)),
            if (stat != stats.last) Gap(spacing.lg),
          ],
        ],
      );
    }
    return Wrap(
      spacing: spacing.lg,
      runSpacing: spacing.lg,
      children: <Widget>[
        for (final stat in stats)
          SizedBox(width: 260, child: _Dashboard01StatCard(stat: stat)),
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
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
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
          Gap(spacing.sm),
          Text(stat.value, style: theme.typography.h3),
          Gap(spacing.sm),
          Text(
            stat.delta,
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.primary,
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
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    // Fixed relative heights: the block ships no data, so the chart is an
    // illustration rather than a live plot.
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
          Gap(spacing.xs),
          Text(
            'January - June 2026',
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          Gap(spacing.lg),
          SizedBox(
            height: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                for (var i = 0; i < series.length; i++)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: spacing.xs),
                      child: Container(
                        height: 180 * series[i],
                        decoration: BoxDecoration(
                          color: theme.colors.chartColors[i % 5],
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
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Recent sales', style: theme.typography.textLarge),
          Gap(spacing.lg),
          const _Dashboard01Sale('Olivia Martin', '\$1,999.00'),
          Gap(spacing.md),
          const _Dashboard01Sale('Jackson Lee', '\$39.00'),
          Gap(spacing.md),
          const _Dashboard01Sale('Isabella Nguyen', '\$299.00'),
          Gap(spacing.md),
          const _Dashboard01Sale('William Kim', '\$99.00'),
          Gap(spacing.lg),
          const Divider(),
          Gap(spacing.lg),
          const Button(variant: ButtonVariant.outline, child: Text('View all')),
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
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Row(
      children: <Widget>[
        Flexible(child: Avatar(initials: _Dashboard01Initials.of(name))),
        Gap(spacing.md),
        Expanded(
          flex: 3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(name, style: theme.typography.textSmall),
              Gap(spacing.xs),
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
    final parts = name.split(' ');
    if (parts.length < 2) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
