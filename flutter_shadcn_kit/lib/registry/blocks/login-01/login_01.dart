// The `login-01` block: a centred sign-in card.
//
// A block is layer 4 of the registry: it may import foundation, theme,
// primitives and components, never another block. Its public widget is the
// preview - the docs page renders it exactly as an app would.

import 'package:flutter/widgets.dart';

import '../../components/button/button.dart';
import '../../components/card/card.dart';
import '../../components/checkbox/checkbox.dart';
import '../../components/divider/divider.dart';
import '../../components/input/input.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';

/// A centred sign-in card: email, password, remember-me and a primary action.
///
/// The card is constrained to 400px and scrolls vertically when the host is
/// shorter than the form, so it renders unchanged from a 375px phone up to a
/// 1440px desktop.
class Login01 extends StatelessWidget {
  /// Creates the block.
  const Login01({super.key});

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
                    Text('Sign in', style: theme.typography.h3),
                    Gap(spacing.xs),
                    Text(
                      'Enter your credentials to access your workspace.',
                      style: theme.typography.textMuted.copyWith(
                        color: theme.colors.mutedForeground,
                      ),
                    ),
                    Gap(spacing.xl),
                    Text(
                      'Email',
                      style: theme.typography.textSmall.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Gap(spacing.sm),
                    const Input(
                      hintText: 'name@example.com',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    Gap(spacing.md),
                    // The label keeps its natural width; the link is a plain
                    // anchor (zero horizontal padding) pushed to the end, so
                    // its text's right edge meets the input's. The link side is
                    // Expanded + right-aligned (never a loose Flexible): in the
                    // Ahem test font the text wraps instead of overflowing, and
                    // the wrapped lines stay end-aligned.
                    Row(
                      children: <Widget>[
                        Text(
                          'Password',
                          style: theme.typography.textSmall.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Button(
                              variant: ButtonVariant.link,
                              onPressed: () {},
                              child: const Text(
                                'Forgot password?',
                                textAlign: TextAlign.end,
                                softWrap: true,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(spacing.sm),
                    const Input(hintText: '••••••••', obscureText: true),
                    Gap(spacing.md),
                    Checkbox(
                      value: CheckboxValue.checked,
                      // Demo keeps the control enabled; the block is static.
                      onChanged: (_) {},
                      label: const Text('Remember me'),
                    ),
                    Gap(spacing.xl),
                    // Demo keeps the primary action enabled (not disabled).
                    Button(onPressed: () {}, child: const Text('Sign in')),
                    Gap(spacing.lg),
                    const Divider(),
                    Gap(spacing.lg),
                    Button(
                      variant: ButtonVariant.outline,
                      onPressed: () {},
                      child: const Text('Create an account'),
                    ),
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
