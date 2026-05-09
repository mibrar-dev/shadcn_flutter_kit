// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../shared/theme/theme.dart';
import '../../../shared/utils/style_value.dart';
part '_impl/core/media_query_visibility.dart';

/// Theme configuration for [MediaQueryVisibility].
class MediaQueryVisibilityTheme extends ComponentThemeData {
  /// Minimum width at which the child is shown.
  final double? minWidth;

  /// Maximum width at which the child is shown.
  final double? maxWidth;

  /// Creates a [MediaQueryVisibilityTheme].
  const MediaQueryVisibilityTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.minWidth,
    this.maxWidth,
  });

  /// Creates a copy of this theme but with the given fields replaced.
  MediaQueryVisibilityTheme copyWith({
    ValueGetter<double?>? minWidth,
    ValueGetter<double?>? maxWidth,
  }) {
    return MediaQueryVisibilityTheme(
      minWidth: minWidth == null ? this.minWidth : minWidth(),
      maxWidth: maxWidth == null ? this.maxWidth : maxWidth(),
    );
  }

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MediaQueryVisibilityTheme &&
        other.minWidth == minWidth &&
        other.maxWidth == maxWidth;
  }

  @override
  int get hashCode => Object.hash(minWidth, maxWidth);
}

/// A widget that conditionally displays children based on media query constraints.
