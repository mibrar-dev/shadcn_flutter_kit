// The stat/progress blocks of the Theme Studio canvas: the reference's
// `Savings Targets` and `Claimable Balance` cards.
//
// `Progress` (registry) paints the bar, so the accent, radius, spacing and
// shadow tokens are all exercised by a real component.

import 'package:flutter/widgets.dart';

import '../../ui/shadcn/components/badge/badge.dart';
import '../../ui/shadcn/foundation/gap.dart';
import '../../ui/shadcn/theme/theme.dart';
import 'studio_card.dart';

/// `Savings Targets`: two progress stats in one card.
class StudioSavingsCard extends StatelessWidget {
  /// Creates the card.
  const StudioSavingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return StudioCard(
      title: 'Savings Targets',
      subtitle: 'Active milestones for 2024',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const StudioStat(
            label: 'Retirement',
            value: r'$420,000',
            progress: 0.65,
            caption: '65% achieved',
          ),
          const Gap(20),
          const StudioStat(
            label: 'Real estate',
            value: r'$85,000',
            progress: 0.32,
            caption: '32% achieved',
          ),
        ],
      ),
    );
  }
}

/// `Claimable Balance`: a number, a status badge and a small table of rows.
class StudioBalanceCard extends StatelessWidget {
  /// Creates the card.
  const StudioBalanceCard({super.key});

  static const List<(String, String)> rows = <(String, String)>[
    ('Net Royalties', r'$0.00'),
    ('Processing Fee', r'-$0.00'),
    ('Total Ready to Claim', r'$0.00 USD'),
  ];

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return StudioCard(
      title: 'Claimable Balance',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            r'$0.00',
            style: theme.typography.h2.copyWith(
              fontSize: 34,
              fontWeight: FontWeight.w700,
              letterSpacing: -1,
            ),
          ),
          const Gap(10),
          const Badge(
            variant: BadgeVariant.secondary,
            child: Text('Pending Setup'),
          ),
          const Gap(16),
          for (final (String label, String value) in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      label,
                      style: theme.typography.small.copyWith(
                        color: theme.colors.mutedForeground,
                      ),
                    ),
                  ),
                  Text(value, style: theme.typography.small),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// A one-line dashboard stat card (the reference's KPI row).
class StudioKpiCard extends StatelessWidget {
  /// Creates the KPI card.
  const StudioKpiCard({
    super.key,
    required this.label,
    required this.value,
    this.delta,
  });

  /// The caption.
  final String label;

  /// The formatted number.
  final String value;

  /// Optional delta line (`+12.4% vs last month`).
  final String? delta;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return StudioCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            label.toUpperCase(),
            style: theme.typography.small.copyWith(
              fontSize: 10.5,
              letterSpacing: 0.6,
              color: theme.colors.mutedForeground,
            ),
          ),
          const Gap(8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: theme.typography.h3.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (delta != null) ...<Widget>[
            const Gap(6),
            Text(
              delta!,
              style: theme.typography.small.copyWith(
                fontSize: 12,
                color: theme.colors.mutedForeground,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
