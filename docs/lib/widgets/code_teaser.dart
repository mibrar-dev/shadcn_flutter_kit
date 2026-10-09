// The collapsed code teaser inside a component preview card (spec §2.4):
// a 3-line source preview (109 px) with a bottom gradient and a centred
// "View Code" button; expanding shows up to 289 px with a copy button at the
// top-right. D4 passes the highlighted snippet widget as [code].

import 'package:flutter/widgets.dart';

import '../ui/shadcn/components/button/button.dart';
import '../ui/shadcn/theme/color_tokens.dart';
import '../ui/shadcn/theme/theme.dart';
import 'copy_button.dart';
import 'docs_tokens.dart';

/// The collapsed/expanded code pane.
class CodeTeaser extends StatefulWidget {
  /// Creates a teaser around a full code block.
  const CodeTeaser({
    super.key,
    required this.code,
    this.copyText,
    this.collapsedHeight = DocsMetrics.codeTeaserHeight,
    this.expandedHeight = 289,
  });

  /// The full highlighted code block (scrolls internally when expanded).
  final Widget code;

  /// When non-null, a copy button appears once expanded.
  final String? copyText;

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
                ? SingleChildScrollView(child: widget.code)
                : ClipRect(child: widget.code),
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
              top: 12,
              right: 16,
              child: CopyButton(
                text: widget.copyText!,
                variant: ButtonVariant.ghost,
                size: ButtonSize.sm,
              ),
            ),
        ],
      ),
    );
  }
}

/// A hairline above expanded code panes (thin helper for D4's cards).
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
