// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../media_query.dart';

/// MediaQueryVisibility defines a reusable type for this registry module.
class MediaQueryVisibility extends StatelessWidget {
  /// Minimum screen width to show [child].
  final double? minWidth;

  /// Maximum screen width to show [child].
  final double? maxWidth;

  /// Widget to display when width is within range.
  final Widget child;

  /// Widget to display when width is outside range.
  final Widget? alternateChild;

  /// Creates a [MediaQueryVisibility].
  const MediaQueryVisibility({
    super.key,
    this.minWidth,
    this.maxWidth,
    required this.child,
    this.alternateChild,
  });

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final compTheme = ComponentTheme.maybeOf<MediaQueryVisibilityTheme>(
      context,
    );

    /// Stores `size` state/configuration for this implementation.
    final size = mediaQuery.size.width;
    final minWidth = styleValue(
      widgetValue: this.minWidth,
      themeValue: compTheme?.minWidth,
      defaultValue: null,
    );
    final maxWidth = styleValue(
      widgetValue: this.maxWidth,
      themeValue: compTheme?.maxWidth,
      defaultValue: null,
    );
    if (minWidth != null && size < minWidth) {
      return SizedBox(child: alternateChild);
    }
    if (maxWidth != null && size > maxWidth) {
      return SizedBox(child: alternateChild);
    }
    return SizedBox(child: child);
  }
}
