// The form block of the Theme Studio canvas (the reference's `Payout
// Threshold` card).
//
// `Select`, `Slider`, `TextArea` and `Button` are the registry components the
// brief asks for; each one re-themes live as the rail edits tokens.

import 'package:flutter/widgets.dart';

import '../../ui/shadcn/components/button/button.dart';
import '../../ui/shadcn/foundation/icons/lucide_icons.dart';
import '../../ui/shadcn/components/select/select.dart';
import '../../ui/shadcn/components/slider/slider.dart';
import '../../ui/shadcn/components/text_area/text_area.dart';
import '../../ui/shadcn/foundation/gap.dart';
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
    'USD — United States Dollar',
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Preferred Currency',
            style: theme.typography.small.copyWith(fontWeight: FontWeight.w600),
          ),
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
              Expanded(
                child: Text(
                  'Minimum Payout Amount',
                  style: theme.typography.small.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '\$${_minimum.toStringAsFixed(2)}',
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
              Text(
                '\$50 (MIN)',
                style: theme.typography.small.copyWith(
                  fontSize: 11,
                  color: theme.colors.mutedForeground,
                ),
              ),
              const Spacer(),
              Text(
                r'$10,000 (MAX)',
                style: theme.typography.small.copyWith(
                  fontSize: 11,
                  color: theme.colors.mutedForeground,
                ),
              ),
            ],
          ),
          const Gap(16),
          Text(
            'Notes',
            style: theme.typography.small.copyWith(fontWeight: FontWeight.w600),
          ),
          const Gap(6),
          const TextArea(
            minLines: 3,
            maxLines: 4,
            hintText: 'Add any notes for this payout configuration...',
          ),
          const Gap(16),
          const SizedBox(
            width: double.infinity,
            child: Button(
              variant: ButtonVariant.primary,
              child: Text('Save Threshold'),
            ),
          ),
        ],
      ),
    );
  }
}
