// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../theme.dart';

/// Marks a widget as individually themeable for studio-style tooling.
///
/// Components implementing `Styleable<T>` expose a per-instance `theme`
/// that styles that widget alone. This is the contract the studio app
/// relies on: every themeable knob of a component lives in its `T`
/// ([ComponentThemeData]), and each widget instance can carry its own `T`
/// which takes precedence over any ancestor [ComponentTheme].
///
/// Semantics (match upstream): when [theme] is non-null the ancestor is
/// not consulted at all, so a field left null here falls back to the
/// component's built-in default rather than to the ancestor's value. To
/// adjust an ancestor theme instead of replacing it, read it with
/// [ComponentTheme.maybeOf] and `copyWith` the result.
// ignore: use_key_in_widget_constructors
abstract interface class Styleable<T extends ComponentThemeData>
    extends Widget {
  /// Styling for this widget alone, overriding the ancestor theme.
  T? get theme;
}
