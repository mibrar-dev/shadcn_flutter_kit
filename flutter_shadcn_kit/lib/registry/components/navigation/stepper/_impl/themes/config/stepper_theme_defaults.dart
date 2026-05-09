// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../stepper.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME DEFAULTS
// Built-in defaults (never changes)
// Extracted from hard-coded values in stepper widgets
// ═══════════════════════════════════════════════════════════

class StepperThemeDefaults {
  const StepperThemeDefaults({
    this.direction = Axis.horizontal,
    this.size = StepSize.medium,
    this.variant = StepVariant.circle,
  });

  /// From `Stepper`: `direction ?? compTheme?.direction ?? Axis.horizontal`
  final Axis direction;

  /// From `Stepper`: `size ?? compTheme?.size ?? StepSize.medium`
  final StepSize size;

  /// From `Stepper`: `variant ?? compTheme?.variant ?? StepVariant.circle`
  final StepVariant variant;
}
