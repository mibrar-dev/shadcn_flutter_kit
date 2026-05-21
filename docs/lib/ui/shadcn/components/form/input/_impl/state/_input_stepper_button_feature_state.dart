// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../input.dart';

/// _InputStepperButtonFeatureState stores and manages mutable widget state.
class _InputStepperButtonFeatureState
    extends InputFeatureState<InputStepperButtonFeature> {
  /// Performs `_clampValue` logic for this form component.
  double _clampValue(double value) {
    final min = feature.min;
    final max = feature.max;
    if (min != null && value < min) {
      return min;
    }
    if (max != null && value > max) {
      return max;
    }
    return value;
  }

  /// Performs `_effectiveValue` logic for this form component.
  double? _effectiveValue() {
    final value = double.tryParse(controller.text);
    return value ?? feature.invalidValue;
  }

  /// Performs `_canApplyStep` logic for this form component.
  bool _canApplyStep(double? value) {
    if (value == null) return false;
    final step = feature.step;
    final min = feature.min;
    final max = feature.max;
    if (step >= 0) {
      return max == null || value < max;
    }
    return min == null || value > min;
  }

  /// Performs `_replaceText` logic for this form component.
  void _replaceText(UnaryOperator<String> replacer) {
    var controller = this.controller;
    var text = controller.text;
    var newText = replacer(text);
    if (newText != text) {
      controller.text = newText;
      input.onChanged?.call(newText);
    }
  }

  /// Performs `_newText` logic for this form component.
  String _newText(double value) {
    String newText = value.toString();
    if (newText.contains('.')) {
      while (newText.endsWith('0')) {
        newText = newText.substring(0, newText.length - 1);
      }
      if (newText.endsWith('.')) {
        newText = newText.substring(0, newText.length - 1);
      }
    }
    return newText;
  }

  /// Performs `_increase` logic for this form component.
  void _increase() {
    /// Performs `_replaceText` logic for this form component.
    _replaceText((text) {
      var value = double.tryParse(text);
      if (value == null) {
        if (feature.invalidValue != null) {
          return _newText(_clampValue(feature.invalidValue!));
        }
        return text;
      }
      return _newText(_clampValue(value + feature.step));
    });
  }

  /// Performs `_buildButton` logic for this form component.
  Widget _buildButton() {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        final theme = Theme.of(context);
        final currentValue = _effectiveValue();
        final clampedValue = currentValue == null
            ? null
            : _clampValue(currentValue);
        final canApplyStep = _canApplyStep(clampedValue);
        return SizedBox.square(
          dimension: 32 * theme.scaling,
          child: IconButton.outline(
            icon: feature.icon ?? const Icon(LucideIcons.plus),
            onPressed: canApplyStep ? _increase : null,
            density: ButtonDensity.compact,
            size: ButtonSize.small,
          ),
        );
      },
    );
  }

  @override
  Iterable<Widget> buildTrailing() sync* {
    if (feature.position == InputFeaturePosition.trailing) {
      yield _buildButton();
    }
  }

  @override
  Iterable<Widget> buildLeading() sync* {
    if (feature.position == InputFeaturePosition.leading) {
      yield _buildButton();
    }
  }
}
