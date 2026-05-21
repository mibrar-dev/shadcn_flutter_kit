// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../swiper.dart';

/// SheetSwiperHandler defines a reusable type for this registry module.
class SheetSwiperHandler extends SwiperHandler {
  /// Creates a sheet-style swiper handler.
  const SheetSwiperHandler();

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
    return openSheetOverlay(
      context: context,
      builder: builder,
      position: position,
      barrierDismissible: barrierDismissible ?? true,
      backdropBuilder: backdropBuilder,
      transformBackdrop: transformBackdrop ?? false,
      barrierColor: barrierColor,
      draggable: draggable ?? false,
      autoOpen: false,
    );
  }
}

/// A gesture-responsive widget that triggers overlay content through swiping.
///
/// Detects swipe gestures on the child widget and displays overlay content
/// using the configured handler (drawer or sheet style). Supports both
/// programmatic and gesture-based triggering with comprehensive customization.
///
/// Features:
/// - Gesture-based overlay triggering
/// - Multiple handler implementations (drawer/sheet)
/// - Configurable swipe sensitivity and behavior
/// - Theme integration and visual customization
/// - Programmatic control and dismissal
/// - Position-aware gesture detection
///
/// The swiper responds to swipe gestures in the direction that would reveal
/// the overlay (e.g., swiping right reveals a left-positioned overlay).
///
/// Example:
/// ```dart
/// Swiper(
///   handler: SwiperHandler.drawer,
///   position: OverlayPosition.left,
///   builder: (context) => NavigationDrawer(),
///   child: AppBar(
///     leading: Icon(Icons.menu),
///     title: Text('My App'),
///   ),
/// )
/// ```
