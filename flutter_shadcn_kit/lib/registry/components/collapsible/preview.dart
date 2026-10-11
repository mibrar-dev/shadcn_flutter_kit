// Named examples for the `collapsible` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/gap.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';
import 'collapsible.dart';

/// One muted row of the branch list.
Widget _collapsibleRow(BuildContext context, String label) {
  final theme = ShadcnTheme.of(context);
  return DecoratedBox(
    decoration: BoxDecoration(
      color: theme.colors.muted,
      borderRadius: theme.borderRadiusLg,
    ),
    child: Padding(padding: EdgeInsetsDensity.pxAll(12), child: Text(label)),
  );
}

/// Uncontrolled: the section keeps its own state.
class _CollapsibleUncontrolled extends StatelessWidget {
  const _CollapsibleUncontrolled();

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Collapsible(
        children: <Widget>[
          const CollapsibleTrigger(child: Text('Recent activity')),
          Gap(spacing.sm),
          _collapsibleRow(context, '@mibrar-dev/shadcn_flutter_kit'),
          CollapsibleContent(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Gap(spacing.sm),
                _collapsibleRow(context, '@flutter/flutter'),
                Gap(spacing.sm),
                _collapsibleRow(context, '@dart-lang/sdk'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Controlled: the example owns the expansion state.
class _CollapsibleControlled extends StatefulWidget {
  const _CollapsibleControlled();

  @override
  State<_CollapsibleControlled> createState() => _CollapsibleControlledState();
}

class _CollapsibleControlledState extends State<_CollapsibleControlled> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Collapsible(
        isExpanded: _expanded,
        onExpansionChanged: (bool value) => setState(() => _expanded = value),
        children: <Widget>[
          const CollapsibleTrigger(child: Text('Controlled section')),
          Gap(spacing.sm),
          CollapsibleContent(
            child: _collapsibleRow(context, 'Toggled by the parent'),
          ),
          Gap(spacing.sm),
          Text(_expanded ? 'open' : 'closed'),
        ],
      ),
    );
  }
}

Widget _collapsibleDefault(BuildContext context) =>
    const _CollapsibleUncontrolled();

Widget _collapsibleControlledExample(BuildContext context) =>
    const _CollapsibleControlled();

/// Named docs examples for `collapsible`; the first entry is the default.
const List<ComponentPreview> collapsiblePreviews = <ComponentPreview>[
  ComponentPreview('Default', _collapsibleDefault),
  ComponentPreview('Controlled', _collapsibleControlledExample),
];
