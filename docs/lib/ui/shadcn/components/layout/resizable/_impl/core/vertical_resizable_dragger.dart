// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../resizable.dart';

/// VerticalResizableDragger defines a reusable type for this registry module.
class VerticalResizableDragger extends StatelessWidget {
  /// Creates a [VerticalResizableDragger].
  const VerticalResizableDragger({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// Stores `scaling` state/configuration for this implementation.
    final scaling = theme.scaling;
    final compTheme = ComponentTheme.maybeOf<ResizableDraggerTheme>(context);
    final color = styleValue(
      widgetValue: null,
      themeValue: compTheme?.color,
      defaultValue: theme.colorScheme.border,
    );
    final borderRadius = styleValue(
      widgetValue: null,
      themeValue: compTheme?.borderRadius,
      defaultValue: theme.radiusSm,
    );
    final width = styleValue(
      widgetValue: null,
      themeValue: compTheme?.width,
      defaultValue: 4 * 4 * scaling,
    );
    final height = styleValue(
      widgetValue: null,
      themeValue: compTheme?.height,
      defaultValue: 3 * 4 * scaling,
    );
    final iconSize = styleValue(
      widgetValue: null,
      themeValue: compTheme?.iconSize,
      defaultValue: 4 * 2.5 * scaling,
    );
    final iconColor = styleValue(
      themeValue: compTheme?.iconColor,
      defaultValue: null,
    );
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius ?? 0),
        ),
        alignment: Alignment.center,
        width: width,
        height: height,
        child: Transform.rotate(
          angle: pi / 2,
          child: Icon(
            RadixIcons.dragHandleDots2,
            size: iconSize,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
