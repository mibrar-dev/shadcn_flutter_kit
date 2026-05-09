// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../markdown.dart';

(String, _MarkdownLinkTarget)? _tryParseReferenceDefinition(String line) {
  final match = RegExp(
    r'''^\s*\[([^\]]+)\]:\s+(\S+)(?:\s+(?:"([^"]+)"|'([^']+)'))?\s*$''',
  ).firstMatch(line);
  if (match == null) {
    return null;
  }
  return (
    _normalizeReferenceKey(match.group(1)!),
    _MarkdownLinkTarget(
      url: match.group(2)!,
      title: match.group(3) ?? match.group(4),
    ),
  );
}

(String, String, int)? _tryParseFootnoteDefinition(
  List<String> lines,
  int index,
) {
  final match = RegExp(
    r'^\s*\[\^([^\]]+)\]:\s+(.+)$',
  ).firstMatch(lines[index].trimRight());
  if (match == null) {
    return null;
  }

  final id = match.group(1)!;
  final buffer = <String>[match.group(2)!];
  var i = index + 1;
  while (i < lines.length) {
    final line = lines[i];
    if (line.trim().isEmpty) {
      buffer.add('');
      i += 1;
      continue;
    }
    if (RegExp(r'^\s{2,}|\t').hasMatch(line)) {
      buffer.add(line.trim());
      i += 1;
      continue;
    }
    break;
  }
  return (id, buffer.join('\n').trimRight(), i);
}

(_MarkdownBlock, int)? _tryParseCodeFence(List<String> lines, int index) {
  final firstLine = lines[index].trimRight();
  final fenceInfo = _parseFenceMarker(firstLine);
  if (fenceInfo == null) {
    return null;
  }
  final marker = fenceInfo.$1;
  final language = fenceInfo.$2;
  final buffer = <String>[];
  var i = index + 1;
  while (i < lines.length &&
      !_isClosingFenceLine(lines[i].trimRight(), marker)) {
    buffer.add(lines[i]);
    i += 1;
  }
  if (i < lines.length) {
    i += 1;
  }
  return (
    _MarkdownBlock(
      type: _MarkdownBlockType.codeFence,
      text: buffer.join('\n'),
      language: language,
    ),
    i,
  );
}

(_MarkdownBlock, int)? _tryParseSetextHeading(List<String> lines, int index) {
  if (index + 1 >= lines.length) {
    return null;
  }
  final text = lines[index].trimRight();
  if (text.isEmpty) {
    return null;
  }
  if (!_isSetextHeadingCandidate(text)) {
    return null;
  }
  final underline = lines[index + 1].trimRight();
  final match = RegExp(r'^\s*(=+|-+)\s*$').firstMatch(underline);
  if (match == null) {
    return null;
  }
  return (
    _MarkdownBlock(
      type: match.group(1)!.startsWith('=')
          ? _MarkdownBlockType.heading1
          : _MarkdownBlockType.heading2,
      text: text,
    ),
    index + 2,
  );
}

bool _isSetextHeadingCandidate(String line) {
  final trimmed = line.trimLeft();
  if (trimmed.isEmpty) {
    return false;
  }
  if (RegExp(r'^[-*+]\s+').hasMatch(trimmed)) {
    return false;
  }
  if (RegExp(r'^\d+\.\s+').hasMatch(trimmed)) {
    return false;
  }
  if (RegExp(r'^\[(?: |x|X)\]\s+').hasMatch(trimmed)) {
    return false;
  }
  if (trimmed.startsWith('>')) {
    return false;
  }
  if (trimmed.startsWith('|') && trimmed.endsWith('|')) {
    return false;
  }
  if (trimmed.startsWith('#')) {
    return false;
  }
  return true;
}

(_MarkdownBlock, int)? _tryParseIndentedCode(List<String> lines, int index) {
  if (!RegExp(r'^( {4}|\t)').hasMatch(lines[index])) {
    return null;
  }
  final buffer = <String>[];
  var i = index;
  while (i < lines.length) {
    final line = lines[i];
    if (line.trim().isEmpty) {
      buffer.add('');
      i += 1;
      continue;
    }
    if (!RegExp(r'^( {4}|\t)').hasMatch(line)) {
      break;
    }
    buffer.add(line.replaceFirst(RegExp(r'^( {4}|\t)'), ''));
    i += 1;
  }
  return (
    _MarkdownBlock(
      type: _MarkdownBlockType.indentedCode,
      text: buffer.join('\n'),
    ),
    i,
  );
}

(_MarkdownBlock, int)? _tryParseBlockMath(List<String> lines, int index) {
  final trimmed = lines[index].trimRight();
  if (trimmed != r'$$') {
    return null;
  }
  final buffer = <String>[];
  var i = index + 1;
  while (i < lines.length && lines[i].trimRight() != r'$$') {
    buffer.add(lines[i]);
    i += 1;
  }
  if (i < lines.length) {
    i += 1;
  }
  return (
    _MarkdownBlock(type: _MarkdownBlockType.math, text: buffer.join('\n')),
    i,
  );
}

