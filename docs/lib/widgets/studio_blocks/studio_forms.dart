// The form blocks of the Theme Studio canvas: the reference `/create` cards
// built from `Select`, `Slider`, `TextArea` and `Input`.
//
// Each one re-themes live: the select surface, the slider track and thumb, the
// textarea border and the button all read the tokens the rail edits.

import 'package:flutter/widgets.dart';

import '../../ui/shadcn/components/button/button.dart';
import '../../ui/shadcn/components/input/input.dart';
import '../../ui/shadcn/components/select/select.dart';
import '../../ui/shadcn/components/slider/slider.dart';
import '../../ui/shadcn/components/switch/switch.dart';
import '../../ui/shadcn/components/text_area/text_area.dart';
import '../../ui/shadcn/foundation/gap.dart';
import '../../ui/shadcn/foundation/icons/lucide_icons.dart';
import '../../ui/shadcn/theme/theme.dart';
import 'studio_card.dart';

/// `Payout Threshold`: a select, a slider with a live amount and a textarea.
class StudioPayoutCard extends StatefulWidget {
  /// Creates the card.
  const StudioPayoutCard({super.key});

  @override
  State<StudioPayoutCard> createState() => _StudioPayoutCardState();
}

class _StudioPayoutCardState extends State<StudioPayoutCard> {
  static const List<String> currencies = <String>[
    r'USD — United States Dollar',
    'EUR — Euro',
    'GBP — British Pound',
  ];

  String _currency = currencies.first;
  double _minimum = 2500;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return StudioCard(
      title: 'Payout Threshold',
      subtitle: 'Set the minimum balance before a payout is triggered.',
      trailing: const Icon(LucideIcons.x, size: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const StudioFieldLabel('Preferred Currency'),
          const Gap(6),
          Select<String>(
            value: _currency,
            onChanged: (String? next) =>
                setState(() => _currency = next ?? _currency),
            items: <Widget>[
              for (final String currency in currencies)
                SelectItem<String>(value: currency, child: Text(currency)),
            ],
            itemBuilder: (BuildContext context, String value) =>
                Text(value, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          const Gap(20),
          Row(
            children: <Widget>[
              const Expanded(child: StudioFieldLabel('Minimum Payout Amount')),
              Text(
                r'$' + _minimum.toStringAsFixed(2),
                style: theme.typography.small.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const Gap(8),
          Slider(
            value: _minimum,
            min: 50,
            max: 10000,
            onChanged: (double next) => setState(() => _minimum = next),
            semanticLabel: 'Minimum payout amount',
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  r'$50 (MIN)',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.typography.xSmall.copyWith(
                    color: theme.colors.mutedForeground,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  r'$10,000 (MAX)',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: theme.typography.xSmall.copyWith(
                    color: theme.colors.mutedForeground,
                  ),
                ),
              ),
            ],
          ),
          const Gap(16),
          const StudioFieldLabel('Notes'),
          const Gap(6),
          const TextArea(
            minLines: 3,
            maxLines: 4,
            hintText: 'Add any notes for this payout configuration...',
          ),
          const Gap(16),
          Button(
            variant: ButtonVariant.primary,
            onPressed: () {},
            child: const SizedBox(
              width: double.infinity,
              child: Text('Save Threshold', textAlign: TextAlign.center),
            ),
          ),
        ],
      ),
    );
  }
}

/// `Buy Investment`: amount input, order-type select and an estimate row.
class StudioInvestmentCard extends StatefulWidget {
  /// Creates the card.
  const StudioInvestmentCard({super.key});

  @override
  State<StudioInvestmentCard> createState() => _StudioInvestmentCardState();
}

class _StudioInvestmentCardState extends State<StudioInvestmentCard> {
  static const List<String> orderTypes = <String>[
    'Market Order',
    'Limit Order',
    'Stop Order',
  ];

