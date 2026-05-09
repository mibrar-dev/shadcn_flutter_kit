// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../switch.dart';

/// Controlled switch with a controller or initial value.
class ControlledSwitch extends StatelessWidget with ControlledComponent<bool> {
  /// Current value stored for `initialValue`.
  @override
  final bool initialValue;

  /// Callback invoked for `onChanged` events.
  @override
  final ValueChanged<bool>? onChanged;

  /// Field storing `enabled` for this form implementation.
  @override
  final bool enabled;

  /// Controller used to coordinate `controller` behavior.
  @override
  final SwitchController? controller;

  /// Field storing `leading` for this form implementation.
  final Widget? leading;

  /// Field storing `trailing` for this form implementation.
  final Widget? trailing;

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

  /// Constructs `ControlledSwitch` with the provided parameters.
  const ControlledSwitch({
    super.key,
    this.controller,
    this.initialValue = false,
    this.onChanged,
    this.enabled = true,
    this.leading,
    this.trailing,
    this.gap,
    this.activeColor,
    this.inactiveColor,
    this.activeThumbColor,
    this.inactiveThumbColor,
    this.borderRadius,
  });

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return ControlledComponentAdapter(
      controller: controller,
      initialValue: initialValue,
      onChanged: onChanged,
      enabled: enabled,
      builder: (context, data) {
        return Switch(
          value: data.value,
          onChanged: data.onChanged,
          enabled: data.enabled,
          leading: leading,
          trailing: trailing,
          gap: gap,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          activeThumbColor: activeThumbColor,
          inactiveThumbColor: inactiveThumbColor,
          borderRadius: borderRadius,
        );
      },
    );
  }
}
