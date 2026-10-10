// The `otp-01` block: a one-time-code verification card.
//
// Six slots, a resend row and a "change email" affordance. The `InputOtp`
// component owns the slots; the block adds the shell around it and keeps the
// resend timer in its own state.

import 'package:flutter/widgets.dart';

import '../../components/button/button.dart';
import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import '../../components/input_otp/input_otp.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';

/// A one-time-code verification card with a countdown before resending.
class Otp01 extends StatefulWidget {
  /// Creates the block.
  const Otp01({super.key});

  @override
  State<Otp01> createState() => _Otp01State();
}

class _Otp01State extends State<Otp01> {
  int _secondsLeft = 47;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(spacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Card(
                padding: EdgeInsets.all(spacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _Otp01Title(),
                    Gap(spacing.xl),
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 320),
                        child: const InputOtp(length: 6),
                      ),
                    ),
                    Gap(spacing.lg),
                    _Otp01Resend(
                      secondsLeft: _secondsLeft,
                      onResend: () => setState(() => _secondsLeft = 47),
                    ),
                    Gap(spacing.xl),
                    const Button(child: Text('Verify')),
                    Gap(spacing.lg),
                    const Divider(),
                    Gap(spacing.lg),
                    const _Otp01ChangeEmail(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Otp01Title extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Verify your email', style: theme.typography.h2),
        Gap(spacing.sm),
        Text(
          'We sent a six-digit code to ada@example.com.',
          style: theme.typography.textMuted.copyWith(
            color: theme.colors.mutedForeground,
          ),
        ),
      ],
    );
  }
}

class _Otp01Resend extends StatelessWidget {
  const _Otp01Resend({required this.secondsLeft, required this.onResend});

  final int secondsLeft;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
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

class _Otp01ChangeEmail extends StatelessWidget {
  const _Otp01ChangeEmail();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Center(
      child: Text(
        'Use a different email',
        style: theme.typography.textSmall.copyWith(
          color: theme.colors.mutedForeground,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
