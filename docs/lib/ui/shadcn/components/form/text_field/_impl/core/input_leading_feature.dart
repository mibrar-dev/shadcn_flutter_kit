// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../text_field.dart';

/// Adds a custom widget to the leading (left) side of the input field.
///
/// Allows you to place any widget before the input text, such as icons,
/// labels, or other decorative elements.
///
/// Example:
/// ```dart
/// TextField(
///   features: [
///     InputLeadingFeature(
///       Icon(Icons.search),
///     ),
///   ],
/// )
/// ```
class InputLeadingFeature extends InputFeature {
  /// The widget to display on the leading side.
  final Widget prefix;

  /// Creates an [InputLeadingFeature].
  ///
  /// Parameters:
  /// - [prefix] (`Widget`, required): The widget to show before the input.
  /// - [visibility] (`InputFeatureVisibility`, optional): Controls visibility.
  /// - [skipFocusTraversal] (`bool`, optional): Whether to skip in focus order.
  const InputLeadingFeature(
    this.prefix, {
    super.visibility,
    super.skipFocusTraversal,
  });

  /// Creates the `State` object for this widget.
  @override
  InputFeatureState createState() => _InputLeadingFeatureState();
}
