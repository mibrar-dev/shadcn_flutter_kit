// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../input_otp.dart';

/// Data passed to [InputOTPChild.build] for rendering OTP input fields.
///
/// Contains information about focus nodes, index positions, current value,
/// and callbacks for changing values. Used internally by [InputOTP] to
/// coordinate input fields.
class InputOTPChildData {
  /// Focus node for the previous input field.
  final FocusNode? previousFocusNode;

  /// Focus node for this input field.
  final FocusNode? focusNode;

  /// Focus node for the next input field.
  final FocusNode? nextFocusNode;

  /// Overall index within all OTP children.
  final int index;

  /// Index of the group this child belongs to.
  final int groupIndex;

  /// Total number of children in this group.
  final int groupLength;

  /// Relative index within the group.
  final int relativeIndex;

  /// Current value (codepoint) of this input field.
  final int? value;

  /// Field storing `_state` for this form implementation.
  final _InputOTPState _state;

  /// Field storing `_key` for this form implementation.
  final GlobalKey<_OTPCharacterInputState>? _key;

  /// Constructs `InputOTPChildData` using the `_` named constructor.
  InputOTPChildData._(
    this._state,
    this._key, {
    required this.focusNode,
    required this.index,
    required this.groupIndex,
    required this.relativeIndex,
    required this.groupLength,
    this.previousFocusNode,
    this.nextFocusNode,
    this.value,
  });

  /// Updates the value for this OTP input field.
  ///
  /// Parameters:
  /// - [value] (`int?`, required): The new codepoint value or null.
  void changeValue(int? value) {
    _state._changeValue(index, value);
  }
}
