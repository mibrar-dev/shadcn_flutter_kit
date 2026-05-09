// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' show Axis, Colors;
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

import '../../../shared/theme/theme.dart';
import '../../../shared/utils/constants.dart';
import '../../../shared/utils/style_value.dart';
import '../basic/basic.dart';
import '../../control/button/button.dart';
import '../outlined_container/outlined_container.dart';
part '_impl/state/_card_image_state.dart';
part '_impl/core/card_image_2.dart';

/// Theme configuration for [CardImage] components.
class CardImageTheme extends ComponentThemeData {
  /// Button style for the card.
  final AbstractButtonStyle? style;

  /// Layout direction for title/subtitle relative to the image.
  final Axis? direction;

  /// Scale factor when hovering over the image.
  final double? hoverScale;

  /// Normal scale factor for the image.
  final double? normalScale;

  /// Background color for the image container.
  final Color? backgroundColor;

  /// Border color for the image container.
  final Color? borderColor;

  /// Gap between image and text content.
  final double? gap;

  const CardImageTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.style,
    this.direction,
    this.hoverScale,
    this.normalScale,
    this.backgroundColor,
    this.borderColor,
    this.gap,
  });

  /// Creates a `CardImageTheme` instance.
  CardImageTheme copyWith({
    ValueGetter<AbstractButtonStyle?>? style,
    ValueGetter<Axis?>? direction,
    ValueGetter<double?>? hoverScale,
    ValueGetter<double?>? normalScale,
    ValueGetter<Color?>? backgroundColor,
    ValueGetter<Color?>? borderColor,
    ValueGetter<double?>? gap,
  }) {
    return CardImageTheme(
      style: style == null ? this.style : style(),
      direction: direction == null ? this.direction : direction(),
      hoverScale: hoverScale == null ? this.hoverScale : hoverScale(),
      normalScale: normalScale == null ? this.normalScale : normalScale(),
      backgroundColor: backgroundColor == null
          ? this.backgroundColor
          : backgroundColor(),
      borderColor: borderColor == null ? this.borderColor : borderColor(),
      gap: gap == null ? this.gap : gap(),
    );
  }

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    return other is CardImageTheme &&
        other.style == style &&
        other.direction == direction &&
        other.hoverScale == hoverScale &&
        other.normalScale == normalScale &&
        other.backgroundColor == backgroundColor &&
        other.borderColor == borderColor &&
        other.gap == gap;
  }

  @override
  int get hashCode => Object.hash(
    style,
    direction,
    hoverScale,
    normalScale,
    backgroundColor,
    borderColor,
    gap,
  );
}

/// Interactive card component with an image and optional text content.
