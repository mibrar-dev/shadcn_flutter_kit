// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../swiper.dart';

/// DrawerSwiperHandler defines a reusable type for this registry module.
class DrawerSwiperHandler extends SwiperHandler {
  /// Creates a drawer-style swiper handler.
  const DrawerSwiperHandler();

  @override
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
  }) {
    return openDrawerOverlay(
      context: context,
      builder: builder,
      position: position,
      expands: expands ?? true,
      draggable: draggable ?? true,
      barrierDismissible: barrierDismissible ?? true,
      backdropBuilder: backdropBuilder,
      useSafeArea: useSafeArea ?? true,
      showDragHandle: showDragHandle ?? true,
      borderRadius: borderRadius,
      dragHandleSize: dragHandleSize,
      transformBackdrop: transformBackdrop ?? true,
      surfaceOpacity: surfaceOpacity,
      surfaceBlur: surfaceBlur,
      barrierColor: barrierColor,
      autoOpen: false,
    );
  }
}

/// Sheet-style swiper handler with minimal styling.
///
/// Creates swipers that behave like sheets with edge-to-edge content,
/// minimal decoration, and optional drag interaction.
///
/// Example:
/// ```dart
/// Swiper(
///   handler: SwiperHandler.sheet,
///   position: OverlayPosition.bottom,
///   builder: (context) => BottomSheetContent(),
///   child: ActionButton(),
/// )
/// ```
