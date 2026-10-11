// The stat blocks of the Theme Studio canvas: the reference's
// `Contribution History` bars, the KPI stats with sparklines, the monthly
// averages and the goal-target rows.
//
// The bars and sparklines are docs-only painters (`studio_paint.dart`); the
// numbers, captions and progress rules are registry-free layout.

import 'package:flutter/widgets.dart';

import '../../ui/shadcn/components/badge/badge.dart';
import '../../ui/shadcn/components/button/button.dart';
import '../../ui/shadcn/components/progress/progress.dart';
import '../../ui/shadcn/components/input/input.dart';
import '../../ui/shadcn/components/select/select.dart';
import '../../ui/shadcn/foundation/gap.dart';
import '../../ui/shadcn/foundation/icons/lucide_icons.dart';
import '../../ui/shadcn/theme/theme.dart';
import 'studio_card.dart';
import 'studio_paint.dart';

/// `Contribution History`: the reference's bar chart plus a payout row.
class StudioContributionCard extends StatelessWidget {
  /// Creates the card.
  const StudioContributionCard({super.key});

  static const List<ContributionBar> bars = <ContributionBar>[
    ContributionBar(label: 'Dec', value: 0.45),
    ContributionBar(label: 'Jan', value: 0.72),
    ContributionBar(label: 'Feb', value: 0.55),
    ContributionBar(label: 'Mar', value: 0.88),
    ContributionBar(label: 'Apr', value: 1),
    ContributionBar(label: 'May', value: 0.62),
  ];

  @override
  Widget build(BuildContext context) {
    return StudioCard(
      title: 'Contribution History',
      subtitle: 'Last 6 months of activity',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const StudioContributionChart(bars: bars),
          const Gap(16),
          const _StudioUpcomingRow(),
        ],
      ),
    );
  }
}

class _StudioUpcomingRow extends StatelessWidget {
  const _StudioUpcomingRow();

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'UPCOMING',
                style: theme.typography.xSmall.copyWith(
                  letterSpacing: 0.6,
                  color: theme.colors.mutedForeground,
                ),
              ),
            ),
            const Badge(
              variant: BadgeVariant.secondary,
              child: Text('May 25, 2026'),
            ),
          ],
        ),
        const Gap(4),
        Text(
          r'$1,000 scheduled',
          style: theme.typography.small.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

/// `Revenue`: a KPI number over a sparkline, the reference's stat card.
class StudioSparklineStatCard extends StatelessWidget {
  /// Creates the card.
  const StudioSparklineStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.caption,
    required this.samples,
  });

  /// Card title.
  final String title;

  /// Formatted value line.
  final String value;

  /// Muted delta line.
  final String caption;

  /// Sparkline samples.
  final List<double> samples;

  @override
  Widget build(BuildContext context) {
    return StudioCard(
      title: title,
      subtitle: caption,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          StudioValue(value, size: 28),
          const Gap(12),
          StudioSparkline(values: samples),
        ],
      ),
    );
  }
}

/// `Monthly Averages`: three labelled stats in one card.
class StudioAveragesCard extends StatelessWidget {
  /// Creates the card.
  const StudioAveragesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const StudioCard(
      title: 'Projected Finish',
      subtitle: 'October 2026',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          StudioRow(label: 'Monthly Average', value: r'$1,250'),
          StudioRow(label: 'Top Contributor', value: 'Auto-Transfer'),
          StudioRow(label: 'Top market', value: r'US$ 24,000 / 80%'),
          Gap(8),
          StudioHelper('Based on the last six months of payouts.'),
        ],
      ),
    );
  }
}

/// `Set a new milestone`: a goal form, the reference's compact create card.
class StudioGoalCard extends StatelessWidget {
  /// Creates the card.
  const StudioGoalCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const StudioCard(
      title: 'Set a new milestone',
      subtitle: 'Define your financial target and we will help pace it.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          StudioFieldLabel('Goal Name'),
          Gap(6),
          Input(hintText: 'House deposit'),
          Gap(16),
          StudioFieldLabel('Target Amount'),
          Gap(6),
          Input(hintText: r'$50,000'),
          Gap(16),
          Row(
            children: <Widget>[
              Expanded(
                child: Button(
                  variant: ButtonVariant.outline,
                  onPressed: studioNoop,
                  child: Text('Cancel'),
                ),
              ),
              Gap(12),
              Expanded(
                child: Button(
                  variant: ButtonVariant.primary,
                  onPressed: studioNoop,
                  child: Text('Create Goal'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// `Usage`: a power-usage strip with a selected window.
class StudioUsageCard extends StatefulWidget {
  /// Creates the card.
  const StudioUsageCard({super.key});

  @override
  State<StudioUsageCard> createState() => _StudioUsageCardState();
}

class _StudioUsageCardState extends State<StudioUsageCard> {
  static const List<String> windows = <String>[
    '6a',
    '8a',
    '10a',
    '12p',
    '2p',
    '4p',
    '6p',
    '8p',
  ];
  static const List<double> samples = <double>[
    1.1,
    1.4,
    2.2,
    2.6,
    3.4,
    3.1,
    2.3,
    1.6,
  ];

  String _window = '12p';

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return StudioCard(
      title: 'Power Usage',
      subtitle: 'Whole home',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Select<String>(
            value: _window,
            onChanged: (String? next) =>
                setState(() => _window = next ?? _window),
            items: <Widget>[
              for (final String window in windows)
                SelectItem<String>(value: window, child: Text(window)),
            ],
            itemBuilder: (BuildContext context, String value) => Text(value),
          ),
          const Gap(16),
          const StudioSparkline(values: samples),
          const Gap(16),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    StudioCaption('Currently Using'),
                    const Gap(4),
                    const StudioValue('3.4 kW', size: 20),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    StudioCaption('Solar Gen'),
                    const Gap(4),
                    const StudioValue('+1.2 kW', size: 20),
                  ],
                ),
              ),
            ],
          ),
          const Gap(12),
          Progress(
            value: 0.85,
            height: 4,
            semanticsLabel: 'Battery level 85 percent',
          ),
          const Gap(8),
          Row(
            children: <Widget>[
              const Expanded(child: StudioHelper('Battery Level')),
              Icon(
                LucideIcons.batteryCharging,
                size: 14,
                color: theme.colors.mutedForeground,
              ),
              const Gap(6),
              const Text('85%'),
            ],
          ),
        ],
      ),
    );
  }
}

/// `Upcoming Payments`: the reference's calendar-adjacent invoice list.
class StudioUpcomingPaymentsCard extends StatelessWidget {
  /// Creates the card.
  const StudioUpcomingPaymentsCard({super.key});

  static const List<(String, String, String)> rows = <(String, String, String)>[
    ('Netflix Subscription', 'Apr 15, 2026', r'$19.99'),
    ('Rent Payment', 'Apr 1, 2026', r'$2,400.00'),
    ('Auto Insurance', 'Apr 22, 2026', r'$186.00'),
  ];

  @override
  Widget build(BuildContext context) {
    return StudioCard(
      title: 'Upcoming Payments',
      subtitle: 'Select a date to view scheduled payments.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (int i = 0; i < rows.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(rows[i].$1),
                        const Gap(2),
                        StudioHelper(rows[i].$2),
                      ],
                    ),
                  ),
                  const Gap(8),
                  const Badge(
                    variant: BadgeVariant.secondary,
                    child: Text('Scheduled'),
                  ),
                  const Gap(8),
                  Expanded(
                    child: Text(
                      rows[i].$3,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
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