  String _orderType = orderTypes.first;
  String _amount = '2500';

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return StudioCard(
      title: 'Buy Investment',
      subtitle: 'A strategy for building wealth over time.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const StudioFieldLabel('Amount to Invest'),
          const Gap(6),
          Row(
            children: <Widget>[
              Text(
                r'$',
                style: theme.typography.h3.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              const Gap(8),
              Expanded(
                child: Input(
                  initialValue: _amount,
                  keyboardType: TextInputType.number,
                  onChanged: (String value) => _amount = value,
                  hintText: '0.00',
                ),
              ),
            ],
          ),
          const Gap(16),
          const StudioFieldLabel('Order Type'),
          const Gap(6),
          Select<String>(
            value: _orderType,
            onChanged: (String? next) =>
                setState(() => _orderType = next ?? _orderType),
            items: <Widget>[
              for (final String type in orderTypes)
                SelectItem<String>(value: type, child: Text(type)),
            ],
            itemBuilder: (BuildContext context, String value) => Text(value),
          ),
          const Gap(16),
          const StudioRow(label: 'Estimated Shares', value: '1.95'),
          const StudioRow(label: 'Buying Power', value: r'$12,450.00'),
          const Gap(12),
          const Text(
            'Market orders execute at the current price. Trades are '
            'typically executed within minutes during market hours.',
            style: TextStyle(fontSize: 12),
          ),
          const Gap(16),
          Button(
            variant: ButtonVariant.primary,
            onPressed: () {},
            child: const SizedBox(
              width: double.infinity,
              child: Text('Review Order', textAlign: TextAlign.center),
            ),
          ),
        ],
      ),
    );
  }
}

/// `Report an Issue`: a select plus a textarea, as shadcn's form cards do.
class StudioReportIssueCard extends StatefulWidget {
  /// Creates the card.
  const StudioReportIssueCard({super.key});

  @override
  State<StudioReportIssueCard> createState() => _StudioReportIssueCardState();
}

class _StudioReportIssueCardState extends State<StudioReportIssueCard> {
  static const List<String> kinds = <String>[
    'Wrong royalty split',
    'Missing track',
    'Artwork rejected',
    'Payout delayed',
  ];

  String _kind = kinds.first;

  @override
  Widget build(BuildContext context) {
    return StudioCard(
      title: 'Report an Issue',
      subtitle: 'Tell us what went wrong and we will pick it up.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const StudioFieldLabel('Category'),
          const Gap(6),
          Select<String>(
            value: _kind,
            onChanged: (String? next) => setState(() => _kind = next ?? _kind),
            items: <Widget>[
              for (final String kind in kinds)
                SelectItem<String>(value: kind, child: Text(kind)),
            ],
            itemBuilder: (BuildContext context, String value) => Text(value),
          ),
          const Gap(16),
          const StudioFieldLabel('What happened?'),
          const Gap(6),
          const TextArea(
            minLines: 4,
            maxLines: 6,
            hintText: 'Include track names, dates and any error codes.',
          ),
          const Gap(16),
          Row(
            children: <Widget>[
              const Expanded(
                child: Button(
                  variant: ButtonVariant.outline,
                  onPressed: studioNoop,
                  child: Text('Cancel'),
                ),
              ),
              const Gap(12),
              Expanded(
                child: Button(
                  variant: ButtonVariant.primary,
                  onPressed: () {},
                  child: const Text('Submit Report'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// `Create Account`: the shadcn email/password signup card.
class StudioCreateAccountCard extends StatefulWidget {
  /// Creates the card.
  const StudioCreateAccountCard({super.key});

  @override
  State<StudioCreateAccountCard> createState() =>
      _StudioCreateAccountCardState();
}

class _StudioCreateAccountCardState extends State<StudioCreateAccountCard> {
  bool _sameAddress = true;
  String _payout = 'Bank Transfer';

  @override
  Widget build(BuildContext context) {
    return StudioCard(
      title: 'Create Account',
      subtitle: 'Start distributing your music in minutes.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const StudioFieldLabel('Email'),
          const Gap(6),
          const Input(
            initialValue: '',
            hintText: 'm@example.com',
            keyboardType: TextInputType.emailAddress,
          ),
          const Gap(16),
          const StudioFieldLabel('Password'),
          const Gap(6),
          const Input(
            initialValue: '',
            obscureText: true,
            hintText: 'At least 8 characters',
          ),
          const Gap(16),
          const StudioFieldLabel('Payout Method'),
          const Gap(6),
          Select<String>(
            value: _payout,
            onChanged: (String? next) =>
                setState(() => _payout = next ?? _payout),
            items: const <Widget>[
              SelectItem<String>(
                value: 'Bank Transfer',
                child: Text('Bank Transfer'),
              ),
              SelectItem<String>(value: 'PayPal', child: Text('PayPal')),
            ],
            itemBuilder: (BuildContext context, String value) => Text(value),
          ),
          const Gap(16),
          Row(
            children: <Widget>[
              const Expanded(child: Text('Billing same as payout')),
              Switch(
                value: _sameAddress,
                onChanged: (bool value) => setState(() => _sameAddress = value),
              ),
            ],
          ),
          const Gap(16),
          Button(
            variant: ButtonVariant.primary,
            onPressed: () {},
            child: const SizedBox(
              width: double.infinity,
              child: Text('Create Account', textAlign: TextAlign.center),
            ),
          ),
        ],
      ),
    );
  }
}
