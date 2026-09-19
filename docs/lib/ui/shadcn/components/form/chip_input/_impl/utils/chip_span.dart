// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../chip_input.dart';

/// An inline span representing a chip value inside a [ChipEditingController].
///
/// Unlike a plain [WidgetSpan], a [ChipSpan] also carries the underlying chip
/// [value]. This lets clipboard operations serialize the actual value instead
/// of the private-use placeholder codepoint that lays the chip out within the
/// editable text.
///
/// Upstream parity: ported from `chip_input.dart` upstream.
class ChipSpan<T> extends WidgetSpan {
  /// The value represented by this chip.
  final T value;

  /// Creates a [ChipSpan] wrapping [child] and carrying [value].
  const ChipSpan({
    required this.value,
    required super.child,
    super.alignment = PlaceholderAlignment.middle,
    super.baseline,
    super.style,
  });
}
