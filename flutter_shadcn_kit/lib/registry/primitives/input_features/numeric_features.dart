// Numeric features: the spinner (up/down buttons plus an optional drag
// gesture) and the single stepper button, both with min/max clamping.

import 'package:flutter/widgets.dart';

import '../../foundation/icons/lucide_icons.dart';
import 'input_features.dart';

double? _numericValue(String text, double? invalidValue) =>
    double.tryParse(text) ?? invalidValue;

double _clampValue(double value, double? min, double? max) {
  if (min != null && value < min) {
    return min;
  }
  if (max != null && value > max) {
    return max;
  }
  return value;
}

String _formatNumber(double value) {
  var text = value.toString();
  if (text.contains('.')) {
    while (text.endsWith('0')) {
      text = text.substring(0, text.length - 1);
    }
    if (text.endsWith('.')) {
      text = text.substring(0, text.length - 1);
    }
  }
  return text;
}

void _replaceText(InputFeatureState state, String text) {
  if (state.controller.text != text) {
    state.controller.text = text;
  }
}

/// Adds up/down buttons (and an optional drag gesture) for numeric input.
class InputSpinnerFeature extends InputFeature {
  /// Creates a spinner feature.
  const InputSpinnerFeature({
    super.visibility,
    super.skipFocusTraversal,
    this.step = 1.0,
    this.enableGesture = true,
    this.invalidValue = 0.0,
    this.min,
    this.max,
  });

  /// Amount added/subtracted on each step.
  final double step;

  /// Whether vertical drags also change the value.
  final bool enableGesture;

  /// Fallback value when the text does not parse; null keeps the text.
  final double? invalidValue;

  /// Minimum allowed value.
  final double? min;

  /// Maximum allowed value.
  final double? max;

  bool _canStep(InputFeatureState state, int direction) {
    final value = _numericValue(state.text, invalidValue);
    if (value == null) {
      return false;
    }
    return direction > 0
        ? (max == null || value < max!)
        : (min == null || value > min!);
  }

  void _step(InputFeatureState state, int direction) {
    final current = _numericValue(state.text, invalidValue);
    if (current == null) {
      return;
    }
    final next = _clampValue(current + step * direction, min, max);
    _replaceText(state, _formatNumber(next));
  }

  @override
  Iterable<Widget> buildTrailing(
    InputFeatureState state,
    BuildContext context,
  ) sync* {
    final buttons = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        InputFeatureIconButton(
          icon: const Icon(LucideIcons.chevronUp),
          enabled: _canStep(state, 1),
          onPressed: () => _step(state, 1),
        ),
        InputFeatureIconButton(
          icon: const Icon(LucideIcons.chevronDown),
          enabled: _canStep(state, -1),
          onPressed: () => _step(state, -1),
        ),
      ],
    );
    if (!enableGesture) {
      yield buttons;
      return;
    }
    yield GestureDetector(
      onVerticalDragUpdate: (details) =>
          _step(state, details.delta.dy < 0 ? 1 : -1),
      child: buttons,
    );
  }
}

/// Adds one increment/decrement button for numeric input.
class InputStepperButtonFeature extends InputIconFeature {
  /// Creates a stepper button.
  const InputStepperButtonFeature({
    super.position,
    super.visibility,
    this.step = 1.0,
    this.invalidValue = 0.0,
    this.min,
    this.max,
    this.icon = const Icon(LucideIcons.plus),
  });

  /// Creates a decrement button.
  const InputStepperButtonFeature.decrement({
    super.position,
    super.visibility,
    this.step = -1.0,
    this.invalidValue = 0.0,
    this.min,
    this.max,
    this.icon = const Icon(LucideIcons.minus),
  });

  /// Amount added on each press (negative subtracts).
  final double step;

  /// Fallback value when the text does not parse; null keeps the text.
  final double? invalidValue;

  /// Minimum allowed value.
  final double? min;

  /// Maximum allowed value.
  final double? max;

  /// The button icon.
  final Widget icon;

  @override
  Widget buildIcon(BuildContext context) => icon;

  @override
  void onPressed(InputFeatureState state, BuildContext context) {
    final current = _numericValue(state.text, invalidValue);
    if (current == null) {
      return;
    }
    final next = _clampValue(current + step, min, max);
    _replaceText(state, _formatNumber(next));
  }
}
