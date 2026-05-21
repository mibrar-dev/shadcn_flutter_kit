// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../theme.dart';

/// _AnimatedThemeState defines a reusable type for this registry module.
class _AnimatedThemeState extends AnimatedWidgetBaseState<AnimatedTheme> {
  /// Stores `_data` state/configuration for this implementation.
  ThemeDataTween? _data;

  @override
  /// Executes `forEachTween` behavior for this component/composite.
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _data =
        visitor(
              _data,
              widget.data,
              (dynamic value) =>
                  ThemeDataTween(begin: value as ThemeData, end: null),
            )
            as ThemeDataTween?;
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = _data!.evaluate(animation);
    return Theme(data: theme, child: widget.child);
  }
}

/// Properties for icon theming.
///
/// Defines size and color for different icon sizes across the theme.
