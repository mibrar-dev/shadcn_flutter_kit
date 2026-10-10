// The picker blocks of the Theme Studio canvas: tabs, calendar, date range,
// preferences, cookie settings and payment method.
//
// These are the blocks that make `accent`, `ring`, `border`, radius and spacing
// edits visible on dense interactive surfaces, the way the reference's pickers
// do.

import 'package:flutter/widgets.dart';

import '../../ui/shadcn/components/badge/badge.dart';
import '../../ui/shadcn/components/button/button.dart';
import '../../ui/shadcn/components/calendar/calendar.dart';
import '../../ui/shadcn/components/date_picker/date_picker.dart';
import '../../ui/shadcn/primitives/date_math.dart';
import '../../ui/shadcn/components/radio_group/radio_group.dart';
import '../../ui/shadcn/components/select/select.dart';
import '../../ui/shadcn/components/switch/switch.dart';
import '../../ui/shadcn/components/tabs/tabs.dart';
import '../../ui/shadcn/foundation/gap.dart';
import 'studio_card.dart';

/// A three-tab block with a live body, so radius/spacing edits show up in the
/// tab strip as well as the body.
class StudioTabsCard extends StatefulWidget {
  /// Creates the card.
  const StudioTabsCard({super.key});

  @override
  State<StudioTabsCard> createState() => _StudioTabsCardState();
}

class _StudioTabsCardState extends State<StudioTabsCard> {
  static const List<String> labels = <String>[
    'Overview',
    'Activity',
    'Settings',
  ];
  static const List<String> bodies = <String>[
    'Net revenue for the selected period, after fees.',
    'Twelve payouts settled in the last 30 days.',
    'Where the balance is routed once it clears.',
  ];

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return StudioCard(
      title: 'Payouts',
      subtitle: bodies[_index],
      child: Tabs(
        index: _index,
        expand: true,
        onChanged: (int index) => setState(() => _index = index),
        children: <TabItem>[
          for (final String label in labels) TabItem(child: Text(label)),
        ],
      ),
    );
  }
}

/// A calendar block (the reference's release-date picker).
class StudioCalendarCard extends StatefulWidget {
  /// Creates the card.
  const StudioCalendarCard({super.key});

  @override
  State<StudioCalendarCard> createState() => _StudioCalendarCardState();
}

class _StudioCalendarCardState extends State<StudioCalendarCard> {
  CalendarValue? _selected = CalendarValue.single(DateTime(2026, 5, 25));
  CalendarView _view = const CalendarView(2026, 5);

  @override
  Widget build(BuildContext context) {
    return StudioCard(
      title: 'Release date',
      subtitle: _subtitle(_selected),
      child: Calendar(
        view: _view,
        value: _selected,
        selectionMode: CalendarSelectionMode.single,
        onViewChanged: (CalendarView view) => setState(() => _view = view),
        onChanged: (CalendarValue? value) => setState(() => _selected = value),
      ),
    );
  }
}

/// A date-range block, the reference's reporting-period picker.
class StudioDateRangeCard extends StatefulWidget {
  /// Creates the card.
  const StudioDateRangeCard({super.key});

  @override
  State<StudioDateRangeCard> createState() => _StudioDateRangeCardState();
}

class _StudioDateRangeCardState extends State<StudioDateRangeCard> {
  DateTimeRange? _range = DateTimeRange(
    DateTime(2026, 1, 1),
    DateTime(2026, 3, 31),
  );

  @override
  Widget build(BuildContext context) {
    return StudioCard(
      title: 'Reporting Period',
      subtitle: _periodSubtitle(_range),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DateRangePicker(
            value: _range,
            onChanged: (DateTimeRange? next) => setState(() => _range = next),
          ),
          const Gap(16),
          Button(
            variant: ButtonVariant.primary,
            onPressed: () {},
            child: const SizedBox(
              width: double.infinity,
              child: Text('Generate Report', textAlign: TextAlign.center),
            ),
          ),
        ],
      ),
    );
  }
}

/// `Preferences`: a select and two switch rows, the reference's settings card.
class StudioPreferencesCard extends StatefulWidget {
  /// Creates the card.
  const StudioPreferencesCard({super.key});

  @override
  State<StudioPreferencesCard> createState() => _StudioPreferencesCardState();
}

class _StudioPreferencesCardState extends State<StudioPreferencesCard> {
  static const List<String> currencies = <String>[
    r'USD — United States Dollar',
    'EUR — Euro',
    'GBP — British Pound',
  ];

  static const List<(String, String)> switches = <(String, String)>[
    ('Public Statistics', 'Allow others to see your stream count'),
    ('Email Notifications', 'Monthly royalty and distribution updates'),
  ];

