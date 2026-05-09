// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../drawer.dart';

DrawerOverlayCompleter<T?> openDrawerOverlay<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  required OverlayPosition position,
  bool expands = false,
  bool draggable = true,
  bool barrierDismissible = true,
  WidgetBuilder? backdropBuilder,
  bool useSafeArea = true,
  bool? showDragHandle,
  BorderRadiusGeometry? borderRadius,
  Size? dragHandleSize,
  bool transformBackdrop = true,
  double? surfaceOpacity,
  double? surfaceBlur,
  Color? barrierColor,
  AnimationController? animationController,
  bool autoOpen = true,
  BoxConstraints? constraints,
  AlignmentGeometry? alignment,
}) {
  final theme = ComponentTheme.maybeOf<DrawerTheme>(context);
  showDragHandle ??= theme?.showDragHandle ?? true;
  surfaceOpacity ??= theme?.surfaceOpacity;
  surfaceBlur ??= theme?.surfaceBlur;
  barrierColor ??= theme?.barrierColor;
  dragHandleSize ??= theme?.dragHandleSize;
  return openRawDrawer<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    backdropBuilder: backdropBuilder,
    useSafeArea: useSafeArea,
    transformBackdrop: transformBackdrop,
    animationController: animationController,
    autoOpen: autoOpen,
    constraints: constraints,
    alignment: alignment,
    builder: (context, extraSize, size, padding, stackIndex) {
      return DrawerWrapper(
        position: position,
        expands: expands,
        draggable: draggable,
        extraSize: extraSize,
        size: size,
        showDragHandle: showDragHandle ?? true,
        dragHandleSize: dragHandleSize,
        padding: padding,
        borderRadius: borderRadius,
        surfaceOpacity: surfaceOpacity,
        surfaceBlur: surfaceBlur,
        barrierColor: barrierColor,
        stackIndex: stackIndex,
        child: Builder(
          builder: (context) {
            return builder(context);
          },
        ),
      );
    },
    position: position,
  );
}

/// Opens a sheet overlay with minimal styling and full-screen expansion.
///
/// Creates a sheet overlay that slides in from the specified position,
/// typically used for bottom sheets or side panels. Unlike drawers,
/// sheets don't transform the backdrop and have minimal decoration.
///
/// Features:
/// - Full-screen expansion with edge-to-edge content
/// - Minimal styling and decoration
/// - Optional drag interaction
/// - Safe area integration
/// - Barrier dismissal support
///
/// Parameters:
/// - [context] (BuildContext, required): build context for overlay creation
/// - [builder] (WidgetBuilder, required): function that builds sheet content
/// - [position] (OverlayPosition, required): side from which sheet slides in
/// - [barrierDismissible] (bool, default: true): whether tapping barrier dismisses sheet
/// - [transformBackdrop] (bool, default: false): whether to transform backdrop
/// - [backdropBuilder] (WidgetBuilder?, optional): custom backdrop builder
/// - [barrierColor] (Color?, optional): color of the modal barrier
/// - [draggable] (bool, default: false): whether sheet can be dragged to dismiss
/// - [animationController] (AnimationController?, optional): custom animation controller
/// - [autoOpen] (bool, default: true): whether to automatically open on creation
/// - [constraints] (BoxConstraints?, optional): size constraints for sheet
/// - [alignment] (AlignmentGeometry?, optional): alignment within constraints
///
/// Returns:
/// A [DrawerOverlayCompleter] that provides control over the sheet lifecycle.
///
/// Example:
/// ```dart
/// final completer = openSheetOverlay<bool>(
///   context: context,
///   position: OverlayPosition.bottom,
///   builder: (context) => BottomSheetContent(),
///   draggable: true,
/// );
/// ```
DrawerOverlayCompleter<T?> openSheetOverlay<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  required OverlayPosition position,
  bool useRootDrawerOverlay = true,
  bool barrierDismissible = true,
  bool transformBackdrop = false,
  WidgetBuilder? backdropBuilder,
  Color? barrierColor,
  bool draggable = false,
  AnimationController? animationController,
  bool autoOpen = true,
  BoxConstraints? constraints,
  AlignmentGeometry? alignment,
}) {
  final theme = ComponentTheme.maybeOf<DrawerTheme>(context);
  barrierColor ??= theme?.barrierColor;
  return openRawDrawer<T>(
    context: context,
    useRootDrawerOverlay: useRootDrawerOverlay,
    transformBackdrop: transformBackdrop,
    barrierDismissible: barrierDismissible,
    useSafeArea: false, // handled by the sheet itself
    animationController: animationController,
    backdropBuilder: backdropBuilder,
    autoOpen: autoOpen,
    constraints: constraints,
    alignment: alignment,
    builder: (context, extraSize, size, padding, stackIndex) {
      return SheetWrapper(
        position: position,
        expands: true,
        draggable: draggable,
        extraSize: extraSize,
        size: size,
        padding: padding,
        barrierColor: barrierColor,
        stackIndex: stackIndex,
        child: Builder(
          builder: (context) {
            return builder(context);
          },
        ),
      );
    },
    position: position,
  );
}

