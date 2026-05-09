// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../swiper.dart';

/// SwiperHandler defines a reusable type for this registry module.
abstract class SwiperHandler {
  /// Handler for drawer-style swipers with backdrop transformation.
  static const SwiperHandler drawer = DrawerSwiperHandler();

  /// Handler for sheet-style swipers with minimal styling.
  static const SwiperHandler sheet = SheetSwiperHandler();

  /// Creates a swiper handler.
  const SwiperHandler();

  /// Creates a swiper overlay with the specified configuration.
  ///
  /// Parameters vary by implementation but commonly include position,
  /// builder, and visual/behavioral properties.
  ///
  /// Returns:
  /// A [DrawerOverlayCompleter] for managing the swiper lifecycle.
  DrawerOverlayCompleter openSwiper({
    required BuildContext context,
    required WidgetBuilder builder,
    required OverlayPosition position,
    bool? expands,
    bool? draggable,
    bool? barrierDismissible,
    WidgetBuilder? backdropBuilder,
    bool? useSafeArea,
    bool? showDragHandle,
    BorderRadiusGeometry? borderRadius,
    Size? dragHandleSize,
    bool? transformBackdrop,
    double? surfaceOpacity,
    double? surfaceBlur,
    Color? barrierColor,
  });
}

/// Drawer-style swiper handler with backdrop transformation.
///
/// Creates swipers that behave like drawers with backdrop scaling,
/// drag handles, and full interaction support.
///
/// Example:
/// ```dart
/// Swiper(
///   handler: SwiperHandler.drawer,
///   position: OverlayPosition.left,
///   builder: (context) => DrawerContent(),
///   child: MenuButton(),
/// )
/// ```
