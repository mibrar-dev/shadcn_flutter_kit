// Named examples for the `radio_group` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle. Each example owns its selection state: the old
// gallery shared one controller across every section.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../theme/theme.dart';
import 'radio_group.dart';

/// A vertical group of row items; the selection lives in this example.
class _RowsDemo extends StatefulWidget {
  const _RowsDemo();

  @override
  State<_RowsDemo> createState() => _RowsDemoState();
}

class _RowsDemoState extends State<_RowsDemo> {
  String _plan = 'free';

  @override
  Widget build(BuildContext context) {
    return ShadcnRadioGroup<String>(
      value: _plan,
      onChanged: (String value) => setState(() => _plan = value),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RadioItem<String>(value: 'free', label: Text('Free')),
          RadioItem<String>(value: 'pro', label: Text('Pro')),
          RadioItem<String>(value: 'team', label: Text('Team')),
        ],
      ),
    );
  }
}

/// A group of card items; the selection lives in this example.
class _CardsDemo extends StatefulWidget {
  const _CardsDemo();

  @override
  State<_CardsDemo> createState() => _CardsDemoState();
}

class _CardsDemoState extends State<_CardsDemo> {
  String _plan = 'pro';

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return ShadcnRadioGroup<String>(
      value: _plan,
      onChanged: (String value) => setState(() => _plan = value),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (final String plan in <String>['free', 'pro'])
            Padding(
              padding: EdgeInsets.only(bottom: spacing.sm),
              child: RadioCard<String>(
                value: plan,
                child: Text(
                  plan,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

Widget _default(BuildContext context) => const _RowsDemo();

Widget _cardItems(BuildContext context) => const _CardsDemo();

/// Named docs examples for `radio_group`; the first entry is the default.
const List<ComponentPreview> radioGroupPreviews = <ComponentPreview>[
  ComponentPreview('Default', _default),
  ComponentPreview('Card items', _cardItems),
];
