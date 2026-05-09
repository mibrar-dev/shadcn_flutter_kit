// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../item_picker.dart';

/// A selectable option within an item picker.
///
/// Wraps an item with selection behavior, applying different styles based on
/// whether it's currently selected. Commonly used inside [ItemPickerDialog]
/// to create selectable items.
///
/// Example:
/// ```dart
/// ItemPickerOption<Color>(
///   value: Colors.red,
///   child: Container(color: Colors.red, width: 50, height: 50),
/// )
/// ```
class ItemPickerOption<T> extends StatelessWidget {
  /// The value this option represents.
  final T value;

  /// Optional label widget displayed with the option.
  final Widget? label;

  /// The main child widget representing the option.
  final Widget child;

  /// Custom style for the option when not selected.
  final AbstractButtonStyle? style;

  /// Custom style for the option when selected.
  final AbstractButtonStyle? selectedStyle;

  /// Creates an [ItemPickerOption].
  ///
  /// Parameters:
  /// - [value] (`T`, required): The value this option represents.
  /// - [child] (`Widget`, required): The widget to display.
  /// - [style] (`AbstractButtonStyle?`, optional): Style when not selected.
  /// - [selectedStyle] (`AbstractButtonStyle?`, optional): Style when selected.
  /// - [label] (`Widget?`, optional): Optional label widget.
  const ItemPickerOption({
    super.key,
    required this.value,
    required this.child,
    this.style,
    this.selectedStyle,
    this.label,
  });

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    final data = Data.maybeOf<ItemPickerData>(context);
    if (data == null) {
      return LayoutBuilder(
        builder: (context, constraints) {
          Size size = constraints.biggest;
          if (size.width == size.height) {
            return Stack(
              fit: StackFit.passthrough,
              children: [
                child,
                if (label != null)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Center(child: label),
                  ),
              ],
            );
          }
          if (label == null) {
            return child;
          }
          return BasicLayout(leading: child, content: label);
        },
      );
    }
    if (data.layout is ListItemPickerLayout) {
      if (label == null) {
        return Button(
          onPressed: data.onChanged == null
              ? null
              : () => data.onChanged!(value),
          style: data.value == value
              ? (selectedStyle ?? ButtonVariance.primary)
              : (style ?? ButtonVariance.ghost),
          child: child,
        );
      }
      return Button(
        onPressed: data.onChanged == null ? null : () => data.onChanged!(value),
        leading: child,
        style: data.value == value
            ? (selectedStyle ?? ButtonVariance.primary)
            : (style ?? ButtonVariance.ghost),
        child: label!,
      );
    }
    return IconButton(
      icon: Stack(
        fit: StackFit.passthrough,
        children: [
          child,
          if (label != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Center(child: label),
            ),
        ],
      ),
      onPressed: data.onChanged == null ? null : () => data.onChanged!(value),
      variance: data.value == value
          ? (selectedStyle ?? ButtonVariance.primary)
          : (style ?? ButtonVariance.ghost),
    );
  }
}
