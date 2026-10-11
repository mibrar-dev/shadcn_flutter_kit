// The settings blocks of the Theme Studio canvas: switch rows grouped the way
// shadcn's account pages do them.
//
// `Switch`, `Badge` and `Button` are the registry components; the rows are
// layout. Split out of `studio_list.dart` to keep every block file short.

import 'package:flutter/widgets.dart';

import '../../ui/shadcn/components/badge/badge.dart';
import '../../ui/shadcn/components/button/button.dart';
import '../../ui/shadcn/components/switch/switch.dart';
import '../../ui/shadcn/foundation/gap.dart';
import 'studio_card.dart';

/// `Notifications`: switch rows, the way shadcn's settings cards read.
class StudioNotificationsCard extends StatefulWidget {
  /// Creates the card.
  const StudioNotificationsCard({super.key});

  @override
  State<StudioNotificationsCard> createState() =>
      _StudioNotificationsCardState();
}

class _StudioNotificationsCardState extends State<StudioNotificationsCard> {
  static const List<(String, String)> rows = <(String, String)>[
    ('Transaction alerts', 'Deposits, withdrawals, and transfers.'),
    ('Security alerts', 'Login attempts and account changes.'),
    ('Goal milestones', 'Updates at 25%, 50%, 75%, and 100%.'),
    ('Market updates', 'Daily portfolio summary and price alerts.'),
  ];

  final Set<int> _on = <int>{0, 1, 2};

  @override
  Widget build(BuildContext context) {
    return StudioCard(
      title: 'Notifications',
      subtitle: 'Choose what you want to be notified about.',
      trailing: Badge(
        variant: BadgeVariant.outline,
        child: Text('${_on.length} of ${rows.length}'),
      ),
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
      ),
    );
  }
}
