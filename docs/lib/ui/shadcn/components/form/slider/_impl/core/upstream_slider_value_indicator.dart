// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

/// Builds the content of the value-indicator bubble shown above a slider
/// thumb for the given resolved (denormalized, i.e. already scaled to
/// the slider min..max domain) [value].
///
/// Upstream parity: ported from `slider.dart` upstream. [ControlledSlider]
/// adapts this to the registry preset slider via its drag popover.
typedef SliderValueIndicatorBuilder =
    Widget Function(BuildContext context, double value);

/// Default bubble widget for displaying a slider's current value.
///
/// Pass this (or a widget wrapping it) as
/// [ControlledSlider.valueIndicatorBuilder] to opt into showing a small
/// bubble above the thumb while dragging:
///
/// ```dart
/// ControlledSlider(
///   initialValue: SliderValue.single(0.5),
///   onChanged: (v) => setState(() => value = v),
///   valueIndicatorBuilder: (context, value) =>
///       SliderValueIndicator(value: value),
/// )
/// ```
///
/// Upstream parity: ported from `slider.dart` upstream. Rendered with a plain
/// container (instead of upstream's `TooltipContainer`) so the slider
/// component stays dependency-free.
class SliderValueIndicator extends StatelessWidget {
  /// The resolved slider value to display.
  final double value;

  /// Optional custom formatter. Defaults to showing whole numbers without a
  /// decimal point and other values with up to 2 decimal places.
  final String Function(double value)? formatter;

  /// Creates a [SliderValueIndicator].
  const SliderValueIndicator({super.key, required this.value, this.formatter});

  static String _defaultFormat(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }
    var text = value.toStringAsFixed(2);
    text = text.replaceFirst(RegExp(r'0+$'), '');
    text = text.replaceFirst(RegExp(r'\.$'), '');
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        (formatter ?? _defaultFormat)(value),
        style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 12),
      ),
    );
  }
}
