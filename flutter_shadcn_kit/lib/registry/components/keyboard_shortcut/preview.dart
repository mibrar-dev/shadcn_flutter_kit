// Named examples for the `keyboard_shortcut` component (P6-F3 preview
// contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';
import 'keyboard_shortcut.dart';

/// A chord rendered from an activator.
Widget _keyboardShortcutDefault(BuildContext context) {
  return const Align(
    alignment: AlignmentDirectional.centerStart,
    child: KeyboardShortcut.fromActivator(
      activator: SingleActivator(LogicalKeyboardKey.keyK, meta: true),
    ),
  );
}

/// A chord from explicit keys, in display order.
Widget _keyboardShortcutMultipleKeys(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const KeyboardShortcut(
        keys: <LogicalKeyboardKey>[
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.shift,
          LogicalKeyboardKey.keyP,
        ],
      ),
      Gap(spacing.md),
      const KeyboardShortcut(
        keys: <LogicalKeyboardKey>[
          LogicalKeyboardKey.arrowUp,
          LogicalKeyboardKey.arrowDown,
        ],
      ),
      Gap(spacing.md),
      const KeyboardShortcut(
        keys: <LogicalKeyboardKey>[
          LogicalKeyboardKey.alt,
          LogicalKeyboardKey.keyF,
        ],
      ),
    ],
  );
}

/// A chord under a custom display scope, plus one bare cap.
Widget _keyboardShortcutScoped(BuildContext context) {
  return const KeyboardShortcutDisplayScope(
    builder: _keyboardShortcutLabel,
    child: KeyboardShortcut(
      keys: <LogicalKeyboardKey>[
        LogicalKeyboardKey.alt,
        LogicalKeyboardKey.keyF,
      ],
    ),
  );
}

Widget _keyboardShortcutLabel(BuildContext context, LogicalKeyboardKey key) =>
    Text(key.keyLabel.toUpperCase());

/// Named docs examples for `keyboard_shortcut`; the first is the default.
const List<ComponentPreview> keyboardShortcutPreviews = <ComponentPreview>[
  ComponentPreview('Default', _keyboardShortcutDefault),
  ComponentPreview('Multiple keys', _keyboardShortcutMultipleKeys),
  ComponentPreview('Scoped labels', _keyboardShortcutScoped),
];
