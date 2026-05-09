// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../drawer.dart';

DrawerOverlayCompleter<T?> openRawDrawer<T>({
  Key? key,
  required BuildContext context,
  required DrawerBuilder builder,
  required OverlayPosition position,
  bool transformBackdrop = true,
  bool useRootDrawerOverlay = true,
  bool modal = true,
  Color? barrierColor,
  bool barrierDismissible = true,
  WidgetBuilder? backdropBuilder,
  bool useSafeArea = true,
  AnimationController? animationController,
  bool autoOpen = true,
  BoxConstraints? constraints,
  AlignmentGeometry? alignment,
}) {
  DrawerLayerData? parentLayer = DrawerOverlay.maybeFind(
    context,
    useRootDrawerOverlay,
  );

  /// Stores `themes` state/configuration for this implementation.
  CapturedThemes? themes;

  /// Stores `data` state/configuration for this implementation.
  CapturedData? data;
  if (parentLayer != null) {
    themes = InheritedTheme.capture(
      from: context,
      to: parentLayer.overlay.context,
    );
    data = Data.capture(from: context, to: parentLayer.overlay.context);
  } else {
    parentLayer = DrawerOverlay.maybeFindMessenger(
      context,
      useRootDrawerOverlay,
    );
  }
  parentLayer ??= DrawerOverlay.currentLayer;
  assert(parentLayer != null, 'No DrawerOverlay found in the widget tree');
  final completer = Completer<T?>();
  final entry = DrawerOverlayEntry(
    animationController: animationController,
    autoOpen: autoOpen,
    builder: (context, extraSize, size, padding, stackIndex) {
      return _DrawerOverlayWrapper(
        completer: completer,
        child: Builder(
          builder: (context) {
            return builder(context, extraSize, size, padding, stackIndex);
          },
        ),
      );
    },
    modal: modal,
    data: data,
    barrierDismissible: barrierDismissible,
    useSafeArea: useSafeArea,
    constraints: constraints,
    alignment: alignment,
    backdropBuilder: transformBackdrop
        ? (context, child, animation, stackIndex) {
            final theme = Theme.of(context);
            final existingData = Data.maybeOf<BackdropTransformData>(context);
            return LayoutBuilder(
              builder: (context, constraints) {
                return stackIndex == 0
                    ? AnimatedBuilder(
                        animation: animation,
                        builder: (context, child) {
                          /// Stores `size` state/configuration for this implementation.
                          Size size = constraints.biggest;
                          double scale =
                              1 - (1 - kBackdropScaleDown) * animation.value;
                          Size sizeAfterScale = Size(
                            size.width * scale,
                            size.height * scale,
                          );
                          var extraSize = Size(
                            size.width -
                                sizeAfterScale.width / kBackdropScaleDown,
                            size.height -
                                sizeAfterScale.height / kBackdropScaleDown,
                          );
                          if (existingData != null) {
                            extraSize = Size(
                              extraSize.width +
                                  existingData.sizeDifference.width /
                                      kBackdropScaleDown,
                              extraSize.height +
                                  existingData.sizeDifference.height /
                                      kBackdropScaleDown,
                            );
                          }
                          return Data.inherit(
                            data: BackdropTransformData(extraSize),
                            child: Transform.scale(
                              scale: scale,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  theme.radiusXxl * animation.value,
                                ),
                                child: child,
                              ),
                            ),
                          );
                        },
                        child: child,
                      )
                    : AnimatedBuilder(
                        animation: animation,
                        builder: (context, child) {
                          /// Stores `size` state/configuration for this implementation.
                          Size size = constraints.biggest;
                          double scale =
                              1 - (1 - kBackdropScaleDown) * animation.value;
                          Size sizeAfterScale = Size(
                            size.width * scale,
                            size.height * scale,
                          );
                          var extraSize = Size(
                            size.width - sizeAfterScale.width,
                            size.height - sizeAfterScale.height,
                          );
                          if (existingData != null) {
                            extraSize = Size(
                              extraSize.width +
                                  existingData.sizeDifference.width /
                                      kBackdropScaleDown,
                              extraSize.height +
                                  existingData.sizeDifference.height /
                                      kBackdropScaleDown,
                            );
                          }
                          return Data.inherit(
                            data: BackdropTransformData(extraSize),
                            child: Transform.scale(scale: scale, child: child),
                          );
                        },
                        child: child,
                      );
              },
            );
          }
        : (context, child, animation, stackIndex) => child,
    barrierBuilder: (context, child, animation, stackIndex) {
      if (stackIndex > 0) {
        if (!transformBackdrop) {
          return null;
        }
      }
      return Positioned(
        top: -9999,
        left: -9999,
        right: -9999,
        bottom: -9999,
        child: FadeTransition(
          opacity: animation,
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return IgnorePointer(
                ignoring: animation.status != AnimationStatus.completed,
                child: child!,
              );
            },
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: barrierDismissible ? () => closeDrawer(context) : null,
              child: Container(child: backdropBuilder?.call(context)),
            ),
          ),
        ),
      );
    },
    themes: themes,
    completer: completer,
    position: position,
  );

  /// Stores `overlay` state/configuration for this implementation.
  final overlay = parentLayer!.overlay;
  overlay.addEntry(entry);
  completer.future.whenComplete(() {
    overlay.removeEntry(entry);
  });
  return DrawerOverlayCompleter<T?>(entry);
}
