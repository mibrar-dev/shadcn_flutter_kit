// The `code_snippet` component: [CodeSnippet] (scrollable code block with
// optional action buttons).
//
// Ported from `components/display/code_snippet`. Fixes: the state class held
// no state, so the widget is stateless; the `gap` package spacer becomes the
// foundation `Gap`.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../primitives/syntax_highlight/syntax_highlight.dart';
import '../../primitives/text/text_extension.dart';
import '../../primitives/text_editing/text_editing.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';
import 'code_snippet_style.dart';

export 'code_snippet_style.dart';

/// Scrollable code block with optional top-right [actions] (copy, run).
///
/// The [code] content renders in the ambient monospace small style. When a
/// [language] is given (or auto-detected from a fence tag / strong content
/// signals), the code is syntax-highlighted with the theme's `syntax` token
/// group. The block sits inside a [SelectableRegion], so the source is
/// selectable by mouse, by the keyboard (`Ctrl/Cmd+A`, then `Ctrl/Cmd+C`) and
/// through the platform context menu; [Text] and [Text.rich] register with
/// the region on their own, so the syntax colours are unchanged.
class CodeSnippet extends StatelessWidget {
  /// Creates a code snippet display.
  const CodeSnippet({
    super.key,
    this.constraints,
    this.actions = const <Widget>[],
    required this.code,
    this.language,
    this.theme,
  });

  /// Bounds of the snippet area.
  final BoxConstraints? constraints;

  /// Action buttons in the top-right corner.
  final List<Widget> actions;

  /// Code content (usually a [Text]).
  final Widget code;

  /// Language id or fence tag (`dart`, `js`, `py`, …) used for syntax
  /// highlighting. When null, the language is auto-detected from the code
  /// text (fence tag first, then conservative content signals); unknown
  /// content stays plain.
  final String? language;

  /// Widget-leg theme override, merged over the other legs.
  final CodeSnippetTheme? theme;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final CodeSnippetTheme style =
        resolveComponentStyle<CodeSnippetTheme, CodeSnippetTheme>(
          context,
          widget: theme,
          select: (t) => t,
          defaults: codeSnippetDefaults,
        );
    final double scale = ambient.scaling;
    return Container(
      decoration: BoxDecoration(
        color: style.background?.resolve(ambient.colors),
        border: Border.all(
          color:
              style.borderColor?.resolve(ambient.colors) ??
              ambient.colors.border,
          width: (style.borderWidth ?? 1) * scale,
        ),
        borderRadius:
            style.borderRadius?.resolve(Directionality.of(context)) ??
            ambient.borderRadiusLg,
      ),
      child: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          Container(
            constraints: constraints,
            child: SingleChildScrollView(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: resolveEdgeInsets(
                  style.padding ?? EdgeInsets.zero,
                  ambient.density.baseContainerPadding * scale,
                ),
                child: DefaultTextStyle.merge(
                  style: TextStyle(color: ambient.colors.foreground),
                  // SelectableRegion needs an Overlay for its handles and
                  // menu; without one (e.g. a bare WidgetsApp) the code still
                  // renders, just not selectable.
                  child: Overlay.maybeOf(context) == null
                      ? _codeChild(ambient)
                      : SelectableRegion(
                          selectionControls: ShadcnSelectionControls(),
                          child: _codeChild(ambient),
                        ),
                ),
              ),
            ),
          ),
          if (actions.isNotEmpty)
            Positioned.directional(
              textDirection: Directionality.of(context),
              end: ambient.density.baseGap * scale,
              top: ambient.density.baseGap * scale,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: _spaced(scale),
              ),
            ),
        ],
      ),
    );
  }

  /// Actions interleaved with 4px gaps.
  List<Widget> _spaced(double scale) {
    final List<Widget> out = <Widget>[];
    for (int i = 0; i < actions.length; i++) {
      if (i > 0) out.add(Gap(4 * scale));
      out.add(actions[i]);
    }
    return out;
  }

  /// The code child, highlighted when a language is known or detected.
  ///
  /// The source string comes from a plain [Text] or from a [Text.rich]
  /// span (`toPlainText`); it is re-colored with the theme syntax group.
  /// Any other widget renders untouched.
  Widget _codeChild(ShadcnThemeData ambient) {
    final Widget raw = code;
    if (raw is! Text) return raw.mono.small;
    final String? text = raw.data ?? raw.textSpan?.toPlainText();
    if (text == null) return raw.mono.small;
    final SyntaxLanguage? detected =
        syntaxLanguageFromId(language) ?? syntaxLanguageGuess(text);
    if (detected == null) return raw.mono.small;
    final TextStyle base = ambient.typography.mono.copyWith(
      color: ambient.colors.foreground,
    );
    return Text.rich(
      syntaxTextSpan(
        code: text,
        language: detected,
        base: base,
        colors: ambient.syntaxColors,
      ),
    ).mono.small;
  }
}
