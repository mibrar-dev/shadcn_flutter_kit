// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../input_otp.dart';

/// A widget-based OTP child that doesn't accept input.
///
/// Used for displaying static content like separators or spacers within
/// an [InputOTP] widget. This child does not hold any value.
///
/// Example:
/// ```dart
/// WidgetInputOTPChild(
///   Icon(Icons.arrow_forward),
/// )
/// ```
class WidgetInputOTPChild extends InputOTPChild {
  /// The widget to display.
  final Widget child;

  /// Creates a [WidgetInputOTPChild].
  ///
  /// Parameters:
  /// - [child] (`Widget`, required): The widget to display.
  const WidgetInputOTPChild(this.child);

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context, InputOTPChildData data) {
    final theme = Theme.of(context);
    return SizedBox(
      width: theme.scaling * 32,
      height: theme.scaling * 32,
      child: Center(child: child),
    );
  }

  /// Flag indicating whether `hasValue` is enabled/active.
  @override
  bool get hasValue => false;
}
