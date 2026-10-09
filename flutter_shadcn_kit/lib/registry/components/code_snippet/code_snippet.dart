// The `code_snippet` component: [CodeSnippet] (scrollable code block with
// optional action buttons).
//
// Ported from `components/display/code_snippet`. Fixes: the state class held
// no state, so the widget is stateless; the `gap` package spacer becomes the
// foundation `Gap`.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../primitives/text/text_extension.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';
import 'code_snippet_style.dart';

export 'code_snippet_style.dart';

/// Scrollable code block with optional top-right [actions] (copy, run).
///
/// The [code] content renders in the ambient monospace small style.
class CodeSnippet extends StatelessWidget {
  /// Creates a code snippet display.
  const CodeSnippet({
    super.key,
    this.constraints,
    this.actions = const <Widget>[],
    required this.code,
    this.theme,
  });

  /// Bounds of the snippet area.
  final BoxConstraints? constraints;

  /// Action buttons in the top-right corner.
  final List<Widget> actions;

  /// Code content (usually a [Text]).
  final Widget code;

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
                  child: code.mono.small,
                ),
              ),
            ),
          ),
          if (actions.isNotEmpty)
            Positioned(
              right: ambient.density.baseGap * scale,
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
}
