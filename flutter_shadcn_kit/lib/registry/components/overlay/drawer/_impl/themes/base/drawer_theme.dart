// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../drawer.dart';

/// DrawerTheme defines a reusable type for this registry module.
class DrawerTheme extends ComponentThemeData {
  /// Surface opacity for backdrop effects.
  final double? surfaceOpacity;

  /// Surface blur intensity for backdrop effects.
  final double? surfaceBlur;

  /// Color of the barrier behind the drawer.
  final Color? barrierColor;

  /// Whether to display the drag handle for draggable drawers.
  final bool? showDragHandle;

  /// Size of the drag handle when displayed.
  final Size? dragHandleSize;

  /// Creates a [DrawerTheme].
  ///
  /// All parameters are optional and will use system defaults when null.
  ///
  /// Parameters:
  /// - [surfaceOpacity] (double?, optional): opacity for backdrop surface effects
  /// - [surfaceBlur] (double?, optional): blur intensity for backdrop effects
  /// - [barrierColor] (Color?, optional): color of the modal barrier
  /// - [showDragHandle] (bool?, optional): whether to show drag handles
  /// - [dragHandleSize] (Size?, optional): size of the drag handle
  ///
  /// Example:
  /// ```dart
  /// const DrawerTheme(
  ///   surfaceOpacity: 0.95,
  ///   showDragHandle: true,
  ///   barrierColor: Color.fromRGBO(0, 0, 0, 0.7),
  /// )
  /// ```
  const DrawerTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.surfaceOpacity,
    this.surfaceBlur,
    this.barrierColor,
    this.showDragHandle,
    this.dragHandleSize,
  });

  /// Creates a copy of this theme with the given fields replaced.
  ///
  /// Parameters:
  /// - [surfaceOpacity] (`ValueGetter<double?>?`, optional): New surface opacity.
  /// - [surfaceBlur] (`ValueGetter<double?>?`, optional): New surface blur amount.
  /// - [barrierColor] (`ValueGetter<Color?>?`, optional): New barrier color.
  /// - [showDragHandle] (`ValueGetter<bool?>?`, optional): New show drag handle setting.
  /// - [dragHandleSize] (`ValueGetter<Size?>?`, optional): New drag handle size.
  ///
  /// Returns: A new [DrawerTheme] with updated properties.
  DrawerTheme copyWith({
    ValueGetter<double?>? surfaceOpacity,
    ValueGetter<double?>? surfaceBlur,
    ValueGetter<Color?>? barrierColor,
    ValueGetter<bool?>? showDragHandle,
    ValueGetter<Size?>? dragHandleSize,
  }) {
    return DrawerTheme(
      surfaceOpacity: surfaceOpacity == null
          ? this.surfaceOpacity
          : surfaceOpacity(),
      surfaceBlur: surfaceBlur == null ? this.surfaceBlur : surfaceBlur(),
      barrierColor: barrierColor == null ? this.barrierColor : barrierColor(),
      showDragHandle: showDragHandle == null
          ? this.showDragHandle
          : showDragHandle(),
      dragHandleSize: dragHandleSize == null
          ? this.dragHandleSize
          : dragHandleSize(),
    );
  }

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) =>
      other is DrawerTheme &&
      other.surfaceOpacity == surfaceOpacity &&
      other.surfaceBlur == surfaceBlur &&
      other.barrierColor == barrierColor &&
      other.showDragHandle == showDragHandle &&
      other.dragHandleSize == dragHandleSize;

  @override
  int get hashCode => Object.hash(
    surfaceOpacity,
    surfaceBlur,
    barrierColor,
    showDragHandle,
    dragHandleSize,
  );

  @override
  /// Executes `toString` behavior for this component/composite.
  String toString() =>
      'DrawerTheme(surfaceOpacity: $surfaceOpacity, surfaceBlur: $surfaceBlur, barrierColor: $barrierColor, showDragHandle: $showDragHandle, dragHandleSize: $dragHandleSize)';
}

/// Opens a drawer overlay with comprehensive customization options.
///
/// Creates a modal drawer that slides in from the specified position with
/// draggable interaction, backdrop transformation, and proper theme integration.
/// Returns a completer that can be used to control the drawer lifecycle.
///
/// Features:
/// - Configurable slide-in positions (left, right, top, bottom)
/// - Draggable interaction with gesture support
/// - Backdrop transformation and scaling effects
/// - Safe area handling and proper theming
/// - Dismissible barriers and custom backdrop builders
///
/// Parameters:
/// - [context] (BuildContext, required): build context for overlay creation
/// - [builder] (WidgetBuilder, required): function that builds drawer content
/// - [position] (OverlayPosition, required): side from which drawer slides in
/// - [expands] (bool, default: false): whether drawer should expand to fill available space
/// - [draggable] (bool, default: true): whether drawer can be dragged to dismiss
/// - [barrierDismissible] (bool, default: true): whether tapping barrier dismisses drawer
/// - [backdropBuilder] (WidgetBuilder?, optional): custom backdrop builder
/// - [useSafeArea] (bool, default: true): whether to respect device safe areas
/// - [showDragHandle] (bool?, optional): whether to show drag handle
/// - [borderRadius] (BorderRadiusGeometry?, optional): corner radius for drawer
/// - [dragHandleSize] (Size?, optional): size of the drag handle
/// - [transformBackdrop] (bool, default: true): whether to scale backdrop
/// - [surfaceOpacity] (double?, optional): opacity for surface effects
/// - [surfaceBlur] (double?, optional): blur intensity for surface effects
/// - [barrierColor] (Color?, optional): color of the modal barrier
/// - [animationController] (AnimationController?, optional): custom animation controller
/// - [autoOpen] (bool, default: true): whether to automatically open on creation
/// - [constraints] (BoxConstraints?, optional): size constraints for drawer
/// - [alignment] (AlignmentGeometry?, optional): alignment within constraints
///
/// Returns:
/// A [DrawerOverlayCompleter] that provides control over the drawer lifecycle.
///
/// Example:
/// ```dart
/// final completer = openDrawerOverlay<String>(
///   context: context,
///   position: OverlayPosition.left,
///   builder: (context) => DrawerContent(),
///   draggable: true,
///   barrierDismissible: true,
/// );
/// final result = await completer.future;
/// ```
