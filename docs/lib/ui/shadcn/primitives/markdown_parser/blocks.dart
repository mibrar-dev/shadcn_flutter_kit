// Textual markdown blocks: paragraphs, headings, lists, code and quotes.
// Tables, images and the image preview live in `media.dart`. Every builder
// is a pure function of the resolved [MarkdownRenderStyle] plus callbacks,
// so streaming renderers can reuse them without the `markdown` component.

import 'package:flutter/widgets.dart';

import '../../foundation/icons/lucide_icons.dart';
import '../../theme/theme.dart';
import '../syntax_highlight/syntax_highlight.dart';
import 'api.dart';
import 'document.dart';
import 'inline_parser.dart';

/// Builds the inline runs of [text] into a span tree under [style].
TextSpan markdownSpans(
  MarkdownRenderStyle style,
  MarkdownCallbacks callbacks,
  TextStyle base,
  String text,
) {
  return TextSpan(
    style: base,
    children: <InlineSpan>[
      for (final run in parseMarkdownInline(
        text,
        style.references,
        style.footnoteOrder,
      ))
        _run(style, callbacks, base, run),
    ],
  );
}

InlineSpan _run(
  MarkdownRenderStyle style,
  MarkdownCallbacks callbacks,
  TextStyle base,
  MarkdownInlineRun run,
) {
  var merged = base;
  if (run.bold) {
    merged = merged.merge(const TextStyle(fontWeight: FontWeight.w700));
  }
  if (run.italic) {
    merged = merged.merge(const TextStyle(fontStyle: FontStyle.italic));
  }
  if (run.strikethrough) {
    merged = merged.merge(
      const TextStyle(decoration: TextDecoration.lineThrough),
    );
  }
  if (run.code) {
    merged = style.mono.copyWith(backgroundColor: style.codeBackground);
  }
  if (run.superscript) {
    merged = merged.copyWith(fontSize: (merged.fontSize ?? 14) * 0.75);
  }
  if (run.linkUrl != null) {
    return TextSpan(
      text: run.text,
      style: merged.copyWith(
        color: style.link.color,
        decoration: TextDecoration.underline,
      ),
      recognizer: callbacks.linkRecognizer(run.text, run.linkUrl!),
    );
  }
  return TextSpan(text: run.text, style: merged);
}

/// Selection-aware rich text. The registrar comes from the nearest selection
/// container, so blocks select inside both `SelectableRegion` and tests.
Widget markdownRichText(
  BuildContext context,
  MarkdownRenderStyle style,
  TextSpan span, {
  TextAlign align = TextAlign.start,
}) {
  return RichText(
    text: span,
    textAlign: align,
    selectionRegistrar: style.selectable
        ? SelectionContainer.maybeOf(context)
        : null,
    selectionColor:
        DefaultSelectionStyle.of(context).selectionColor ?? style.selection,
  );
}

/// Heading with header semantics; [shape] carries the level style and links
/// resolve through [callbacks] like every other block.
Widget buildMarkdownHeading(
  BuildContext context,
  MarkdownRenderStyle style,
  MarkdownCallbacks callbacks,
  TextStyle shape,
  String text,
) {
  return Semantics(
    header: true,
    child: markdownRichText(
      context,
      style,
      TextSpan(
        style: shape,
        children: markdownSpans(style, callbacks, shape, text).children,
      ),
    ),
  );
}

/// List entry: task checkbox, ordered numeral or bullet plus content.
Widget buildMarkdownListItem(
  BuildContext context,
  MarkdownRenderStyle style,
  MarkdownCallbacks callbacks,
  MarkdownBlock block,
) {
  Widget marker;
  if (block.kind == MarkdownBlockKind.taskList) {
    final checked = block.checked == true;
    marker = Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: checked ? style.link.color : null,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: checked ? style.link.color ?? style.rule : style.rule,
          width: 1.4,
        ),
      ),
      child: checked
          ? Icon(LucideIcons.check, size: 13, color: style.onLink)
          : null,
    );
  } else {
    marker = markdownRichText(
      context,
      style,
      TextSpan(
        style: style.body,
        text: block.kind == MarkdownBlockKind.orderedList
            ? '${block.orderedIndex}. '
            : '• ',
      ),
    );
  }
  return Padding(
    padding: EdgeInsets.only(left: 8 + block.indentLevel * 18),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(padding: const EdgeInsets.only(top: 2), child: marker),
        const SizedBox(width: 8),
        Expanded(
          child: markdownRichText(
            context,
            style,
            markdownSpans(style, callbacks, style.body, block.text),
          ),
        ),
      ],
    ),
  );
}

/// Fenced or indented code with an optional language label.
///
/// Fenced blocks with a known language tag are syntax-highlighted with the
/// theme's `syntax` token group; the spans concatenate back to the plain
/// text, so selection and copy are unchanged.
Widget buildMarkdownCode(
  BuildContext context,
  MarkdownRenderStyle style,
  MarkdownBlock block,
) {
  final SyntaxLanguage? language = syntaxLanguageFromId(block.language);
  final TextSpan code = language == null
      ? TextSpan(style: style.mono, text: block.text)
      : syntaxTextSpan(
          code: block.text,
          language: language,
          base: style.mono,
          colors: ShadcnTheme.of(context).syntaxColors,
        );
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(vertical: 6),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: style.codeBackground,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if ((block.language ?? '').isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: markdownRichText(
              context,
              style,
              TextSpan(
                style: style.mono.copyWith(
                  fontSize: (style.mono.fontSize ?? 14) * 0.85,
                  color: style.muted,
                ),
                text: block.language,
              ),
            ),
          ),
        markdownRichText(context, style, code),
      ],
    ),
  );
}

/// Quote with a themed left rule; [nested] re-parses the body so nested
/// blocks render (guarded by depth at the call site).
Widget buildMarkdownQuote(
  BuildContext context,
  MarkdownRenderStyle style,
  MarkdownBlock block,
  List<Widget> nested,
) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(vertical: 4),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      border: Border(left: BorderSide(color: style.quoteBorder, width: 3)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: nested,
    ),
  );
}
