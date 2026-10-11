import 'markdown_style.dart';

/// User-owned markdown overrides.
///
/// Values only: const constructors and const values, no closures and no
/// `BuildContext`. The CLI never overwrites this file; Studio rewrites it
/// deterministically. Every field left unset falls through to
/// [markdownDefaults] and then to the ambient token set, so an empty override
/// table is the correct starting point.
///
/// ```dart
/// const MarkdownTheme markdownThemeOverrides = MarkdownTheme(
///   linkColor: ThemedColor.ref(ColorRef.accent),
///   blockSpacing: 8.0,
/// );
/// ```
const MarkdownTheme markdownThemeOverrides = MarkdownTheme();
