// Home showcase: money cards (P6-H1).
//
// The compositions extend the Theme Studio money blocks
// (`studio_blocks/studio_money.dart`): same registry components, same sample
// data shapes, same interior helpers — re-shelled in [CollageCard] so the
// home wall keeps its spec §2.1 shell (24 px radius) on every card.

import 'package:flutter/widgets.dart';

import '../ui/shadcn/components/badge/badge.dart';
import '../ui/shadcn/components/button/button.dart';
import '../ui/shadcn/components/progress/progress.dart';
import '../ui/shadcn/components/switch/switch.dart';
import '../ui/shadcn/foundation/gap.dart';
import '../ui/shadcn/foundation/icons/lucide_icons.dart';
import '../ui/shadcn/theme/theme.dart';
import 'collage_cards.dart';
import 'studio_blocks/studio_card.dart';
import 'studio_blocks/studio_paint.dart';

/// `Analytics`: the reference home's visitors KPI with its CTA.
class HomeAnalyticsCard extends StatelessWidget {
  /// Creates the card.
  const HomeAnalyticsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const CollageCard(
      title: 'Analytics',
      subtitle: 'Visitors this quarter',
      children: <Widget>[
        StudioValue('418.2K', size: 30),
        Gap(6),
        StudioHelper('+10.2% vs last quarter'),
        Gap(12),
        Button(
          size: ButtonSize.sm,
          onPressed: null,
          child: Text('View Analytics'),
        ),
      ],
    );
  }
}

/// `Savings Targets`: two progress stats in one card.
class HomeSavingsCard extends StatelessWidget {
  /// Creates the card.
  const HomeSavingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const CollageCard(
      title: 'Savings Targets',
      subtitle: 'Active milestones for 2024',
      trailing: Button(
        variant: ButtonVariant.outline,
        size: ButtonSize.sm,
        onPressed: null,
        child: Text('New Goal'),
      ),
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
    );
  }
}

/// `Claimable Balance`: a number, a status badge and a small table of rows.
class HomeClaimableCard extends StatelessWidget {
  /// Creates the card.
  const HomeClaimableCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const CollageCard(
      title: 'Claimable Balance',
      children: <Widget>[
        StudioValue(r'$1,211.29', size: 34),
        Gap(10),
        Badge(variant: BadgeVariant.secondary, child: Text('Pending Setup')),
        Gap(16),
        StudioRow(label: 'Net Royalties', value: r'$1,248.75'),
        StudioRow(label: 'Processing Fee', value: r'-$37.46'),
        StudioRow(label: 'Total Ready to Claim', value: r'$1,211.29 USD'),
        Gap(4),
        StudioHelper(
          r'Once your bank is connected, balances over $10.00 are '
          r'automatically eligible for monthly distribution on the 15th.',
        ),
      ],
    );
  }
}

/// `Q2 Dividend Income`: a progress list of holdings.
class HomeDividendCard extends StatelessWidget {
  /// Creates the card.
  const HomeDividendCard({super.key});

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
    return CollageCard(
      title: 'Q2 Dividend Income',
      subtitle: 'Quarterly payouts across your portfolio holdings.',
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
    );
  }
}

/// `Card Balance`: a sparkline card with a due date and an action.
class HomeCardBalanceCard extends StatelessWidget {
  /// Creates the card.
  const HomeCardBalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return CollageCard(
      title: 'Card Balance',
      trailing: Icon(
        LucideIcons.creditCard,
        size: 16,
        color: theme.colors.mutedForeground,
      ),
      children: <Widget>[
        const StudioValue(r'US$12.94', size: 30),
        Text(
          r'US$11,337.06 Available',
          style: theme.typography.small.copyWith(
            color: theme.colors.mutedForeground,
          ),
        ),
        const Gap(12),
        const Row(
          children: <Widget>[
            Expanded(child: StudioHelper('Payment due')),
            Badge(variant: BadgeVariant.outline, child: Text('1 Apr')),
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
          onPressed: null,
          child: Text('Pay Early'),
        ),
      ],
    );
  }
}

/// `Yearly Activity`: a month strip with a switch row, exercising `switch`.
class HomeActivityCard extends StatefulWidget {
  /// Creates the card.
  const HomeActivityCard({super.key});

  @override
  State<HomeActivityCard> createState() => _HomeActivityCardState();
}

class _HomeActivityCardState extends State<HomeActivityCard> {
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
    return CollageCard(
      title: 'Yearly Activity',
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
    );
  }

  void _setAutoSave(bool value) => setState(() => _autoSave = value);
}
