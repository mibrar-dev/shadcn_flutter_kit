// Block-level markdown parsing: [parseMarkdownDocument] plus the table
// row/alignment helpers. Inline emphasis lives in `inline_parser.dart`.

import 'dart:ui' show TextAlign;

import 'document.dart';
import 'inline_parser.dart';

MarkdownDocument parseMarkdownDocument(String data) {
  final lines = data.replaceAll('\r\n', '\n').split('\n');
  final blocks = <MarkdownBlock>[];
  final references = <String, MarkdownLinkTarget>{};
  final footnotes = <String, String>{};
  var i = 0;
  while (i < lines.length) {
    final line = lines[i].replaceAll('\t', '    ');
    final trimmed = line.trimRight();
    if (trimmed.trim().isEmpty) {
      blocks.add(const MarkdownBlock(kind: MarkdownBlockKind.blank, text: ''));
      i++;
      continue;
    }
    final fence = markdownFenceMarker(trimmed.trim());
    if (fence != null) {
      final language = trimmed.trim().substring(3).trim();
      final buffer = <String>[];
      i++;
      while (i < lines.length &&
          !markdownClosesFence(lines[i].trimRight().trim(), fence)) {
        buffer.add(lines[i].replaceAll('\t', '    '));
        i++;
      }
      i++; // Skip the closing fence (or run off the end).
      blocks.add(
        MarkdownBlock(
          kind: MarkdownBlockKind.codeBlock,
          text: buffer.join('\n'),
          language: language.isEmpty ? null : language,
        ),
      );
      continue;
    }
    final heading = RegExp(
      r'^(#{1,6})\s+(.*?)\s*#*\s*$',
    ).firstMatch(trimmed.trim());
    if (heading != null) {
      blocks.add(
        MarkdownBlock(
          kind: MarkdownBlockKind.heading,
          text: heading.group(2) ?? '',
          headingLevel: heading.group(1)!.length,
        ),
      );
      i++;
      continue;
    }
    if (RegExp(r'^\s*(\*\*\*+|---+|___+)\s*$').hasMatch(trimmed)) {
      blocks.add(
        const MarkdownBlock(kind: MarkdownBlockKind.horizontalRule, text: ''),
      );
      i++;
      continue;
    }
    if (trimmed.contains('|') &&
        i + 1 < lines.length &&
        isMarkdownTableDelimiter(lines[i + 1])) {
      final header = _splitTableRow(trimmed);
      final aligns = _tableAlignments(lines[i + 1]);
      final rows = <List<String>>[header];
      i += 2;
      while (i < lines.length &&
          lines[i].trim().isNotEmpty &&
          lines[i].contains('|')) {
        rows.add(_splitTableRow(lines[i]));
        i++;
      }
      blocks.add(
        MarkdownBlock(
          kind: MarkdownBlockKind.table,
          text: '',
          tableRows: rows,
          tableAlignments: aligns,
        ),
      );
      continue;
    }
    if (trimmed.trimLeft().startsWith('>')) {
      final buffer = <String>[];
      while (i < lines.length && lines[i].trimLeft().startsWith('>')) {
        buffer.add(lines[i].trimLeft().replaceFirst(RegExp(r'^>\s?'), ''));
        i++;
      }
      blocks.add(
        MarkdownBlock(kind: MarkdownBlockKind.quote, text: buffer.join('\n')),
      );
      continue;
    }
    final list = RegExp(r'^(\s*)([-*+]|\d+[.)])\s+(.*)$').firstMatch(line);
    if (list != null) {
      final marker = list.group(2)!;
      var rest = list.group(3) ?? '';
      final indent = list.group(1)!.length ~/ 2;
      var checked = false;
      var isTask = false;
      final task = RegExp(r'^\[([ xX])\]\s+(.*)$').firstMatch(rest);
      if (task != null && !RegExp(r'^\d').hasMatch(marker)) {
        isTask = true;
        checked = task.group(1)!.toLowerCase() == 'x';
        rest = task.group(2) ?? '';
      }
      final ordered = RegExp(r'^(\d+)[.)]$').firstMatch(marker);
      blocks.add(
        MarkdownBlock(
          kind: isTask
              ? MarkdownBlockKind.taskList
              : ordered != null
              ? MarkdownBlockKind.orderedList
              : MarkdownBlockKind.unorderedList,
          text: rest,
          orderedIndex: ordered == null ? 1 : int.parse(ordered.group(1)!),
          indentLevel: indent,
          checked: isTask ? checked : null,
        ),
      );
      i++;
      continue;
    }
    final image = RegExp(
      r'^!\[([^\]]*)\]\(\s*(\S+?)(?:\s+"([^"]*)")?\s*\)\s*$',
    ).firstMatch(trimmed.trim());
    if (image != null) {
      blocks.add(
        MarkdownBlock(
          kind: MarkdownBlockKind.image,
          text: '',
          imageAlt: image.group(1),
          imageUrl: image.group(2),
          imageTitle: image.group(3),
        ),
      );
      i++;
      continue;
    }
    if (line.startsWith('    ') && line.trim().isNotEmpty) {
      final buffer = <String>[];
      while (i < lines.length &&
          (lines[i].startsWith('    ') || lines[i].trim().isEmpty)) {
        buffer.add(
          lines[i].startsWith('    ') ? lines[i].substring(4) : lines[i],
        );
        i++;
      }
      blocks.add(
        MarkdownBlock(
          kind: MarkdownBlockKind.codeBlock,
          text: buffer.join('\n').trimRight(),
        ),
      );
      continue;
    }
    final reference = _parseReferenceDefinition(trimmed);
    if (reference != null) {
      references[reference.$1] = reference.$2;
      i++;
      continue;
    }
    final footnote = _parseFootnoteDefinition(lines, i);
    if (footnote != null) {
      footnotes[footnote.$1] = footnote.$2;
      i = footnote.$3;
      continue;
    }
    final details = _parseDetailsBlock(lines, i);
    if (details != null) {
      blocks.add(details.$1);
      i = details.$2;
      continue;
    }
    final buffer = <String>[trimmed.trim()];
    i++;
    while (i < lines.length &&
        lines[i].trim().isNotEmpty &&
        markdownFenceMarker(lines[i].trim()) == null &&
        !RegExp(r'^#{1,6}\s').hasMatch(lines[i].trim()) &&
        !RegExp(r'^\s*(\*\*\*+|---+|___+)\s*$').hasMatch(lines[i]) &&
        !lines[i].trimLeft().startsWith('>') &&
        !RegExp(r'^(\s*)([-*+]|\d+[.)])\s+').hasMatch(lines[i]) &&
        !isMarkdownTableDelimiter(lines[i]) &&
        !(lines[i].contains('|') &&
            i + 1 < lines.length &&
            isMarkdownTableDelimiter(lines[i + 1])) &&
        _parseReferenceDefinition(lines[i].trimRight()) == null &&
        _parseFootnoteDefinition(lines, i) == null &&
        !lines[i].trimLeft().toLowerCase().startsWith('<details')) {
      buffer.add(lines[i].trim());
      i++;
    }
    blocks.add(
      MarkdownBlock(kind: MarkdownBlockKind.paragraph, text: buffer.join(' ')),
    );
  }
  var footnoteIndex = 0;
  for (final id in markdownFootnoteOrder(blocks)) {
    final text = footnotes[id];
    if (text == null) continue;
    footnoteIndex++;
    blocks.add(
      MarkdownBlock(
        kind: MarkdownBlockKind.footnote,
        text: text,
        footnoteId: id,
        orderedIndex: footnoteIndex,
      ),
    );
  }
  return MarkdownDocument(
    blocks: List<MarkdownBlock>.unmodifiable(blocks),
    references: Map<String, MarkdownLinkTarget>.unmodifiable(references),
    footnotes: Map<String, String>.unmodifiable(footnotes),
  );
}

