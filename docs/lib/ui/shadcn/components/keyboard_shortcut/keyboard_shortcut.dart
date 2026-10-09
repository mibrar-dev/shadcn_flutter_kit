// @dart=3.13
// The `keyboard_shortcut` component: [KeyboardShortcut] (the whole chord),
// [KeyboardKeyCap] (one key) and [KeyboardShortcutDisplayScope] (the optional
// app-wide key-label override).
//
// Ported from `components/display/keyboard_shortcut/**` (12 files, 603 LOC,
// six `part` files). The bugs it fixed are listed in README.md under
// "Fixed (not ported)".
//
// Two old names are gone deliberately:
//   * `KeyboardDisplay` / `KeyboardKeyDisplay` become `KeyboardShortcut` /
//     `KeyboardKeyCap` — the component id is `keyboard_shortcut`, and "display"
//     described no behaviour;
//   * `KeyboardShortcutDisplayMapper` (a `StatefulWidget` whose state only
//     cached a handle) becomes `KeyboardShortcutDisplayScope`, a stateless
//     `Data` provider. The handle type itself is already owned by
//     `foundation/keyboard.dart`, so the component no longer re-declares the
//     `KeyboardShortcutDisplayBuilder` / `KeyboardShortcutDisplayHandle`
//     typedefs, and `shortcutActivatorToKeySet` is not copied a second time.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/data.dart';
import '../../foundation/gap.dart';
import '../../foundation/keyboard.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import '../card/card.dart';
import 'keyboard_shortcut_style.dart';

export 'keyboard_shortcut_style.dart';

/// Glyphs for the keys that do not have a useful `keyLabel`.
///
/// Left and right variants are listed separately because `LogicalKeyboardKey`
/// compares by identity, not by family: `control` and `controlLeft` are three
/// different keys that a chord can carry. Not `const`: a constant map may not
/// use a key type that overrides `==`, which `LogicalKeyboardKey` does.
final Map<LogicalKeyboardKey, String> _keyGlyphs =
    Map<LogicalKeyboardKey, String>.unmodifiable(<LogicalKeyboardKey, String>{
      LogicalKeyboardKey.control: 'Ctrl',
      LogicalKeyboardKey.controlLeft: 'Ctrl',
      LogicalKeyboardKey.controlRight: 'Ctrl',
      LogicalKeyboardKey.shift: 'Shift',
      LogicalKeyboardKey.shiftLeft: 'Shift',
      LogicalKeyboardKey.shiftRight: 'Shift',
      LogicalKeyboardKey.alt: 'Alt',
      LogicalKeyboardKey.altLeft: 'Alt',
      LogicalKeyboardKey.altRight: 'Alt',
      LogicalKeyboardKey.meta: '\u2318',
      LogicalKeyboardKey.metaLeft: '\u2318',
      LogicalKeyboardKey.metaRight: '\u2318',
      LogicalKeyboardKey.enter: '\u21b5',
      LogicalKeyboardKey.escape: 'Esc',
      LogicalKeyboardKey.backspace: '\u232b',
      LogicalKeyboardKey.delete: '\u2326',
      LogicalKeyboardKey.arrowLeft: '\u2190',
      LogicalKeyboardKey.arrowRight: '\u2192',
      LogicalKeyboardKey.arrowUp: '\u2191',
      LogicalKeyboardKey.arrowDown: '\u2193',
    });

/// Label shown for [key] when no [KeyboardShortcutDisplayScope] is installed.
///
/// These are key *names*, not copy, so they are not localized: a shortcut has
/// to read the same on every keyboard the user is on, and `keyLabel` is what
/// Flutter itself reports for everything else.
Widget defaultKeyboardKeyLabel(BuildContext context, LogicalKeyboardKey key) {
  return Text(
    _keyGlyphs[key] ?? key.keyLabel,
    style: DefaultTextStyle.of(context).style,
  );
}

/// Installs an app-wide key-label builder for [child].
///
/// Without one, [KeyboardKeyCap] falls back to [defaultKeyboardKeyLabel].
/// [builder] is read through [Data] so a single install covers every hint in
/// the subtree.
class KeyboardShortcutDisplayScope extends StatelessWidget {
  /// Creates the scope.
  const KeyboardShortcutDisplayScope({
    super.key,
    this.builder,
    required this.child,
  });

  /// Builds the label for one key; null keeps [defaultKeyboardKeyLabel].
  final KeyboardShortcutDisplayBuilder? builder;

  /// Wraps the tree that reads the builder.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final KeyboardShortcutDisplayBuilder resolved =
        builder ?? defaultKeyboardKeyLabel;
    return Data<KeyboardShortcutDisplayHandle>.inherit(
      data: KeyboardShortcutDisplayHandle(resolved),
      child: child,
    );
  }
}

