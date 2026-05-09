// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../input_otp.dart';

/// A visual separator for OTP input groups.
///
/// Displays a dash "-" character between groups of OTP input fields.
/// Automatically applies theming and spacing based on the current theme.
///
/// Example:
/// ```dart
/// InputOTP(
///   children: [
///     InputOTPChild.input(),
///     OTPSeparator(),
///     InputOTPChild.input(),
///   ],
/// )
/// ```
class OTPSeparator extends StatelessWidget {
  /// Creates an [OTPSeparator].
  const OTPSeparator({super.key});

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return const Text('-')
        .bold()
        .withPadding(horizontal: theme.density.baseGap * theme.scaling * gapXs)
        .base()
        .foreground();
  }
}
