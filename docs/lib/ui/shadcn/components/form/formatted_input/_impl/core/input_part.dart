// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../formatted_input.dart';

/// Abstract base class for parts of a formatted input.
///
/// [InputPart] defines the interface for components that make up a formatted
/// input field, such as static text, editable sections, or custom widgets.
/// Each part can be rendered and may optionally hold a value.
///
/// Example parts:
/// - Static text separators (e.g., "/", "-")
/// - Editable numeric fields (e.g., month, day, year)
/// - Custom widget decorations
abstract class InputPart implements FormattedValuePart {
  /// Creates a static text part.
  const factory InputPart.static(String text) = StaticPart;

  /// Creates an editable input part.
  const factory InputPart.editable({
    required int length,
    bool obscureText,
    List<TextInputFormatter> inputFormatters,
    Widget? placeholder,
    required double width,
  }) = EditablePart;

  /// Creates a custom widget part.
  const factory InputPart.widget(Widget widget) = WidgetPart;

  /// Creates an [InputPart].
  const InputPart();

  /// Builds the widget for this part.
  Widget build(BuildContext context, FormattedInputData data);

  /// A unique key identifying this part.
  Object? get partKey;

  /// Whether this part can hold a value.
  bool get canHaveValue => false;

  /// The current value of this part, or null if it doesn't hold a value.
  @override
  String? get value => null;

  /// Returns this part.
  @override
  InputPart get part => this;

  /// Creates a copy of this part with the specified value.
  @override
  FormattedValuePart withValue(String value) {
    return FormattedValuePart(this, value);
  }

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InputPart && other.partKey == partKey;
  }

  /// Flag indicating whether `hashCode` is enabled/active.
  @override
  int get hashCode => partKey.hashCode;
}