  String _currency = currencies.first;
  final Set<int> _on = <int>{0};

  @override
  Widget build(BuildContext context) {
    return StudioCard(
      title: 'Preferences',
      subtitle: 'Manage your account settings and notifications.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const StudioFieldLabel('Default Currency'),
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
          const Gap(16),
          for (int i = 0; i < switches.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(switches[i].$1),
                        const Gap(2),
                        StudioHelper(switches[i].$2),
                      ],
                    ),
                  ),
                  const Gap(12),
                  Switch(
                    value: _on.contains(i),
                    onChanged: (bool value) => setState(() {
                      if (value) {
                        _on.add(i);
                      } else {
                        _on.remove(i);
                      }
                    }),
                  ),
                ],
              ),
            ),
          const Gap(16),
          Row(
            children: <Widget>[
              const Expanded(
                child: Button(
                  variant: ButtonVariant.outline,
                  onPressed: studioNoop,
                  child: Text('Reset'),
                ),
              ),
              const Gap(12),
              Expanded(
                child: Button(
                  variant: ButtonVariant.primary,
                  onPressed: () {},
                  child: const Text('Save Preferences'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// `Cookie Settings`: three switch rows with badges.
class StudioCookieCard extends StatefulWidget {
  /// Creates the card.
  const StudioCookieCard({super.key});

  @override
  State<StudioCookieCard> createState() => _StudioCookieCardState();
}

class _StudioCookieCardState extends State<StudioCookieCard> {
  static const List<(String, String, bool)> rows = <(String, String, bool)>[
    ('Strictly Necessary', 'Required for the site to work.', true),
    ('Functional', 'Remembers your preset and mode.', true),
    ('Analytics', 'Anonymous usage measurements.', false),
  ];

  final Set<int> _on = <int>{0, 1};

  @override
  Widget build(BuildContext context) {
    return StudioCard(
      title: 'Cookie Settings',
      subtitle: 'Choose which cookies we may set.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (int i = 0; i < rows.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: <Widget>[
                            Text(rows[i].$1),
                            if (rows[i].$3)
                              const Badge(
                                variant: BadgeVariant.outline,
                                child: Text('Always on'),
                              ),
                          ],
                        ),
                        const Gap(2),
                        StudioHelper(rows[i].$2),
                      ],
                    ),
                  ),
                  const Gap(12),
                  Switch(
                    value: _on.contains(i),
                    onChanged: (bool value) => setState(() {
                      if (value) {
                        _on.add(i);
                      } else {
                        _on.remove(i);
                      }
                    }),
                  ),
                ],
              ),
            ),
          const Gap(12),
          Button(
            variant: ButtonVariant.primary,
            onPressed: () {},
            child: const SizedBox(
              width: double.infinity,
              child: Text('Save Choices', textAlign: TextAlign.center),
            ),
          ),
        ],
      ),
    );
  }
}

/// `Payment Method`: two `RadioCard`s from the registry's radio group.
class StudioPaymentMethodCard extends StatefulWidget {
  /// Creates the card.
  const StudioPaymentMethodCard({super.key});

  @override
  State<StudioPaymentMethodCard> createState() =>
      _StudioPaymentMethodCardState();
}

class _StudioPaymentMethodCardState extends State<StudioPaymentMethodCard> {
  String _method = 'bank';

  @override
  Widget build(BuildContext context) {
    return StudioCard(
      title: 'Payment Method',
      subtitle: 'How royalties are paid out.',
      child: ShadcnRadioGroup<String>(
        value: _method,
        onChanged: (String next) => setState(() => _method = next),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RadioCard<String>(
              value: 'bank',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const <Widget>[
                  Text('Bank Transfer'),
                  StudioHelper('SWIFT · IBAN · 3-5 business days'),
                ],
              ),
            ),
            const Gap(12),
            RadioCard<String>(
              value: 'paypal',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const <Widget>[
                  Text('PayPal'),
                  StudioHelper('Instant · 1.5% processing fee'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _subtitle(CalendarValue? value) {
  final DateTime? date = switch (value) {
    SingleCalendarValue(date: final DateTime picked) => picked,
    MultiCalendarValue(dates: final List<DateTime> picked) =>
      picked.isEmpty ? null : picked.first,
    _ => null,
  };
  return date == null ? 'No date picked' : _format(date);
}

String _periodSubtitle(DateTimeRange? range) {
  if (range == null) {
    return 'No period selected';
  }
  return '${_format(range.start)} – ${_format(range.end)}';
}

String _format(DateTime date) => '${date.day}/${date.month}/${date.year}';
