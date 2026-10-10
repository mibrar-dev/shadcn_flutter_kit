// Home showcase: settings cards (P6-H1).
//
// Extends the Theme Studio settings blocks
// (`studio_blocks/studio_settings.dart`, `studio_blocks/studio_tabs.dart`):
// switch rows, a currency select and cookie choices, re-shelled in
// [CollageCard] for the home wall.

import 'package:flutter/widgets.dart';

import '../ui/shadcn/components/badge/badge.dart';
import '../ui/shadcn/components/button/button.dart';
import '../ui/shadcn/components/select/select.dart';
import '../ui/shadcn/components/switch/switch.dart';
import '../ui/shadcn/foundation/gap.dart';
import 'collage_cards.dart';
import 'studio_blocks/studio_card.dart';

/// `Notifications`: switch rows, the way shadcn's settings cards read.
class HomeNotificationsCard extends StatefulWidget {
  /// Creates the card.
  const HomeNotificationsCard({super.key});

  @override
  State<HomeNotificationsCard> createState() => _HomeNotificationsCardState();
}

class _HomeNotificationsCardState extends State<HomeNotificationsCard> {
  static const List<(String, String)> rows = <(String, String)>[
    ('Transaction alerts', 'Deposits, withdrawals, and transfers.'),
    ('Security alerts', 'Login attempts and account changes.'),
    ('Goal milestones', 'Updates at 25%, 50%, 75%, and 100%.'),
    ('Market updates', 'Daily portfolio summary and price alerts.'),
  ];

  final Set<int> _on = <int>{0, 1, 2};

  @override
  Widget build(BuildContext context) {
    return CollageCard(
      title: 'Notifications',
      subtitle: 'Choose what you want to be notified about.',
      trailing: Badge(
        variant: BadgeVariant.outline,
        child: Text('${_on.length} of ${rows.length}'),
      ),
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
                      Text(rows[i].$1),
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
        const Gap(8),
        Button(
          variant: ButtonVariant.primary,
          onPressed: () {},
          child: const SizedBox(
            width: double.infinity,
            child: Text('Save Preferences', textAlign: TextAlign.center),
          ),
        ),
      ],
    );
  }
}

/// `Preferences`: a select and two switch rows.
class HomePreferencesCard extends StatefulWidget {
  /// Creates the card.
  const HomePreferencesCard({super.key});

  @override
  State<HomePreferencesCard> createState() => _HomePreferencesCardState();
}

class _HomePreferencesCardState extends State<HomePreferencesCard> {
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
    return CollageCard(
      title: 'Preferences',
      subtitle: 'Manage your account settings and notifications.',
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
                onPressed: null,
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
    );
  }
}

/// `Cookie Settings`: three switch rows with badges.
class HomeCookieCard extends StatefulWidget {
  /// Creates the card.
  const HomeCookieCard({super.key});

  @override
  State<HomeCookieCard> createState() => _HomeCookieCardState();
}

class _HomeCookieCardState extends State<HomeCookieCard> {
  static const List<(String, String, bool)> rows = <(String, String, bool)>[
    ('Strictly Necessary', 'Required for the site to work.', true),
    ('Functional', 'Remembers your preset and mode.', true),
    ('Analytics', 'Anonymous usage measurements.', false),
  ];

  final Set<int> _on = <int>{0, 1};

  @override
  Widget build(BuildContext context) {
    return CollageCard(
      title: 'Cookie Settings',
      subtitle: 'Choose which cookies we may set.',
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
    );
  }
}
