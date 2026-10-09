// A generic docs code figure (spec §2.3): the `--code` surface, 18 px radius,
// 16 px padding, Geist Mono 14/24.5, an optional language label and a copy
// button. The component install block and README snippet blocks share the same
// visual; the theming and dark-mode pages use this figure for their
// hand-written samples.

import 'package:flutter/widgets.dart';

import '../ui/shadcn/components/button/button.dart';
import '../ui/shadcn/primitives/syntax_highlight/syntax_highlight.dart';
import '../ui/shadcn/theme/theme.dart';
import 'copy_button.dart';
import 'docs_tokens.dart';

/// A code figure with an optional language label and a copy button.
class DocsCodeFigure extends StatelessWidget {
  /// Creates a code figure.
  const DocsCodeFigure({
    super.key,
    required this.code,
    this.language,
    this.showCopy = true,
  });

  /// The code text (rendered verbatim and copied).
  final String code;

  /// Optional header label (`dart`, `bash`).
  final String? language;

  /// Whether the copy button renders.
  final bool showCopy;

  @override
  Widget build(BuildContext context) {
    final DocsSiteColors site = DocsSiteColors.of(context);
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final bool dark = site.codeSurface == const Color(0xFF161616);
    final Color ink = dark ? const Color(0xFFE5E5E5) : const Color(0xFF262626);
    final TextStyle style = theme.typography.mono.copyWith(
      fontSize: 14,
      height: 24.5 / 14,
      color: ink,
    );
    final bool header = language != null || showCopy;
    // With a known language the code renders highlighted spans (the spans
    // concatenate back to the plain text, so selection/copy is unchanged);
    // the copy button always copies the plain [code] string. Named [syntax]
    // (not [language]) so it never shadows the [String] field of the same
    // name — the field drives the header label below.
    final SyntaxLanguage? syntax = syntaxLanguageFromId(language);
    final Widget codeBlock = syntax == null
        ? Text(code, style: style)
        : Text.rich(
            syntaxTextSpan(
              code: code,
              language: syntax,
              base: style,
              colors: theme.syntaxColors,
            ),
          );
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        decoration: BoxDecoration(
          color: site.codeSurface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: theme.colors.border.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (header)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 6, 0),
                child: Row(
                  children: <Widget>[
                    if (language != null)
                      Text(
                        language!,
                        style: theme.typography.mono.copyWith(
                          fontSize: 12.8,
                          color: theme.colors.mutedForeground,
                        ),
                      ),
                    const Spacer(),
                    if (showCopy)
                      CopyButton(
                        text: code,
                        variant: ButtonVariant.ghost,
                        size: ButtonSize.sm,
                      ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: codeBlock,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
