// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../radio_group.dart';

/// A card-style radio button with custom content.
///
/// Provides a larger, card-like selection area within a [RadioGroup].
class RadioCard<T> extends StatefulWidget {
  /// The child widget displayed in the card.
  final Widget child;

  /// The value represented by this radio card.
  final T value;

  /// Whether this radio card is enabled.
  final bool enabled;

  /// Focus node for keyboard navigation.
  final FocusNode? focusNode;

  /// Creates a radio card.
  const RadioCard({
    super.key,
    required this.child,
    required this.value,
    this.enabled = true,
    this.focusNode,
  });

  /// Creates the `State` object for this widget.
  @override
  State<RadioCard<T>> createState() => _RadioCardState<T>();
}
