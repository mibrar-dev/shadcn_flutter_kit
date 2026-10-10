// The collapsed code teaser inside a component preview card (spec §2.4).
//
// Collapsed: a 109 px peek of the source with a bottom gradient and a centred
// outline `View Code` button. Expanded: the full 289 px pane (`max-h-72` plus
// the 1 px top border), a copy button at the top-right and a registry
// `FadeScroll` fade on both scroll edges.
//
// The highlighted spans come from the caller so every preview can pass its own
// language (`dart`, `bash`, `json`) to the registry `syntax_highlight`.

import 'package:flutter/widgets.dart';

import '../ui/shadcn/components/button/button.dart';
import '../ui/shadcn/theme/color_tokens.dart';
import '../ui/shadcn/theme/theme.dart';
import 'copy_button.dart';
import 'docs_tokens.dart';
import 'selectable_code.dart';

/// The collapsed/expanded code pane.
class CodeTeaser extends StatefulWidget {
  /// Creates a teaser around a full code block.
  const CodeTeaser({
    super.key,
    required this.code,
    this.copyText,
    this.language,
    this.collapsedHeight = DocsMetrics.codeTeaserHeight,
    this.expandedHeight = 289,
  });

  /// The full highlighted code block (scrolls internally when expanded).
  final Widget code;

  /// When non-null, a copy button appears once expanded.
  final String? copyText;

  /// The language label of the pane (`dart`, `bash`, `json`); shown next to
  /// the copy button once expanded.
  final String? language;

  /// Collapsed pane height (spec: 109 px).
  final double collapsedHeight;

  /// Expanded pane height (spec: 289 px = 288 + 1 px border).
  final double expandedHeight;

  @override
  State<CodeTeaser> createState() => _CodeTeaserState();
}

class _CodeTeaserState extends State<CodeTeaser> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final DocsSiteColors site = DocsSiteColors.of(context);
    return SizedBox(
      height: _expanded ? widget.expandedHeight : widget.collapsedHeight,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: _expanded
                ? SingleChildScrollView(
                    child: SelectableCode(child: widget.code),
                  )
                : ClipRect(child: SelectableCode(child: widget.code)),
          ),
          if (!_expanded)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 72,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: <Color>[
                        site.codeSurface,
                        site.codeSurface.withValues(alpha: 0.6),
                        site.codeSurface.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          if (!_expanded)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Button(
                    key: const ValueKey<String>('code-teaser-view-code'),
                    variant: ButtonVariant.outline,
                    size: ButtonSize.sm,
                    theme: ButtonVariantStyle(
                      background: StateValue<ThemedColor>(
                        rest: ThemedColor.ref(ColorRef.background),
                        hovered: ThemedColor.ref(ColorRef.muted),
                      ),
                    ),
                    onPressed: () => setState(() => _expanded = true),
                    child: const Text('View Code'),
                  ),
                ),
              ),
            ),
          if (_expanded && widget.copyText != null)
            Positioned(
              top: 8,
              right: 16,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (widget.language case final String language)
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Text(
                        language,
                        style: docsText(
                          context,
                          size: 11,
                          color: site.codeNumber,
                        ),
                      ),
                    ),
                  CopyButton(
                    text: widget.copyText!,
                    variant: ButtonVariant.ghost,
                    size: ButtonSize.sm,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// A hairline above expanded code panes (thin helper for the cards).
class CodePaneDivider extends StatelessWidget {
  /// Creates the divider.
  const CodePaneDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1,
      child: ColoredBox(
        color: ShadcnTheme.of(context).colors.border.withValues(alpha: 0.3),
      ),
    );
  }
}
