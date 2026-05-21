// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../drawer.dart';

/// _DrawerOverlayWrapperState defines a reusable type for this registry module.
class _DrawerOverlayWrapperState extends State<_DrawerOverlayWrapper>
    with OverlayHandlerStateMixin {
  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Data<OverlayHandlerStateMixin>.inherit(
      data: this,
      child: widget.child,
    );
  }

  @override
  /// Executes `close` behavior for this component/composite.
  Future<void> close([bool immediate = false]) {
    if (immediate) {
      widget.completer.complete();
      return widget.completer.future;
    }
    return closeDrawer(context);
  }

  @override
  /// Executes `closeLater` behavior for this component/composite.
  void closeLater() {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (mounted) {
          closeDrawer(context);
        } else {
          widget.completer.complete();
        }
      });
    }
  }

  @override
  Future<void> closeWithResult<X>([X? value]) {
    return closeDrawer(context, value);
  }
}

/// Opens a raw drawer overlay with full customization.
///
/// Low-level function for creating custom drawer overlays. Provides complete
/// control over drawer positioning, appearance, and behavior.
///
/// Parameters:
/// - [key] (`Key?`, optional): Widget key.
/// - [context] (`BuildContext`, required): Build context.
/// - [builder] (`DrawerBuilder`, required): Drawer content builder.
/// - [position] (`OverlayPosition`, required): Drawer position on screen.
/// - [transformBackdrop] (`bool`, default: `true`): Whether to transform backdrop.
/// - [useRootDrawerOverlay] (`bool`, default: `true`): Use root overlay.
/// - [modal] (`bool`, default: `true`): Whether drawer is modal.
/// - [barrierColor] (`Color?`, optional): Barrier color.
/// - [barrierDismissible] (`bool`, default: `true`): Dismissible by tapping barrier.
/// - [backdropBuilder] (`WidgetBuilder?`, optional): Custom backdrop builder.
/// - [useSafeArea] (`bool`, default: `true`): Respect safe area.
/// - [animationController] (`AnimationController?`, optional): Custom animation.
/// - [autoOpen] (`bool`, default: `true`): Auto-open on creation.
/// - [constraints] (`BoxConstraints?`, optional): Size constraints.
/// - [alignment] (`AlignmentGeometry?`, optional): Content alignment.
///
/// Returns: `DrawerOverlayCompleter<T?>` for managing the drawer lifecycle.
