// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../formatted_input.dart';

/// Internal data structure for formatted input parts.
///
/// [FormattedInputData] holds the state and configuration data needed
/// to render and manage an individual input part within a formatted input.
class FormattedInputData {
  /// The index of this part in the formatted input.
  final int partIndex;

  /// The initial value for this part.
  final String? initialValue;

  /// Whether this part is enabled for editing.
  final bool enabled;

  /// The controller managing the overall formatted input.
  final FormattedInputController? controller;

  /// The focus node for this specific part.
  final FocusNode? focusNode;

  /// All focus nodes in the formatted input.
  final List<FocusNode> focusNodes;

  /// Creates a [FormattedInputData].
  FormattedInputData({
    required this.partIndex,
    required this.initialValue,
    required this.enabled,
    required this.controller,
    required this.focusNode,
    required this.focusNodes,
  });

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FormattedInputData &&
        partIndex == other.partIndex &&
        initialValue == other.initialValue &&
        enabled == other.enabled &&
        controller == other.controller &&
        focusNode == other.focusNode &&
        focusNodes == other.focusNodes;
  }

  @override
  int get hashCode => Object.hash(
    partIndex,
    initialValue,
    enabled,
    controller,
    focusNode,
    focusNodes,
  );
}