/// Parses a `[ref]: url "title"` definition; null when [line] is not one.
/// Titles accept `"`, `'` or `()` quoting; one line only.
(String, MarkdownLinkTarget)? _parseReferenceDefinition(String line) {
  if (line.trimLeft().startsWith('[^')) return null;
  final match = RegExp(r'^\s{0,3}\[([^\]]+)\]:\s*(\S+)(.*)$').firstMatch(line);
  if (match == null) return null;
  final rest = match.group(3)!.trim();
  String? title;
  if (rest.isNotEmpty) {
    final titleMatch = RegExp(
      r'''^"([^"]*)"$|^'([^']*)'$|^\(([^()]*)\)$''',
    ).firstMatch(rest);
    if (titleMatch == null) return null;
    title = titleMatch.group(1) ?? titleMatch.group(2) ?? titleMatch.group(3);
  }
  return (
    normalizeMarkdownReferenceKey(match.group(1)!),
    MarkdownLinkTarget(
      url: decodeMarkdownEntities(match.group(2)!),
      title: title == null ? null : decodeMarkdownEntities(title),
    ),
  );
}

/// Parses a `[^id]: text` footnote definition plus its indented
/// continuation lines; returns id, text and the next line index.
(String, String, int)? _parseFootnoteDefinition(List<String> lines, int index) {
  final first = lines[index].replaceAll('\t', '    ');
  final match = RegExp(r'^\s{0,3}\[\^([^\]]+)\]:\s*(.*)$').firstMatch(first);
  if (match == null) return null;
  final buffer = <String>[match.group(2)?.trim() ?? ''];
  var i = index + 1;
  while (i < lines.length) {
    final next = lines[i].replaceAll('\t', '    ');
    if (next.trim().isEmpty || !next.startsWith('    ')) break;
    buffer.add(next.substring(4).trimRight());
    i++;
  }
  return (match.group(1)!, buffer.join('\n').trimRight(), i);
}

