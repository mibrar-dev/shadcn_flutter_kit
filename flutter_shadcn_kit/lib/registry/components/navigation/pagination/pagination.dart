// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../shared/icons/radix_icons.dart';
import '../../../shared/localizations/shadcn_localizations.dart';
import '../../../shared/primitives/icon_extensions.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/style_value.dart';
import '../../control/button/button.dart';
import '../../display/triple_dots/triple_dots.dart';
part '_impl/core/pagination_2.dart';

/// Theme data for customizing [Pagination] appearance.
class PaginationTheme extends ComponentThemeData {
  /// Stores `gap` state/configuration for this implementation.
  final double? gap;

  /// Stores `showLabel` state/configuration for this implementation.
  final bool? showLabel;

  /// Creates a `PaginationTheme` instance.
  const PaginationTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.gap,
    this.showLabel,
  });

  /// Creates a `PaginationTheme` instance.
  PaginationTheme copyWith({
    ValueGetter<double?>? gap,
    ValueGetter<bool?>? showLabel,
  }) {
    return PaginationTheme(
      gap: gap == null ? this.gap : gap(),
      showLabel: showLabel == null ? this.showLabel : showLabel(),
    );
  }

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaginationTheme &&
        other.gap == gap &&
        other.showLabel == showLabel;
  }

  @override
  int get hashCode => Object.hash(gap, showLabel);
}

/// Widget that renders pagination controls with page buttons and navigation arrows.