/// One key of a shortcut chord, drawn as a small rounded cap.
class KeyboardKeyCap extends StatelessWidget {
  /// Creates a key cap.
  const KeyboardKeyCap({
    super.key,
    required this.keyboardKey,
    this.padding,
    this.background,
    this.foreground,
    this.borderRadius,
    this.shadows,
    this.theme,
  });

  /// The key this cap stands for.
  final LogicalKeyboardKey keyboardKey;

  /// Padding inside the cap; null resolves the theme's.
  final EdgeInsetsGeometry? padding;

  /// Fill override; null resolves the theme's.
  final ThemedColor? background;

  /// Label colour override; null resolves the theme's.
  final ThemedColor? foreground;

  /// Corner radius override; null resolves the theme's.
  final BorderRadiusGeometry? borderRadius;

  /// Shadows override; null resolves the theme's (none by default).
  final List<BoxShadow>? shadows;

  /// Widget-leg style override.
  final KeyboardShortcutTheme? theme;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData shadcnTheme = ShadcnTheme.of(context);
    final KeyboardShortcutTheme container =
        resolveComponentStyle<KeyboardShortcutTheme, KeyboardShortcutTheme>(
          context,
          widget: theme,
          select: (KeyboardShortcutTheme t) => t,
          defaults: keyboardShortcutDefaults,
        );
    final ThemedColor fill =
        background ??
        container.keyBackground ??
        ThemedColor.value(shadcnTheme.colors.background.withValues(alpha: 0.7));
    final ThemedColor ink =
        foreground ??
        container.keyForeground ??
        ThemedColor.ref(ColorRef.mutedForeground);

    return Card(
      key: keyboardKeyCapKey,
      padding: padding ?? container.keyPadding,
      background: fill,
      borderRadius: borderRadius ?? container.keyBorderRadius,
      shadows: shadows ?? container.keyShadows,
      child: DefaultTextStyle.merge(
        style: (container.keyTextStyle ?? keyboardShortcutDefaultTextStyle)
            .copyWith(color: ink.resolve(shadcnTheme.colors)),
        child:
            Data.maybeOf<KeyboardShortcutDisplayHandle>(context)
                ?.buildKeyboardDisplay(context, keyboardKey) ??
            defaultKeyboardKeyLabel(context, keyboardKey),
      ),
    );
  }
}

/// Lookup key of one key cap.
const ValueKey<String> keyboardKeyCapKey = ValueKey<String>(
  'shadcn.keyboard_shortcut.cap',
);

/// A whole shortcut chord, drawn as a row of caps.
///
/// ```dart
/// KeyboardShortcut.fromActivator(
///   activator: const SingleActivator(LogicalKeyboardKey.keyK, meta: true),
/// )
/// ```
class KeyboardShortcut extends StatelessWidget {
  /// Creates a chord from explicit keys, in the order they are shown.
  const KeyboardShortcut({
    super.key,
    required List<LogicalKeyboardKey> this._keys,
    this.spacing,
    this.theme,
  }) : _activator = null;

  /// Creates a chord from a [ShortcutActivator], modifiers first.
  const KeyboardShortcut.fromActivator({
    super.key,
    required ShortcutActivator this._activator,
    this.spacing,
    this.theme,
  }) : _keys = null;

  final List<LogicalKeyboardKey>? _keys;
  final ShortcutActivator? _activator;

  /// Horizontal gap between caps; null resolves the theme's.
  final double? spacing;

  /// Widget-leg style override, applied to every cap.
  final KeyboardShortcutTheme? theme;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData shadcnTheme = ShadcnTheme.of(context);
    final KeyboardShortcutTheme container =
        resolveComponentStyle<KeyboardShortcutTheme, KeyboardShortcutTheme>(
          context,
          widget: theme,
          select: (KeyboardShortcutTheme t) => t,
          defaults: keyboardShortcutDefaults,
        );
    final List<LogicalKeyboardKey> keys =
        _keys ?? shortcutActivatorToKeySet(_activator!);
    if (keys.isEmpty) {
      return const SizedBox.shrink();
    }
    final double gap =
        spacing ?? container.spacing ?? keyboardShortcutDefaultSpacing;
    return Row(
      key: keyboardShortcutKey,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < keys.length; i++) ...<Widget>[
          if (i > 0) Gap(gap * shadcnTheme.scaling),
          KeyboardKeyCap(keyboardKey: keys[i], theme: theme),
        ],
      ],
    );
  }
}

/// Lookup key of the whole chord.
const ValueKey<String> keyboardShortcutKey = ValueKey<String>(
  'shadcn.keyboard_shortcut.row',
);
