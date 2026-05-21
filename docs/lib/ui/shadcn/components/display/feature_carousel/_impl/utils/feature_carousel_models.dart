// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';

/// Function/type signature used by feature carousel APIs.
typedef FeatureCarouselIconBuilder =
    Widget Function(BuildContext context, Color accentColor, double size);

/// Core class used by the feature carousel component.
class FeatureCarouselItem {
  /// Text/content element used by `FeatureCarouselItem` when composing its visual layout.
  final String? title;

  /// Input parameter used by `FeatureCarouselItem` during rendering and behavior handling.
  final String? description;

  /// Input parameter used by `FeatureCarouselItem` during rendering and behavior handling.
  final IconData? icon;

  /// Input parameter used by `FeatureCarouselItem` during rendering and behavior handling.
  final FeatureCarouselIconBuilder? iconBuilder;

  /// Color value used by feature carousel painting or state styling.
  final Color? accentColor;

  /// Creates `FeatureCarouselItem` for configuring or rendering feature carousel.
  const FeatureCarouselItem({
    this.title,
    this.description,
    this.icon,
    this.iconBuilder,
    this.accentColor,
  });
}