(_MarkdownBlock, int)? _tryParseDetailsBlock(List<String> lines, int index) {
  if (!lines[index].trim().toLowerCase().startsWith('<details')) {
    return null;
  }

  String summary = 'Details';
  final body = <String>[];
  var i = index + 1;
  while (i < lines.length) {
    final trimmed = lines[i].trim();
    final summaryMatch = RegExp(
      r'^<summary\b[^>]*>([\s\S]*?)</summary>$',
      caseSensitive: false,
    ).firstMatch(trimmed);
    if (summaryMatch != null) {
      summary = _normalizeHtmlInline(summaryMatch.group(1) ?? '').trim();
      i += 1;
      continue;
    }
    if (trimmed.toLowerCase().startsWith('</details')) {
      i += 1;
      break;
    }
    body.add(lines[i]);
    i += 1;
  }

  return (
    _MarkdownBlock(
      type: _MarkdownBlockType.details,
      text: summary,
      items: <String>[body.join('\n').trim()],
    ),
    i,
  );
}

(_MarkdownBlock, int)? _tryParseHtmlBlock(List<String> lines, int index) {
  final trimmed = lines[index].trim();
  if (!trimmed.startsWith('<') || trimmed.startsWith('</')) {
    return null;
  }
  if (trimmed.toLowerCase().startsWith('<details')) {
    return null;
  }

  final buffer = <String>[lines[index]];
  final tag = RegExp(
    r'^<([a-zA-Z0-9]+)',
  ).firstMatch(trimmed)?.group(1)?.toLowerCase();
  var i = index + 1;
  while (i < lines.length && lines[i].trim().isNotEmpty) {
    buffer.add(lines[i]);
    if (tag != null && lines[i].trim().toLowerCase() == '</$tag>') {
      i += 1;
      break;
    }
    i += 1;
  }

  return (
    _MarkdownBlock(
      type: _MarkdownBlockType.rawHtml,
      text: buffer.join('\n'),
      htmlTag: tag,
      rawHtml: buffer.join('\n'),
    ),
    i,
  );
}

(_MarkdownBlock, int)? _tryParseQuote(List<String> lines, int index) {
  if (!_isQuoteLine(lines[index].trimRight())) {
    return null;
  }
  final buffer = <String>[];
  var i = index;
  while (i < lines.length && _isQuoteLine(lines[i].trimRight())) {
    buffer.add(lines[i].trimRight().replaceFirst(RegExp(r'^\s*>\s?'), ''));
    i += 1;
  }
  return (
    _MarkdownBlock(type: _MarkdownBlockType.quote, text: buffer.join('\n')),
    i,
  );
}

(_MarkdownBlock, int)? _tryParseDefinitionList(List<String> lines, int index) {
  if (index + 1 >= lines.length || lines[index].trim().isEmpty) {
    return null;
  }
  if (!lines[index + 1].trimLeft().startsWith(':')) {
    return null;
  }

  final term = lines[index].trim();
  final definitions = <String>[];
  var i = index + 1;
  while (i < lines.length && lines[i].trimLeft().startsWith(':')) {
    definitions.add(lines[i].trimLeft().substring(1).trim());
    i += 1;
  }

  return (
    _MarkdownBlock(
      type: _MarkdownBlockType.definitionList,
      text: term,
      items: definitions,
    ),
    i,
  );
}

bool _isQuoteLine(String line) {
  return RegExp(r'^\s*>\s?').hasMatch(line);
}

_MarkdownBlock? _parseListItem(String line) {
  final indent = _leadingSpaces(line) ~/ 2;

  final task = RegExp(r'^\s*[-*+]\s+\[( |x|X)\]\s+(.+)$').firstMatch(line);
  if (task != null) {
    return _MarkdownBlock(
      type: _MarkdownBlockType.taskList,
      text: task.group(2)!,
      checked: task.group(1)!.toLowerCase() == 'x',
      indentLevel: indent,
    );
  }

  final ul = RegExp(r'^\s*[-*+]\s+(.+)$').firstMatch(line);
  if (ul != null) {
    return _MarkdownBlock(
      type: _MarkdownBlockType.unorderedList,
      text: ul.group(1)!,
      indentLevel: indent,
    );
  }

  final ol = RegExp(r'^\s*(\d+)\.\s+(.+)$').firstMatch(line);
  if (ol != null) {
    return _MarkdownBlock(
      type: _MarkdownBlockType.orderedList,
      orderedIndex: int.tryParse(ol.group(1)!) ?? 1,
      text: ol.group(2)!,
      indentLevel: indent,
    );
  }

  return null;
}

