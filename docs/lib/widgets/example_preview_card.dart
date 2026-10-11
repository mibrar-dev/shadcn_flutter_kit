// One example's Preview | Code card (P7-D1, shadcn docs layout).
//
// Every named preview example gets its own framed card: a toolbar row with
// keyboard-accessible Preview/Code tabs on the left (the registry `Tabs`
// strip: roving focus, arrow keys) and a per-card light/dark toggle plus a
// copy button on the right, then the stage or the code pane below.
//
// The stage reserves its minimum height while the deferred chunk loads, so
// swapping tabs or examples never jumps the layout. Examples below the fold
// stay empty until the scroll settles ([_LazyPreview]), keeping long pages
// fast: the deferred chunk itself loads once per component and is shared by
// every card on the page.

import 'package:flutter/widgets.dart';

import '../generated/docs_example_sources.dart';
import '../routing/docs_router.dart';
import '../state/docs_state.dart';
import '../ui/shadcn/components/button/button.dart';
import '../ui/shadcn/components/tabs/tabs.dart';
import '../ui/shadcn/components/tooltip/tooltip.dart';
import '../ui/shadcn/foundation/gap.dart';
import '../ui/shadcn/foundation/icons/lucide_icons.dart';
import '../ui/shadcn/primitives/syntax_highlight/syntax_highlight.dart';
import '../ui/shadcn/theme/theme.dart';
import 'code_teaser.dart';
import 'component_preview_card.dart' show PreviewExampleLoader;
import 'copy_button.dart';
import 'docs_tokens.dart';
import 'preview_stage.dart';
import 'selectable_code.dart';

/// Minimum stage height of the main (first-example) demo card.
const double kMainPreviewMinHeight = 350;

/// Minimum stage height of the per-example cards.
const double kExamplePreviewMinHeight = 200;

/// One example's card: toolbar (tabs + toggle + copy) over stage/code.
class ExamplePreviewCard extends StatefulWidget {
  /// Creates the card for one example.
  const ExamplePreviewCard({
    super.key,
    required this.componentId,
    required this.exampleIndex,
    required this.source,
    this.isMain = false,
  });

  /// The registry component id.
  final String componentId;

  /// Index into the exported `const List<ComponentPreview>`.
  final int exampleIndex;

  /// The generated display source (label, description, code).
  final DocsExampleSource source;

  /// Whether this is the page's main demo (taller stage).
  final bool isMain;

  @override
  State<ExamplePreviewCard> createState() => _ExamplePreviewCardState();
}

class _ExamplePreviewCardState extends State<ExamplePreviewCard> {
  int _tab = 0;
  bool _inverted = false;

  double get _minHeight =>
      widget.isMain ? kMainPreviewMinHeight : kExamplePreviewMinHeight;

  @override
  Widget build(BuildContext context) {
    final DocsState state = DocsRouterScope.of(context).state;
    return ListenableBuilder(
      listenable: state.themeModel,
      builder: (BuildContext context, Widget? _) {
        final Brightness site = state.brightness;
        final Brightness stageBrightness = _inverted
            ? (site == Brightness.dark ? Brightness.light : Brightness.dark)
            : site;
        final Widget stage = PreviewStage(
          minHeight: _minHeight,
          child: _LazyPreview(
            minHeight: _minHeight,
            child: PreviewExampleLoader(
              componentId: widget.componentId,
              exampleIndex: widget.exampleIndex,
            ),
          ),
        );
        final Widget body = _tab == 0
            ? (_inverted
                  ? ShadcnTheme(
                      data: state.themeModel.themeFor(stageBrightness),
                      child: stage,
                    )
                  : stage)
            : Column(
                children: <Widget>[
                  const CodePaneDivider(),
                  CodeTeaser(
                    code: ExampleSnippetCode(code: widget.source.code),
                    copyText: widget.source.code,
                    language: 'dart',
                  ),
                ],
              );
        return PreviewFrame(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _ExampleToolbar(
                exampleIndex: widget.exampleIndex,
                tab: _tab,
                onTab: (int tab) => setState(() => _tab = tab),
                stageBrightness: stageBrightness,
                inverted: _inverted,
                onToggle: () => setState(() => _inverted = !_inverted),
                copyText: widget.source.code,
              ),
              body,
            ],
          ),
        );
      },
    );
  }
}

/// The toolbar row: Preview/Code tabs left, toggle + copy right.
///
/// Always a single row at 320 px and up (P7-D1b): the light/dark toggle is a
/// compact icon-only button with a tooltip, so the tab strip plus the two
/// icon buttons fit the ~295 px the 375 px article leaves for this row. There
/// is no wrapping branch: tabs left, toggle + copy right, separated by a
/// spacer.
class _ExampleToolbar extends StatelessWidget {
  /// Creates the toolbar.
  const _ExampleToolbar({
    required this.exampleIndex,
    required this.tab,
    required this.onTab,
    required this.stageBrightness,
    required this.inverted,
    required this.onToggle,
    required this.copyText,
  });

