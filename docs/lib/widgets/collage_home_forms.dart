// Home showcase: form cards (P6-H1).
//
// Extends the Theme Studio form blocks (`studio_blocks/studio_forms.dart`):
// `Select`, `Slider`, `TextArea` and `Input` compositions, re-shelled in
// [CollageCard] for the home wall.

import 'package:flutter/widgets.dart';

import '../ui/shadcn/components/button/button.dart';
import '../ui/shadcn/components/select/select.dart';
import '../ui/shadcn/components/slider/slider.dart';
import '../ui/shadcn/components/text_area/text_area.dart';
import '../ui/shadcn/foundation/gap.dart';
import '../ui/shadcn/foundation/icons/lucide_icons.dart';
import '../ui/shadcn/theme/theme.dart';
import 'collage_cards.dart';
import 'studio_blocks/studio_card.dart';

/// `Payout Threshold`: a select, a slider with a live amount and a textarea.
class HomePayoutCard extends StatefulWidget {
  /// Creates the card.
  const HomePayoutCard({super.key});

  @override
  State<HomePayoutCard> createState() => _HomePayoutCardState();
}

class _HomePayoutCardState extends State<HomePayoutCard> {
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
    return CollageCard(
      title: 'Payout Threshold',
      subtitle: 'Set the minimum balance before a payout is triggered.',
      trailing: const Icon(LucideIcons.x, size: 14),
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
    );
  }
}

/// `Report an Issue`: a select plus a textarea, as shadcn's form cards do.
class HomeReportCard extends StatefulWidget {
  /// Creates the card.
  const HomeReportCard({super.key});

  @override
  State<HomeReportCard> createState() => _HomeReportCardState();
}

class _HomeReportCardState extends State<HomeReportCard> {
  static const List<String> kinds = <String>[
    'Wrong royalty split',
    'Missing track',
    'Artwork rejected',
    'Payout delayed',
  ];

  String _kind = kinds.first;

  @override
  Widget build(BuildContext context) {
    return CollageCard(
      title: 'Report an Issue',
      subtitle: 'Tell us what went wrong and we will pick it up.',
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
                onPressed: collageNoop,
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
    );
  }
}
