// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../context_menu.dart';

/// ContextMenuPopup defines a reusable type for this registry module.
class ContextMenuPopup extends StatelessWidget {
  /// Build context for anchoring the popup.
  final BuildContext anchorContext;

  /// Position to display the popup.
  final Offset position;

  /// Menu items to display.
  final List<MenuItem> children;

  /// Captured themes for consistent styling.
  final CapturedThemes? themes;

  /// Direction to lay out menu items.
  final Axis direction;

  /// Callback when popup follows the anchor.
  final ValueChanged<PopoverOverlayWidgetState>? onTickFollow;

  /// Size of the anchor widget.
  final Size? anchorSize;

  /// Creates a [ContextMenuPopup].
  ///
  /// Parameters:
  /// - [anchorContext] (`BuildContext`, required): Anchor context.
  /// - [position] (`Offset`, required): Popup position.
  /// - [children] (`List<MenuItem>`, required): Menu items.
  /// - [themes] (`CapturedThemes?`, optional): Captured themes.
  /// - [direction] (`Axis`, default: `Axis.vertical`): Layout direction.
  /// - [onTickFollow] (`ValueChanged<PopoverOverlayWidgetState>?`, optional): Follow callback.
  /// - [anchorSize] (`Size?`, optional): Anchor size.
  const ContextMenuPopup({
    super.key,
    required this.anchorContext,
    required this.position,
    required this.children,
    this.themes,
    this.direction = Axis.vertical,
    this.onTickFollow,
    this.anchorSize,
  });

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return AnimatedValueBuilder<double>(
      value: 1.0,
      initialValue: 0.0,
      duration: const Duration(milliseconds: 100),
      builder: (context, value, _) {
        final isSheetOverlay = SheetOverlayHandler.isSheetOverlay(context);
        return PopoverOverlayWidget(
          anchorContext: anchorContext,
          position: position,
          anchorSize: anchorSize,
          alignment: Alignment.topLeft,
          themes: themes,
          follow: onTickFollow != null,
          onTickFollow: onTickFollow,
          builder: (context) {
            final theme = Theme.of(context);
            return LimitedBox(
              maxWidth: 192 * theme.scaling,
              child: MenuGroup(
                direction: direction,
                itemPadding: isSheetOverlay
                    ? EdgeInsets.symmetric(
                        horizontal: theme.density.baseGap * theme.scaling,
                      )
                    : EdgeInsets.zero,
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
                children: children,
              ),
            );
          },
          animation: value,
          anchorAlignment: Alignment.topRight,
        );
      },
    );
  }
}
