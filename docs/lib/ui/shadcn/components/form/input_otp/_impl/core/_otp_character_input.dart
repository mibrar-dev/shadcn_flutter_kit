// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../input_otp.dart';

/// _OTPCharacterInput renders form UI and wires input behavior.
class _OTPCharacterInput extends StatefulWidget {
  /// Field storing `data` for this form implementation.
  final InputOTPChildData data;

  /// Field storing `predicate` for this form implementation.
  final CodepointPredicate? predicate;

  /// Field storing `transform` for this form implementation.
  final CodepointUnaryOperator? transform;

  /// Field storing `obscured` for this form implementation.
  final bool obscured;

  /// Field storing `readOnly` for this form implementation.
  final bool readOnly;

  /// Field storing `keyboardType` for this form implementation.
  final TextInputType? keyboardType;

  /// Constructs `_OTPCharacterInput` with the provided parameters.
  const _OTPCharacterInput({
    super.key,
    required this.data,
    this.predicate,
    this.transform,
    this.obscured = false,
    this.readOnly = false,
    this.keyboardType,
  });

  /// Creates the `State` object for this widget.
  @override
  State<_OTPCharacterInput> createState() => _OTPCharacterInputState();
}
