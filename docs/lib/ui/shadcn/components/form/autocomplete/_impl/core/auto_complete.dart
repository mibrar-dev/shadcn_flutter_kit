// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../autocomplete.dart';

/// Intelligent autocomplete functionality with customizable suggestion handling.
///
/// Provides real-time autocomplete suggestions in a popover overlay when used
/// with text input widgets. Supports multiple text replacement modes, keyboard
/// navigation, and theming customization. The widget wraps a child (typically
/// a text field) and displays filtered suggestions based on user input.
class AutoComplete extends StatefulWidget {
  /// List of suggestions to display in the autocomplete popover.
  final List<String> suggestions;

  /// The child widget that receives autocomplete functionality.
  final Widget child;

  /// Constraints applied to the autocomplete popover container.
  final BoxConstraints? popoverConstraints;

  /// Width constraint strategy for the autocomplete popover.
  final PopoverConstraint? popoverWidthConstraint;

  /// Alignment point on the anchor widget for popover attachment.
  final AlignmentDirectional? popoverAnchorAlignment;

  /// Alignment point on the popover for anchor attachment.
  final AlignmentDirectional? popoverAlignment;

  /// Text replacement strategy when a suggestion is selected.
  final AutoCompleteMode? mode;

  /// Function to customize suggestion text before application.
  final AutoCompleteCompleter completer;

  /// Creates an [AutoComplete] widget.
  const AutoComplete({
    super.key,
    required this.suggestions,
    required this.child,
    this.popoverConstraints,
    this.popoverWidthConstraint,
    this.popoverAnchorAlignment,
    this.popoverAlignment,
    this.mode,
    this.completer = _defaultCompleter,
  });

  /// Creates the `State` object for this widget.
  @override
  State<AutoComplete> createState() => _AutoCompleteState();

  /// Default completer that returns suggestions unchanged.
  static String _defaultCompleter(String suggestion) => suggestion;
}
