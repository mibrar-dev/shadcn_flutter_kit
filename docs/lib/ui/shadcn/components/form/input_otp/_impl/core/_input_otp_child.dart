// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../input_otp.dart';

/// _InputOTPChild renders form UI and wires input behavior.
class _InputOTPChild {
  /// Current value stored for `value`.
  int? value;

  /// Focus node/reference used by `focusNode` interactions.
  final FocusNode focusNode;

  /// Field storing `groupIndex` for this form implementation.
  final int groupIndex;

  /// Field storing `relativeIndex` for this form implementation.
  final int relativeIndex;

  /// Field storing `child` for this form implementation.
  final InputOTPChild child;

  /// Field storing `groupLength` for this form implementation.
  int groupLength = 0;

  /// Field storing `key` for this form implementation.
  final GlobalKey<_OTPCharacterInputState> key;

  /// Constructs `_InputOTPChild` with the provided parameters.
  _InputOTPChild({
    required this.focusNode,
    required this.child,
    this.value,
    required this.groupIndex,
    required this.relativeIndex,
  }) : key = GlobalKey<_OTPCharacterInputState>();

  /// Constructs `_InputOTPChild` using the `withNewChild` named constructor.
  _InputOTPChild.withNewChild(_InputOTPChild old, InputOTPChild newChild)
    : focusNode = old.focusNode,
      value = old.value,
      groupIndex = old.groupIndex,
      relativeIndex = old.relativeIndex,
      child = newChild,
      groupLength = old.groupLength,
      key = old.key;
}
