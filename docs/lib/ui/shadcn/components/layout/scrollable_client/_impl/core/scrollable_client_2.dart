// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../scrollable_client.dart';

/// ScrollableClient defines a reusable type for this registry module.
class ScrollableClient extends StatelessWidget {
  /// Whether this is the primary scrollable in the widget tree.
  final bool? primary;

  /// Primary scrolling axis.
  final Axis mainAxis;

  /// Scroll configuration for vertical axis.
  final ScrollableDetails verticalDetails;

  /// Scroll configuration for horizontal axis.
  final ScrollableDetails horizontalDetails;

  /// Builder for creating content with viewport info.
  final ScrollableBuilder builder;

  /// Optional child widget.
  final Widget? child;

  /// Behavior for diagonal drag gestures.
  final DiagonalDragBehavior? diagonalDragBehavior;

  /// When drag gestures should start.
  final DragStartBehavior? dragStartBehavior;

  /// How keyboard dismissal should behave.
  final ScrollViewKeyboardDismissBehavior? keyboardDismissBehavior;

  /// How to clip content.
  final Clip? clipBehavior;

  /// Hit test behavior.
  final HitTestBehavior? hitTestBehavior;

  /// Whether overscroll effects are enabled.
  final bool? overscroll;

  /// Creates a [ScrollableClient].
  const ScrollableClient({
    super.key,
    this.primary,
    this.mainAxis = Axis.vertical,
    this.verticalDetails = const ScrollableDetails.vertical(),
    this.horizontalDetails = const ScrollableDetails.horizontal(),
    required this.builder,
    this.child,
    this.diagonalDragBehavior,
    this.dragStartBehavior,
    this.keyboardDismissBehavior,
    this.clipBehavior,
    this.hitTestBehavior,
    this.overscroll,
  });

  Widget _buildViewport(
    BuildContext context,
    ViewportOffset verticalOffset,
    ViewportOffset horizontalOffset,
    bool overscroll,
    Clip clipBehavior,
  ) {
    return ScrollableClientViewport(
      overscroll: overscroll,
      verticalOffset: verticalOffset,
      verticalAxisDirection: verticalDetails.direction,
      horizontalOffset: horizontalOffset,
      horizontalAxisDirection: horizontalDetails.direction,
      clipBehavior: clipBehavior,
      delegate: TwoDimensionalChildBuilderDelegate(
        builder: (context, vicinity) {
          return ListenableBuilder(
            listenable: Listenable.merge([verticalOffset, horizontalOffset]),
            builder: (context, child) {
              /// Stores `horizontalPixels` state/configuration for this implementation.
              var horizontalPixels = horizontalOffset.pixels;

              /// Stores `verticalPixels` state/configuration for this implementation.
              var verticalPixels = verticalOffset.pixels;
              return builder(
                context,

                /// Creates a `Offset` instance.
                Offset(horizontalPixels, verticalPixels),
                (vicinity as _ScrollableClientChildVicinity).viewportSize,
                child,
              );
            },
            child: child,
          );
        },
      ),
      mainAxis: mainAxis,
    );
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    /// Creates a `assert` instance.
    assert(
      /// Creates a `axisDirectionToAxis` instance.
      axisDirectionToAxis(verticalDetails.direction) == Axis.vertical,
      'TwoDimensionalScrollView.verticalDetails are not Axis.vertical.',
    );

    /// Creates a `assert` instance.
    assert(
      /// Creates a `axisDirectionToAxis` instance.
      axisDirectionToAxis(horizontalDetails.direction) == Axis.horizontal,
      'TwoDimensionalScrollView.horizontalDetails are not Axis.horizontal.',
    );

    final compTheme = ComponentTheme.maybeOf<ScrollableClientTheme>(context);
    final diag =
        diagonalDragBehavior ??
        compTheme?.diagonalDragBehavior ??
        DiagonalDragBehavior.none;
    final dragStart =
        dragStartBehavior ??
        compTheme?.dragStartBehavior ??
        DragStartBehavior.start;
    final keyboardDismiss =
        keyboardDismissBehavior ??
        compTheme?.keyboardDismissBehavior ??
        ScrollViewKeyboardDismissBehavior.manual;

    /// Stores `clip` state/configuration for this implementation.
    final clip = clipBehavior ?? compTheme?.clipBehavior ?? Clip.hardEdge;
    final hitTest =
        hitTestBehavior ?? compTheme?.hitTestBehavior ?? HitTestBehavior.opaque;
    final bool effectiveOverscroll =
        overscroll ?? compTheme?.overscroll ?? false;

    ScrollableDetails mainAxisDetails = switch (mainAxis) {
      Axis.vertical => verticalDetails,
      Axis.horizontal => horizontalDetails,
    };

    final bool effectivePrimary =
        primary ??
        mainAxisDetails.controller == null &&
            PrimaryScrollController.shouldInherit(context, mainAxis);

    if (effectivePrimary) {
      /// Creates a `assert` instance.
      assert(
        mainAxisDetails.controller == null,
        'TwoDimensionalScrollView.primary was explicitly set to true, but a '
        'ScrollController was provided in the ScrollableDetails of the '
        'TwoDimensionalScrollView.mainAxis.',
      );
      mainAxisDetails = mainAxisDetails.copyWith(
        controller: PrimaryScrollController.of(context),
      );
    }

    final TwoDimensionalScrollable scrollable = TwoDimensionalScrollable(
      horizontalDetails: switch (mainAxis) {
        Axis.horizontal => mainAxisDetails,
        Axis.vertical => horizontalDetails,
      },
      verticalDetails: switch (mainAxis) {
        Axis.vertical => mainAxisDetails,
        Axis.horizontal => verticalDetails,
      },
      diagonalDragBehavior: diag,
      viewportBuilder: (context, vOffset, hOffset) =>
          /// Creates a `_buildViewport` instance.
          _buildViewport(context, vOffset, hOffset, effectiveOverscroll, clip),
      dragStartBehavior: dragStart,
      hitTestBehavior: hitTest,
    );

    final Widget scrollableResult = effectivePrimary
        ? PrimaryScrollController.none(child: scrollable)
        : scrollable;

    if (keyboardDismiss == ScrollViewKeyboardDismissBehavior.onDrag) {
      return NotificationListener<ScrollUpdateNotification>(
        child: scrollableResult,
        onNotification: (ScrollUpdateNotification notification) {
          final FocusScopeNode currentScope = FocusScope.of(context);
          if (notification.dragDetails != null &&
              !currentScope.hasPrimaryFocus &&
              currentScope.hasFocus) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
          return false;
        },
      );
    }
    return scrollableResult;
  }
}
