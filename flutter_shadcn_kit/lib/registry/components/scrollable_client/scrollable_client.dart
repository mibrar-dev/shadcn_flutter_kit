// @dart=3.13
// The `scrollable_client` component: a two-dimensional scroll surface whose
// content is built with the current offset and viewport size.
//
// This is the superset copy the old `layout/scrollable_client` directory
// held; `table` imports it. The `ScrollableClient*` fork that lived inside
// `layout/scrollable` is deleted there, so every name below has exactly one
// owner. The render object clamps with `primitives/scroll_metrics.dart`.

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../primitives/scroll_metrics.dart';
import '../../theme/theme.dart';
import 'scrollable_client_style.dart';

export 'scrollable_client_style.dart';

/// Builds content for a viewport of [viewportSize] at scroll [offset].
typedef ScrollableBuilder = Widget Function(
  BuildContext context,
  Offset offset,
  Size viewportSize,
  Widget? child,
);

/// A scrollable surface that scrolls on both axes.
///
/// The [builder] receives the current offset and the viewport size, so
/// content can translate, zoom or virtualise itself. When [overscroll] is
/// true the offset may leave the content bounds; otherwise it is clamped.
class ScrollableClient extends StatelessWidget {
  /// Creates a two-dimensional scrollable client.
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
    this.theme,
  });

  /// Whether this is the primary scrollable of the [mainAxis].
  final bool? primary;

  /// Axis that inherits the primary controller and the keyboard dismissal.
  final Axis mainAxis;

  /// Controller, physics and axis direction of the vertical axis.
  final ScrollableDetails verticalDetails;

  /// Controller, physics and axis direction of the horizontal axis.
  final ScrollableDetails horizontalDetails;

  /// Builds the content for the current offset and viewport size.
  final ScrollableBuilder builder;

  /// Optional child handed through to [builder].
  final Widget? child;

  /// How diagonal drags pick an axis.
  final DiagonalDragBehavior? diagonalDragBehavior;

  /// When drag gestures start.
  final DragStartBehavior? dragStartBehavior;

  /// Keyboard dismissal on drag.
  final ScrollViewKeyboardDismissBehavior? keyboardDismissBehavior;

  /// Viewport clipping.
  final Clip? clipBehavior;

  /// Hit-test behaviour of the scrollable.
  final HitTestBehavior? hitTestBehavior;

  /// Whether offsets may move past the content edges.
  final bool? overscroll;

  /// Widget-leg style override, merged on top of the other resolver legs.
  final ScrollableClientTheme? theme;

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
            listenable: Listenable.merge(<Listenable>[
              verticalOffset,
              horizontalOffset,
            ]),
            builder: (context, child) {
              return builder(
                context,
                Offset(horizontalOffset.pixels, verticalOffset.pixels),
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
  Widget build(BuildContext context) {
    assert(
      axisDirectionToAxis(verticalDetails.direction) == Axis.vertical,
      'ScrollableClient.verticalDetails are not Axis.vertical.',
    );
    assert(
      axisDirectionToAxis(horizontalDetails.direction) == Axis.horizontal,
      'ScrollableClient.horizontalDetails are not Axis.horizontal.',
    );

    final ScrollableClientTheme resolved =
        resolveComponentStyle<ScrollableClientTheme, ScrollableClientTheme>(
          context,
          widget: theme,
          select: (t) => t,
          defaults: scrollableClientDefaults,
        );
    final DiagonalDragBehavior diagonal =
        diagonalDragBehavior ??
        resolved.diagonalDragBehavior ??
        DiagonalDragBehavior.none;
    final DragStartBehavior dragStart =
        dragStartBehavior ??
        resolved.dragStartBehavior ??
        DragStartBehavior.start;
    final ScrollViewKeyboardDismissBehavior keyboardDismiss =
        keyboardDismissBehavior ??
        resolved.keyboardDismissBehavior ??
        ScrollViewKeyboardDismissBehavior.manual;
    final Clip clip = clipBehavior ?? resolved.clipBehavior ?? Clip.hardEdge;
    final HitTestBehavior hitTest =
        hitTestBehavior ?? resolved.hitTestBehavior ?? HitTestBehavior.opaque;
    final bool effectiveOverscroll = overscroll ?? resolved.overscroll ?? false;

    ScrollableDetails mainAxisDetails = switch (mainAxis) {
      Axis.vertical => verticalDetails,
      Axis.horizontal => horizontalDetails,
    };

    final bool effectivePrimary =
        primary ??
        mainAxisDetails.controller == null &&
            PrimaryScrollController.shouldInherit(context, mainAxis);

    if (effectivePrimary) {
      assert(
        mainAxisDetails.controller == null,
        'ScrollableClient.primary was explicitly set to true, but a '
        'ScrollController was provided in the ScrollableDetails of '
        'ScrollableClient.mainAxis.',
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
      diagonalDragBehavior: diagonal,
      viewportBuilder: (context, vOffset, hOffset) =>
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
        onNotification: (notification) {
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

/// Viewport widget for [ScrollableClient] with two-dimensional scrolling.
class ScrollableClientViewport extends TwoDimensionalViewport {
  /// Whether the offset may move past the content edges.
  final bool overscroll;

  /// Creates a viewport for a [ScrollableClient].
  const ScrollableClientViewport({
    super.key,
    required super.verticalOffset,
    required super.verticalAxisDirection,
    required super.horizontalOffset,
    required super.horizontalAxisDirection,
    required super.delegate,
    required super.mainAxis,
    super.scrollCacheExtent,
    super.clipBehavior = Clip.hardEdge,
    required this.overscroll,
  });

  @override
  RenderTwoDimensionalViewport createRenderObject(BuildContext context) {
    return RenderScrollableClientViewport(
      horizontalOffset: horizontalOffset,
      horizontalAxisDirection: horizontalAxisDirection,
      verticalOffset: verticalOffset,
      verticalAxisDirection: verticalAxisDirection,
      delegate: delegate,
      mainAxis: mainAxis,
      childManager: context as TwoDimensionalChildManager,
      scrollCacheExtent: scrollCacheExtent,
      clipBehavior: clipBehavior,
      overscroll: overscroll,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderScrollableClientViewport renderObject,
  ) {
    renderObject
      ..horizontalOffset = horizontalOffset
      ..horizontalAxisDirection = horizontalAxisDirection
      ..verticalOffset = verticalOffset
      ..verticalAxisDirection = verticalAxisDirection
      ..delegate = delegate
      ..mainAxis = mainAxis
      ..scrollCacheExtent = scrollCacheExtent
      ..clipBehavior = clipBehavior
      ..overscroll = overscroll;
  }
}

/// Render object for [ScrollableClientViewport].
///
/// The single child is laid out at the viewport size and translated by the
/// (clamped) offset; both offsets get the content dimensions of that child.
class RenderScrollableClientViewport extends RenderTwoDimensionalViewport {
  /// Whether the offset may move past the content edges.
  bool get overscroll => _overscroll;
  bool _overscroll;

  set overscroll(bool value) {
    if (_overscroll == value) {
      return;
    }
    _overscroll = value;
    markNeedsLayout();
  }

  /// Creates a render object for a [ScrollableClientViewport].
  RenderScrollableClientViewport({
    required super.horizontalOffset,
    required super.horizontalAxisDirection,
    required super.verticalOffset,
    required super.verticalAxisDirection,
    required super.delegate,
    required super.mainAxis,
    required super.childManager,
    super.scrollCacheExtent,
    super.clipBehavior = Clip.hardEdge,
    required this._overscroll,
  });

  @override
  void layoutChildSequence() {
    double horizontalPixels = horizontalOffset.pixels;
    double verticalPixels = verticalOffset.pixels;
    final Size viewportDimension = this.viewportDimension;
    final ChildVicinity vicinity = _ScrollableClientChildVicinity(
      viewportSize: viewportDimension,
      xIndex: 0,
      yIndex: 0,
    );
    final RenderBox child = buildOrObtainChildFor(vicinity)!;
    child.layout(
      BoxConstraints(
        minWidth: constraints.maxWidth,
        minHeight: constraints.maxHeight,
      ),
      parentUsesSize: true,
    );
    final double maxHorizontal = maxScrollExtentFor(
      contentExtent: child.size.width,
      viewportExtent: viewportDimension.width,
    );
    final double maxVertical = maxScrollExtentFor(
      contentExtent: child.size.height,
      viewportExtent: viewportDimension.height,
    );
    if (!overscroll) {
      horizontalPixels = clampScrollPixels(
        horizontalPixels,
        minScrollExtent: 0,
        maxScrollExtent: maxHorizontal,
      );
      verticalPixels = clampScrollPixels(
        verticalPixels,
        minScrollExtent: 0,
        maxScrollExtent: maxVertical,
      );
    }
    parentDataOf(child).layoutOffset = Offset(
      -horizontalPixels,
      -verticalPixels,
    );
    horizontalOffset.applyContentDimensions(0, maxHorizontal);
    verticalOffset.applyContentDimensions(0, maxVertical);
    horizontalOffset.applyViewportDimension(viewportDimension.width);
    verticalOffset.applyViewportDimension(viewportDimension.height);
  }
}

/// Child vicinity carrying the viewport size the builder receives.
class _ScrollableClientChildVicinity extends ChildVicinity {
  /// Size of the visible viewport.
  final Size viewportSize;

  /// Creates a vicinity for the single content child.
  const _ScrollableClientChildVicinity({
    required this.viewportSize,
    required super.xIndex,
    required super.yIndex,
  });
}
