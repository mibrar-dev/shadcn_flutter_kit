// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../formatted_input.dart';

/// A part that displays a custom widget.
class WidgetPart extends InputPart {
  /// The widget to display.
  final Widget widget;

  /// Creates a [WidgetPart] with the specified widget.
  const WidgetPart(this.widget);

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context, FormattedInputData data) {
    return widget;
  }

  /// Field storing `partKey` for this form implementation.
  @override
  Object? get partKey => widget.key;

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WidgetPart && other.widget == widget;
  }

  /// Flag indicating whether `hashCode` is enabled/active.
  @override
  int get hashCode => widget.hashCode;
}
