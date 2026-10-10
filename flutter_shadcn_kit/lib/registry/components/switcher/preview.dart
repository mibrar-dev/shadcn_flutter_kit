// Named examples for the `switcher` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../theme/theme.dart';
import '../button/button.dart';
import 'switcher.dart';

/// Horizontal pager driven by buttons; owns its index.
class _HorizontalSwitcher extends StatefulWidget {
  const _HorizontalSwitcher();

  @override
  State<_HorizontalSwitcher> createState() => _HorizontalSwitcherState();
}

class _HorizontalSwitcherState extends State<_HorizontalSwitcher> {
  int _index = 0;
  final List<int> _reported = <int>[];

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 240,
          height: 120,
          child: Switcher(
            index: _index,
            direction: AxisDirection.right,
            onIndexChanged: (int value) {
              _reported.add(value);
              setState(() => _index = value);
            },
            children: <Widget>[
              for (int i = 0; i < 3; i++)
                ColoredBox(
                  color: i.isEven ? theme.colors.muted : theme.colors.accent,
                  child: Center(child: Text('page $i')),
                ),
            ],
          ),
        ),
        SizedBox(height: theme.spacing.md),
        Wrap(
          spacing: 8,
          children: <Widget>[
            for (int i = 0; i < 3; i++)
              Button(
                size: ButtonSize.sm,
                variant: i == _index
                    ? ButtonVariant.primary
                    : ButtonVariant.outline,
                onPressed: () => setState(() => _index = i),
                child: Text('$i'),
              ),
          ],
        ),
        SizedBox(height: theme.spacing.sm),
        Text('reported: $_reported'),
      ],
    );
  }
}

Widget _default(BuildContext context) => const _HorizontalSwitcher();

/// Vertical pager with a slower scoped curve.
Widget _vertical(BuildContext context) {
  final theme = ShadcnTheme.of(context);
  return ComponentTheme<SwitcherTheme>(
    data: const SwitcherTheme(
      duration: Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    ),
    child: SizedBox(
      width: 240,
      height: 100,
      child: Switcher(
        direction: AxisDirection.down,
        children: <Widget>[
          for (int i = 0; i < 2; i++)
            ColoredBox(
              color: i.isEven ? theme.colors.muted : theme.colors.accent,
              child: Center(child: Text('v$i')),
            ),
        ],
      ),
    ),
  );
}

/// Named docs examples for `switcher`; the first entry is the default.
const List<ComponentPreview> switcherPreviews = <ComponentPreview>[
  ComponentPreview('Default', _default),
  ComponentPreview('Vertical', _vertical),
];
