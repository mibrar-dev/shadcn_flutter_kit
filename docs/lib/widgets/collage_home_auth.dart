// Home showcase: auth cards (P6-H1).
//
// `Create Account` and `Verify your phone` extend the Theme Studio blocks
// (`studio_blocks/studio_forms.dart`, `studio_blocks/studio_media.dart`);
// `Welcome back` is the reference home's `Account Access` card, composed
// from the same `Input` / `Button` / `Divider` components.

import 'package:flutter/widgets.dart';

import '../ui/shadcn/components/button/button.dart';
import '../ui/shadcn/components/divider/divider.dart';
import '../ui/shadcn/components/input/input.dart';
import '../ui/shadcn/components/input_otp/input_otp.dart';
import '../ui/shadcn/components/select/select.dart';
import '../ui/shadcn/components/switch/switch.dart';
import '../ui/shadcn/foundation/gap.dart';
import 'collage_cards.dart';
import 'studio_blocks/studio_card.dart';

/// `Create Account`: the shadcn email/password signup card.
class HomeCreateAccountCard extends StatefulWidget {
  /// Creates the card.
  const HomeCreateAccountCard({super.key});

  @override
  State<HomeCreateAccountCard> createState() => _HomeCreateAccountCardState();
}

class _HomeCreateAccountCardState extends State<HomeCreateAccountCard> {
  bool _sameAddress = true;
  String _payout = 'Bank Transfer';

  @override
  Widget build(BuildContext context) {
    return CollageCard(
      title: 'Create Account',
      subtitle: 'Start distributing your music in minutes.',
      children: <Widget>[
        const StudioFieldLabel('Email'),
        const Gap(6),
        const Input(
          initialValue: '',
          hintText: 'm@example.com',
          keyboardType: TextInputType.emailAddress,
        ),
        const Gap(16),
        const StudioFieldLabel('Password'),
        const Gap(6),
        const Input(
          initialValue: '',
          obscureText: true,
          hintText: 'At least 8 characters',
        ),
        const Gap(16),
        const StudioFieldLabel('Payout Method'),
        const Gap(6),
        Select<String>(
          value: _payout,
          onChanged: (String? next) =>
              setState(() => _payout = next ?? _payout),
          items: const <Widget>[
            SelectItem<String>(
              value: 'Bank Transfer',
              child: Text('Bank Transfer'),
            ),
            SelectItem<String>(value: 'PayPal', child: Text('PayPal')),
          ],
          itemBuilder: (BuildContext context, String value) => Text(value),
        ),
        const Gap(16),
        Row(
          children: <Widget>[
            const Expanded(child: Text('Billing same as payout')),
            Switch(
              value: _sameAddress,
              onChanged: (bool value) => setState(() => _sameAddress = value),
            ),
          ],
        ),
        const Gap(16),
        Button(
          variant: ButtonVariant.primary,
          onPressed: () {},
          child: const SizedBox(
            width: double.infinity,
            child: Text('Create Account', textAlign: TextAlign.center),
          ),
        ),
      ],
    );
  }
}

/// `Welcome back`: the reference home's account-access card.
class HomeLoginCard extends StatelessWidget {
  /// Creates the card.
  const HomeLoginCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const CollageCard(
      title: 'Welcome back',
      subtitle: 'Sign in to your workspace.',
      children: <Widget>[
        StudioFieldLabel('Email Address'),
        Gap(6),
        Input(
          initialValue: '',
          hintText: 'm@example.com',
          keyboardType: TextInputType.emailAddress,
        ),
        Gap(16),
        StudioFieldLabel('Password'),
        Gap(6),
        Input(initialValue: '', obscureText: true, hintText: '••••••••'),
        Gap(16),
        Button(
          variant: ButtonVariant.primary,
          onPressed: collageNoop,
          child: SizedBox(
            width: double.infinity,
            child: Text('Sign In', textAlign: TextAlign.center),
          ),
        ),
        Gap(12),
        Divider(label: Text('or')),
        Gap(12),
        Button(
          variant: ButtonVariant.outline,
          onPressed: collageNoop,
          child: SizedBox(
            width: double.infinity,
            child: Text('Continue with SSO', textAlign: TextAlign.center),
          ),
        ),
        Gap(8),
        StudioHelper('Forgot your password? Reset it by email.'),
      ],
    );
  }
}

/// `Verify your phone`: an OTP field with its action row.
class HomeOtpCard extends StatelessWidget {
  /// Creates the card.
  const HomeOtpCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const CollageCard(
      title: 'Verify your phone',
      subtitle: 'Enter the 6-digit code we texted to ···· 1192.',
      children: <Widget>[
        InputOtp(length: 6),
        Gap(16),
        Row(
          children: <Widget>[
            Expanded(
              child: Button(
                variant: ButtonVariant.outline,
                onPressed: collageNoop,
                child: Text('Resend'),
              ),
            ),
            Gap(12),
            Expanded(
              child: Button(
                variant: ButtonVariant.primary,
                onPressed: collageNoop,
                child: Text('Verify'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
