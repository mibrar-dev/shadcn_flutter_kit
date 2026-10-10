// GENERATED CODE - DO NOT MODIFY BY HAND.
//
// Sources:
//   * flutter_shadcn_kit/lib/registry/blocks/<id>/<file>.dart
//
// Regenerate: dart run tool/gen_docs_data.dart
//
// The Blocks code view: one file per block, verbatim, with the same
// 4-class highlight map the README snippets use (`p`/`c`/`k`/`s`,
// one class per character). Imported by the deferred Blocks pages.

/// One block file: its install-root-relative path and source.
class DocsBlockFile {
  /// Creates a block file entry.
  const DocsBlockFile({
    required this.path,
    required this.code,
    required this.tokenClasses,
  });

  /// Install-root-relative path (`lib/ui/shadcn/blocks/…`).
  final String path;

  /// File source, verbatim.
  final String code;

  /// One highlight class per character of [code].
  final String tokenClasses;

  /// File name without its block-directory prefix.
  String get name => path.split('/').last;
}

/// Block files keyed by block id, in manifest `files` order.
const Map<String, List<DocsBlockFile>>
kBlockFileSources = <String, List<DocsBlockFile>>{
  'login-01': <DocsBlockFile>[
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/login-01/login_01.dart',
      code: r'''// The `login-01` block: a centred sign-in card.
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
''',
      tokenClasses:
          'ccccccccccccccccccccccccccccccccccccccccccccccccpccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccpkkkkkpppppppppkkkkkkkpppppppppppppppppppppccccccccccccccccccccccpppkkkkkppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppppppppppppppccccccccccccccccccccccccccccccccccccccppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppsssssssssspppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'login-02': <DocsBlockFile>[
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/login-02/login_02.dart',
      code:
          r'''// The `login-02` block: a split login — form beside a full-bleed image.
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
''',
      tokenClasses:
          'ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccppkkkkkkpsssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkppppppppppppppppppppppppppppppppppsssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssspppppssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssspppppssssssssssssssssssssssssssssssssssssspppcccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppkkkkkkkpppppppppppppppppppppccccccccccccccccccccccpppkkkkkppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppsssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppsssssssssspppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'login-03': <DocsBlockFile>[
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/login-03/login_03.dart',
      code: r'''// The `login-03` block: a sign-in card with social buttons.
//
// Three providers, a divider between them, and the email/password form below.
// The provider buttons wrap, so the card keeps its 400px measure on a phone
// and centres itself on a desktop stage.

import 'package:flutter/widgets.dart';

import '../../components/button/button.dart';
import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import '../../components/input/input.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/theme.dart';

/// A sign-in card with social providers and an email form.
class Login03 extends StatelessWidget {
  /// Creates the block.
  const Login03({super.key});

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
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                padding: EdgeInsets.all(spacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _Login03Title(),
                    Gap(spacing.xl),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Button(
                            variant: ButtonVariant.outline,
                            onPressed: () {},
                            child: const _Login03ProviderButton('GitHub'),
                          ),
                        ),
                        Gap(0, crossAxisExtent: 12),
                        Expanded(
                          child: Button(
                            variant: ButtonVariant.outline,
                            onPressed: () {},
                            child: const _Login03ProviderButton('Google'),
                          ),
                        ),
                      ],
                    ),
                    Gap(spacing.xl),
                    const Divider(),
                    Gap(spacing.xl),
                    _Login03EmailField(),
                    Gap(spacing.md),
                    _Login03PasswordField(),
                    Gap(spacing.md),
                    const _Login03ForgotRow(),
                    Gap(spacing.xl),
                    Button(
                      onPressed: () {},
                      child: const Text('Sign in with email'),
                    ),
                    Gap(spacing.lg),
                    const _Login03Signup(),
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

class _Login03Title extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Sign in', style: theme.typography.h2),
        Gap(spacing.sm),
        Text(
          'Pick the way you prefer.',
          style: theme.typography.textMuted.copyWith(
            color: theme.colors.mutedForeground,
          ),
        ),
      ],
    );
  }
}

/// A social provider button: an icon plus the provider name.
class _Login03ProviderButton extends StatelessWidget {
  const _Login03ProviderButton(this.provider);

  final String provider;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(LucideIcons.github, size: 16, color: theme.colors.foreground),
        const Gap(0, crossAxisExtent: 8),
        Flexible(child: Text(provider, style: theme.typography.textSmall)),
      ],
    );
  }
}

class _Login03EmailField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: theme.typography.textSmall.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        Gap(spacing.sm),
        const Input(hintText: 'name@example.com'),
      ],
    );
  }
}

class _Login03PasswordField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: theme.typography.textSmall.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        Gap(spacing.sm),
        const Input(hintText: 'Password', obscureText: true),
      ],
    );
  }
}

class _Login03ForgotRow extends StatelessWidget {
  const _Login03ForgotRow();

  @override
  Widget build(BuildContext context) {
    // Right-aligned under the password field, on the field's right edge: a
    // plain anchor (zero horizontal padding) pushed to the end. Expanded +
    // right-aligned (never a loose Flexible): the text wraps instead of
    // overflowing, and wrapped lines stay end-aligned.
    return Row(
      children: <Widget>[
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Button(
              variant: ButtonVariant.link,
              onPressed: () {},
              child: const Text(
                'Forgot your password?',
                textAlign: TextAlign.end,
                softWrap: true,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Login03Signup extends StatelessWidget {
  const _Login03Signup();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    // Centered footer: static text plus a real link button (was plain text
    // with no handler); wraps on narrow screens.
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4,
      children: <Widget>[
        Text(
          "Don't have an account?",
          style: theme.typography.textSmall.copyWith(
            color: theme.colors.mutedForeground,
          ),
        ),
        Button(
          variant: ButtonVariant.link,
          onPressed: () {},
          child: const Text('Sign up'),
        ),
      ],
    );
  }
}
''',
      tokenClasses:
          'ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpssssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppkkkkkkkpppppppppppppppppppppccccccccccccccccccccccpppkkkkkppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppkkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkppppppppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppkkkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppkkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppssssssssssssssssssppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppkkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppsssssssssspppppppppppppppkkkkppppppppppppppppppppppppppkkkkkpppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppcccccccccccccccccccccccccccccccccccccccccccccccccccpppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppsssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppcccccccccccccccccccccccccccccccccccccccccccccpppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssspppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'otp-01': <DocsBlockFile>[
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/otp-01/otp_01.dart',
      code: r'''// The `otp-01` block: a one-time-code verification card.
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
                    Button(onPressed: () {}, child: const Text('Verify')),
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
    // Was plain underlined text with no handler; a real link button now.
    return Center(
      child: Button(
        variant: ButtonVariant.link,
        onPressed: () {},
        child: const Text('Use a different email'),
      ),
    );
  }
}
''',
      tokenClasses:
          'cccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppkkkkkkkppppppppppppppppppppccccccccccccccccccccccpppkkkkkppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppkkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppkkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppkkkkkkkkpkkkkppppppppppppppkkkkkkkkpkkkkppppppppppppppppkkkkkppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppsssssssssssppppppppppppppssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssspppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssssssssssssssssppppppppppppppppppppppppp',
    ),
  ],
  'signup-01': <DocsBlockFile>[
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/signup-01/signup_01.dart',
      code:
          r'''// The `signup-01` block: a create-account card with a terms checkbox.
//
// The form is shrink-wrapped and scrollable, so the card never overflows on a
// 375px phone and centres itself on a desktop stage.

import 'package:flutter/widgets.dart';

import '../../components/button/button.dart';
import '../../components/card/card.dart';
import '../../components/checkbox/checkbox.dart';
import '../../components/input/input.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';

/// A create-account card: name, email, password and a terms checkbox.
class Signup01 extends StatelessWidget {
  /// Creates the block.
  const Signup01({super.key});

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
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                padding: EdgeInsets.all(spacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text('Create an account', style: theme.typography.h2),
                    Gap(spacing.sm),
                    Text(
                      'Enter your email below to create your account.',
                      style: theme.typography.textMuted.copyWith(
                        color: theme.colors.mutedForeground,
                      ),
                    ),
                    Gap(spacing.xl),
                    _Signup01Field(label: 'Name', hint: 'Pavel Nikolov'),
                    Gap(spacing.md),
                    _Signup01Field(label: 'Email', hint: 'name@example.com'),
                    Gap(spacing.md),
                    _Signup01Field(
                      label: 'Password',
                      hint: 'Password',
                      obscure: true,
                    ),
                    Gap(spacing.lg),
                    const _Signup01Terms(),
                    Gap(spacing.xl),
                    Button(
                      onPressed: () {},
                      child: const Text('Create account'),
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

class _Signup01Field extends StatelessWidget {
  const _Signup01Field({
    required this.label,
    required this.hint,
    this.obscure = false,
  });

  final String label;
  final String hint;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: theme.typography.textSmall.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        Gap(spacing.sm),
        Input(hintText: hint, obscureText: obscure),
      ],
    );
  }
}

class _Signup01Terms extends StatelessWidget {
  const _Signup01Terms();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Checkbox(value: CheckboxValue.unchecked, onChanged: (_) {}),
        Gap(spacing.sm),
        // Was a RichText with underlined spans and no handlers; inline
        // plain-anchor link buttons keep the sentence shape and stay tappable.
        Expanded(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 0,
            children: <Widget>[
              Text(
                'I agree to the ',
                style: theme.typography.textSmall.copyWith(
                  color: theme.colors.mutedForeground,
                ),
              ),
              Button(
                variant: ButtonVariant.link,
                onPressed: () {},
                child: const Text('terms'),
              ),
              Text(
                ' and the ',
                style: theme.typography.textSmall.copyWith(
                  color: theme.colors.mutedForeground,
                ),
              ),
              Button(
                variant: ButtonVariant.link,
                onPressed: () {},
                child: const Text('privacy policy'),
              ),
              Text(
                '.',
                style: theme.typography.textSmall.copyWith(
                  color: theme.colors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
''',
      tokenClasses:
          'ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkppppppppppkkkkkkkpppppppppppppppppppppccccccccccccccccccccccpppkkkkkpppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssppppppppsssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssppppppppsssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssppppppppppppppppppppppppppppppsssssssssspppppppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkkkkpkkkkppppppppppppkkkkkkkkpkkkkpppppppppppkkkkpppppppppppkkkkkpppppppppppkkkkkpppppppppppppppppkkkkkppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'signup-02': <DocsBlockFile>[
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/signup-02/signup_02.dart',
      code:
          r'''// The `signup-02` block: a two-column sign-up with a summary aside.
//
// The form and the "what you get" aside sit side by side from 960px up, and
// stack below that. The password field carries a strength meter driven by the
// theme tokens, not a hard-coded colour.

import 'package:flutter/widgets.dart';

import '../../components/button/button.dart';
import '../../components/card/card.dart';
import '../../components/checkbox/checkbox.dart';
import '../../components/divider/divider.dart';
import '../../components/input/input.dart';
import '../../components/progress/progress.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/theme.dart';

/// A two-column sign-up: form on the left, a plan summary aside.
class Signup02 extends StatelessWidget {
  /// Creates the block.
  const Signup02({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool aside = constraints.maxWidth >= 960;
            final Widget form = const Signup02Form();
            if (!aside) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(spacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    form,
                    Gap(spacing.lg),
                    const Signup02Aside(),
                  ],
                ),
              );
            }
            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(spacing.xl),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1080),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(flex: 3, child: form),
                      Gap(spacing.xl),
                      const Expanded(flex: 2, child: Signup02Aside()),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// The sign-up form itself.
class Signup02Form extends StatelessWidget {
  /// Creates the form column.
  const Signup02Form({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text('Create your account', style: theme.typography.h2),
        Gap(spacing.sm),
        Text(
          'Start your 14-day trial. No credit card required.',
          style: theme.typography.textMuted.copyWith(
            color: theme.colors.mutedForeground,
          ),
        ),
        Gap(spacing.xl),
        Row(
          children: <Widget>[
            const Expanded(
              child: _Signup02Field(label: 'First name', hint: 'Ada'),
            ),
            Gap(spacing.md),
            const Expanded(
              child: _Signup02Field(label: 'Last name', hint: 'Lovelace'),
            ),
          ],
        ),
        Gap(spacing.md),
        const _Signup02Field(label: 'Work email', hint: 'ada@example.com'),
        Gap(spacing.md),
        const _Signup02Field(
          label: 'Password',
          hint: 'At least 8 characters',
          obscure: true,
        ),
        Gap(spacing.sm),
        const _Signup02Strength(),
        Gap(spacing.lg),
        const _Signup02Consent(),
        Gap(spacing.xl),
        Button(onPressed: () {}, child: const Text('Start free trial')),
        Gap(spacing.lg),
        const Divider(),
        Gap(spacing.lg),
        const _Signup02Signin(),
      ],
    );
  }
}

class _Signup02Signin extends StatelessWidget {
  const _Signup02Signin();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    // Was plain text with no handler; static text plus a real link button.
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4,
      children: <Widget>[
        Text(
          'Already have an account?',
          style: theme.typography.textSmall.copyWith(
            color: theme.colors.mutedForeground,
          ),
        ),
        Button(
          variant: ButtonVariant.link,
          onPressed: () {},
          child: const Text('Sign in'),
        ),
      ],
    );
  }
}

class _Signup02Field extends StatelessWidget {
  const _Signup02Field({
    required this.label,
    required this.hint,
    this.obscure = false,
  });

  final String label;
  final String hint;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: theme.typography.textSmall.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        Gap(spacing.sm),
        Input(hintText: hint, obscureText: obscure),
      ],
    );
  }
}

/// A four-step strength meter; the colour follows the preset charts so it
/// re-themes with the app.
class _Signup02Strength extends StatelessWidget {
  const _Signup02Strength();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    const List<String> labels = <String>['Weak', 'Fair', 'Good', 'Strong'];
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            for (var i = 0; i < 4; i++) ...<Widget>[
              Expanded(
                child: Container(
                  height: spacing.xs,
                  decoration: BoxDecoration(
                    color: i < 2 ? theme.colors.chart1 : theme.colors.muted,
                    borderRadius: theme.borderRadiusXl,
                  ),
                ),
              ),
              if (i < 3) Gap(spacing.sm),
            ],
          ],
        ),
        Gap(spacing.sm),
        Text(
          labels[1],
          style: theme.typography.xSmall.copyWith(
            color: theme.colors.mutedForeground,
          ),
        ),
      ],
    );
  }
}

class _Signup02Consent extends StatelessWidget {
  const _Signup02Consent();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Checkbox(value: CheckboxValue.unchecked, onChanged: (_) {}),
        Gap(spacing.sm),
        // Was a RichText with underlined spans and no handlers; inline
        // plain-anchor link buttons keep the sentence shape and stay tappable.
        Expanded(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 0,
            children: <Widget>[
              Text(
                'I agree to the ',
                style: theme.typography.textSmall.copyWith(
                  color: theme.colors.mutedForeground,
                ),
              ),
              Button(
                variant: ButtonVariant.link,
                onPressed: () {},
                child: const Text('terms'),
              ),
              Text(
                ' and the ',
                style: theme.typography.textSmall.copyWith(
                  color: theme.colors.mutedForeground,
                ),
              ),
              Button(
                variant: ButtonVariant.link,
                onPressed: () {},
                child: const Text('privacy policy'),
              ),
              Text(
                '.',
                style: theme.typography.textSmall.copyWith(
                  color: theme.colors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The aside that lists what the trial includes.
class Signup02Aside extends StatelessWidget {
  /// Creates the summary aside.
  const Signup02Aside({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Card(
      padding: EdgeInsets.all(spacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('What you get', style: theme.typography.h3),
          Gap(spacing.lg),
          for (final line in const <String>[
            'Unlimited projects during the trial',
            'All component categories',
            'Priority support',
          ]) ...<Widget>[_Signup02Bullet(line: line), Gap(spacing.md)],
          const Divider(),
          Gap(spacing.lg),
          const Progress(value: 1, height: 8),
          Gap(spacing.sm),
          Text(
            '14 days left in your trial',
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

class _Signup02Bullet extends StatelessWidget {
  const _Signup02Bullet({required this.line});

  final String line;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(LucideIcons.check, size: 16, color: theme.colors.primary),
        Gap(spacing.sm),
        Expanded(child: Text(line, style: theme.typography.textSmall)),
      ],
    );
  }
}
''',
      tokenClasses:
          'ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpssssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkppppppppppkkkkkkkpppppppppppppppppppppccccccccccccccccccccccpppkkkkkpppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppkkkkkpppppppppppppppppppppppppppppkkppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppccccccccccccccccccccccccccccpkkkkkppppppppppppppkkkkkkkpppppppppppppppppppppccccccccccccccccccccccccccccpppkkkkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssppppppppssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssppppppppsssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppssssssssssssppppppppsssssssssssssssssppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppssssssssssppppppppppppppppppssssssssssssssssssssssspppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssssssssssspppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssspppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkkkkpkkkkppppppppppppkkkkkkkkpkkkkpppppppppppkkkkpppppppppppkkkkkpppppppppppkkkkkpppppppppppppppppkkkkkppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccpkkkkkpppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppssssssppssssssppssssssppsssssssspppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppppppppkkkkkkkpppppppppppppppppppppccccccccccccccccccccccccccccccpppkkkkkppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkkkppppppkkpkkkkkpppppppppppppppppppppppsssssssssssssssssssssssssssssssssssssppppppppppppppssssssssssssssssssssssssssppppppppppppppssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppkkkkkkkkpkkkkppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'calendar-01': <DocsBlockFile>[
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/calendar-01/calendar_01.dart',
      code: r'''// The `calendar-01` block: a date-range picker card.
//
// A two-month range calendar (one month on a phone), a visible range summary
// and the shadcn date-range card footer. `Calendar` owns no navigation, so
// the block drives the `CalendarView` itself.

import 'package:flutter/widgets.dart';

import '../../components/button/button.dart';
import '../../components/calendar/calendar.dart';
import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../primitives/date_math.dart';
import '../../theme/theme.dart';

/// A date-range card: the calendar, a range summary and footer actions.
class Calendar01 extends StatefulWidget {
  /// Creates the block.
  const Calendar01({super.key});

  @override
  State<Calendar01> createState() => _Calendar01State();
}

class _Calendar01State extends State<Calendar01> {
  CalendarView _view = const CalendarView(2026, 10);
  CalendarValue? _value;

  void _shift(int months) {
    setState(() => _view = months < 0 ? _view.previous : _view.next);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool twoMonths = constraints.maxWidth >= 720;
            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(spacing.lg),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Card(
                    padding: EdgeInsets.all(spacing.lg),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        _Calendar01Header(
                          view: _view,
                          twoMonths: twoMonths,
                          onShift: _shift,
                        ),
                        Gap(spacing.lg),
                        if (twoMonths)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: _Calendar01Month(
                                  view: _view,
                                  value: _value,
                                  onChanged: (CalendarValue? value) =>
                                      setState(() => _value = value),
                                ),
                              ),
                              Gap(spacing.xl),
                              Expanded(
                                child: _Calendar01Month(
                                  view: _view.next,
                                  value: _value,
                                  onChanged: (CalendarValue? value) =>
                                      setState(() => _value = value),
                                ),
                              ),
                            ],
                          )
                        else
                          _Calendar01Month(
                            view: _view,
                            value: _value,
                            onChanged: (CalendarValue? value) =>
                                setState(() => _value = value),
                          ),
                        Gap(spacing.lg),
                        const Divider(),
                        Gap(spacing.lg),
                        const _Calendar01Footer(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Calendar01Header extends StatelessWidget {
  const _Calendar01Header({
    required this.view,
    required this.twoMonths,
    required this.onShift,
  });

  final CalendarView view;
  final bool twoMonths;
  final ValueChanged<int> onShift;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    final months = twoMonths
        ? '${_monthName(view.month)} - ${_monthName(view.next.month)} ${view.next.year}'
        : '${_monthName(view.month)} ${view.year}';
    return Row(
      children: <Widget>[
        Expanded(child: Text(months, style: theme.typography.textLarge)),
        Gap(spacing.md),
        _Calendar01Step(
          icon: LucideIcons.chevronLeft,
          tooltip: 'Previous month',
          onPressed: () => onShift(-1),
        ),
        Gap(spacing.sm),
        _Calendar01Step(
          icon: LucideIcons.chevronRight,
          tooltip: 'Next month',
          onPressed: () => onShift(1),
        ),
      ],
    );
  }
}

class _Calendar01Step extends StatelessWidget {
  const _Calendar01Step({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // shadcn month stepper: a ghost icon button (was a raw '<'/'>' glyph).
    return Button(
      variant: ButtonVariant.ghost,
      size: ButtonSize.icon,
      onPressed: onPressed,
      child: Icon(icon, size: 16),
    );
  }
}

class _Calendar01Month extends StatelessWidget {
  const _Calendar01Month({
    required this.view,
    required this.value,
    required this.onChanged,
  });

  final CalendarView view;
  final CalendarValue? value;
  final ValueChanged<CalendarValue?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Calendar(
      view: view,
      now: DateTime(2026, 10, 10),
      selectionMode: CalendarSelectionMode.range,
      value: value,
      onChanged: onChanged,
    );
  }
}

class _Calendar01Footer extends StatelessWidget {
  const _Calendar01Footer();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            'Your stay: 7 nights',
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
        ),
        Gap(spacing.md),
        Button(
          variant: ButtonVariant.outline,
          onPressed: () {},
          child: const Text('Clear'),
        ),
        Gap(spacing.sm),
        Button(onPressed: () {}, child: const Text('Apply')),
      ],
    );
  }
}

String _monthName(int month) => switch (month) {
  1 => 'January',
  2 => 'February',
  3 => 'March',
  4 => 'April',
  5 => 'May',
  6 => 'June',
  7 => 'July',
  8 => 'August',
  9 => 'September',
  10 => 'October',
  11 => 'November',
  12 => 'December',
  _ => 'Month $month',
};
''',
      tokenClasses:
          'cccccccccccccccccccccccccccccccccccccccccccccccccccccpccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpssssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkppppppppppppkkkkkkkppppppppppppppppppppccccccccccccccccccccccpppkkkkkpppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppkkkkkkkppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppppkkkkkkkkpkkkkpppppppppppkkkkkkkkpkkkkppppppppppppppppkkkkkkkkpkkkkpppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkpppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppspppppppppppppppppppppppppsssppppppppppppppppppppppppppppppspppppppppppppppppspppppppppppspppppppppppppppppppppppppsppppppppppppsppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppkkkkkkkkpkkkkpppppppppppkkkkkkkkpkkkkppppppppppppppkkkkkkkkpkkkkpppppppppppppppppppppkkkkkppppppppppppppppppkkkkkpppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppkkkkkkkkpkkkkpppppppppppkkkkkkkkpkkkkppppppppppppkkkkkkkkpkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkpppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppssssssssspppppppppsssssssssspppppppppssssssspppppppppssssssspppppppppssssspppppppppsssssspppppppppsssssspppppppppsssssssspppppppppsssssssssssppppppppppsssssssssppppppppppssssssssssppppppppppsssssssssspppppppppsssssssppppppsppppp',
    ),
  ],
  'calendar-02': <DocsBlockFile>[
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/calendar-02/calendar_02.dart',
      code: r'''// The `calendar-02` block: a scheduling panel.
//
// A month calendar with the selected day's agenda beside it (below 960px the
// agenda moves under the calendar). Time slots are plain buttons so the block
// needs no extra component beyond `calendar`, `card` and `button`.

import 'package:flutter/widgets.dart';

import '../../components/button/button.dart';
import '../../components/calendar/calendar.dart';
import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../primitives/date_math.dart';
import '../../theme/theme.dart';

/// A scheduling panel: a month calendar and the selected day's agenda.
class Calendar02 extends StatefulWidget {
  /// Creates the block.
  const Calendar02({super.key});

  @override
  State<Calendar02> createState() => _Calendar02State();
}

class _Calendar02State extends State<Calendar02> {
  final DateTime _today = DateTime(2026, 10, 10);
  CalendarView _view = const CalendarView(2026, 10);
  CalendarValue? _value;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool aside = constraints.maxWidth >= 960;
            final Widget calendar = Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _Calendar02Header(
                    view: _view,
                    onPrevious: () => setState(() => _view = _view.previous),
                    onNext: () => setState(() => _view = _view.next),
                  ),
                  Gap(spacing.lg),
                  Calendar(
                    view: _view,
                    now: _today,
                    selectionMode: CalendarSelectionMode.single,
                    value: _value,
                    onChanged: (CalendarValue? value) =>
                        setState(() => _value = value),
                  ),
                ],
              ),
            );
            final Widget agenda = const _Calendar02Agenda();
            if (!aside) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(spacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[calendar, Gap(spacing.lg), agenda],
                ),
              );
            }
            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(spacing.xl),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1080),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(flex: 3, child: calendar),
                      Gap(spacing.xl),
                      Expanded(flex: 2, child: agenda),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Calendar02Header extends StatelessWidget {
  const _Calendar02Header({
    required this.view,
    required this.onPrevious,
    required this.onNext,
  });

  final CalendarView view;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            '${_monthName(view.month)} ${view.year}',
            style: theme.typography.textLarge,
          ),
        ),
        Gap(spacing.md),
        _Calendar02Step(
          icon: LucideIcons.chevronLeft,
          tooltip: 'Previous',
          onPressed: onPrevious,
        ),
        Gap(spacing.sm),
        _Calendar02Step(
          icon: LucideIcons.chevronRight,
          tooltip: 'Next',
          onPressed: onNext,
        ),
      ],
    );
  }
}

class _Calendar02Step extends StatelessWidget {
  const _Calendar02Step({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // shadcn month stepper: a ghost icon button (was a raw '<'/'>' glyph).
    return Button(
      variant: ButtonVariant.ghost,
      size: ButtonSize.icon,
      onPressed: onPressed,
      child: Icon(icon, size: 16),
    );
  }
}

class _Calendar02Agenda extends StatelessWidget {
  const _Calendar02Agenda();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text('Saturday, 10 October', style: theme.typography.h3),
          Gap(spacing.sm),
          Text(
            'Four slots left, 30 minutes each.',
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          Gap(spacing.lg),
          const _Calendar02Slots(),
          Gap(spacing.lg),
          const Divider(),
          Gap(spacing.lg),
          const _Calendar02Booking(),
        ],
      ),
    );
  }
}

class _Calendar02Slots extends StatelessWidget {
  const _Calendar02Slots();

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return Wrap(
      spacing: spacing.sm,
      runSpacing: spacing.sm,
      children: const <Widget>[
        _Calendar02Slot('09:00', taken: true),
        _Calendar02Slot('09:30'),
        _Calendar02Slot('10:00', taken: true),
        _Calendar02Slot('10:30'),
        _Calendar02Slot('11:00'),
        _Calendar02Slot('11:30', taken: true),
      ],
    );
  }
}

class _Calendar02Slot extends StatelessWidget {
  const _Calendar02Slot(this.time, {this.taken = false});

  final String time;
  final bool taken;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Button(
      variant: taken ? ButtonVariant.outline : ButtonVariant.secondary,
      enabled: !taken,
      onPressed: () {},
      child: Text(time, style: theme.typography.textSmall),
    );
  }
}

class _Calendar02Booking extends StatelessWidget {
  const _Calendar02Booking();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text('Calendar link', style: theme.typography.textSmall),
        Gap(theme.spacing.sm),
        Text(
          'cal.acme.com/ada-lovelace/30min',
          style: theme.typography.inlineCode.copyWith(
            color: theme.colors.mutedForeground,
          ),
        ),
        Gap(theme.spacing.lg),
        Button(onPressed: () {}, child: const Text('Book a meeting')),
      ],
    );
  }
}

String _monthName(int month) => switch (month) {
  1 => 'January',
  2 => 'February',
  3 => 'March',
  4 => 'April',
  5 => 'May',
  6 => 'June',
  7 => 'July',
  8 => 'August',
  9 => 'September',
  10 => 'October',
  11 => 'November',
  12 => 'December',
  _ => 'Month $month',
};
''',
      tokenClasses:
          'cccccccccccccccccccccccccccccccccccccccccccccccpccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpssssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkppppppppppppkkkkkkkppppppppppppppppppppccccccccccccccccccccccpppkkkkkpppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppkkkkkkkpppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppppkkkkkkkkpkkkkpppppppppppkkkkkkkkpkkkkpppppppppppppppppkkkkkkkkpkkkkppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppspppppppppppppppppppppppppsppppppppppppspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppkkkkkkkkpkkkkpppppppppppkkkkkkkkpkkkkppppppppppppppkkkkkkkkpkkkkpppppppppppppppppppppkkkkkppppppppppppppppppkkkkkpppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppkkpppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppssssssspppppppppkkkkpppppppppppppppppppppppppppssssssspppppppppppppppppppppppppppssssssspppppppppkkkkpppppppppppppppppppppppppppssssssspppppppppppppppppppppppppppssssssspppppppppppppppppppppppppppssssssspppppppppkkkkppppppppppppppppppppppppppkkkkkpppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppkkkkppppppppkkkkpppppppppkkkkkpppppppkkkkkppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppssssssssspppppppppsssssssssspppppppppssssssspppppppppssssssspppppppppssssspppppppppsssssspppppppppsssssspppppppppsssssssspppppppppsssssssssssppppppppppsssssssssppppppppppssssssssssppppppppppsssssssssspppppppppsssssssppppppsppppp',
    ),
  ],
  'dashboard-01': <DocsBlockFile>[
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/dashboard-01/dashboard_01.dart',
      code: r'''// The `dashboard-01` block: an analytics dashboard.
//
// Stat tiles, a bar chart drawn from theme chart tokens and a recent-orders
// table. Everything is laid out from `LayoutBuilder` breakpoints so the same
// widget works at 375px (one column) and 1440px (stat row + chart + table).

import 'package:flutter/widgets.dart';

import '../../components/avatar/avatar.dart';
import '../../components/button/button.dart';
import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import 'dashboard_01_table.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';

/// A dashboard: four stat tiles, a twelve-week bar chart and a recent table.
class Dashboard01 extends StatelessWidget {
  /// Creates the block.
  const Dashboard01({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool wide = constraints.maxWidth >= 1080;
            return SingleChildScrollView(
              padding: EdgeInsets.all(spacing.lg),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1440),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const _Dashboard01Header(),
                    Gap(spacing.lg),
                    _Dashboard01Stats(wide: wide),
                    Gap(spacing.lg),
                    if (wide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Expanded(flex: 3, child: _Dashboard01Chart()),
                          Gap(spacing.lg),
                          const Expanded(
                            flex: 2,
                            child: _Dashboard01Activity(),
                          ),
                        ],
                      )
                    else ...<Widget>[
                      const _Dashboard01Chart(),
                      Gap(spacing.lg),
                      const _Dashboard01Activity(),
                    ],
                    Gap(spacing.lg),
                    const Dashboard01Recent(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Dashboard01Header extends StatelessWidget {
  const _Dashboard01Header();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Overview', style: theme.typography.h2),
        Gap(spacing.xs),
        Text(
          'Revenue, subscriptions and the most recent orders.',
          style: theme.typography.textMuted.copyWith(
            color: theme.colors.mutedForeground,
          ),
        ),
      ],
    );
  }
}

class _Dashboard01Stats extends StatelessWidget {
  const _Dashboard01Stats({required this.wide});

  final bool wide;

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    const List<_Dashboard01Stat> stats = <_Dashboard01Stat>[
      _Dashboard01Stat('Total revenue', '\$45,231.89', '+20.1%'),
      _Dashboard01Stat('Subscriptions', '+2,350', '+180.1%'),
      _Dashboard01Stat('Sales', '+12,234', '+19.0%'),
      _Dashboard01Stat('Active now', '+573', '+2.0%'),
    ];
    if (wide) {
      // IntrinsicHeight bounds the cross axis before the stretch Row sees
      // it: inside the block's own scroll view the height is unbounded and
      // a bare Row(stretch) hands its Gap separators a tight infinite
      // height, which asserts in debug builds. Cards keep equal heights.
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            for (final stat in stats) ...<Widget>[
              Expanded(child: _Dashboard01StatCard(stat: stat)),
              if (stat != stats.last) Gap(spacing.lg),
            ],
          ],
        ),
      );
    }
    return Wrap(
      spacing: spacing.lg,
      runSpacing: spacing.lg,
      children: <Widget>[
        for (final stat in stats)
          SizedBox(width: 260, child: _Dashboard01StatCard(stat: stat)),
      ],
    );
  }
}

class _Dashboard01Stat {
  const _Dashboard01Stat(this.label, this.value, this.delta);

  final String label;
  final String value;
  final String delta;
}

class _Dashboard01StatCard extends StatelessWidget {
  const _Dashboard01StatCard({required this.stat});

  final _Dashboard01Stat stat;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            stat.label,
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          Gap(spacing.sm),
          Text(stat.value, style: theme.typography.h3),
          Gap(spacing.sm),
          Text(
            '${stat.delta} from last month',
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

class _Dashboard01Chart extends StatelessWidget {
  const _Dashboard01Chart();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    // One series, one token: every bar uses `chart1`, the way the
    // reference area chart fills a single series.
    const List<double> series = <double>[
      0.34,
      0.52,
      0.41,
      0.68,
      0.58,
      0.79,
      0.62,
      0.88,
      0.71,
      0.94,
      0.83,
      1.0,
    ];
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Revenue by month', style: theme.typography.textLarge),
          Gap(spacing.xs),
          Text(
            'January - June 2026',
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          Gap(spacing.lg),
          SizedBox(
            height: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                for (var i = 0; i < series.length; i++)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: spacing.xs),
                      child: Container(
                        height: 180 * series[i],
                        decoration: BoxDecoration(
                          color: theme.colors.chart1,
                          borderRadius: theme.borderRadiusSm,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Dashboard01Activity extends StatelessWidget {
  const _Dashboard01Activity();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Recent sales', style: theme.typography.textLarge),
          Gap(spacing.lg),
          const _Dashboard01Sale('Olivia Martin', '\$1,999.00'),
          Gap(spacing.md),
          const _Dashboard01Sale('Jackson Lee', '\$39.00'),
          Gap(spacing.md),
          const _Dashboard01Sale('Isabella Nguyen', '\$299.00'),
          Gap(spacing.md),
          const _Dashboard01Sale('William Kim', '\$99.00'),
          Gap(spacing.lg),
          const Divider(),
          Gap(spacing.lg),
          Button(
            variant: ButtonVariant.outline,
            onPressed: () {},
            child: const Text('View all'),
          ),
        ],
      ),
    );
  }
}

class _Dashboard01Sale extends StatelessWidget {
  const _Dashboard01Sale(this.name, this.amount);

  final String name;
  final String amount;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Row(
      children: <Widget>[
        Flexible(child: Avatar(initials: _Dashboard01Initials.of(name))),
        Gap(spacing.md),
        Expanded(
          flex: 3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(name, style: theme.typography.textSmall),
              Gap(spacing.xs),
              Text(
                '$amount - card',
                style: theme.typography.textSmall.copyWith(
                  color: theme.colors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Dashboard01Initials {
  const _Dashboard01Initials._();

  /// Two-letter initials for [name]; the second initial is dropped for a
  /// one-word name.
  static String of(String name) {
    final parts = name.split(' ');
    if (parts.length < 2) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
''',
      tokenClasses:
          'ccccccccccccccccccccccccccccccccccccccccccccccccccccpccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppppppkkkkkkkpppppppppppppppppppppccccccccccccccccccccccpppkkkkkppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppkkkkkkkkpkkkkppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppkkpppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssppsssssssssssssppssssssssppppppppppppppppppppppppppsssssssssssssssppssssssssppsssssssssppppppppppppppppppppppppppsssssssppsssssssssppssssssssppppppppppppppppppppppppppssssssssssssppssssssppsssssssppppppppppppppkkppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkkkppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkkkppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkppppppppppppppppppkkkkppppppppkkkkppppppppkkkkppppppppppppkkkkkpppppppppppppppppkkkkkpppppppppppppppppkkkkkppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppkkkkkkkkpkkkkppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppspppppppppppppssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppccccccccccccccccccccccccccccccccccccccccccccccpppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppsssssssssssssssppssssssssssssppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppsssssssssssssppsssssssssppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppsssssssssssssssssppssssssssssppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppsssssssssssssppsssssssssppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppkkkkpppppppkkkkpppppppppppppkkkkkppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppspppppppsssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppccccccccccccccccccpppkkkkkkppppppppkkppppppppppppppppppppkkkkkppppppppppppppppppppssspppppppkkppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpspppppppppppppppppppppppppppppppppspppppppppppppppppppppp',
    ),
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/dashboard-01/dashboard_01_table.dart',
      code:
          r'''// The `dashboard-01` block, part 2: the recent-transactions table and the
// status pill it uses. Imported by `dashboard_01.dart`; a block never imports
// another block.

import 'package:flutter/widgets.dart';

import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import '../../components/input/input.dart';
import '../../components/table/table.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';

class Dashboard01Recent extends StatelessWidget {
  const Dashboard01Recent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Card(
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(spacing.lg),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Transactions',
                    style: theme.typography.textLarge,
                  ),
                ),
                Gap(spacing.lg),
                const SizedBox(
                  width: 220,
                  child: Input(hintText: 'Filter transactions'),
                ),
              ],
            ),
          ),
          const Divider(),
          ShadcnTable(
            defaultRowHeight: const FixedTableSize(48),
            columnWidths: const <int, TableSize>{
              0: FlexTableSize(flex: 2),
              1: FlexTableSize(),
              2: FlexTableSize(),
              3: FixedTableSize(110),
            },
            rows: const <ShadcnTableRow>[
              ShadcnTableHeader(
                cells: <ShadcnTableCell>[
                  ShadcnTableCell(child: Text('Customer')),
                  ShadcnTableCell(child: Text('Status')),
                  ShadcnTableCell(child: Text('Method')),
                  ShadcnTableCell(child: Text('Amount')),
                ],
              ),
              ShadcnTableRow(
                cells: <ShadcnTableCell>[
                  ShadcnTableCell(child: Text('Olivia Martin')),
                  ShadcnTableCell(
                    child: _Dashboard01Pill('Paid', chartIndex: 1),
                  ),
                  ShadcnTableCell(child: Text('Visa')),
                  ShadcnTableCell(child: Text('\$1,999.00')),
                ],
              ),
              ShadcnTableRow(
                cells: <ShadcnTableCell>[
                  ShadcnTableCell(child: Text('Jackson Lee')),
                  ShadcnTableCell(
                    child: _Dashboard01Pill('Pending', chartIndex: 2),
                  ),
                  ShadcnTableCell(child: Text('Mastercard')),
                  ShadcnTableCell(child: Text('\$39.00')),
                ],
              ),
              ShadcnTableRow(
                cells: <ShadcnTableCell>[
                  ShadcnTableCell(child: Text('Isabella Nguyen')),
                  ShadcnTableCell(
                    child: _Dashboard01Pill('Refunded', chartIndex: 0),
                  ),
                  ShadcnTableCell(child: Text('PayPal')),
                  ShadcnTableCell(child: Text('\$299.00')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A status pill: a chart-token tint on a transparent fill, so it re-themes
/// with the preset instead of hard-coding a colour.
class _Dashboard01Pill extends StatelessWidget {
  const _Dashboard01Pill(this.label, {required this.chartIndex});

  final String label;

  /// Index into `theme.colors.chartColors`.
  final int chartIndex;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.sm,
        vertical: spacing.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colors.chartColors[chartIndex % 5].withValues(alpha: 0.16),
        borderRadius: theme.borderRadiusXl,
        border: Border.all(color: theme.colors.chartColors[chartIndex % 5]),
      ),
      child: Text(
        label,
        style: theme.typography.xSmall.copyWith(
          color: theme.colors.foreground,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
''',
      tokenClasses:
          'ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppkkkkkpppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppssssssssppppppppppppppppppppppppppppppppppppppppppppppppppssssssssppppppppppppppppppppppppppppppppppppppppppppppppppssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppkkkkpppppppppkkkkkkkkpkkkkppppppppppppppppppkkkkkppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'dashboard-02': <DocsBlockFile>[
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/dashboard-02/dashboard_02.dart',
      code: r'''// The `dashboard-02` block: an analytics workspace.
//
// A wider companion to `dashboard-01`: a filter row, a chart card with a
// legend, a device split and a traffic-source list. Breakpoints come from
// `LayoutBuilder`, so the grid collapses from four columns to one.

import 'package:flutter/widgets.dart';

import '../../components/button/button.dart';
import '../../components/card/card.dart';
import '../../components/input/input.dart';
import 'dashboard_02_sections.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';

/// An analytics workspace: chart, device split and traffic sources.
class Dashboard02 extends StatelessWidget {
  /// Creates the block.
  const Dashboard02({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final int columns = constraints.maxWidth >= 1080
                ? 4
                : constraints.maxWidth >= 640
                ? 2
                : 1;
            return SingleChildScrollView(
              padding: EdgeInsets.all(spacing.lg),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1440),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const _Dashboard02Filters(),
                    Gap(spacing.lg),
                    _Dashboard02Tiles(
                      columns: columns,
                      width: constraints.maxWidth - spacing.lg * 2,
                    ),
                    Gap(spacing.lg),
                    const Dashboard02Chart(),
                    Gap(spacing.lg),
                    if (constraints.maxWidth >= 1080)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Expanded(child: Dashboard02Sources()),
                          Gap(spacing.lg),
                          const Expanded(flex: 2, child: Dashboard02Devices()),
                        ],
                      )
                    else ...<Widget>[
                      const Dashboard02Sources(),
                      Gap(spacing.lg),
                      const Dashboard02Devices(),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Dashboard02Filters extends StatelessWidget {
  const _Dashboard02Filters();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Analytics', style: theme.typography.h2),
        Gap(spacing.xs),
        Text(
          'Sessions, devices and where the traffic came from.',
          style: theme.typography.textMuted.copyWith(
            color: theme.colors.mutedForeground,
          ),
        ),
        Gap(spacing.lg),
        Wrap(
          spacing: spacing.md,
          runSpacing: spacing.md,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            const SizedBox(
              width: 240,
              child: Input(hintText: 'Search reports'),
            ),
            Button(
              variant: ButtonVariant.outline,
              onPressed: () {},
              child: const Text('Last 30 days'),
            ),
            Button(
              variant: ButtonVariant.outline,
              onPressed: () {},
              child: const Text('All devices'),
            ),
            Button(onPressed: () {}, child: const Text('Download')),
          ],
        ),
      ],
    );
  }
}

class _Dashboard02Tiles extends StatelessWidget {
  const _Dashboard02Tiles({required this.columns, required this.width});

  final int columns;

  /// Width available to the grid, so each card gets an exact share.
  final double width;

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    const List<_Dashboard02Tile> tiles = <_Dashboard02Tile>[
      _Dashboard02Tile('Sessions', '12,480', 0.42),
      _Dashboard02Tile('Users', '8,910', 0.63),
      _Dashboard02Tile('Bounce rate', '38%', 0.38),
      _Dashboard02Tile('Avg. session', '2m 41s', 0.27),
    ];
    final double cardWidth = (width - spacing.lg * (columns - 1)) / columns;
    return Wrap(
      spacing: spacing.lg,
      runSpacing: spacing.lg,
      children: <Widget>[
        for (final tile in tiles)
          SizedBox(
            width: cardWidth,
            child: _Dashboard02TileCard(tile: tile),
          ),
      ],
    );
  }
}

class _Dashboard02Tile {
  const _Dashboard02Tile(this.label, this.value, this.fill);

  final String label;
  final String value;

  /// Ratio 0..1 drawn as a sparkline fill.
  final double fill;
}

class _Dashboard02TileCard extends StatelessWidget {
  const _Dashboard02TileCard({required this.tile});

  final _Dashboard02Tile tile;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            tile.label,
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          Gap(spacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(child: Text(tile.value, style: theme.typography.h3)),
              SizedBox(
                width: 64,
                height: 28,
                child: CustomPaint(
                  painter: _Dashboard02SparkPainter(
                    fill: tile.fill,
                    color: theme.colors.chart1,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A one-stroke sparkline; the block ships no data, so the shape is derived
/// from a single `fill` ratio instead of a series.
class _Dashboard02SparkPainter extends CustomPainter {
  const _Dashboard02SparkPainter({required this.fill, required this.color});

  final double fill;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final Path path = Path();
    for (var i = 0; i <= 6; i++) {
      final double t = i / 6;
      final double y =
          size.height - (size.height * fill * (0.35 + 0.65 * _wobble(t)));
      if (i == 0) {
        path.moveTo(size.width * t, y);
      } else {
        path.lineTo(size.width * t, y);
      }
    }
    canvas.drawPath(path, stroke);
  }

  double _wobble(double t) => 0.5 + 0.5 * _sin(t * 3.1);

  double _sin(double x) => x - x * x * x / 6;

  @override
  bool shouldRepaint(_Dashboard02SparkPainter oldDelegate) =>
      oldDelegate.fill != fill || oldDelegate.color != color;
}
''',
      tokenClasses:
          'ccccccccccccccccccccccccccccccccccccccccccccccccccccpccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppppppkkkkkkkpppppppppppppppppppppccccccccccccccccccccccpppkkkkkppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppkkkkkkkkpkkkkppppppppppkkkkkkkkpkkkkpppppppppppppkkkkkpppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppkkpppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssppssssssssppppppppppppppppppppppppppppppppsssssssppsssssssppppppppppppppppppppppppppppppppsssssssssssssppsssssppppppppppppppppppppppppppppppppssssssssssssssppssssssssppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkkkppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkppppppppppppppppppkkkkppppppppkkkkppppppppkkkkpppppppppppkkkkkpppppppppppppppppkkkkkppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppkkkkkppppppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppkkkkkkkkpkkkkppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkppppppppppppppppppppppppppkkkkkkkpppppppppppppppppppkkkkkpppppppppppppppppppppppppppkkkkkkkkpkkkkpppppppkkkkkkkkpkkkkpppppppppppppkkkkkppppppppppppppppkkkkkpppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppkkkppkkkpppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/dashboard-02/dashboard_02_sections.dart',
      code:
          r'''// The `dashboard-02` block, part 2: the chart, the traffic-source card, the
// device split and the tab strip. Imported by `dashboard_02.dart`; a block
// never imports another block.

import 'package:flutter/widgets.dart';

import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import '../../components/progress/progress.dart';
import '../../components/tabs/tabs.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';

class Dashboard02Chart extends StatelessWidget {
  const Dashboard02Chart({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    const List<double> series = <double>[
      0.28,
      0.45,
      0.36,
      0.62,
      0.51,
      0.74,
      0.60,
      0.86,
      0.70,
      0.93,
      0.78,
      1.0,
    ];
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text('Visitors', style: theme.typography.textLarge),
              ),
              const Spacer(),
              const _Dashboard02Legend('Desktop', 0),
              Gap(spacing.lg),
              const _Dashboard02Legend('Mobile', 1),
            ],
          ),
          Gap(spacing.lg),
          SizedBox(
            height: 220,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                for (var i = 0; i < series.length; i++)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: spacing.xs),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            height: 220 * series[i],
                            decoration: BoxDecoration(
                              // One series, one token (see dashboard-01).
                              color: theme.colors.chart1,
                              borderRadius: theme.borderRadiusSm,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Dashboard02Legend extends StatelessWidget {
  const _Dashboard02Legend(this.label, this.chartIndex);

  final String label;
  final int chartIndex;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Row(
      children: <Widget>[
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: theme.colors.chartColors[chartIndex],
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const Gap(0, crossAxisExtent: 6),
        Text(
          label,
          style: theme.typography.textSmall.copyWith(
            color: theme.colors.mutedForeground,
          ),
        ),
      ],
    );
  }
}

/// Traffic sources, each with a share bar.
class Dashboard02Sources extends StatelessWidget {
  /// Creates the traffic-source card.
  const Dashboard02Sources({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    const List<_Dashboard02Source> sources = <_Dashboard02Source>[
      _Dashboard02Source('Direct', 0.38),
      _Dashboard02Source('Search', 0.31),
      _Dashboard02Source('Referral', 0.19),
      _Dashboard02Source('Social', 0.12),
    ];
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Traffic sources', style: theme.typography.textLarge),
          Gap(spacing.lg),
          for (final source in sources) ...<Widget>[
            Text(source.label, style: theme.typography.textSmall),
            Gap(spacing.sm),
            Progress(value: source.share, height: spacing.xs),
            Gap(spacing.lg),
          ],
        ],
      ),
    );
  }
}

class _Dashboard02Source {
  const _Dashboard02Source(this.label, this.share);

  final String label;
  final double share;
}

/// Device split as three stacked progress rows.
class Dashboard02Devices extends StatelessWidget {
  /// Creates the device-split card.
  const Dashboard02Devices({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    const List<_Dashboard02Device> devices = <_Dashboard02Device>[
      _Dashboard02Device('Desktop', 0.52, 0),
      _Dashboard02Device('Mobile', 0.41, 1),
      _Dashboard02Device('Tablet', 0.07, 2),
    ];
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('By device', style: theme.typography.textLarge),
          Gap(spacing.lg),
          for (final device in devices) ...<Widget>[
            _Dashboard02DeviceRow(device: device),
            if (device != devices.last) Gap(spacing.lg),
          ],
          Gap(spacing.lg),
          const Divider(),
          Gap(spacing.lg),
          const Dashboard02Tabs(),
        ],
      ),
    );
  }
}

class _Dashboard02Device {
  const _Dashboard02Device(this.label, this.share, this.chartIndex);

  final String label;
  final double share;
  final int chartIndex;
}

class _Dashboard02DeviceRow extends StatelessWidget {
  const _Dashboard02DeviceRow({required this.device});

  final _Dashboard02Device device;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Flexible(
              child: Text(device.label, style: theme.typography.textSmall),
            ),
            const Spacer(),
            Text(
              '${(device.share * 100).round()}%',
              style: theme.typography.textSmall.copyWith(
                color: theme.colors.mutedForeground,
              ),
            ),
          ],
        ),
        Gap(spacing.sm),
        Progress(
          value: device.share,
          height: spacing.xs,
          color: theme.colors.chartColors[device.chartIndex],
        ),
      ],
    );
  }
}

/// A demo tab strip; the selection is local so taps visibly switch tabs.
class Dashboard02Tabs extends StatefulWidget {
  const Dashboard02Tabs({super.key});

  @override
  State<Dashboard02Tabs> createState() => _Dashboard02TabsState();
}

class _Dashboard02TabsState extends State<Dashboard02Tabs> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    // `Tabs` measures its strip at natural width; on a phone the three labels
    // do not fit, so the strip scrolls instead of overflowing.
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Tabs(
        index: _index,
        onChanged: (int value) => setState(() => _index = value),
        children: const <TabItem>[
          TabItem(child: Text('Overview')),
          TabItem(child: Text('Sessions')),
          TabItem(child: Text('Conversions')),
        ],
      ),
    );
  }
}
''',
      tokenClasses:
          'ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppkkkkkppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppkkkkkppppppppppppppppppppssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppkkkkppppppppkkkkpppppppppppppppppkkkkkpppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccpkkkkkppppppppppppppppppppkkkkkkkpppppppppppppppppppppccccccccccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssppppppppppppppppppppppppppppppppppssssssssppppppppppppppppppppppppppppppppppssssssssssppppppppppppppppppppppppppppppppppssssssssppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkkkpkkkkkkpkkppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppkkkkkppppppppppppppppppppkkkkppppppppkkkkppppppppppppkkkkkpppppppppppppppppkkkkkppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkppppppppppppppppppppkkkkkkkpppppppppppppppppppppccccccccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssspppppppppppppppppppppppppppppppppppppsssssssspppppppppppppppppppppppppppppppppppppsssssssspppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkkkppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppkkkkkppppppppppppppppppppkkkkppppppppkkkkppppppppkkkkpppppppppppppppppkkkkkpppppppppppppppppkkkkkpppppppppppppppppkkkkkppppppppppppppppppppkkkkkpppppppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppkkkkkkkkpkkkkppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppspppppppppppppppppppppppppppppppsspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppppppppppkkkkkkkppppppppppppppppppppkkkkkppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppkkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppssssssssssppppppppppppppppppppppppppppppppppssssssssssppppppppppppppppppppppppppppppppppsssssssssssssppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'pricing-01': <DocsBlockFile>[
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/pricing-01/pricing_01.dart',
      code: r'''// The `pricing-01` block: a marketing pricing section.
//
// Three plans with a feature list and a highlighted middle tier. From 1080px
// the tiers sit side by side; below that they stack. The highlight uses the
// primary/ring tokens, so it survives a preset switch.

import 'package:flutter/widgets.dart';

import '../../components/badge/badge.dart';
import '../../components/button/button.dart';
import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import '../../components/input_otp/input_otp.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/theme.dart';

/// A pricing section: three plans, the middle one highlighted.
class Pricing01 extends StatelessWidget {
  /// Creates the block.
  const Pricing01({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(spacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const _Pricing01Heading(),
                Gap(spacing.xxl),
                const _Pricing01Plans(),
                Gap(spacing.xxl),
                const _Pricing01Faq(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Pricing01Heading extends StatelessWidget {
  const _Pricing01Heading();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Badge(
          variant: BadgeVariant.secondary,
          child: Text('Pricing', style: theme.typography.xSmall),
        ),
        Gap(spacing.lg),
        Text(
          'Plans that scale with you',
          style: theme.typography.h2,
          textAlign: TextAlign.center,
        ),
        Gap(spacing.sm),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Text(
            'Start free, upgrade when your team grows. Every plan includes '
            'the full component library and the theme presets.',
            textAlign: TextAlign.center,
            style: theme.typography.textMuted.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
        ),
      ],
    );
  }
}

class _Pricing01Plans extends StatelessWidget {
  const _Pricing01Plans();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    const List<_Pricing01Plan> plans = <_Pricing01Plan>[
      _Pricing01Plan(
        name: 'Starter',
        price: '\$0',
        cadence: 'per user / month',
        features: <String>[
          'Up to 3 projects',
          'Community support',
          '1 theme preset',
        ],
        cta: 'Get started',
        highlighted: false,
      ),
      _Pricing01Plan(
        name: 'Pro',
        price: '\$20',
        cadence: 'per user / month',
        features: <String>[
          'Unlimited projects',
          'All 42 theme presets',
          'Blocks and charts',
          'Priority support',
        ],
        cta: 'Subscribe',
        highlighted: true,
      ),
      _Pricing01Plan(
        name: 'Enterprise',
        price: 'Custom',
        cadence: 'annual billing',
        features: <String>[
          'SSO and audit log',
          'Dedicated support',
          'Custom themes',
        ],
        cta: 'Contact sales',
        highlighted: false,
      ),
    ];
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool stacked = constraints.maxWidth < 1080;
        if (stacked) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (final plan in plans) ...<Widget>[
                _Pricing01Card(plan: plan),
                if (plan != plans.last) Gap(spacing.lg),
              ],
            ],
          );
        }
        // IntrinsicHeight bounds the cross axis before the stretch Row sees
        // it: inside the block's own scroll view the height is unbounded and
        // a bare Row(stretch) hands its Gap separators a tight infinite
        // height, which asserts in debug builds. Cards keep equal heights.
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              for (final plan in plans) ...<Widget>[
                Expanded(child: _Pricing01Card(plan: plan)),
                if (plan != plans.last) Gap(spacing.lg),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _Pricing01Plan {
  const _Pricing01Plan({
    required this.name,
    required this.price,
    required this.cadence,
    required this.features,
    required this.cta,
    required this.highlighted,
  });

  final String name;
  final String price;
  final String cadence;
  final List<String> features;
  final String cta;
  final bool highlighted;
}

class _Pricing01Card extends StatelessWidget {
  const _Pricing01Card({required this.plan});

  final _Pricing01Plan plan;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    // The highlight is a 2 px primary border on the default card fill, so
    // every text colour stays the card's own (primary-foreground on a card
    // fill would be unreadable after a preset switch).
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: theme.borderRadiusXl,
        border: Border.all(
          color: plan.highlighted ? theme.colors.primary : theme.colors.border,
          width: plan.highlighted ? 2 : 1,
        ),
      ),
      child: Card(
        borderRadius: BorderRadius.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(plan.name, style: theme.typography.textLarge),
                ),
                if (plan.highlighted)
                  Icon(
                    LucideIcons.sparkles,
                    size: 16,
                    color: theme.colors.primary,
                  ),
              ],
            ),
            Gap(spacing.sm),
            Text(plan.price, style: theme.typography.h1),
            Gap(spacing.xs),
            Text(
              plan.cadence,
              style: theme.typography.textSmall.copyWith(
                color: theme.colors.mutedForeground,
              ),
            ),
            Gap(spacing.lg),
            const Divider(),
            Gap(spacing.lg),
            _Pricing01Features(plan: plan),
            Gap(spacing.xl),
            Button(
              variant: plan.highlighted
                  ? ButtonVariant.secondary
                  : ButtonVariant.outline,
              onPressed: () {},
              child: Text(plan.cta),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pricing01Features extends StatelessWidget {
  const _Pricing01Features({required this.plan});

  final _Pricing01Plan plan;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    final foreground = theme.colors.foreground;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (final feature in plan.features) ...<Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(LucideIcons.check, size: 16, color: theme.colors.primary),
              Gap(spacing.sm),
              Expanded(
                child: Text(
                  feature,
                  style: theme.typography.textSmall.copyWith(color: foreground),
                ),
              ),
            ],
          ),
          if (feature != plan.features.last) Gap(spacing.md),
        ],
      ],
    );
  }
}

class _Pricing01Faq extends StatelessWidget {
  const _Pricing01Faq();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text('Questions', style: theme.typography.h3),
        Gap(spacing.lg),
        Wrap(
          spacing: spacing.xl,
          runSpacing: spacing.lg,
          alignment: WrapAlignment.center,
          children: <Widget>[
            _Pricing01FaqItem(
              question: 'Can I change plans later?',
              answer: 'Yes. Upgrades apply immediately, downgrades next cycle.',
            ),
            _Pricing01FaqItem(
              question: 'Is there a free trial?',
              answer: 'Every plan starts with 14 days, no card required.',
            ),
          ],
        ),
        Gap(spacing.xl),
        const Divider(),
        Gap(spacing.xl),
        Text(
          'Have a code? Enter it below.',
          style: theme.typography.textSmall.copyWith(
            color: theme.colors.mutedForeground,
          ),
        ),
        Gap(spacing.md),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 260),
            child: const InputOtp(length: 6),
          ),
        ),
      ],
    );
  }
}

class _Pricing01FaqItem extends StatelessWidget {
  const _Pricing01FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(question, style: theme.typography.textSmall),
          Gap(spacing.sm),
          Text(
            answer,
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}
''',
      tokenClasses:
          'cccccccccccccccccccccccccccccccccccccccccccccccccccccccpccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpssssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppppkkkkkkkpppppppppppppppppppppccccccccccccccccccccccpppkkkkkppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssspppppppppppppsssssssssssssssssssssssssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssspppppppppppppppppssssspppppppppppppppppppssssssssssssssssssppppppppppppppppppppppppppppppppppppppppssssssssssssssssssppppppppppppsssssssssssssssssssppppppppppppssssssssssssssssppppppppppppppppppppppppppssssssssssssspppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppssssspppppppppppppppppsssssspppppppppppppppppppssssssssssssssssssppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssppppppppppppssssssssssssssssssssssppppppppppppsssssssssssssssssssppppppppppppssssssssssssssssssppppppppppppppppppppppppppssssssssssspppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppsssssssssssspppppppppppppppppsssssssspppppppppppppppppppssssssssssssssssppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssppppppppppppsssssssssssssssssssppppppppppppsssssssssssssssppppppppppppppppppppppppppssssssssssssssspppppppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkkkppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkkkppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkkkkpkkkkpppppppppppkkkkkkkkpkkkkppppppppppppkkkkkkkkpkkkkppppppppppppppkkkkkkkkpkkkkpppppppppppppppkkkkkkkkpkkkkppppppppppkkkkkkkkpkkkkpppppppppppppppppppppppkkkkkppppppppppppppppkkkkkpppppppppppppppppkkkkkpppppppppppppppppppkkkkkppppppppppppppppppppppppppkkkkkpppppppppppppppkkkkkppppppppppppppppppppppkkkkkppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppkkkkkkkkpkkkkppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppcccccccccccccccccccccccccccccccccccccccccccccccccccpppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppkkkkkkkkpkkkkppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkkkpppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssssssssppppppppppppppppppppppppsssssssssssssssssssssssssssssssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssppppppppppppppppppppppppsssssssssssssssssssssssssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppkkkkkkkkpkkkkpppppppppppkkkkkkkkpkkkkppppppppppppppkkkkkppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'account-01': <DocsBlockFile>[
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/account-01/account_01.dart',
      code:
          r'''// The `account-01` block: an account settings screen with a profile form.
//
// A tab strip (Profile / Password / Teams), a two-field profile form and a
// save row. The form uses the plain `Input`/`Text` pair rather than the `form`
// component so the block stays copy-paste small.

import 'package:flutter/widgets.dart';

import '../../components/alert/alert.dart';
import '../../components/avatar/avatar.dart';
import '../../components/button/button.dart';
import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import '../../components/input/input.dart';
import '../../components/tabs/tabs.dart';
import '../../components/text_area/text_area.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';

/// An account settings screen: profile form, avatar row and a save action.
class Account01 extends StatefulWidget {
  /// Creates the block.
  const Account01({super.key});

  @override
  State<Account01> createState() => _Account01State();
}

class _Account01State extends State<Account01> {
  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(spacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 880),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text('Settings', style: theme.typography.h2),
                Gap(spacing.xs),
                Text(
                  'Manage your account settings and set your email preferences.',
                  style: theme.typography.textMuted.copyWith(
                    color: theme.colors.mutedForeground,
                  ),
                ),
                Gap(spacing.lg),
                const _Account01Tabs(),
                Gap(spacing.lg),
                const _Account01Profile(),
                Gap(spacing.lg),
                const _Account01SaveRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Account01Tabs extends StatefulWidget {
  const _Account01Tabs();

  @override
  State<_Account01Tabs> createState() => _Account01TabsState();
}

class _Account01TabsState extends State<_Account01Tabs> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Tabs(
        index: _index,
        onChanged: (int value) => setState(() => _index = value),
        children: const <TabItem>[
          TabItem(child: Text('Profile')),
          TabItem(child: Text('Password')),
          TabItem(child: Text('Team')),
        ],
      ),
    );
  }
}

class _Account01Profile extends StatelessWidget {
  const _Account01Profile();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text('Profile', style: theme.typography.textLarge),
          Gap(spacing.sm),
          Text(
            'This is how others will see you on the site.',
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          Gap(spacing.lg),
          const Divider(),
          Gap(spacing.lg),
          Row(
            children: <Widget>[
              const Avatar(initials: 'AL', size: 56),
              Gap(spacing.lg),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Your avatar', style: theme.typography.textSmall),
                    Gap(spacing.sm),
                    Button(
                      variant: ButtonVariant.outline,
                      onPressed: () {},
                      child: const Text('Upload image'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(spacing.lg),
          const Divider(),
          Gap(spacing.lg),
          const _Account01Fields(),
        ],
      ),
    );
  }
}

class _Account01Fields extends StatelessWidget {
  const _Account01Fields();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Wrap(
          spacing: spacing.lg,
          runSpacing: spacing.md,
          children: const <Widget>[
            SizedBox(
              width: 340,
              child: _Account01Field(label: 'Name', hint: 'Ada Lovelace'),
            ),
            SizedBox(
              width: 340,
              child: _Account01Field(label: 'Username', hint: 'ada'),
            ),
          ],
        ),
        Gap(spacing.lg),
        Text(
          'Bio',
          style: theme.typography.textSmall.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        Gap(spacing.sm),
        const TextArea(
          hintText: 'Tell us a little bit about yourself',
          minLines: 3,
          maxLines: 6,
        ),
        Gap(spacing.lg),
        const Divider(),
        Gap(spacing.lg),
        const _Account01EmailRow(),
      ],
    );
  }
}

class _Account01EmailRow extends StatelessWidget {
  const _Account01EmailRow();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: theme.typography.textSmall.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        Gap(spacing.sm),
        Text(
          'ada@example.com',
          style: theme.typography.textSmall.copyWith(
            color: theme.colors.mutedForeground,
          ),
        ),
      ],
    );
  }
}

class _Account01Field extends StatelessWidget {
  const _Account01Field({required this.label, required this.hint});

  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: theme.typography.textSmall.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        Gap(spacing.sm),
        Input(hintText: hint),
      ],
    );
  }
}

class _Account01SaveRow extends StatelessWidget {
  const _Account01SaveRow();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Row(
      children: <Widget>[
        Expanded(
          child: Alert(
            variant: AlertVariant.base,
            content: Text(
              'Changes are saved automatically.',
              style: theme.typography.textSmall,
            ),
          ),
        ),
        Gap(spacing.lg),
        Button(onPressed: () {}, child: const Text('Save changes')),
      ],
    );
  }
}
''',
      tokenClasses:
          'ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppppkkkkkkkppppppppppppppppppppccccccccccccccccccccccpppkkkkkppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppkkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppkkkkkkkppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppsssssssssppppppppppppppppppppppppppppppppppssssssssssppppppppppppppppppppppppppppppppppssssssppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssppppppppssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssppppppppssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppsssssssssssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppkkkkkkkkpkkkkppppppppkkkkkkkkpkkkkppppppppppppkkkkkpppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssssssspppppppppppppppppppppppppp',
    ),
  ],
  'account-02': <DocsBlockFile>[
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/account-02/account_02.dart',
      code: r'''// The `account-02` block: a notifications preferences screen.
//
// Grouped switch rows, a channel grid and a quiet-hours range. Every control
// reads the ambient theme; the state is local so the block can be dropped
// into a scaffold as-is.

import 'package:flutter/widgets.dart';

import '../../components/breadcrumb/breadcrumb.dart';
import '../../components/button/button.dart';
import '../../components/card/card.dart';
import '../../components/checkbox/checkbox.dart';
import '../../components/divider/divider.dart';
import '../../components/switch/switch.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';

/// A notifications preferences screen: per-channel rows plus a digest summary.
class Account02 extends StatefulWidget {
  /// Creates the block.
  const Account02({super.key});

  @override
  State<Account02> createState() => _Account02State();
}

class _Account02State extends State<Account02> {
  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(spacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Breadcrumb(
                  children: <Widget>[
                    Text('Settings'),
                    Gap(0, crossAxisExtent: 8),
                    Text('Notifications'),
                  ],
                ),
                Gap(spacing.md),
                Text('Notifications', style: theme.typography.h2),
                Gap(spacing.xs),
                Text(
                  'Choose what you want to hear about, and where.',
                  style: theme.typography.textMuted.copyWith(
                    color: theme.colors.mutedForeground,
                  ),
                ),
                Gap(spacing.lg),
                const _Account02EmailCard(),
                Gap(spacing.lg),
                const _Account02MobileCard(),
                Gap(spacing.lg),
                const _Account02Digest(),
                Gap(spacing.lg),
                const _Account02Actions(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Account02EmailCard extends StatelessWidget {
  const _Account02EmailCard();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text('Email notifications', style: theme.typography.textLarge),
          Gap(spacing.xs),
          Text(
            'Sent to ada@example.com',
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          Gap(spacing.lg),
          const _Account02Rows(prefix: 'Email'),
        ],
      ),
    );
  }
}

class _Account02MobileCard extends StatelessWidget {
  const _Account02MobileCard();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text('Push notifications', style: theme.typography.textLarge),
          Gap(spacing.xs),
          Text(
            'Delivered to your devices',
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          Gap(spacing.lg),
          const _Account02Rows(prefix: 'Push'),
          Gap(spacing.lg),
          const Divider(),
          Gap(spacing.lg),
          const _Account02QuietHours(),
        ],
      ),
    );
  }
}

class _Account02Rows extends StatefulWidget {
  const _Account02Rows({required this.prefix});

  final String prefix;

  @override
  State<_Account02Rows> createState() => _Account02RowsState();
}

class _Account02RowsState extends State<_Account02Rows> {
  final Set<String> _off = <String>{'Marketing'};

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    const List<_Account02Channel> channels = <_Account02Channel>[
      _Account02Channel('Everything'),
      _Account02Channel('Mentions and replies'),
      _Account02Channel('Product updates'),
      _Account02Channel('Marketing'),
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (final channel in channels) ...<Widget>[
          _Account02Row(
            title: '${widget.prefix} · ${channel.label}',
            value: !_off.contains(channel.label),
            onChanged: (bool value) => setState(() {
              if (value) {
                _off.remove(channel.label);
              } else {
                _off.add(channel.label);
              }
            }),
          ),
          if (channel != channels.last) Gap(spacing.md),
        ],
      ],
    );
  }
}

class _Account02Channel {
  const _Account02Channel(this.label);

  final String label;
}

class _Account02Row extends StatelessWidget {
  const _Account02Row({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Row(
      children: <Widget>[
        Expanded(child: Text(title, style: theme.typography.textSmall)),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}

class _Account02QuietHours extends StatelessWidget {
  const _Account02QuietHours();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Quiet hours', style: theme.typography.textSmall),
              Gap(spacing.sm),
              Text(
                '22:00 - 07:00, your local time',
                style: theme.typography.textSmall.copyWith(
                  color: theme.colors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
        Gap(spacing.md),
        Checkbox(value: CheckboxValue.checked, onChanged: (_) {}),
      ],
    );
  }
}

class _Account02Digest extends StatelessWidget {
  const _Account02Digest();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Weekly digest', style: theme.typography.textLarge),
          Gap(spacing.sm),
          Text(
            'One email every Monday with everything that happened.',
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

class _Account02Actions extends StatelessWidget {
  const _Account02Actions();

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return Wrap(
      spacing: spacing.md,
      runSpacing: spacing.md,
      children: <Widget>[
        Button(onPressed: () {}, child: const Text('Save preferences')),
        Button(
          variant: ButtonVariant.outline,
          onPressed: () {},
          child: const Text('Reset'),
        ),
      ],
    );
  }
}
''',
      tokenClasses:
          'ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppppkkkkkkkppppppppppppppppppppccccccccccccccccccccccpppkkkkkppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppkkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppssssssspppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppssssssppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppkkkkkkkppppppppppppppppppppkkkkkpppppppppppppppppkkkkkkkkpkkkkppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkkkkkkpppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppkkpppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssspppppppppppppppppppppppppppsssssssssssssssssssssspppppppppppppppppppppppppppssssssssssssssssspppppppppppppppppppppppppppsssssssssssppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkkkpppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsppppppppppppppppsssppppppppppppppppspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppkkkkkpppppppppppppppppppkkkkppppppppppppkkkkkppppppppppppppppppkkkkkpppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppkkkkkkkkpkkkkppppppppppppkkkkkkkkpkkkkppppppppppppkkkkkkkkpkkkkpppppppppppppppppppppkkkkkpppppppppppppppppkkkkkpppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssssssssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppkkpppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssspppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'sidebar-01': <DocsBlockFile>[
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/sidebar-01/sidebar_01.dart',
      code: r'''// The `sidebar-01` block: a collapsible icon rail.
//
// The rail is a navigation strip of icon buttons that collapses to its icons
// only. It reads the sidebar tokens (`sidebar`, `sidebarAccent`, …), so it
// re-themes with every preset, and below 720px it flips to a horizontal strip
// on top of the content instead of overflowing.

import 'package:flutter/widgets.dart';

import '../../components/button/button.dart';
import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/theme.dart';

/// A navigation rail that collapses to icons, with a sample content area.
class Sidebar01 extends StatefulWidget {
  /// Creates the block.
  const Sidebar01({super.key});

  @override
  State<Sidebar01> createState() => _Sidebar01State();
}

class _Sidebar01State extends State<Sidebar01> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool vertical = constraints.maxWidth >= 720;
            final Widget rail = _Sidebar01Rail(
              vertical: vertical,
              selected: _selected,
              onSelected: (int index) => setState(() => _selected = index),
            );
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (!vertical) ...<Widget>[rail, Gap(spacing.lg)],
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(spacing.lg),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (vertical) rail,
                        if (vertical) Gap(spacing.lg),
                        const Expanded(child: Sidebar01Content()),
                      ],
                    ),
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

class _Sidebar01Rail extends StatelessWidget {
  const _Sidebar01Rail({
    required this.vertical,
    required this.selected,
    required this.onSelected,
  });

  final bool vertical;
  final int selected;
  final ValueChanged<int> onSelected;

  static const List<_Sidebar01Item> _items = <_Sidebar01Item>[
    _Sidebar01Item('Home', LucideIcons.house),
    _Sidebar01Item('Inbox', LucideIcons.inbox),
    _Sidebar01Item('Calendar', LucideIcons.calendarDays),
    _Sidebar01Item('Search', LucideIcons.search),
    _Sidebar01Item('Settings', LucideIcons.settings),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    final List<Widget> buttons = <Widget>[
      for (var i = 0; i < _items.length; i++)
        _Sidebar01RailButton(
          item: _items[i],
          vertical: vertical,
          selected: i == selected,
          onPressed: () => onSelected(i),
        ),
    ];
    final Widget content = vertical
        ? Column(mainAxisSize: MainAxisSize.min, children: buttons)
        : Row(mainAxisSize: MainAxisSize.min, children: buttons);
    return Container(
      padding: EdgeInsets.all(spacing.sm),
      decoration: BoxDecoration(
        color: theme.colors.sidebar,
        borderRadius: theme.borderRadiusLg,
        border: Border.all(color: theme.colors.sidebarBorder),
      ),
      child: content,
    );
  }
}

class _Sidebar01Item {
  const _Sidebar01Item(this.label, this.icon);

  final String label;
  final IconData icon;
}

class _Sidebar01RailButton extends StatelessWidget {
  const _Sidebar01RailButton({
    required this.item,
    required this.vertical,
    required this.selected,
    required this.onPressed,
  });

  final _Sidebar01Item item;

  /// Whether the rail runs vertically (margin below) or horizontally.
  final bool vertical;

  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Semantics(
      label: item.label,
      selected: selected,
      button: true,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 40,
          height: 40,
          margin: vertical
              ? const EdgeInsets.only(bottom: 4)
              : const EdgeInsets.only(right: 4),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? theme.colors.sidebarAccent : null,
            borderRadius: theme.borderRadiusMd,
          ),
          child: Icon(
            item.icon,
            size: 18,
            color: selected
                ? theme.colors.sidebarAccentForeground
                : theme.colors.sidebarForeground,
          ),
        ),
      ),
    );
  }
}

/// The sample content that sits next to the rail.
class Sidebar01Content extends StatelessWidget {
  /// Creates the content area.
  const Sidebar01Content({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text('Mailbox', style: theme.typography.h2),
        Gap(spacing.xs),
        Text(
          'Everything in one place, at arm’s reach.',
          style: theme.typography.textMuted.copyWith(
            color: theme.colors.mutedForeground,
          ),
        ),
        Gap(spacing.lg),
        Card(
          padding: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _Sidebar01Row(
                'Design review',
                'Kara — 2 hours ago',
                'Can we move the sidebar review to Thursday?',
              ),
              const Divider(),
              _Sidebar01Row(
                'Invoice 4821',
                'Billing — yesterday',
                'Your receipt for the annual plan is attached.',
              ),
              const Divider(),
              _Sidebar01Row(
                'Welcome aboard',
                'Team — Monday',
                'Here is everything you need to get started.',
              ),
            ],
          ),
        ),
        Gap(spacing.lg),
        Wrap(
          spacing: spacing.md,
          runSpacing: spacing.md,
          children: <Widget>[
            Button(
              variant: ButtonVariant.outline,
              onPressed: () {},
              child: const Text('Mark all read'),
            ),
            Button(onPressed: () {}, child: const Text('Compose')),
          ],
        ),
      ],
    );
  }
}

class _Sidebar01Row extends StatelessWidget {
  const _Sidebar01Row(this.title, this.author, this.preview);

  final String title;
  final String author;
  final String preview;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Padding(
      padding: EdgeInsets.all(spacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: theme.typography.textSmall),
          Gap(spacing.xs),
          Text(
            author,
            style: theme.typography.xSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          Gap(spacing.sm),
          Text(preview, style: theme.typography.textSmall),
        ],
      ),
    );
  }
}
''',
      tokenClasses:
          'cccccccccccccccccccccccccccccccccccccccccccccccccccpccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpssssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppppkkkkkkkppppppppppppppppppppccccccccccccccccccccccpppkkkkkppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppkkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkkkkpkkkkpppppppppppppppkkkkkkkkpkkkkpppppppppppppppkkkkkkkkpkkkkppppppppppppppppppppppkkkkkppppppppppppppppppkkkkkpppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppkkkkkkpkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssspppppppppppppppppppppppppppppppppppppppppssssssspppppppppppppppppppppppppppppppppppppppppssssssssssppppppppppppppppppppppppppppppppppppppppppppppppssssssssppppppppppppppppppppppppppppppppppppppppppssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppkkkppkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppkkkkkppppppppppppppppkkkkppppppppkkkkpppppppppppkkkkkpppppppppppppppppkkkkkpppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppppppkkkkkkkkpkkkkpppppppppppkkkkkkkkpkkkkpppppppppppppppkkkkkkkkpkkkkpppppppppppppppkkkkkkkkpkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppkkkkkppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkppppppppppppppppppkkkkkkkpppppppppppppppppppppcccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssppppppppppppppppppssssssssssssssssssssppppppppppppppppppssssssssssssssssssssssssssssssssssssssssssssspppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssppppppppppppppppppsssssssssssssssssssssppppppppppppppppppssssssssssssssssssssssssssssssssssssssssssssssspppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssppppppppppppppppppsssssssssssssssppppppppppppppppppssssssssssssssssssssssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppkkkkppppppppkkkkpppppppppkkkkppppppppppppppkkkkkpppppppppppppppppkkkkkppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'sidebar-02': <DocsBlockFile>[
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/sidebar-02/sidebar_02.dart',
      code:
          r'''// The `sidebar-02` block: an inset sidebar with grouped navigation.
//
// The sidebar is inset (rounded, with a gutter to the page background) and its
// navigation is grouped by section, the way shadcn's `sidebar-01` is. Below
// 840px the sidebar moves above the content instead of squeezing it.

import 'package:flutter/widgets.dart';

import '../../components/avatar/avatar.dart';
import '../../components/badge/badge.dart';
import '../../components/button/button.dart';
import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import '../../components/input/input.dart';
import '../../components/progress/progress.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/theme.dart';

/// A grouped, inset sidebar shell around a sample content area.
class Sidebar02 extends StatelessWidget {
  /// Creates the block.
  const Sidebar02({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool inset = constraints.maxWidth >= 840;
            final Widget sidebar = const _Sidebar02Panel();
            final Widget content = const Sidebar02Content();
            if (!inset) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(spacing.md),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[sidebar, Gap(spacing.lg), content],
                ),
              );
            }
            return Padding(
              padding: EdgeInsets.all(spacing.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(width: 260, child: sidebar),
                  Gap(spacing.md),
                  Expanded(child: SingleChildScrollView(child: content)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Sidebar02Panel extends StatelessWidget {
  const _Sidebar02Panel();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Container(
      decoration: BoxDecoration(
        color: theme.colors.sidebar,
        borderRadius: theme.borderRadiusXl,
        border: Border.all(color: theme.colors.sidebarBorder),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(spacing.lg),
            child: Row(
              children: <Widget>[
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: theme.colors.sidebarPrimary,
                    borderRadius: theme.borderRadiusSm,
                  ),
                  child: Icon(
                    LucideIcons.command,
                    size: 16,
                    color: theme.colors.sidebarPrimaryForeground,
                  ),
                ),
                Gap(spacing.sm),
                Text('Acme Inc', style: theme.typography.textSmall),
                const Spacer(),
                Text(
                  'v1.2',
                  style: theme.typography.xSmall.copyWith(
                    color: theme.colors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.lg),
            child: const Input(hintText: 'Search'),
          ),
          Gap(spacing.lg),
          const _Sidebar02Group(
            label: 'Platform',
            first: true,
            items: ['Playground', 'Models', 'Documentation'],
          ),
          Gap(spacing.md),
          const _Sidebar02Group(
            label: 'Projects',
            first: false,
            items: ['Design system', 'Marketing site'],
          ),
          Gap(spacing.lg),
          const Divider(),
          Gap(spacing.lg),
          const _Sidebar02User(),
        ],
      ),
    );
  }
}

class _Sidebar02Group extends StatelessWidget {
  const _Sidebar02Group({
    required this.label,
    required this.first,
    required this.items,
  });

  final String label;
  final bool first;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            label,
            style: theme.typography.xSmall.copyWith(
              color: theme.colors.mutedForeground,
              fontWeight: FontWeight.w600,
            ),
          ),
          Gap(spacing.sm),
          for (var i = 0; i < items.length; i++) ...<Widget>[
            if (first && i == 0)
              const _Sidebar02ActiveItem(label: 'Playground')
            else
              _Sidebar02NavItem(label: items[i]),
            if (i != items.length - 1) Gap(spacing.xs),
          ],
        ],
      ),
    );
  }
}

class _Sidebar02NavItem extends StatelessWidget {
  const _Sidebar02NavItem({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.sm,
        vertical: theme.spacing.xs,
      ),
      child: Text(label, style: theme.typography.textSmall),
    );
  }
}

class _Sidebar02ActiveItem extends StatelessWidget {
  const _Sidebar02ActiveItem({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.sm,
        vertical: spacing.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colors.sidebarAccent,
        borderRadius: theme.borderRadiusSm,
      ),
      child: Text(
        label,
        style: theme.typography.textSmall.copyWith(
          color: theme.colors.sidebarAccentForeground,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _Sidebar02User extends StatelessWidget {
  const _Sidebar02User();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Padding(
      padding: EdgeInsets.all(spacing.lg),
      child: Row(
        children: <Widget>[
          const Avatar(initials: 'SD'),
          Gap(spacing.sm),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('shadcn', style: theme.typography.textSmall),
                Gap(spacing.xs),
                Text(
                  'm@example.com',
                  style: theme.typography.xSmall.copyWith(
                    color: theme.colors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The sample content area.
class Sidebar02Content extends StatelessWidget {
  /// Creates the content area.
  const Sidebar02Content({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text('Playground', style: theme.typography.h2),
        Gap(spacing.xs),
        Text(
          'Experiment with the API before you ship it.',
          style: theme.typography.textMuted.copyWith(
            color: theme.colors.mutedForeground,
          ),
        ),
        Gap(spacing.lg),
        Wrap(
          spacing: spacing.md,
          runSpacing: spacing.md,
          children: const <Widget>[
            Badge(variant: BadgeVariant.secondary, child: Text('Stable')),
            Badge(variant: BadgeVariant.outline, child: Text('Beta channel')),
            Badge(variant: BadgeVariant.primary, child: Text('New: batches')),
          ],
        ),
        Gap(spacing.lg),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Usage this month', style: theme.typography.textLarge),
              Gap(spacing.lg),
              const Progress(value: 0.68),
              Gap(spacing.sm),
              Text(
                '2,040,000 of 3,000,000 tokens',
                style: theme.typography.textSmall.copyWith(
                  color: theme.colors.mutedForeground,
                ),
              ),
              Gap(spacing.lg),
              const Divider(),
              Gap(spacing.lg),
              Button(onPressed: () {}, child: const Text('Upgrade plan')),
            ],
          ),
        ),
      ],
    );
  }
}
''',
      tokenClasses:
          'ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpssssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppppkkkkkkkpppppppppppppppppppppccccccccccccccccccccccpppkkkkkppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppsssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppsssssssssspppppppppppppppppppppkkkkppppppppppppppppppppppssssssssssssppssssssssppssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppsssssssssspppppppppppppppppppppkkkkkppppppppppppppppppppppsssssssssssssssppsssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppkkkkkkkkpkkkkppppppppppppkkkkkkkkpkkkkppppppppppppkkkkkkkkpkkkkpppppppppppppppppkkkkkpppppppppppppppppkkkkkpppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppssssssssssssppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppkkkkkkkkpkkkkpppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppkkkkkkkkpkkkkpppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppccccccccccccccccccccccccccccpkkkkkppppppppppppppppppkkkkkkkpppppppppppppppppppppcccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'sidebar-03': <DocsBlockFile>[
    DocsBlockFile(
      path: 'lib/ui/shadcn/blocks/sidebar-03/sidebar_03.dart',
      code:
          r'''// The `sidebar-03` block: a whole app shell — header, grouped sidebar, content.
//
// This is the "shell" variant of the blocks set: it wires the pieces a real
// app needs (a header row with breadcrumb + search + avatar, a grouped
// sidebar that stacks above the content below 840px, and a content column)
// so a project can adopt the layout and drop its own screens inside.

import 'package:flutter/widgets.dart';

import '../../components/avatar/avatar.dart';
import '../../components/badge/badge.dart';
import '../../components/breadcrumb/breadcrumb.dart';
import '../../components/button/button.dart';
import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import '../../components/input/input.dart';
import '../../components/progress/progress.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/theme.dart';

/// A complete application shell: header, sidebar and a sample screen.
class Sidebar03 extends StatefulWidget {
  /// Creates the block.
  const Sidebar03({super.key});

  @override
  State<Sidebar03> createState() => _Sidebar03State();
}

class _Sidebar03State extends State<Sidebar03> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    final background = ShadcnTheme.of(context).colors.background;
    return ColoredBox(
      color: background,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool inset = constraints.maxWidth >= 840;
            final Widget header = _Sidebar03Header(selected: _selected);
            if (!inset) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(spacing.md),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    header,
                    Gap(spacing.md),
                    Sidebar03Sidebar(
                      selected: _selected,
                      onSelected: (int index) =>
                          setState(() => _selected = index),
                    ),
                    Gap(spacing.md),
                    const Sidebar03Content(),
                  ],
                ),
              );
            }
            return Padding(
              padding: EdgeInsets.all(spacing.md),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  header,
                  Gap(spacing.md),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const SizedBox(width: 260, child: Sidebar03Sidebar()),
                        Gap(spacing.md),
                        const Expanded(child: Sidebar03Content()),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Sidebar03Header extends StatelessWidget {
  const _Sidebar03Header({required this.selected});

  static const List<String> _titles = <String>[
    'Dashboard',
    'Documents',
    'Reports',
    'Settings',
  ];

  final int selected;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colors.card,
        borderRadius: theme.borderRadiusLg,
        border: Border.all(color: theme.colors.border),
      ),
      // The 200 px search field collapses below 500 px (like the reference
      // header), so the icon, breadcrumb and avatar always fit a phone.
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool showSearch = constraints.maxWidth >= 500;
          return Row(
            children: <Widget>[
              Icon(
                LucideIcons.command,
                size: 18,
                color: theme.colors.foreground,
              ),
              Gap(spacing.md),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Breadcrumb(
                    children: <Widget>[
                      Text(
                        'Acme',
                        style: theme.typography.textSmall.copyWith(
                          color: theme.colors.mutedForeground,
                        ),
                      ),
                      const Gap(0, crossAxisExtent: 8),
                      Text(
                        _titles[selected],
                        style: theme.typography.textSmall,
                      ),
                    ],
                  ),
                ),
              ),
              if (showSearch) ...<Widget>[
                Gap(spacing.md),
                const SizedBox(width: 200, child: Input(hintText: 'Search')),
              ],
              Gap(spacing.md),
              const Avatar(initials: 'AC'),
            ],
          );
        },
      ),
    );
  }
}

const List<_Sidebar03Link> _sidebar03Links = <_Sidebar03Link>[
  _Sidebar03Link('Dashboard', LucideIcons.layoutDashboard),
  _Sidebar03Link('Documents', LucideIcons.fileText),
  _Sidebar03Link('Reports', LucideIcons.chartBar),
  _Sidebar03Link('Settings', LucideIcons.settings),
];

/// The sidebar panel: grouped navigation plus a storage meter.
class Sidebar03Sidebar extends StatelessWidget {
  /// Creates the sidebar panel.
  const Sidebar03Sidebar({super.key, this.selected = 0, this.onSelected});

  /// Index of the selected link; drives the highlight.
  final int selected;

  /// Called with the tapped link index; null leaves the panel static.
  final ValueChanged<int>? onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Container(
      decoration: BoxDecoration(
        color: theme.colors.sidebar,
        borderRadius: theme.borderRadiusXl,
        border: Border.all(color: theme.colors.sidebarBorder),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(spacing.lg),
            child: Text('Navigation', style: theme.typography.textLarge),
          ),
          const Divider(),
          Padding(
            padding: EdgeInsets.all(spacing.sm),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                for (var i = 0; i < _sidebar03Links.length; i++)
                  _Sidebar03NavRow(
                    link: _sidebar03Links[i],
                    selected: i == selected,
                    onPressed: onSelected == null ? null : () => onSelected!(i),
                  ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: EdgeInsets.all(spacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Storage',
                  style: theme.typography.xSmall.copyWith(
                    color: theme.colors.mutedForeground,
                  ),
                ),
                Gap(spacing.sm),
                Text('12.4 GB of 20 GB', style: theme.typography.textSmall),
                Gap(spacing.sm),
                const _Sidebar03Bar(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Sidebar03Link {
  const _Sidebar03Link(this.label, this.icon);

  final String label;
  final IconData icon;
}

class _Sidebar03NavRow extends StatelessWidget {
  const _Sidebar03NavRow({
    required this.link,
    required this.selected,
    required this.onPressed,
  });

  final _Sidebar03Link link;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    final foreground = selected
        ? theme.colors.sidebarAccentForeground
        : theme.colors.sidebarForeground;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.md,
          vertical: spacing.sm,
        ),
        decoration: BoxDecoration(
          color: selected ? theme.colors.sidebarAccent : null,
          borderRadius: theme.borderRadiusSm,
        ),
        child: Row(
          children: <Widget>[
            Icon(link.icon, size: 16, color: foreground),
            Gap(spacing.sm),
            Expanded(
              child: Text(
                link.label,
                style: theme.typography.textSmall.copyWith(
                  color: foreground,
                  fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ),
            if (link.label == 'Settings')
              Badge(
                variant: BadgeVariant.secondary,
                child: Text('3', style: theme.typography.xSmall),
              ),
          ],
        ),
      ),
    );
  }
}

class _Sidebar03Bar extends StatelessWidget {
  const _Sidebar03Bar();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Progress(
      value: 0.62,
      height: theme.spacing.xs,
      color: theme.colors.sidebarPrimary,
      backgroundColor: theme.colors.muted,
    );
  }
}

/// The sample screen inside the shell.
class Sidebar03Content extends StatelessWidget {
  /// Creates the content area.
  const Sidebar03Content({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text('Recent projects', style: theme.typography.h2),
        Gap(spacing.xs),
        Text(
          'Four shared workspaces, updated today.',
          style: theme.typography.textMuted.copyWith(
            color: theme.colors.mutedForeground,
          ),
        ),
        Gap(spacing.lg),
        Wrap(
          spacing: spacing.lg,
          runSpacing: spacing.lg,
          children: const <Widget>[
            SizedBox(width: 280, child: Sidebar03ProjectCard('Atlas')),
            SizedBox(width: 280, child: Sidebar03ProjectCard('Beacon')),
            SizedBox(width: 280, child: Sidebar03ProjectCard('Cobalt')),
          ],
        ),
      ],
    );
  }
}

class Sidebar03ProjectCard extends StatelessWidget {
  /// Creates one project card.
  const Sidebar03ProjectCard(this.name, {super.key});

  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: Text(name, style: theme.typography.textLarge)),
              Badge(
                variant: BadgeVariant.secondary,
                child: Text('Live', style: theme.typography.xSmall),
              ),
            ],
          ),
          Gap(spacing.sm),
          Text(
            'Shared with 4 people · edited 3 minutes ago',
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          Gap(spacing.lg),
          Button(
            variant: ButtonVariant.outline,
            onPressed: () {},
            child: const Text('Open'),
          ),
        ],
      ),
    );
  }
}
''',
      tokenClasses:
          'ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpccpccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccppkkkkkkpsssssssssssssssssssssssssssssspppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssssssppkkkkkkpssssssssssssssssssssssssssssssssssssssssssppkkkkkkpsssssssssssssssssssssssspppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppppkkkkkkkppppppppppppppppppppccccccccccccccccccccccpppkkkkkppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppkkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppkkpppppppppppppppppppppppkkkkkppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppppppkkkkkkkkpkkkkppppppppppppppppkkkkkkpkkkkkppppppppppppppppppppppppppppppppppppppsssssssssssppppppsssssssssssppppppsssssssssppppppssssssssssppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppsssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssppppppppppppppppppppppppppppppppppppppppppsssssssssppppppppppppppppppppppppppppppppppppppppppsssssssssspppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkppppppppppppppppppkkkkkkkpppppppppppppppppppppccccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppkkkkkppppppkkkkpppppppppppppppkkkkppppppppppppppppppcccccccccccccccccccccccccccccccccccccccccccccccccccccpppkkkkkppppppppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkpppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppkkkkkppppppppppppppppkkkkppppppppkkkkpppppppppppkkkkkpppppppppppppppppkkkkkpppppppppppppppppppkkkkkppppppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppkkkkkkkkpkkkkpppppppppppkkkkkkkkpkkkkpppppppppppppppkkkkkkkkpkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppkkkkkppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccccccccccccccccccccccccccccccccpkkkkkppppppppppppppppppkkkkkkkpppppppppppppppppppppcccccccccccccccccccccccccccccpppkkkkkpppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssspppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppkkkkkkkpppppppppppppppppppppcccccccccccccccccccccccccccccpppkkkkkppppppppppppppppppppppkkkkppppppppkkkkkpppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkpppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
};
