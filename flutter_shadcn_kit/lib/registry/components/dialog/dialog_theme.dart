import 'dialog_style.dart';

/// User-owned dialog overrides.
///
/// Values only: const constructors and const values, no closures and no
/// `BuildContext`. The CLI never overwrites this file; Studio rewrites it
/// deterministically. Every field left unset falls through to
/// [dialogDefaults] and then to the ambient token set, so an empty override
/// table is the correct starting point.
///
/// Add entries as const values, for example:
///
/// ```dart
/// const DialogTheme dialogThemeOverrides = DialogTheme(
///   maxWidth: 640.0,
///   barrierColor: ThemedColor.ref(ColorRef.foreground, alpha: 0.4),
///   borderRadius: BorderRadius.all(Radius.circular(12)),
/// );
/// ```
const DialogTheme dialogThemeOverrides = DialogTheme();
