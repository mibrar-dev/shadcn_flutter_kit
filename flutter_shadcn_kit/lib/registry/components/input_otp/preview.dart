// Widgets-only preview gallery for the `input_otp` component.
//
// Shows a plain code, a separator, an obscured code, a disabled one and a
// scoped theme leg.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'input_otp.dart';

/// Preview entry point used by the docs gallery.
class InputOtpPreview extends StatefulWidget {
  /// Creates the preview.
  const InputOtpPreview({super.key});

  @override
  State<InputOtpPreview> createState() => _InputOtpPreviewState();
}

class _InputOtpPreviewState extends State<InputOtpPreview> {
  String _code = '';
  String _grouped = '';
  String _obscured = '';

  @override
  Widget build(BuildContext context) {
    return ShadcnTheme(
      data: const ShadcnThemeData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return ColoredBox(
      color: colors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('code: "$_code"'),
            SizedBox(height: ShadcnTheme.of(context).spacing.sm),
            InputOtp(
              length: 6,
              onChanged: (code) => setState(() => _code = code),
            ),
            SizedBox(height: ShadcnTheme.of(context).spacing.xl),
            Text('grouped: "$_grouped"'),
            SizedBox(height: ShadcnTheme.of(context).spacing.sm),
            InputOtp(
              length: 6,
              separatorEvery: 3,
              separator: const Text('-'),
              onChanged: (code) => setState(() => _grouped = code),
            ),
            SizedBox(height: ShadcnTheme.of(context).spacing.xl),
            Text('obscured: "$_obscured"'),
            SizedBox(height: ShadcnTheme.of(context).spacing.sm),
            InputOtp(
              length: 6,
              obscureText: true,
              initialValue: '4242',
              onChanged: (code) => setState(() => _obscured = code),
            ),
            SizedBox(height: ShadcnTheme.of(context).spacing.xl),
            const Text('read-only'),
            SizedBox(height: ShadcnTheme.of(context).spacing.sm),
            const InputOtp(length: 4, readOnly: true, initialValue: '1234'),
            SizedBox(height: ShadcnTheme.of(context).spacing.xl),
            const Text('scoped theme leg (taller, rounded slots)'),
            SizedBox(height: ShadcnTheme.of(context).spacing.sm),
            ComponentTheme<InputOtpTheme>(
              data: const InputOtpTheme(
                boxSize: 48,
                spacing: 12,
                borderRadius: BorderRadius.all(Radius.circular(12)),
                background: StateValue(
                  rest: ThemedColor.ref(ColorRef.accent, alpha: 0.3),
                ),
              ),
              child: const InputOtp(length: 4),
            ),
          ],
        ),
      ),
    );
  }
}
