// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../../../shared/primitives/form_control.dart';
import '../../../../../shared/primitives/slider_value.dart';

/// Reactive controller for managing slider state with value operations.
///
/// Extends [ValueNotifier] to provide state management for slider widgets
/// using [SliderValue] objects that support both single and range slider
/// configurations. Enables programmatic slider value changes and provides
/// convenient methods for common slider operations.
///
/// The controller manages [SliderValue] objects which can represent either
/// single values or dual-thumb range values, providing unified state management
/// for different slider types.
///
/// Example:
/// ```dart
/// final controller = SliderController(SliderValue.single(0.5));
///
/// // React to changes
/// controller.addListener(() {
///   print('Slider value: ${controller.value}');
/// });
///
/// // Programmatic control
/// controller.setValue(0.75);
/// controller.setRange(0.2, 0.8);
/// ```
///
/// Upstream parity: ported from `slider.dart` upstream. Works with the
/// registry [Slider] preset API via [ControlledSlider], and with any widget
/// that consumes [SliderValue].
class SliderController extends ValueNotifier<SliderValue>
    with ComponentController<SliderValue> {
  /// Creates a [SliderController] with the specified initial value.
  ///
  /// The [value] parameter provides the initial slider configuration as a
  /// [SliderValue]. The controller notifies listeners when the value changes
  /// through any method calls or direct value assignment.
  ///
  /// Example:
  /// ```dart
  /// final controller = SliderController(SliderValue.single(0.3));
  /// ```
  SliderController(super.value);

  /// Sets the slider to a single value configuration.
  ///
  /// Converts the slider to single-thumb mode with the specified [value].
  /// The value should be within the slider's min/max bounds.
  void setValue(double value) {
    this.value = SliderValue.single(value);
  }

  /// Sets the slider to a range value configuration.
  ///
  /// Converts the slider to dual-thumb mode with the specified [start] and
  /// [end] values. The values should be within the slider's min/max bounds
  /// with start <= end.
  void setRange(double start, double end) {
    value = SliderValue.ranged(start, end);
  }

  /// Returns true if the slider is in single-value mode.
  bool get isSingle => !value.isRanged;

  /// Returns true if the slider is in range mode.
  bool get isRanged => value.isRanged;

  /// Gets the current single value (valid only in single mode).
  ///
  /// Throws an exception if called when the slider is in range mode.
  double get singleValue => value.value;

  /// Gets the current range start value (valid only in range mode).
  ///
  /// Throws an exception if called when the slider is in single mode.
  double get rangeStart => value.start;

  /// Gets the current range end value (valid only in range mode).
  ///
  /// Throws an exception if called when the slider is in single mode.
  double get rangeEnd => value.end;
}
