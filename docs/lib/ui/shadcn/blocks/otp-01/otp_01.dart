// The `otp-01` block: a one-time-code verification card with a validated
// form.
//
// A block is layer 4 of the registry: it may import foundation, theme,
// primitives and components, never another block. Its public widget is the
// preview - the docs page renders it exactly as an app would.
//
// The card is constrained to 384px (max-w-sm) and centres itself; the content
// shrink-wraps so the docs frame sizes to its intrinsic height, and scrolls
// internally when the host is bounded and shorter than the form. The code
// must be exactly 6 digits; completing all slots submits automatically.

import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../components/alert/alert.dart';
import '../../components/button/button.dart';
import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import '../../components/form/form.dart';
import '../../components/input_otp/input_otp.dart';
import '../../components/spinner/spinner.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';

/// Values submitted by [Otp01].
class Otp01Data {
  /// Creates the submitted values.
  const Otp01Data({required this.code});

  /// The validated 6-digit code.
  final String code;
}

/// A one-time-code verification card with a countdown before resending.
class Otp01 extends StatefulWidget {
  /// Creates the block.
  const Otp01({super.key, this.email, this.onSubmit, this.onChangeEmail});

  /// The address the code was sent to.
  final String? email;

  /// Called once with the typed values after a valid submit (after a short
  /// simulated async call). Null keeps the demo success alert.
  final FutureOr<void> Function(Otp01Data data)? onSubmit;

  /// Called when "Use a different email" is tapped.
  final VoidCallback? onChangeEmail;

  @override
  State<Otp01> createState() => _Otp01State();
}

class _Otp01State extends State<Otp01> {
  static final Validator<String> _codeValidator =
      const NotEmptyValidator() &
      const LengthValidator(min: 6, max: 6) &
      RegexValidator(RegExp(r'^\d{6}$'));

  final FormController _controller = FormController();
  final FormKey<String> _codeKey = const FormKey<String>('code');
  Timer? _timer;
  int _secondsLeft = 30;
  bool _submitting = false;
  bool _succeeded = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _secondsLeft = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (!mounted) {
        return;
      }
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _secondsLeft = 0);
        return;
      }
      setState(() => _secondsLeft -= 1);
    });
  }

  Future<void> _submit() async {
    if (_submitting) {
      return;
    }
    setState(() {
      _submitting = true;
      _succeeded = false;
    });
    try {
      await _controller.submit(context);
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  Future<void> _handleValidSubmit(FormMapValues values) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final Otp01Data data = Otp01Data(code: values.getValue(_codeKey) ?? '');
    await widget.onSubmit?.call(data);
    if (!mounted) {
      return;
    }
    setState(() => _succeeded = true);
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final String email = widget.email ?? 'ada@example.com';
    final Widget body = Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 384),
        child: Card(
          padding: EdgeInsets.all(theme.spacing.xl),
          child: ShadcnForm(
            controller: _controller,
            onSubmit: _handleValidSubmit,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text('Verify your email', style: theme.typography.h2),
                Gap(theme.spacing.sm),
                Text(
                  'We sent a six-digit code to $email.',
                  style: theme.typography.textMuted.copyWith(
                    color: theme.colors.mutedForeground,
                  ),
                ),
                Gap(theme.spacing.xl),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 320),
                    child: ShadcnFormField<String>(
                      key: _codeKey,
                      label: const Text('Code'),
                      validator: _codeValidator,
                      showErrors: const <FormValidationMode>{
                        FormValidationMode.changed,
                        FormValidationMode.submitted,
                      },
                      child: InputOtp(
                        length: 6,
                        onCompleted: (_) => _submit(),
                        onSubmitted: (_) => _submit(),
                      ),
                    ),
                  ),
                ),
                Gap(theme.spacing.lg),
                _Otp01Resend(
                  secondsLeft: _secondsLeft,
                  onResend: _startCountdown,
                ),
                Gap(theme.spacing.xl),
                Button(
                  onPressed: _submitting ? null : _submit,
                  child: _submitting
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Spinner(
                              size: 14,
                              color: theme.colors.primaryForeground,
                            ),
                            Gap(theme.spacing.sm),
                            const Text('Verifying'),
                          ],
                        )
                      : const Text('Verify'),
                ),
                if (_succeeded) ...<Widget>[
                  Gap(theme.spacing.lg),
                  Alert(
                    content: Text(
                      'Email verified — you are all set.',
                      style: theme.typography.textSmall,
                    ),
                  ),
                ],
                Gap(theme.spacing.lg),
                const Divider(),
                Gap(theme.spacing.lg),
                Center(
                  child: Button(
                    variant: ButtonVariant.link,
                    onPressed: widget.onChangeEmail ?? () {},
                    child: const Text('Use a different email'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (!constraints.maxHeight.isFinite) {
              return Padding(
                padding: EdgeInsets.all(theme.spacing.lg),
                child: body,
              );
            }
            return SingleChildScrollView(
              padding: EdgeInsets.all(theme.spacing.lg),
              child: body,
            );
          },
        ),
      ),
    );
  }
}

class _Otp01Resend extends StatelessWidget {
  const _Otp01Resend({required this.secondsLeft, required this.onResend});

  final int secondsLeft;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Row(
      children: <Widget>[
        Flexible(
          child: Text(
            "Didn't get the code?",
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
        ),
        const Spacer(),
        if (secondsLeft > 0)
          Text(
            'Resend in ${secondsLeft}s',
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          )
        else
          Button(
            variant: ButtonVariant.link,
            onPressed: onResend,
            child: const Text('Resend'),
          ),
      ],
    );
  }
}
