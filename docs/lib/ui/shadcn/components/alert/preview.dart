// Named examples for the `alert` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/icons/lucide_icons.dart';
import 'alert.dart';

/// One alert, stretched to the stage width.
Widget _alert(
  BuildContext context,
  AlertVariant variant,
  String title,
  String content,
) {
  return ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 512),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Alert(
          variant: variant,
          leading: const Icon(LucideIcons.info, size: 16),
          title: Text(title),
          content: Text(content),
        ),
      ],
    ),
  );
}

/// Default variant.
Widget _alertDefault(BuildContext context) => _alert(
  context,
  AlertVariant.base,
  'Heads up',
  'You can install components from the CLI.',
);

/// Destructive variant.
Widget _alertDestructive(BuildContext context) => _alert(
  context,
  AlertVariant.destructive,
  'Session expired',
  'Please log in again to continue.',
);

/// A compact alert with a trailing action and no leading icon.
Widget _alertCompact(BuildContext context) {
  return ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 512),
    child: Alert(
      title: Text('Notification'),
      content: Text('You have a new message.'),
      trailing: Text('Now'),
    ),
  );
}

/// Named docs examples for `alert`; the first entry is the default.
const List<ComponentPreview> alertPreviews = <ComponentPreview>[
  ComponentPreview('Default', _alertDefault),
  ComponentPreview('Destructive', _alertDestructive),
  ComponentPreview('Compact', _alertCompact),
];
