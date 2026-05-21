// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../drawer.dart';

/// SheetOverlayHandler defines a reusable type for this registry module.
class SheetOverlayHandler extends OverlayHandler {
  /// Checks if the current context is within a sheet overlay.
  ///
  /// Parameters:
  /// - [context] (BuildContext, required): Build context to check
  ///
  /// Returns true if context is within a sheet overlay, false otherwise.
  static bool isSheetOverlay(BuildContext context) {
    return Model.maybeOf<bool>(context, #shadcn_flutter_sheet_overlay) == true;
  }

  /// Position where the sheet appears.
  final OverlayPosition position;

  /// Optional barrier color for the modal backdrop.
  final Color? barrierColor;

  /// Creates a sheet overlay handler.
  ///
  /// Parameters:
  /// - [position] (OverlayPosition): Sheet position, defaults to bottom
  /// - [barrierColor] (Color?): Optional barrier color
  const SheetOverlayHandler({
    this.position = OverlayPosition.bottom,
    this.barrierColor,
  });

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SheetOverlayHandler &&
        other.position == position &&
        other.barrierColor == barrierColor;
  }

  @override
  int get hashCode => Object.hash(position, barrierColor);

  @override
  OverlayCompleter<T?> show<T>({
    required BuildContext context,
    required AlignmentGeometry alignment,
    required WidgetBuilder builder,
    Offset? position,
    AlignmentGeometry? anchorAlignment,
    PopoverConstraint widthConstraint = PopoverConstraint.flexible,
    PopoverConstraint heightConstraint = PopoverConstraint.flexible,
    Key? key,
    bool rootOverlay = true,
    bool modal = true,
    bool barrierDismissable = true,
    Clip clipBehavior = Clip.none,
    Object? regionGroupId,
    Offset? offset,
    AlignmentGeometry? transitionAlignment,
    EdgeInsetsGeometry? margin,
    bool follow = true,
    bool consumeOutsideTaps = true,
    ValueChanged<PopoverOverlayWidgetState>? onTickFollow,
    bool allowInvertHorizontal = true,
    bool allowInvertVertical = true,
    bool dismissBackdropFocus = true,
    Duration? showDuration,
    Duration? dismissDuration,
    OverlayBarrier? overlayBarrier,
    LayerLink? layerLink,
  }) {
    return openRawDrawer<T>(
      context: context,
      transformBackdrop: false,
      useSafeArea: true,
      barrierDismissible: barrierDismissable,
      builder: (context, extraSize, size, padding, stackIndex) {
        final theme = Theme.of(context);
        return MultiModel(
          data: const [Model(#shadcn_flutter_sheet_overlay, true)],
          child: SheetWrapper(
            position: this.position,
            gapAfterDragger: 8 * theme.scaling,
            expands: true,
            extraSize: extraSize,
            size: size,
            draggable: barrierDismissable,
            padding: padding,
            barrierColor: barrierColor,
            stackIndex: stackIndex,
            child: Builder(
              builder: (context) {
                return builder(context);
              },
            ),
          ),
        );
      },
      position: this.position,
    );
  }
}
