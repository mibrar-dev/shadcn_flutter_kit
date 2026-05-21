// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../preview.dart';

/// _InputOtpPreviewState stores and manages mutable widget state.
class _InputOtpPreviewState extends State<InputOtpPreview> {
  /// Current value stored for `value`.
  String value = '';

  /// Current value stored for `submittedValue`.
  String? submittedValue;

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InputOTP(
              onChanged: (value) {
                /// Triggers a rebuild after mutating local state.
                setState(() {
                  this.value = value.otpToString();
                });
              },
              onSubmitted: (value) {
                /// Triggers a rebuild after mutating local state.
                setState(() {
                  submittedValue = value.otpToString();
                });
              },
              children: [
                InputOTPChild.character(allowDigit: true),
                InputOTPChild.character(allowDigit: true),
                InputOTPChild.character(allowDigit: true),
                InputOTPChild.separator,
                InputOTPChild.character(allowDigit: true),
                InputOTPChild.character(allowDigit: true),
                InputOTPChild.character(allowDigit: true),
              ],
            ),
            const SizedBox(height: 16),
            Text('Current: $value'),
            if (submittedValue != null) Text('Submitted: $submittedValue'),
          ],
        ),
      ),
    );
  }
}
