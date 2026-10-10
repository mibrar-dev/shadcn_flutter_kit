// The `login-02` block: a split login — form beside a full-bleed image.
//
// Below 900px the image panel stacks above the form; the image itself is a
// 48x48 PNG decoded from memory, so the block renders offline and inside a
// widget test exactly as it does in a real app.

import 'dart:convert';

import 'package:flutter/widgets.dart';

import '../../components/image/image.dart';
import '../../components/input/input.dart';
import '../../components/button/button.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';

/// A 48x48 PNG decoded from memory: the block never hits the network, so it
/// renders identically offline and inside a widget test.
const String _login02PhotoBase64 =
    'iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAIAAADYYG7QAAAAWElEQVR42u3OoRGAMBBFwdPURBHoFIaj'
    'KTS9hBL+ROTUzjz/ts7xxZ73js1x5eqIFRAQEBAQ0CKoczarYkBAQEBAQKugzhkQEBAQENAWUOMMCAgIC'
    'AhoQz/vbpR28UARAAAAAABJRU5ErkJggg==';

/// The photo decoded from [_login02PhotoBase64].
final ImageProvider _login02Photo = MemoryImage(
  base64Decode(_login02PhotoBase64),
);

/// A split login page: the form on one side, a full-bleed image on the other.
class Login02 extends StatelessWidget {
  /// Creates the block.
  const Login02({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool split = constraints.maxWidth >= 900;
            final Widget form = SingleChildScrollView(
              padding: EdgeInsets.all(spacing.xl),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 380),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text('Sign in', style: theme.typography.h2),
                    Gap(spacing.sm),
                    Text(
                      'Enter your details below to continue.',
                      style: theme.typography.textMuted.copyWith(
                        color: theme.colors.mutedForeground,
                      ),
                    ),
                    Gap(spacing.xl),
                    _login02Label(context, 'Email'),
                    Gap(spacing.sm),
                    const Input(hintText: 'name@example.com'),
                    Gap(spacing.lg),
                    _login02Label(context, 'Password'),
                    Gap(spacing.sm),
                    const Input(hintText: 'Password', obscureText: true),
                    Gap(spacing.xl),
                    Button(onPressed: () {}, child: const Text('Sign in')),
                    Gap(spacing.lg),
                    const _Login02Footer(),
                  ],
                ),
              ),
            );
            if (!split) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 180,
                      child: ShadcnImage(
                        image: _login02Photo,
                        fit: BoxFit.cover,
                        height: 180,
                        semanticLabel: 'Abstract placeholder artwork',
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(spacing.lg), child: form),
                  ],
                ),
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(flex: 3, child: form),
                Expanded(
                  flex: 2,
                  // The panel fills the shell's height, so its height comes
                  // from the layout constraints rather than a literal.
                  child: ShadcnImage(
                    image: _login02Photo,
                    fit: BoxFit.cover,
                    height: constraints.maxHeight,
                    semanticLabel: 'Abstract placeholder artwork',
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

Widget _login02Label(BuildContext context, String text) {
  final theme = ShadcnTheme.of(context);
  return Text(
    text,
    style: theme.typography.textSmall.copyWith(fontWeight: FontWeight.w500),
  );
}

class _Login02Footer extends StatelessWidget {
  const _Login02Footer();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'By signing in you agree to our terms of service.',
          textAlign: TextAlign.center,
          style: theme.typography.xSmall.copyWith(
            color: theme.colors.mutedForeground,
          ),
        ),
      ],
    );
  }
}
