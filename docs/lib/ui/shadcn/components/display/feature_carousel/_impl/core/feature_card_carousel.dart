// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../feature_carousel.dart';

/// Core class used by the feature carousel component.
class FeatureCardCarousel extends StatefulWidget {
  /// Creates `FeatureCardCarousel` for configuring or rendering feature carousel.
  const FeatureCardCarousel({
    super.key,
    required this.items,
    this.height,
    this.width,
    this.controller,
    this.theme,
    this.cardBuilder,
    this.titleBuilder,
    this.descriptionBuilder,
    this.ctaBuilder,
    this.backgroundBuilder,
  });

  /// Data consumed by `FeatureCardCarousel` to render feature carousel content.
  final List<FeatureCarouselItem> items;

  /// Layout/size setting that affects feature carousel rendering.
  final double? height;

  /// Layout/size setting that affects feature carousel rendering.
  final double? width;

  /// Controller reference used to coordinate feature carousel behavior.
  final FeatureCarouselController? controller;

  /// Theme override or resolved theme data for feature carousel.
  final FeatureCarouselThemeData? theme;
  final Widget Function(
    BuildContext context,
    FeatureCarouselItem item,
    int index,
    FeatureCarouselThemeData theme,
  )?
  cardBuilder;
  final Widget Function(
    BuildContext context,
    FeatureCarouselItem item,
    int index,
  )?
  titleBuilder;
  final Widget Function(
    BuildContext context,
    FeatureCarouselItem item,
    int index,
  )?
  descriptionBuilder;
  final Widget Function(
    BuildContext context,
    FeatureCarouselItem item,
    int index,
    VoidCallback onAction,
  )?
  ctaBuilder;
  final Widget Function(BuildContext context, FeatureCarouselThemeData theme)?
  backgroundBuilder;

  /// Creates the State object used by this feature carousel widget.
  @override
  State<FeatureCardCarousel> createState() => _FeatureCardCarouselState();
}
