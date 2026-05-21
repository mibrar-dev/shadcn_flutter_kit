// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../markdown.dart';

(String, int)? _collectHtmlElement(List<String> lines, int index, String tag) {
  final open = RegExp('<$tag\\b', caseSensitive: false);
  final close = RegExp('</$tag\\s*>', caseSensitive: false);
  if (!open.hasMatch(lines[index])) {
    return null;
  }

  final buffer = <String>[];
  var depth = 0;
  var i = index;
  while (i < lines.length) {
    final line = lines[i];
    buffer.add(line);
    depth += open.allMatches(line).length;
    depth -= close.allMatches(line).length;
    i += 1;
    if (depth <= 0 && close.hasMatch(line)) {
      break;
    }
  }

  if (depth > 0) {
    return null;
  }
  return (buffer.join('\n'), i);
}

(String, int)? _collectSelfClosingHtmlTag(List<String> lines, int index) {
  final buffer = StringBuffer(lines[index].trim());
  var i = index + 1;
  while (!buffer.toString().contains('>') && i < lines.length) {
    buffer.write(lines[i].trim());
    i += 1;
  }
  if (!buffer.toString().contains('>')) {
    return null;
  }
  return (buffer.toString(), i);
}

String _extractInnerHtml(String raw, String tag) {
  final openPattern = RegExp('^\\s*<$tag\\b[^>]*>', caseSensitive: false);
  final closePattern = RegExp('</$tag>\\s*\$', caseSensitive: false);
  var value = raw.replaceFirst(openPattern, '');
  value = value.replaceFirst(closePattern, '');
  return value.trim();
}

String _extractOpeningHtmlAttributes(String raw, String tag) {
  final match = RegExp(
    '^\\s*<$tag\\b([^>]*)>',
    caseSensitive: false,
  ).firstMatch(raw);
  return match?.group(1)?.trim() ?? '';
}

Map<String, String> _extractHtmlAttributesMap(String raw) {
  if (raw.trim().isEmpty) {
    return const <String, String>{};
  }
  final attributes = <String, String>{};
  final matches = RegExp(
    r'''([^\s=/>]+)(?:\s*=\s*(?:"([^"]*)"|'([^']*)'|([^\s"'=<>`]+)))?''',
    caseSensitive: false,
  ).allMatches(raw);
  for (final match in matches) {
    final key = (match.group(1) ?? '').trim();
    if (key.isEmpty) {
      continue;
    }
    final value = match.group(2) ?? match.group(3) ?? match.group(4) ?? 'true';
    attributes[key] = _decodeHtmlEntities(value);
  }
  return Map<String, String>.unmodifiable(attributes);
}

String? _extractHtmlAttribute(String raw, String name) {
  final match = RegExp(
    '''$name\\s*=\\s*("([^"]*)"|'([^']*)')''',
    caseSensitive: false,
  ).firstMatch(raw);
  return match?.group(2) ?? match?.group(3);
}

String? _extractLanguageFromCodeAttrs(String attrs) {
  final match = RegExp(
    r'''class\s*=\s*("([^"]*)"|'([^']*)')''',
    caseSensitive: false,
  ).firstMatch(attrs);
  final classes = match?.group(2) ?? match?.group(3);
  if (classes == null || classes.isEmpty) {
    return null;
  }
  for (final token in classes.split(RegExp(r'\s+'))) {
    final normalized = token.trim();
    if (normalized.startsWith('language-') && normalized.length > 9) {
      return normalized.substring(9);
    }
    if (normalized.startsWith('lang-') && normalized.length > 5) {
      return normalized.substring(5);
    }
  }
  return null;
}

String _normalizeHtmlBlockText(String value) {
  final text = _normalizeHtmlInline(
    value
        .replaceAll(
          RegExp(r'</?(p|div|section|article)\b[^>]*>', caseSensitive: false),
          '\n',
        )
        .replaceAll(RegExp(r'</li>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<li\b[^>]*>', caseSensitive: false), '• '),
  );
  return text.replaceAll(RegExp(r'\n{3,}'), '\n\n').trim();
}

String _normalizeHtmlInline(String html) {
  var value = html;
  value = value.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n');
  value = value.replaceAllMapped(
    RegExp(
      r'''<a\b[^>]*href\s*=\s*["']([^"']+)["'][^>]*>([\s\S]*?)</a>''',
      caseSensitive: false,
    ),
    (match) {
      final href = _decodeHtmlEntities(match.group(1) ?? '');
      final label = _stripHtmlTags(match.group(2) ?? '').trim();
      if (href.isEmpty) {
        return label;
      }
      return '[${label.isEmpty ? href : label}]($href)';
    },
  );
  value = value.replaceAllMapped(
    RegExp(r'<(strong|b)>([\s\S]*?)</\1>', caseSensitive: false),
    (match) => '**${_stripHtmlTags(match.group(2) ?? '').trim()}**',
  );
  value = value.replaceAllMapped(
    RegExp(r'<(em|i)>([\s\S]*?)</\1>', caseSensitive: false),
    (match) => '*${_stripHtmlTags(match.group(2) ?? '').trim()}*',
  );
  value = value.replaceAllMapped(
    RegExp(r'<(del|s)>([\s\S]*?)</\1>', caseSensitive: false),
    (match) => '~~${_stripHtmlTags(match.group(2) ?? '').trim()}~~',
  );
  value = value.replaceAllMapped(
    RegExp(r'<code>([\s\S]*?)</code>', caseSensitive: false),
    (match) => '`${_stripHtmlTags(match.group(1) ?? '').trim()}`',
  );
  value = value.replaceAllMapped(
    RegExp(r'<kbd>([\s\S]*?)</kbd>', caseSensitive: false),
    (match) => '<kbd>${_stripHtmlTags(match.group(1) ?? '').trim()}</kbd>',
  );
  value = _stripHtmlTags(value);
  return _decodeHtmlEntities(value).trim();
}

