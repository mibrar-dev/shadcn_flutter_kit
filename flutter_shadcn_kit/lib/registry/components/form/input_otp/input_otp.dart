// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../text_field/text_field.dart';
import '../../../shared/primitives/focus_outline.dart';
import '../../../shared/primitives/form_value_supplier.dart';
import '../../../shared/primitives/text.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/color_extensions.dart';
import '../../../shared/utils/util.dart';

part '_impl/themes/base/input_otp_theme.dart';

part '_impl/core/_input_otp_child.dart';
part '_impl/core/_input_otp_spacing.dart';
part '_impl/state/_input_otp_state.dart';
part '_impl/core/_otp_character_input.dart';
part '_impl/state/_otp_character_input_state.dart';
part '_impl/core/character_input_otp_child.dart';
part '_impl/core/input_otp_child.dart';
part '_impl/core/input_otp_child_data.dart';
part '_impl/core/otp_separator.dart';
part '_impl/core/widget_input_otp_child.dart';

/// A predicate that tests whether a Unicode codepoint is valid.
///
/// Parameters:
/// - [codepoint] (`int`): The Unicode codepoint to test.
///
/// Returns: `true` if the codepoint passes the predicate, `false` otherwise.
typedef CodepointPredicate = bool Function(int codepoint);

/// A function that transforms a Unicode codepoint to another.
///
/// Parameters:
/// - [codepoint] (`int`): The Unicode codepoint to transform.
///
/// Returns: The transformed codepoint.
typedef CodepointUnaryOperator = int Function(int codepoint);

/// A list of nullable codepoints representing OTP input values.
///
/// Each element represents a character's Unicode codepoint, or null if not set.
typedef OTPCodepointList = List<int?>;

/// Extension methods for [OTPCodepointList].
extension OTPCodepointListExtension on OTPCodepointList {
  /// Converts the codepoint list to a string.
  ///
  /// Null values are converted to empty strings.
  ///
  /// Returns: A string representation of the OTP code.
  ///
  /// Example:
  /// ```dart
  /// final codes = [49, 50, 51]; // '1', '2', '3'
  /// print(codes.otpToString()); // '123'
  /// ```
  String otpToString() {
    return map((e) => e == null ? '' : String.fromCharCode(e)).join();
  }
}

/// A specialized input widget for One-Time Password (OTP) and verification code entry.
///
/// [InputOTP] provides a user-friendly interface for entering OTP codes, verification
/// numbers, and similar sequential input scenarios. The widget displays a series of
/// individual input fields that automatically advance focus as the user types,
/// creating an intuitive experience for multi-digit input.
///
/// Key features:
/// - Sequential character input with automatic focus advancement
/// - Customizable field layout with separators and spacing
/// - Support for various character types (digits, letters, symbols)
/// - Keyboard navigation and clipboard paste support
/// - Form integration with validation support
/// - Accessibility features for screen readers
/// - Theming and visual customization
///
/// The widget uses a flexible child system that allows mixing input fields
/// with separators, spaces, and custom widgets:
/// - Character input fields for actual OTP digits/letters
/// - Separators for visual grouping (e.g., dashes, dots)
/// - Spacing elements for layout control
/// - Custom widgets for specialized display needs
///
/// Common use cases:
/// - SMS verification codes (e.g., 6-digit codes)
/// - Two-factor authentication tokens
/// - Credit card security codes
/// - License key input
/// - PIN code entry
///
/// Example:
/// ```dart
/// InputOTP(
///   children: [
///     CharacterInputOTPChild(),
///     CharacterInputOTPChild(),
///     CharacterInputOTPChild(),
///     InputOTPChild.separator,
///     CharacterInputOTPChild(),
///     CharacterInputOTPChild(),
///     CharacterInputOTPChild(),
///   ],
///   onChanged: (code) => _handleOTPChange(code),
///   onSubmitted: (code) => _verifyOTP(code),
/// );
/// ```
class InputOTP extends StatefulWidget {
  /// The list of children defining input fields, separators, and spaces.
  final List<InputOTPChild> children;

  /// Initial OTP codepoint values.
  final OTPCodepointList? initialValue;

  /// Called when the OTP value changes.
  final ValueChanged<OTPCodepointList>? onChanged;

  /// Called when the user submits the OTP (e.g., presses Enter on last field).
  final ValueChanged<OTPCodepointList>? onSubmitted;

  /// Creates an [InputOTP] widget.
  ///
  /// Parameters:
  /// - [children] (`List<InputOTPChild>`, required): The OTP input fields and decorations.
  /// - [initialValue] (`OTPCodepointList?`, optional): Initial codepoints.
  /// - [onChanged] (`ValueChanged<OTPCodepointList>?`, optional): Value change callback.
  /// - [onSubmitted] (`ValueChanged<OTPCodepointList>?`, optional): Submit callback.
  const InputOTP({
    super.key,
    required this.children,
    this.initialValue,
    this.onChanged,
    this.onSubmitted,
  });

  /// Creates the `State` object for this widget.
  @override
  State<InputOTP> createState() => _InputOTPState();
}