/// Opens a drawer and returns a future that completes when dismissed.
///
/// Convenience function that opens a drawer overlay and returns the future
/// directly, suitable for use with async/await patterns.
///
/// Returns:
/// A [Future] that completes with the result when the drawer is dismissed.
///
/// Example:
/// ```dart
/// final result = await openDrawer<String>(
///   context: context,
///   position: OverlayPosition.left,
///   builder: (context) => MyDrawerContent(),
/// );
/// ```
Future<T?> openDrawer<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  required OverlayPosition position,
  bool expands = false,
  bool draggable = true,
  bool barrierDismissible = true,
  WidgetBuilder? backdropBuilder,
  bool useSafeArea = true,
  bool? showDragHandle,
  BorderRadiusGeometry? borderRadius,
  Size? dragHandleSize,
  bool transformBackdrop = true,
  double? surfaceOpacity,
  double? surfaceBlur,
  Color? barrierColor,
  AnimationController? animationController,
  BoxConstraints? constraints,
  AlignmentGeometry? alignment,
}) {
  return openDrawerOverlay<T>(
    context: context,
    builder: builder,
    position: position,
    expands: expands,
    draggable: draggable,
    barrierDismissible: barrierDismissible,
    backdropBuilder: backdropBuilder,
    useSafeArea: useSafeArea,
    showDragHandle: showDragHandle,
    borderRadius: borderRadius,
    dragHandleSize: dragHandleSize,
    transformBackdrop: transformBackdrop,
    surfaceOpacity: surfaceOpacity,
    surfaceBlur: surfaceBlur,
    barrierColor: barrierColor,
    animationController: animationController,
    constraints: constraints,
    alignment: alignment,
  ).future;
}

/// Opens a sheet and returns a future that completes when dismissed.
///
/// Convenience function that opens a sheet overlay and returns the future
/// directly, suitable for use with async/await patterns.
///
/// Returns:
/// A [Future] that completes with the result when the sheet is dismissed.
///
/// Example:
/// ```dart
/// final accepted = await openSheet<bool>(
///   context: context,
///   position: OverlayPosition.bottom,
///   builder: (context) => ConfirmationSheet(),
/// );
/// ```
Future<T?> openSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  required OverlayPosition position,
  bool useRootDrawerOverlay = true,
  bool barrierDismissible = true,
  bool transformBackdrop = false,
  Color? barrierColor,
  bool draggable = false,
  AnimationController? animationController,
  WidgetBuilder? backdropBuilder,
  BoxConstraints? constraints,
  AlignmentGeometry? alignment,
}) {
  return openSheetOverlay<T>(
    context: context,
    builder: builder,
    position: position,
    useRootDrawerOverlay: useRootDrawerOverlay,
    barrierDismissible: barrierDismissible,
    transformBackdrop: transformBackdrop,
    barrierColor: barrierColor,
    draggable: draggable,
    animationController: animationController,
    backdropBuilder: backdropBuilder,
    constraints: constraints,
    alignment: alignment,
  ).future;
}

/// Internal wrapper widget for drawer/sheet rendering.
///
/// Manages the visual presentation and interaction behavior of drawer overlays.
/// Handles sizing, positioning, drag interactions, and animations.
