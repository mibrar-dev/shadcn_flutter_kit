// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../context_menu.dart';

/// _ContextMenuState defines a reusable type for this registry module.
class _ContextMenuState extends State<ContextMenu> {
  /// Stores `_children` state/configuration for this implementation.
  late ValueNotifier<List<MenuItem>> _children;

  @override
  /// Executes `initState` behavior for this component/composite.
  void initState() {
    super.initState();
    _children = ValueNotifier(widget.items);
  }

  @override
  /// Executes `didUpdateWidget` behavior for this component/composite.
  void didUpdateWidget(covariant ContextMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(widget.items, oldWidget.items)) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (mounted) _children.value = widget.items;
      });
    }
  }

  @override
  /// Executes `dispose` behavior for this component/composite.
  void dispose() {
    _children.dispose();
    super.dispose();
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    final bool enableLongPress =
        platform == TargetPlatform.iOS ||
        platform == TargetPlatform.android ||
        platform == TargetPlatform.fuchsia;
    return GestureDetector(
      behavior: widget.behavior,
      onSecondaryTapDown: !widget.enabled
          ? null
          : (details) {
              /// Creates a `_showContextMenu` instance.
              _showContextMenu(
                context,
                details.globalPosition,
                _children,
                widget.direction,
              );
            },
      onLongPressStart: enableLongPress && widget.enabled
          ? (details) {
              /// Creates a `_showContextMenu` instance.
              _showContextMenu(
                context,
                details.globalPosition,
                _children,
                widget.direction,
              );
            }
          : null,
      child: widget.child,
    );
  }
}

Future<void> _showContextMenu(
  BuildContext context,
  Offset position,
  ValueListenable<List<MenuItem>> children,
  Axis direction,
) async {
  final key = GlobalKey<OverlayHandlerStateMixin>();
  final theme = Theme.of(context);
  final overlayManager = OverlayManager.of(context);
  return overlayManager
      .showMenu(
        key: key,
        context: context,
        position: position + const Offset(8, 0),
        alignment: Alignment.topLeft,
        anchorAlignment: Alignment.topRight,
        regionGroupId: key,
        modal: true,
        follow: true,
        consumeOutsideTaps: false,
        dismissBackdropFocus: false,
        overlayBarrier: OverlayBarrier(
          borderRadius: BorderRadius.circular(theme.radiusMd),
          barrierColor: const Color(0xB2000000),
        ),
        builder: (context) {
          return AnimatedBuilder(
            animation: children,
            builder: (context, child) {
              bool isSheetOverlay = SheetOverlayHandler.isSheetOverlay(context);
              return ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 192),
                child: MenuGroup(
                  itemPadding: isSheetOverlay
                      ? EdgeInsets.symmetric(
                              horizontal: theme.density.baseGap,
                            ) *
                            theme.scaling
                      : EdgeInsets.zero,
                  direction: direction,
                  regionGroupId: key,
                  subMenuOffset: const Offset(8, -4),
                  onDismissed: () {
                    closeOverlay(context);
                  },
                  builder: (context, children) {
                    final compTheme = ComponentTheme.maybeOf<ContextMenuTheme>(
                      context,
                    );
                    return MenuPopup(
                      surfaceOpacity: compTheme?.surfaceOpacity,
                      surfaceBlur: compTheme?.surfaceBlur,
                      children: children,
                    );
                  },
                  children: children.value,
                ),
              );
            },
          );
        },
      )
      .future;
}

/// Internal widget for rendering a context menu popup.
///
/// Displays the actual menu content in an overlay with positioning and theming.
/// Typically used internally by [ContextMenu].
