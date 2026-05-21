// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../variants/empty_state_action_style.dart';

/// Core class used by the empty state component.
class EmptyStateAction {
  /// Creates `EmptyStateAction` for configuring or rendering empty state.
  const EmptyStateAction({
    required this.label,
    this.onPressed,
    this.icon,
    this.trailingIcon,
    this.style = EmptyStateActionStyle.primary,
  });

  /// Text/content element used by `EmptyStateAction` when composing its visual layout.
  final String label;

  /// Callback invoked by empty state when `onPressed` is triggered.
  final VoidCallback? onPressed;

  /// Input parameter used by `EmptyStateAction` during rendering and behavior handling.
  final Widget? icon;

  /// Input parameter used by `EmptyStateAction` during rendering and behavior handling.
  final Widget? trailingIcon;

  /// Style/theme override that customizes `EmptyStateAction` appearance.
  final EmptyStateActionStyle style;
}