int _leadingSpaces(String value) {
  var count = 0;
  for (final rune in value.runes) {
    if (rune == 32) {
      count += 1;
      continue;
    }
    break;
  }
  return count;
}

bool _looksLikeTableHeader(List<String> lines, int index) {
  if (index + 1 >= lines.length) {
    return false;
  }
  final first = lines[index].trimRight();
  final second = lines[index + 1].trimRight();
  if (!first.contains('|')) {
    return false;
  }
  if (_parseTableRow(first).length < 2) {
    return false;
  }
  return _isTableSeparatorLine(second);
}

List<String> _parseTableRow(String line) {
  final trimmed = line.trim();
  var content = trimmed;
  if (content.startsWith('|')) {
    content = content.substring(1);
  }
  if (content.endsWith('|')) {
    content = content.substring(0, content.length - 1);
  }

  final cells = <String>[];
  final buffer = StringBuffer();
  var escaped = false;
  for (var i = 0; i < content.length; i++) {
    final char = content[i];
    if (escaped) {
      buffer.write(char);
      escaped = false;
      continue;
    }
    if (char == r'\') {
      escaped = true;
      continue;
    }
    if (char == '|') {
      cells.add(buffer.toString().trim());
      buffer.clear();
      continue;
    }
    buffer.write(char);
  }
  cells.add(buffer.toString().trim());
  return cells;
}

(List<List<String>>, int) _consumeMarkdownTableRows(
  List<String> lines,
  int startIndex, {
  required int expectedColumns,
}) {
  final rows = <List<String>>[];
  List<String>? pendingRow;
  var i = startIndex;

  while (i < lines.length) {
    final rawLine = lines[i];
    final trimmedRight = rawLine.trimRight();
    if (trimmedRight.trim().isEmpty) {
      break;
    }

    if (trimmedRight.contains('|')) {
      final parsed = _parseTableRow(trimmedRight);
      if (pendingRow == null) {
        pendingRow = parsed;
      } else if (_isTableRowComplete(pendingRow, expectedColumns)) {
        rows.add(pendingRow);
        pendingRow = parsed;
      } else {
        pendingRow = _mergeTableRowFragments(pendingRow, parsed);
      }
      i += 1;
      continue;
    }

    if (pendingRow == null ||
        _isTableRowComplete(pendingRow, expectedColumns)) {
      break;
    }

    pendingRow = _appendTableRowContinuation(pendingRow, trimmedRight);
    i += 1;
  }

  if (pendingRow != null) {
    rows.add(pendingRow);
  }
  return (rows, i);
}

bool _isTableRowComplete(List<String> row, int expectedColumns) {
  return row.length >= expectedColumns;
}

List<String> _mergeTableRowFragments(List<String> base, List<String> fragment) {
  if (fragment.isEmpty) {
    return base;
  }
  final merged = List<String>.from(base);
  if (merged.isEmpty) {
    return List<String>.from(fragment);
  }
  merged[merged.length - 1] = merged.last.isEmpty
      ? fragment.first
      : '${merged.last}\n${fragment.first}';
  if (fragment.length > 1) {
    merged.addAll(fragment.skip(1));
  }
  return merged;
}

List<String> _appendTableRowContinuation(
  List<String> row,
  String continuation,
) {
  final merged = List<String>.from(row);
  if (merged.isEmpty) {
    merged.add(continuation);
    return merged;
  }
  merged[merged.length - 1] = merged.last.isEmpty
      ? continuation
      : '${merged.last}\n$continuation';
  return merged;
}

List<TextAlign> _tableAlignments(String separatorLine) {
  final cells = _parseTableRow(separatorLine);
  return <TextAlign>[for (final cell in cells) _tableAlignment(cell)];
}

TextAlign _tableAlignment(String cell) {
  final trimmed = cell.trim();
  final left = trimmed.startsWith(':');
  final right = trimmed.endsWith(':');
  if (left && right) {
    return TextAlign.center;
  }
  if (right) {
    return TextAlign.right;
  }
  return TextAlign.left;
}

bool _isTableSeparatorLine(String line) {
  final cells = _parseTableRow(line);
  if (cells.length < 2) {
    return false;
  }
  for (final cell in cells) {
    final normalized = cell.replaceAll(' ', '');
    if (!RegExp(r'^:?-{2,}:?$').hasMatch(normalized)) {
      return false;
    }
  }
  return true;
}

(String, String, String?)? _tryParseImageSyntax(String input) {
  final match = RegExp(
    r'''^!\[([^\]]*)\]\((\S+?)(?:\s+(?:"([^"]+)"|'([^']+)'))?\)\s*$''',
  ).firstMatch(input);
  if (match == null) {
    return null;
  }
  return (
    match.group(1) ?? '',
    match.group(2)!,
    match.group(3) ?? match.group(4),
  );
}

String _normalizeReferenceKey(String value) {
  return value.trim().toLowerCase();
}
