// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../../shared/icons/radix_icons.dart';
import '../../../shared/primitives/text.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/style_value.dart';
part '_impl/core/breadcrumb_2.dart';
part '_impl/core/_slash_separator.dart';
part '_impl/core/_arrow_separator.dart';

/// Theme for [Breadcrumb].
class BreadcrumbTheme extends ComponentThemeData {
  /// Separator widget between breadcrumb items.
  final Widget? separator;

  /// Padding surrounding the breadcrumb row.
  final EdgeInsetsGeometry? padding;

  /// Creates a [BreadcrumbTheme].
  const BreadcrumbTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.separator,
    this.padding,
  });

  /// Returns a copy of this theme with the given values replaced.
  BreadcrumbTheme copyWith({
    ValueGetter<Widget?>? separator,
    ValueGetter<EdgeInsetsGeometry?>? padding,
  }) {
    return BreadcrumbTheme(
      separator: separator == null ? this.separator : separator(),
      padding: padding == null ? this.padding : padding(),
    );
  }

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BreadcrumbTheme &&
        other.separator == separator &&
        other.padding == padding;
  }

  @override
  int get hashCode => Object.hash(separator, padding);
}

/// Navigation breadcrumb trail showing hierarchical path with customizable separators.
