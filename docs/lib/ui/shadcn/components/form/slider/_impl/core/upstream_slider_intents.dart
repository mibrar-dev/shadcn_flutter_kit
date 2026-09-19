// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

/// Intent for increasing the slider value via keyboard shortcuts.
///
/// Used with Flutter's shortcuts and actions system to handle keyboard
/// input for incrementing slider values. Typically bound to arrow keys.
/// [ControlledSlider] handles this intent by stepping the current value.
///
/// Upstream parity: ported from `slider.dart` upstream.
class IncreaseSliderValue extends Intent {
  /// Creates an [IncreaseSliderValue] intent.
  const IncreaseSliderValue();
}

/// Intent for decreasing the slider value via keyboard shortcuts.
///
/// Used with Flutter's shortcuts and actions system to handle keyboard
/// input for decrementing slider values. Typically bound to arrow keys.
/// [ControlledSlider] handles this intent by stepping the current value.
///
/// Upstream parity: ported from `slider.dart` upstream.
class DecreaseSliderValue extends Intent {
  /// Creates a [DecreaseSliderValue] intent.
  const DecreaseSliderValue();
}
