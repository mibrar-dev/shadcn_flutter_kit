// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../tooltip.dart';

/// FixedTooltipOverlayHandler defines a reusable type for this registry module.
class FixedTooltipOverlayHandler extends OverlayHandler {
  const FixedTooltipOverlayHandler();

  @override
  OverlayCompleter<T> show<T>({
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
    TextDirection textDirection = Directionality.of(context);
    Alignment resolvedAlignment = alignment.resolve(textDirection);
    anchorAlignment ??= alignment * -1;
    Alignment resolvedAnchorAlignment = anchorAlignment.resolve(textDirection);
    final OverlayState overlay = Overlay.of(context, rootOverlay: rootOverlay);
    final themes = InheritedTheme.capture(from: context, to: overlay.context);
    final data = Data.capture(from: context, to: overlay.context);

    ValueNotifier<bool> isClosed = ValueNotifier(false);

    /// Stores `overlayEntry` state/configuration for this implementation.
    late OverlayEntry overlayEntry;
    final OverlayPopoverEntry<T> popoverEntry = OverlayPopoverEntry();

    /// Stores `completer` state/configuration for this implementation.
    final completer = popoverEntry.completer;

    /// Stores `animationCompleter` state/configuration for this implementation.
    final animationCompleter = popoverEntry.animationCompleter;
    overlayEntry = OverlayEntry(
      builder: (innerContext) {
        return RepaintBoundary(
          child: FocusScope(
            autofocus: dismissBackdropFocus,
            child: AnimatedBuilder(
              animation: isClosed,
              builder: (innerContext, child) {
                return AnimatedValueBuilder<double>(
                  value: isClosed.value ? 0.0 : 1.0,
                  initialValue: 0.0,
                  curve: isClosed.value
                      ? const Interval(0, 2 / 3)
                      : Curves.linear,
                  duration: isClosed.value
                      ? (showDuration ?? kDefaultDuration)
                      : (dismissDuration ?? const Duration(milliseconds: 100)),
                  onEnd: (value) {
                    if (value == 0.0 && isClosed.value) {
                      popoverEntry.remove();
                      popoverEntry.dispose();
                      animationCompleter.complete();
                    }
                  },
                  builder: (innerContext, animation, child) {
                    final theme = Theme.of(innerContext);
                    var popoverAnchor = PopoverOverlayWidget(
                      animation: animation,
                      onTapOutside: () {
                        if (isClosed.value) return;
                        if (!modal) {
                          isClosed.value = true;
                          completer.complete();
                        }
                      },
                      key: key,
                      anchorContext: context,
                      position: position,
                      alignment: resolvedAlignment,
                      themes: themes,
                      builder: builder,
                      anchorAlignment: resolvedAnchorAlignment,
                      widthConstraint: widthConstraint,
                      heightConstraint: heightConstraint,
                      regionGroupId: regionGroupId,
                      offset: offset,
                      transitionAlignment: Alignment.center,
                      margin: EdgeInsets.all(
                        theme.density.baseContainerPadding * theme.scaling * 3,
                      ),
                      follow: follow,
                      consumeOutsideTaps: consumeOutsideTaps,
                      allowInvertHorizontal: allowInvertHorizontal,
                      allowInvertVertical: allowInvertVertical,
                      data: data,
                      onClose: () {
                        if (isClosed.value) return Future.value();
                        isClosed.value = true;
                        completer.complete();
                        return animationCompleter.future;
                      },
                      onImmediateClose: () {
                        popoverEntry.remove();
                        completer.complete();
                      },
                      onCloseWithResult: (value) {
                        if (isClosed.value) return Future.value();
                        isClosed.value = true;
                        completer.complete(value as T);
                        return animationCompleter.future;
                      },
                    );
                    return popoverAnchor;
                  },
                );
              },
            ),
          ),
        );
      },
    );
    popoverEntry.initialize(overlayEntry);
    overlay.insert(overlayEntry);
    return popoverEntry;
  }
}
