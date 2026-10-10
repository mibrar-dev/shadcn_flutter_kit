// Gallery preview for the `keyboard_shortcut` component: explicit chords,
// activators, the display scope and dark.
// Widgets-only; the docs app embeds [KeyboardShortcutPreview] directly.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'keyboard_shortcut.dart';

/// Renders the keyboard-shortcut gallery.
class KeyboardShortcutPreview extends StatelessWidget {
  /// Creates the preview.
  const KeyboardShortcutPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: TextStyle(color: theme.colors.foreground, fontSize: 13),
        child: ColoredBox(
          color: theme.colors.background,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _section(
                  context,
                  'From an activator',
                  const KeyboardShortcut.fromActivator(
                    activator: SingleActivator(
                      LogicalKeyboardKey.keyK,
                      meta: true,
                    ),
                  ),
                ),
                Gap(theme.spacing.lg),
                _section(
                  context,
                  'Explicit keys',
                  const KeyboardShortcut(
                    keys: <LogicalKeyboardKey>[
                      LogicalKeyboardKey.control,
                      LogicalKeyboardKey.shift,
                      LogicalKeyboardKey.keyP,
                    ],
                  ),
                ),
                Gap(theme.spacing.lg),
                _section(
                  context,
                  'Arrows',
                  const KeyboardShortcut(
                    keys: <LogicalKeyboardKey>[
                      LogicalKeyboardKey.arrowUp,
                      LogicalKeyboardKey.arrowDown,
                    ],
                  ),
                ),
                Gap(theme.spacing.lg),
                _section(
                  context,
                  'Single cap',
                  const KeyboardKeyCap(keyboardKey: LogicalKeyboardKey.enter),
                ),
                Gap(theme.spacing.lg),
                _section(context, 'Custom label scope', const _Scoped()),
                Gap(theme.spacing.lg),
                _section(context, 'Dark', _dark(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dark(BuildContext context) {
    return ShadcnTheme(
      data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
      child: ColoredBox(
        color: ShadcnColors.darkFallback.background,
        child: Padding(
          padding: EdgeInsets.all(ShadcnTheme.of(context).spacing.md),
          child: KeyboardShortcut(
            keys: <LogicalKeyboardKey>[
              LogicalKeyboardKey.meta,
              LogicalKeyboardKey.enter,
            ],
          ),
        ),
      ),
    );
  }

  Widget _section(BuildContext context, String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        Gap(ShadcnTheme.of(context).spacing.sm),
        child,
      ],
    );
  }
}

/// A chord under a custom [KeyboardShortcutDisplayScope].
class _Scoped extends StatelessWidget {
  const _Scoped();

  @override
  Widget build(BuildContext context) {
    return KeyboardShortcutDisplayScope(
      builder: (BuildContext context, LogicalKeyboardKey key) =>
          Text(key.keyLabel.toUpperCase()),
      child: const KeyboardShortcut(
        keys: <LogicalKeyboardKey>[
          LogicalKeyboardKey.alt,
          LogicalKeyboardKey.keyF,
        ],
      ),
    );
  }
}
