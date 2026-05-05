part of '../../overlay.dart';

/// PopoverOverlayHandler defines a reusable type for this registry module.
class PopoverOverlayHandler extends OverlayHandler {
  /// Creates a [PopoverOverlayHandler].
  const PopoverOverlayHandler();
  @override
  OverlayCompleter<T> show<T>({
    required BuildContext context,
    required AlignmentGeometry alignment,
    required WidgetBuilder builder,
    ui.Offset? position,
    AlignmentGeometry? anchorAlignment,
    PopoverConstraint widthConstraint = PopoverConstraint.flexible,
    PopoverConstraint heightConstraint = PopoverConstraint.flexible,
    Key? key,
    bool rootOverlay = true,
    bool modal = true,
    bool barrierDismissable = true,
    ui.Clip clipBehavior = Clip.none,
    Object? regionGroupId,
    ui.Offset? offset,
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

/// Stores `anchorSize` state/configuration for this implementation.
    Size? anchorSize;
    if (position == null) {
      RenderBox renderBox = context.findRenderObject() as RenderBox;
      Offset pos = renderBox.localToGlobal(Offset.zero);
      anchorSize ??= renderBox.size;
      position = Offset(
        pos.dx +
            anchorSize.width / 2 +
            anchorSize.width / 2 * resolvedAnchorAlignment.x,
        pos.dy +
            anchorSize.height / 2 +
            anchorSize.height / 2 * resolvedAnchorAlignment.y,
      );
    }
    final OverlayPopoverEntry<T> popoverEntry = OverlayPopoverEntry();
/// Stores `completer` state/configuration for this implementation.
    final completer = popoverEntry.completer;
/// Stores `animationCompleter` state/configuration for this implementation.
    final animationCompleter = popoverEntry.animationCompleter;
    ValueNotifier<bool> isClosed = ValueNotifier(false);
/// Stores `barrierEntry` state/configuration for this implementation.
    OverlayEntry? barrierEntry;
/// Stores `overlayEntry` state/configuration for this implementation.
    late OverlayEntry overlayEntry;
    if (modal) {
      if (consumeOutsideTaps) {
        barrierEntry = OverlayEntry(
          builder: (context) {
            return GestureDetector(
              onTap: () {
                if (!barrierDismissable || isClosed.value) return;
                isClosed.value = true;
                completer.complete();
              },
            );
          },
        );
      } else {
        barrierEntry = OverlayEntry(
          builder: (context) {
            return Listener(
              behavior: HitTestBehavior.translucent,
              onPointerDown: (event) {
                if (!barrierDismissable || isClosed.value) return;
                isClosed.value = true;
                completer.complete();
              },
            );
          },
        );
      }
    }

    overlayEntry = OverlayEntry(
      builder: (innerContext) {
        return RepaintBoundary(
          child: AnimatedBuilder(
            animation: isClosed,
            builder: (innerContext, child) {
              return FocusScope(
                autofocus: dismissBackdropFocus,
                canRequestFocus: !isClosed.value,
                child: AnimatedValueBuilder<double>(
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
                      position: position!,
                      alignment: resolvedAlignment,
                      themes: themes,
                      builder: builder,
                      anchorSize: anchorSize,
                      // anchorAlignment: anchorAlignment ?? alignment * -1,
                      anchorAlignment: resolvedAnchorAlignment,
                      widthConstraint: widthConstraint,
                      heightConstraint: heightConstraint,
                      regionGroupId: regionGroupId,
                      offset: offset,
                      transitionAlignment: transitionAlignment,
                      margin: margin,
                      follow: follow,
                      consumeOutsideTaps: consumeOutsideTaps,
                      onTickFollow: onTickFollow,
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
                ),
              );
            },
          ),
        );
      },
    );
    popoverEntry.initialize(overlayEntry, barrierEntry);
    if (barrierEntry != null) {
      overlay.insert(barrierEntry);
    }
    overlay.insert(overlayEntry);
    return popoverEntry;
  }
}

/// Internal widget for rendering popover overlays.
///
/// Manages positioning, constraints, and lifecycle of popover content
/// relative to an anchor widget.