(_MarkdownBlock, int)? _tryParseHtmlTable(List<String> lines, int index) {
  final start = lines[index].trimLeft().toLowerCase();
  if (!start.startsWith('<table')) {
    return null;
  }

  final buffer = <String>[lines[index]];
  var i = index + 1;
  while (i < lines.length) {
    buffer.add(lines[i]);
    if (lines[i].trim().toLowerCase().contains('</table>')) {
      i += 1;
      break;
    }
    i += 1;
  }

  final raw = buffer.join('\n');
  final table = _parseHtmlTable(raw);
  if (table != null) {
    return (table, i);
  }
  return (
    _MarkdownBlock(
      type: _MarkdownBlockType.rawHtml,
      text: raw,
      htmlTag: 'table',
      rawHtml: raw,
    ),
    i,
  );
}

_MarkdownBlock? _parseHtmlTable(String raw) {
  final rowMatches = RegExp(
    r'<tr\b[^>]*>([\s\S]*?)</tr>',
    caseSensitive: false,
  ).allMatches(raw);
  if (rowMatches.isEmpty) {
    return null;
  }

  final rows = <List<String>>[];
  var alignments = <TextAlign>[];

  for (final rowMatch in rowMatches) {
    final rowHtml = rowMatch.group(1) ?? '';
    final cells = _parseHtmlTableCells(rowHtml);
    if (cells.isEmpty) {
      continue;
    }

    rows.add(<String>[
      for (final cell in cells) _normalizeHtmlTableCell(cell.$3),
    ]);
    if (alignments.isEmpty) {
      alignments = <TextAlign>[
        for (final cell in cells) _alignmentFromHtmlAttributes(cell.$2),
      ];
    }
  }

  if (rows.isEmpty) {
    return null;
  }

  final maxColumns = rows.fold<int>(
    0,
    (max, row) => row.length > max ? row.length : max,
  );
  return _MarkdownBlock(
    type: _MarkdownBlockType.table,
    text: '',
    tableRows: [
      for (final row in rows)
        [
          for (var col = 0; col < maxColumns; col++)
            col < row.length ? row[col] : '',
        ],
    ],
    tableAlignments: [
      for (var col = 0; col < maxColumns; col++)
        col < alignments.length ? alignments[col] : TextAlign.left,
    ],
    htmlTag: 'table',
    rawHtml: raw,
  );
}

List<(String, String, String)> _parseHtmlTableCells(String rowHtml) {
  final matches = RegExp(
    r'<(th|td)\b([^>]*)>([\s\S]*?)</\1>',
    caseSensitive: false,
  ).allMatches(rowHtml);
  return <(String, String, String)>[
    for (final match in matches)
      (
        (match.group(1) ?? '').toLowerCase(),
        match.group(2) ?? '',
        match.group(3) ?? '',
      ),
  ];
}

TextAlign _alignmentFromHtmlAttributes(String attrs) {
  final alignMatch = RegExp(
    r'''align\s*=\s*["']?\s*(left|center|right)\s*["']?''',
    caseSensitive: false,
  ).firstMatch(attrs);
  if (alignMatch != null) {
    return _cssAlignToTextAlign(alignMatch.group(1) ?? '');
  }

  final styleMatch = RegExp(
    r'''text-align\s*:\s*(left|center|right)''',
    caseSensitive: false,
  ).firstMatch(attrs);
  if (styleMatch != null) {
    return _cssAlignToTextAlign(styleMatch.group(1) ?? '');
  }
  return TextAlign.left;
}

TextAlign _cssAlignToTextAlign(String value) {
  return switch (value.toLowerCase().trim()) {
    'center' => TextAlign.center,
    'right' => TextAlign.right,
    _ => TextAlign.left,
  };
}

String _normalizeHtmlTableCell(String html) {
  var value = html;
  value = value.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n');
  value = value.replaceAllMapped(
    RegExp(
      r'''<a\b[^>]*href\s*=\s*["']([^"']+)["'][^>]*>([\s\S]*?)</a>''',
      caseSensitive: false,
    ),
    (match) {
      final url = match.group(1) ?? '';
      final label = _stripHtmlTags(match.group(2) ?? '').trim();
      if (url.isEmpty) {
        return label;
      }
      return '[${label.isEmpty ? url : label}]($url)';
    },
  );
  value = value.replaceAllMapped(
    RegExp(r'<(strong|b)>([\s\S]*?)</\1>', caseSensitive: false),
    (match) => '**${_stripHtmlTags(match.group(2) ?? '').trim()}**',
  );
  value = value.replaceAllMapped(
    RegExp(r'<(em|i)>([\s\S]*?)</\1>', caseSensitive: false),
    (match) => '*${_stripHtmlTags(match.group(2) ?? '').trim()}*',
  );
  value = value.replaceAllMapped(
    RegExp(r'<code>([\s\S]*?)</code>', caseSensitive: false),
    (match) => '`${_stripHtmlTags(match.group(1) ?? '').trim()}`',
  );
  value = _stripHtmlTags(value);
  return _decodeHtmlEntities(value).trim();
}

String _stripHtmlTags(String value) {
  return value.replaceAll(RegExp(r'<[^>]+>'), '');
}
