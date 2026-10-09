// The `Get Code` dialog (spec §2.7 requirement 3).
//
// Three tabs over the live document: `Dart` (the exact `app_theme.dart`
// `flutter_shadcn theme apply` writes), `JSON` (the canonical schema-v2 preset
// document) and `CLI` (how to apply it). Each tab copies its own payload with
// the site's 2 s copied state, and the whole pane is syntax-highlighted from
// the language of the active tab (registry `syntax_highlight`).

import 'package:flutter/widgets.dart';

import '../state/site_theme_model.dart';
import '../theme/theme_export.dart';
import '../ui/shadcn/components/button/button.dart';
import '../ui/shadcn/components/dialog/dialog.dart';
import '../ui/shadcn/components/tabs/tabs.dart';
import '../ui/shadcn/foundation/gap.dart';
import '../ui/shadcn/primitives/fade_scroll.dart';
import '../ui/shadcn/primitives/syntax_highlight/syntax_highlight.dart';
import '../ui/shadcn/theme/theme.dart';
import 'copy_button.dart';
import 'docs_tokens.dart';

/// The three payloads of the dialog.
enum GetCodeTab {
  /// The generated `app_theme.dart`.
  dart('Dart', 'dart'),

  /// The canonical preset document.
  json('JSON', 'json'),

  /// How to apply it in a project.
  cli('CLI', 'bash');

  const GetCodeTab(this.label, this.language);

  /// The tab label.
  final String label;

  /// The `SyntaxLanguage` id of the payload.
  final String language;
}

/// Shows the `Get Code` dialog for [model] and returns when it closes.
Future<void> showGetCodeDialog(BuildContext context, SiteThemeModel model) {
  return showShadcnDialog<void>(
    context: context,
    builder: (BuildContext context) => _GetCodeDialog(model: model),
  );
}

class _GetCodeDialog extends StatefulWidget {
  const _GetCodeDialog({required this.model});

  final SiteThemeModel model;

  @override
  State<_GetCodeDialog> createState() => _GetCodeDialogState();
}

class _GetCodeDialogState extends State<_GetCodeDialog> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final SiteThemeModel model = widget.model;
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: DocsMetrics.paletteWidth + 160,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(child: Text('Get Code', style: theme.typography.h4)),
                CopyButton(
                  text: getCodePayload(model, GetCodeTab.values[_index]),
                  variant: ButtonVariant.outline,
                  size: ButtonSize.sm,
                  showLabel: true,
                  label: 'Copy',
                ),
              ],
            ),
            const Gap(12),
            SizedBox(
              width: 640,
              child: Tabs(
                index: _index,
                onChanged: (int index) => setState(() => _index = index),
                children: <TabItem>[
                  for (final GetCodeTab tab in GetCodeTab.values)
                    TabItem(child: Text(tab.label)),
                ],
              ),
            ),
            const Gap(12),
            SizedBox(
              width: 640,
              height: 288,
              child: _CodePane(
                code: getCodePayload(model, GetCodeTab.values[_index]),
                language: GetCodeTab.values[_index].language,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The code pane of the dialog: highlighted, horizontally scrollable, with a
/// registry `FadeScroll` fade on both edges (spec scroll-fade).
class _CodePane extends StatefulWidget {
  const _CodePane({required this.code, required this.language});

  final String code;
  final String language;

  @override
  State<_CodePane> createState() => _CodePaneState();
}

class _CodePaneState extends State<_CodePane> {
  final ScrollController _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final DocsSiteColors site = DocsSiteColors.of(context);
    final SyntaxLanguage? language = syntaxLanguageFromId(widget.language);
    final TextStyle base = theme.typography.mono.copyWith(
      fontSize: 13,
      height: 20 / 13,
      color: site.codeSurface == const Color(0xFF161616)
          ? const Color(0xFFE5E5E5)
          : const Color(0xFF262626),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: site.codeSurface,
          border: Border.all(color: theme.colors.border.withValues(alpha: 0.4)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: FadeScroll(
            controller: _scroll,
            endOffset: 8,
            startOffset: 8,
            gradient: <Color>[
              site.codeSurface,
              site.codeSurface.withValues(alpha: 0),
            ],
            child: SingleChildScrollView(
              controller: _scroll,
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: language == null
                    ? Text(widget.code, style: base)
                    : Text.rich(
                        syntaxTextSpan(
                          code: widget.code,
                          language: language,
                          base: base,
                          colors: theme.syntaxColors,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The text [tab] shows for the document [model] currently holds.
///
/// The document is the single source: the Dart tab is rendered from the same
/// values the site renders, and the JSON tab is what `Open Preset` accepts
/// back, so a copy/paste round-trip is lossless.
String getCodePayload(SiteThemeModel model, GetCodeTab tab) => switch (tab) {
  GetCodeTab.dart => model.dartSource,
  GetCodeTab.json => model.json,
  GetCodeTab.cli => themeCliGuide(model.document),
};
