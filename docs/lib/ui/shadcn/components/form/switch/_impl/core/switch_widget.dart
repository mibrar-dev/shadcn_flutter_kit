// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../switch.dart';

/// Switch widget for toggling boolean values.
class Switch extends StatefulWidget {
  /// Current value stored for `value`.
  final bool value;

  /// Callback invoked for `onChanged` events.
  final ValueChanged<bool>? onChanged;

  /// Field storing `leading` for this form implementation.
  final Widget? leading;

  /// Field storing `trailing` for this form implementation.
  final Widget? trailing;

  /// Field storing `enabled` for this form implementation.
  final bool? enabled;

  /// Field storing `gap` for this form implementation.
  final double? gap;

  /// Field storing `activeColor` for this form implementation.
  final Color? activeColor;

  /// Field storing `inactiveColor` for this form implementation.
  final Color? inactiveColor;

  /// Field storing `activeThumbColor` for this form implementation.
  final Color? activeThumbColor;

  /// Field storing `inactiveThumbColor` for this form implementation.
  final Color? inactiveThumbColor;

  /// Field storing `borderRadius` for this form implementation.
  final BorderRadiusGeometry? borderRadius;

  /// Constructs `Switch` with the provided parameters.
  const Switch({
    super.key,
    required this.value,
    required this.onChanged,
    this.leading,
    this.trailing,
    this.enabled = true,
    this.gap,
    this.activeColor,
    this.inactiveColor,
    this.activeThumbColor,
    this.inactiveThumbColor,
    this.borderRadius,
  });

  /// Creates the `State` object for this widget.
  @override
  State<Switch> createState() => _SwitchState();
}
