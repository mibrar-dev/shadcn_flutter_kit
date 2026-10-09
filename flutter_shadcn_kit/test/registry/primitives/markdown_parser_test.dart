// Unit tests for the shared markdown parser: block dispatch, inline runs,
// sanitization, anchor slugs, link classification and the streaming
// stable-prefix helper consumed by `text_animate`.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/primitives/markdown_parser/markdown_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('blocks', () {
    test('headings carry levels 1-6', () {
      final doc = parseMarkdownDocument('# A\n\n### B\n\n###### C');
      final headings = doc.blocks
          .where((block) => block.kind == MarkdownBlockKind.heading)
          .toList();
      expect(headings.map((block) => block.headingLevel), [1, 3, 6]);
      expect(headings.first.text, 'A');
    });

    test('lists split per item with index and indent', () {
      final doc = parseMarkdownDocument('- a\n- b\n3. c\n  - d');
      expect(doc.blocks.map((block) => block.kind), [
        MarkdownBlockKind.unorderedList,
        MarkdownBlockKind.unorderedList,
        MarkdownBlockKind.orderedList,
        MarkdownBlockKind.unorderedList,
      ]);
      expect(doc.blocks[2].orderedIndex, 3);
      expect(doc.blocks[3].indentLevel, 1);
    });

    test('task items report checked state', () {
      final doc = parseMarkdownDocument('- [x] done\n- [ ] open');
      expect(doc.blocks[0].checked, isTrue);
      expect(doc.blocks[1].checked, isFalse);
    });

    test('fences keep language, indented code has none', () {
      final doc = parseMarkdownDocument('```dart\nx\n```\n\n    code');
      final code = doc.blocks
          .where((block) => block.kind == MarkdownBlockKind.codeBlock)
          .toList();
      expect(code.length, 2);
      expect(code.first.language, 'dart');
      expect(code.last.language, isNull);
    });

    test('tables parse header, alignments and rows', () {
      final doc = parseMarkdownDocument('| A | B |\n| :-- | --: |\n| 1 | 2 |');
      final table = doc.blocks.firstWhere(
        (block) => block.kind == MarkdownBlockKind.table,
      );
      expect(table.tableRows.length, 2);
      expect(table.tableRows.first, ['A', 'B']);
      expect(table.tableAlignments, [TextAlign.left, TextAlign.right]);
    });

    test('standalone images, quotes, rules and blanks dispatch', () {
      final doc = parseMarkdownDocument('![alt](u "t")\n\n> q\n\n---\n\n');
      final kinds = doc.blocks.map((block) => block.kind).toList();
      expect(kinds.first, MarkdownBlockKind.image);
      expect(kinds, contains(MarkdownBlockKind.quote));
      expect(kinds, contains(MarkdownBlockKind.horizontalRule));
      final image = doc.blocks.first;
      expect(image.imageAlt, 'alt');
      expect(image.imageTitle, 't');
    });

    test('paragraph lines join with spaces', () {
      final doc = parseMarkdownDocument('one\ntwo');
      expect(doc.blocks.length, 1);
      expect(doc.blocks.single.text, 'one two');
    });
  });

  group('inline', () {
    test('emphasis toggles nest', () {
      final runs = parseMarkdownInline('**bold *both*** plain');
      expect(runs.first.bold, isTrue);
      expect(runs.any((run) => run.bold && run.italic), isTrue);
      expect(runs.last.bold, isFalse);
    });

    test('code spans are literal', () {
      final runs = parseMarkdownInline('`a **b**`');
      expect(runs.length, 1);
      expect(runs.single.code, isTrue);
      expect(runs.single.text, 'a **b**');
    });

    test('links keep url and title; autolinks resolve', () {
      final runs = parseMarkdownInline('[t](https://e.com "T") <https://a.io>');
      expect(runs.first.linkUrl, 'https://e.com');
      expect(runs.first.linkTitle, 'T');
      expect(runs.last.linkUrl, 'https://a.io');
    });

    test('escapes, entities and breaks decode', () {
      final runs = parseMarkdownInline(r'\*x\* &amp; &#65;<br>y');
      expect(runs.first.text, '*x* & A');
      expect(runs.any((run) => run.text == '\n'), isTrue);
    });
  });

  group('sanitize', () {
    test('dangerous tags go with content', () {
      final out = sanitizeMarkdownHtml(
        'a<script>x</script>b',
        MarkdownHtmlSanitizationStrategy.stripDangerousHtml,
      );
      expect(out, 'ab');
    });

    test('strip-all removes every tag', () {
      expect(
        sanitizeMarkdownHtml(
          '<b>x</b>',
          MarkdownHtmlSanitizationStrategy.stripAllHtml,
        ),
        'x',
      );
    });

    test('permissive keeps input', () {
      expect(
        sanitizeMarkdownHtml(
          '<b>x</b>',
          MarkdownHtmlSanitizationStrategy.permissive,
        ),
        '<b>x</b>',
      );
    });
  });

  group('slugs and links', () {
    test('slugs lowercase, dash and dedupe at call site', () {
      expect(markdownAnchorSlug('Hello World!'), 'hello-world');
      expect(markdownAnchorSlug('  a--b  '), 'a-b');
    });

    test('malformed escapes never throw', () {
      expect(() => markdownAnchorSlug('100% sure'), returnsNormally);
    });

    test('classification covers anchor, mail, external, relative', () {
      expect(classifyMarkdownLink('#a'), MarkdownLinkKind.anchor);
      expect(classifyMarkdownLink('mailto:x@y.z'), MarkdownLinkKind.email);
      expect(classifyMarkdownLink('https://e.com'), MarkdownLinkKind.external);
      expect(classifyMarkdownLink('docs/a'), MarkdownLinkKind.relative);
    });
  });

  group('stable prefix', () {
    test('empty input is zero', () {
      expect(computeStableMarkdownPrefixLength(''), 0);
    });

    test('closed fences count, open fences hold the tail', () {
      const closed = '```\na\n```\nnext';
      expect(computeStableMarkdownPrefixLength(closed), closed.length);
      const open = 'text\n```\npartial';
      expect(computeStableMarkdownPrefixLength(open), 'text\n'.length);
    });

    test('tables hold until a blank line', () {
      const doc = '| A |\n| - |\n| 1 |\n\ntail';
      expect(computeStableMarkdownPrefixLength(doc), doc.length);
      const partial = '| A |\n| --- |\n| 1';
      expect(computeStableMarkdownPrefixLength(partial), '| A |\n'.length);
    });
  });

  group('references', () {
    test('definitions collect; full, collapsed and shortcut resolve', () {
      final doc = parseMarkdownDocument(
        '[Docs]: https://e.com "T"\n\nSee [the docs][docs], [docs][] and [docs].',
      );
      expect(doc.references['docs']?.url, 'https://e.com');
      expect(
        doc.blocks.any((block) => block.text.contains('[Docs]:')),
        isFalse,
      );
      final para = doc.blocks.firstWhere(
        (block) => block.kind == MarkdownBlockKind.paragraph,
      );
      final links = parseMarkdownInline(
        para.text,
        doc.references,
        const <String>[],
      ).where((run) => run.linkUrl != null).toList();
      expect(links.length, 3);
      expect(links.every((run) => run.linkUrl == 'https://e.com'), isTrue);
      expect(links.first.linkTitle, 'T');
    });

    test('keys match case-insensitively; undefined stays literal', () {
      final doc = parseMarkdownDocument('[A B]: /u\n\n[x][a  b] and [nope].');
      final para = doc.blocks.last;
      final runs = parseMarkdownInline(
        para.text,
        doc.references,
        const <String>[],
      );
      expect(runs.any((run) => run.linkUrl == '/u'), isTrue);
      expect(runs.any((run) => run.linkUrl != null), isTrue);
      expect(runs.map((run) => run.text).join(), contains('[nope]'));
    });

    test('reference images surface as alt text', () {
      final doc = parseMarkdownDocument('[pic]: /i.png\n\n![alt][pic]');
      final runs = parseMarkdownInline(
        doc.blocks.last.text,
        doc.references,
        const <String>[],
      );
      expect(runs.any((run) => run.linkUrl != null), isFalse);
      expect(runs.map((run) => run.text).join(), contains('alt'));
    });
  });

  group('footnotes', () {
    test('markers resolve to ordinals; section appends in ref order', () {
      final doc = parseMarkdownDocument(
        'First[^b] then[^a].\n\n[^a]: Alpha\n[^b]: Beta\n',
      );
      final notes = doc.blocks
          .where((block) => block.kind == MarkdownBlockKind.footnote)
          .toList();
      expect(notes.map((block) => block.footnoteId), ['b', 'a']);
      expect(notes.map((block) => block.orderedIndex), [1, 2]);
      expect(notes.first.text, 'Beta');
      final runs = parseMarkdownInline(
        'First[^b]',
        doc.references,
        markdownFootnoteOrder(
          doc.blocks
              .where((b) => b.kind != MarkdownBlockKind.footnote)
              .toList(),
        ),
      );
      final marker = runs.firstWhere((run) => run.linkUrl != null);
      expect(marker.text, '1');
      expect(marker.linkUrl, '#fn-b');
      expect(marker.superscript, isTrue);
    });

    test('unreferenced definitions never render; unknown markers literal', () {
      final doc = parseMarkdownDocument('Text.\n\n[^x]: Unused\n');
      expect(
        doc.blocks.any((block) => block.kind == MarkdownBlockKind.footnote),
        isFalse,
      );
      expect(doc.blocks.any((block) => block.text.contains('Unused')), isFalse);
      final runs = parseMarkdownInline(
        'See [^y].',
        doc.references,
        const <String>[],
      );
      expect(runs.any((run) => run.linkUrl != null), isFalse);
    });
  });

  group('details', () {
    test('summary defaults and body splits', () {
      final doc = parseMarkdownDocument(
        '<details>\n<summary>More</summary>\nBody **bold**.\n</details>',
      );
      final details = doc.blocks.firstWhere(
        (block) => block.kind == MarkdownBlockKind.details,
      );
      expect(details.summary, 'More');
      expect(details.text, contains('Body'));
    });

    test('unclosed details run to end; missing summary falls back', () {
      final doc = parseMarkdownDocument('<details>\nJust body.');
      final details = doc.blocks.firstWhere(
        (block) => block.kind == MarkdownBlockKind.details,
      );
      expect(details.summary, 'Details');
      expect(details.text, contains('Just body.'));
    });
  });

  group('nesting', () {
    test('deep quotes re-parse level by level', () {
      final doc = parseMarkdownDocument('> a\n>> b\n>>> deep');
      expect(doc.blocks.length, 1);
      expect(doc.blocks.single.kind, MarkdownBlockKind.quote);
      final inner = parseMarkdownDocument(doc.blocks.single.text);
      expect(inner.blocks.map((block) => block.kind), [
        MarkdownBlockKind.paragraph,
        MarkdownBlockKind.quote,
      ]);
      final deep = parseMarkdownDocument(inner.blocks.last.text);
      expect(deep.blocks.map((block) => block.kind), [
        MarkdownBlockKind.paragraph,
        MarkdownBlockKind.quote,
      ]);
    });
  });
}