  /// Example index (disambiguates widget-test keys per card).
  final int exampleIndex;

  /// Selected tab (0 preview, 1 code).
  final int tab;

  /// Called with the new tab index.
  final ValueChanged<int> onTab;

  /// The brightness the stage currently shows.
  final Brightness stageBrightness;

  /// Whether the stage is inverted to the opposite brightness.
  final bool inverted;

  /// Flips the stage brightness override.
  final VoidCallback onToggle;

  /// The example code the copy button writes.
  final String copyText;

  @override
  Widget build(BuildContext context) {
    final Widget tabs = Tabs(
      key: ValueKey<String>('example-tabs-$exampleIndex'),
      index: tab,
      onChanged: onTab,
      children: const <TabItem>[
        TabItem(child: Text('Preview')),
        TabItem(child: Text('Code')),
      ],
    );
    final Widget actions = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Tooltip(
          tooltip: (BuildContext context) => Text(
            stageBrightness == Brightness.dark
                ? 'Switch to light'
                : 'Switch to dark',
          ),
          child: Button(
            key: ValueKey<String>('preview-theme-toggle-$exampleIndex'),
            variant: ButtonVariant.outline,
            size: ButtonSize.sm,
            onPressed: onToggle,
            child: Icon(
              stageBrightness == Brightness.dark
                  ? LucideIcons.moon
                  : LucideIcons.sun,
              size: 14,
            ),
          ),
        ),
        const Gap(4),
        CopyButton(
          key: ValueKey<String>('example-copy-$exampleIndex'),
          text: copyText,
          variant: ButtonVariant.ghost,
          size: ButtonSize.sm,
        ),
      ],
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: <Widget>[
          // The tab strip keeps its natural width on wide cards and shrinks
          // (scrolling internally) on 320 px phones instead of overflowing
          // the row: `Flexible` caps it at the leftover width and the
          // horizontal scroll view carries the 192 px strip when the leftover
          // is smaller. The spacer keeps toggle + copy at the right edge.
          Flexible(
            flex: 10,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: tabs,
            ),
          ),
          const Spacer(),
          actions,
        ],
      ),
    );
  }
}

/// Defers the preview below the fold until the scroll settles.
///
/// The placeholder keeps the stage's minimum height, so revealing the example
/// never shifts the layout. Above the fold (or when idle) the example shows
/// on the next frame.
class _LazyPreview extends StatefulWidget {
  /// Creates the lazy slot around the real loader.
  const _LazyPreview({required this.minHeight, required this.child});

  /// Stage minimum height (the placeholder matches it).
  final double minHeight;

  /// The real deferred preview loader.
  final Widget child;

  @override
  State<_LazyPreview> createState() => _LazyPreviewState();
}

class _LazyPreviewState extends State<_LazyPreview> {
  bool _revealed = false;

  @override
  Widget build(BuildContext context) {
    if (_revealed) {
      return widget.child;
    }
    if (!Scrollable.recommendDeferredLoadingForContext(context)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_revealed) {
          setState(() => _revealed = true);
        }
      });
    }
    return NotificationListener<ScrollEndNotification>(
      onNotification: (_) {
        if (!_revealed) {
          setState(() => _revealed = true);
        }
        return false;
      },
      child: SizedBox(height: widget.minHeight),
    );
  }
}

/// The highlighted example source inside the card's code teaser.
///
/// Highlighting runs at build time from the generated code string (the spans
/// concatenate back to the plain text, so selection/copy is unchanged); the
/// copy button always copies the plain [code] string.
class ExampleSnippetCode extends StatelessWidget {
  /// Creates the code block for [code].
  const ExampleSnippetCode({super.key, required this.code});

  /// The example source text.
  final String code;

  @override
  Widget build(BuildContext context) {
    final DocsSiteColors site = DocsSiteColors.of(context);
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final bool dark = site.codeSurface == const Color(0xFF161616);
    final TextStyle style = theme.typography.mono.copyWith(
      fontSize: 14,
      height: 24.5 / 14,
      color: dark ? const Color(0xFFE5E5E5) : const Color(0xFF262626),
    );
    return Container(
      color: site.codeSurface,
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SelectableCode(
          child: Text.rich(
            syntaxTextSpan(
              code: code,
              language: SyntaxLanguage.dart,
              base: style,
              colors: theme.syntaxColors,
            ),
          ),
        ),
      ),
    );
  }
}