/// Parses a `<details>` … `</details>` block; summary defaults to `Details`.
/// Returns the block and the next line index, or null when [index] does not
/// open one. Unclosed blocks run to the end of input.
(MarkdownBlock, int)? _parseDetailsBlock(List<String> lines, int index) {
  if (!lines[index].trimLeft().toLowerCase().startsWith('<details')) {
    return null;
  }
  var summary = 'Details';
  final body = <String>[];
  var i = index + 1;
  while (i < lines.length &&
      !lines[i].trimLeft().toLowerCase().startsWith('</details')) {
    final summaryMatch = RegExp(
      r'<summary>(.*?)</summary>',
      caseSensitive: false,
    ).firstMatch(lines[i]);
    if (summaryMatch != null) {
      final text = summaryMatch.group(1)!.trim();
      if (text.isNotEmpty) summary = text;
    } else {
      body.add(lines[i]);
    }
    i++;
  }
  return (
    MarkdownBlock(
      kind: MarkdownBlockKind.details,
      text: body.join('\n').trimRight(),
      summary: summary,
    ),
    i + 1,
  );
}

/// Referenced footnote ids in first-ref order, scanning texts and table
/// cells (quote and details bodies are raw text, so they scan too).
List<String> markdownFootnoteOrder(List<MarkdownBlock> blocks) {
  final order = <String>[];
  void scan(String text) {
    for (final match in RegExp(r'\[\^([^\]]+)\]').allMatches(text)) {
      final id = match.group(1)!;
      if (!order.contains(id)) order.add(id);
    }
  }

  for (final block in blocks) {
    scan(block.text);
    for (final row in block.tableRows) {
      for (final cell in row) {
        scan(cell);
      }
    }
  }
  return order;
}

/// Splits a table row into cells, dropping the decorative outer pipes.
List<String> _splitTableRow(String line) {
  final cells = line.trim().replaceAll(RegExp(r'^\||\|$'), '').split('|');
  return <String>[for (final cell in cells) cell.trim()];
}

/// Column alignments parsed from a delimiter row.
List<TextAlign> _tableAlignments(String delimiter) {
  final aligns = <TextAlign>[];
  for (final cell in _splitTableRow(delimiter)) {
    final c = cell.trim();
    if (c.startsWith(':') && c.endsWith(':')) {
      aligns.add(TextAlign.center);
    } else if (c.endsWith(':')) {
      aligns.add(TextAlign.right);
    } else {
      aligns.add(TextAlign.left);
    }
  }
  return aligns;
}

/// Parses inline emphasis, code, links and autolinks into runs. Toggles nest
/// (`**bold *both***`); code spans and link URLs are literal.
