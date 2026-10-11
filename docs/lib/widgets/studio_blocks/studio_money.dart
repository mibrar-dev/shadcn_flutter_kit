// The money blocks of the Theme Studio canvas: the reference `/create`
// cards that exercise `progress`, `badge`, `avatar`, `switch` and the big
// number / caption type pair.
//
// Every colour and metric comes from the live theme; nothing is hard-coded
// except the sample data.

import 'package:flutter/widgets.dart';

import '../../ui/shadcn/components/badge/badge.dart';
import '../../ui/shadcn/components/button/button.dart';
import '../../ui/shadcn/components/progress/progress.dart';
import '../../ui/shadcn/components/switch/switch.dart';
import '../../ui/shadcn/foundation/gap.dart';
import '../../ui/shadcn/foundation/icons/lucide_icons.dart';
import '../../ui/shadcn/theme/theme.dart';
import 'studio_card.dart';
import 'studio_paint.dart';

/// A one-line dashboard KPI (the reference's `$48,320` blocks).
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
          StudioCaption(label),
          const Gap(8),
          StudioValue(value, size: 24),
          if (delta != null) ...<Widget>[
            const Gap(6),
            Text(
              delta!,
              style: theme.typography.small.copyWith(
                color: theme.colors.mutedForeground,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// `Savings Targets`: two progress stats in one card.
class StudioSavingsCard extends StatelessWidget {
  /// Creates the card.
  const StudioSavingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const StudioCard(
      title: 'Savings Targets',
      subtitle: 'Active milestones for 2024',
      trailing: Button(
        variant: ButtonVariant.outline,
        size: ButtonSize.sm,
        onPressed: studioNoop,
        child: Text('New Goal'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          StudioStat(
            label: 'Retirement',
            value: r'$420,000',
            progress: 0.65,
            caption: r'65% achieved · $273,000',
          ),
          Gap(20),
          StudioStat(
            label: 'Real estate',
            value: r'$85,000',
            progress: 0.32,
            caption: r'32% achieved · $27,200',
          ),
          Gap(12),
          StudioHelper('You have not met your targets for this year.'),
        ],
      ),
    );
  }
}

/// `Claimable Balance`: a number, a status badge and a small table of rows.
class StudioClaimableBalanceCard extends StatelessWidget {
  /// Creates the card.
  const StudioClaimableBalanceCard({super.key});

  static const List<(String, String)> rows = <(String, String)>[
    ('Net Royalties', r'$0.00'),
    ('Processing Fee', r'-$0.00'),
    ('Total Ready to Claim', r'$0.00 USD'),
  ];

  @override
  Widget build(BuildContext context) {
    return const StudioCard(
      title: 'Claimable Balance',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          StudioValue(r'$0.00', size: 34),
          Gap(10),
          Badge(variant: BadgeVariant.secondary, child: Text('Pending Setup')),
          Gap(16),
          StudioRow(label: 'Net Royalties', value: r'$0.00'),
          StudioRow(label: 'Processing Fee', value: r'-$0.00'),
          StudioRow(label: 'Total Ready to Claim', value: r'$0.00 USD'),
          Gap(4),
          StudioHelper(
            r'Once your bank is connected, balances over $10.00 are '
            r'automatically eligible for monthly distribution on the 15th.',
          ),
        ],
      ),
    );
  }
}

/// `Card Balance`: a sparkline card with a due date and an action.
class StudioCardBalanceCard extends StatelessWidget {
  /// Creates the card.
  const StudioCardBalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return StudioCard(
      title: 'Card Balance',
      trailing: const Icon(LucideIcons.creditCard, size: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          StudioValue(r'US$12.94', size: 30),
          Text(
            r'US$11,337.06 Available',
            style: theme.typography.small.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          const Gap(12),
          Row(
            children: <Widget>[
              Expanded(child: StudioHelper('Payment due')),
              const Badge(variant: BadgeVariant.outline, child: Text('1 Apr')),
            ],
          ),
          const Gap(12),
          const StudioSparkline(
            values: <double>[18, 24, 21, 30, 28, 36, 33, 42, 39, 52],
          ),
          const Gap(12),
          const Button(
            variant: ButtonVariant.outline,
            size: ButtonSize.sm,
            onPressed: studioNoop,
            child: Text('Pay Early'),
          ),
        ],
      ),
    );
  }
}

/// `Q2 Dividend Income`: a progress list of holdings.
class StudioDividendCard extends StatelessWidget {
  /// Creates the card.
  const StudioDividendCard({super.key});

  static const List<(String, String, double)> holdings =
      <(String, String, double)>[
        ('Vanguard VIG', '450 shares', 0.44),
        ('S&P 500 VOO', '112 shares', 0.22),
        ('Apple AAPL', '85 shares', 0.2),
        ('Realty Income', '320 shares', 0.14),
      ];

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return StudioCard(
      title: 'Q2 Dividend Income',
      subtitle: 'Quarterly payouts across your portfolio holdings.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (final (String name, String shares, double share) in holdings)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(child: Text(name)),
                      Text(
                        shares,
                        style: theme.typography.small.copyWith(
                          color: theme.colors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                  const Gap(6),
                  Progress(value: share, height: 4, semanticsLabel: name),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// `Yearly Activity`: a month strip with a switch row, exercising `switch`.
class StudioActivityCard extends StatefulWidget {
  /// Creates the card.
  const StudioActivityCard({super.key});

  @override
  State<StudioActivityCard> createState() => _StudioActivityCardState();
}

class _StudioActivityCardState extends State<StudioActivityCard> {
  bool _autoSave = true;

  static const List<String> months = <String>[
    'J',
    'F',
    'M',
    'A',
    'M',
    'J',
    'J',
    'A',
    'S',
    'O',
    'N',
    'D',
  ];

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return StudioCard(
      title: 'Yearly Activity',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              for (int i = 0; i < months.length; i++) ...<Widget>[
                if (i > 0) const Spacer(),
                Text(
                  months[i],
                  style: theme.typography.xSmall.copyWith(
                    color: theme.colors.mutedForeground,
                  ),
                ),
              ],
            ],
          ),
          const Gap(12),
          const StudioSparkline(
            values: <double>[2, 6, 4, 9, 7, 12, 10, 14, 11, 16, 13, 18],
          ),
          const Gap(12),
          Row(
            children: <Widget>[
              const Expanded(child: Text(r'+US$0.25 Daily Cash')),
              Switch(value: _autoSave, onChanged: _setAutoSave),
            ],
          ),
        ],
      ),
    );
  }

  void _setAutoSave(bool value) => setState(() => _autoSave = value);
}
