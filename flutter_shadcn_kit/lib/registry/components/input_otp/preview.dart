// Named examples for the `input_otp` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';
import 'input_otp.dart';

/// The six-slot code field.
class _InputOtpOtp extends StatefulWidget {
  const _InputOtpOtp({
    this.length = 6,
    this.separatorEvery,
    this.obscureText = false,
  });

  final int length;
  final int? separatorEvery;
  final bool obscureText;

  @override
  State<_InputOtpOtp> createState() => _InputOtpOtpState();
}

class _InputOtpOtpState extends State<_InputOtpOtp> {
  String _code = '';

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        InputOtp(
          length: widget.length,
          separatorEvery: widget.separatorEvery,
          obscureText: widget.obscureText,
          onChanged: (String code) => setState(() => _code = code),
        ),
        Gap(theme.spacing.md),
        Text(
          'code: "$_code"',
          style: TextStyle(fontSize: 12, color: theme.colors.mutedForeground),
        ),
      ],
    );
  }
}

/// The default field.
Widget _inputOtpDefault(BuildContext context) => const _InputOtpOtp();

/// A grouped field: a separator every three slots.
Widget _inputOtpSeparated(BuildContext context) =>
    const _InputOtpOtp(separatorEvery: 3);

/// An obscured field (each character paints as a dot).
Widget _inputOtpObscured(BuildContext context) =>
    const _InputOtpOtp(obscureText: true);

/// The shorter four-slot field.
Widget _inputOtpFourSlots(BuildContext context) =>
    const _InputOtpOtp(length: 4);

/// Named docs examples for `input_otp`; the first entry is the default.
const List<ComponentPreview> inputOtpPreviews = <ComponentPreview>[
  ComponentPreview('Default', _inputOtpDefault),
  ComponentPreview('Separated', _inputOtpSeparated),
  ComponentPreview('Obscured', _inputOtpObscured),
  ComponentPreview('Four slots', _inputOtpFourSlots),
];
