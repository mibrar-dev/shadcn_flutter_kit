// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../markdown.dart';

(_MarkdownBlock, int)? _tryParseSemanticHtmlBlock(
  List<String> lines,
  int index,
) {
  final trimmed = lines[index].trimLeft();
  if (!trimmed.startsWith('<') || trimmed.startsWith('</')) {
    return null;
  }

  final headingMatch = RegExp(
    r'^<h([1-6])\b',
    caseSensitive: false,
  ).firstMatch(trimmed);
  if (headingMatch != null) {
    final level = int.tryParse(headingMatch.group(1) ?? '') ?? 1;
    final tag = 'h$level';
    final collected = _collectHtmlElement(lines, index, tag);
    if (collected == null) {
      return null;
    }
    final content = _extractInnerHtml(collected.$1, tag);
    final text = _normalizeHtmlInline(content);
    if (text.isEmpty) {
      return null;
    }
    return (
      _MarkdownBlock(
        type: switch (level) {
          1 => _MarkdownBlockType.heading1,
          2 => _MarkdownBlockType.heading2,
          3 => _MarkdownBlockType.heading3,
          4 => _MarkdownBlockType.heading4,
          5 => _MarkdownBlockType.heading5,
          _ => _MarkdownBlockType.heading6,
        },
        text: text,
        htmlTag: tag,
        rawHtml: collected.$1,
      ),
      collected.$2,
    );
  }

  final lower = trimmed.toLowerCase();
  if (RegExp(r'^<hr\b[^>]*\/?>$').hasMatch(lower)) {
    return (
      _MarkdownBlock(
        type: _MarkdownBlockType.horizontalRule,
        text: '',
        htmlTag: 'hr',
        rawHtml: lines[index].trimRight(),
      ),
      index + 1,
    );
  }

  if (lower.startsWith('<img')) {
    final collected = _collectSelfClosingHtmlTag(lines, index);
    if (collected == null) {
      return null;
    }
    final attrs = collected.$1;
    final src = _extractHtmlAttribute(attrs, 'src');
    if (src == null || src.isEmpty) {
      return null;
    }
    return (
      _MarkdownBlock(
        type: _MarkdownBlockType.image,
        text: '',
        imageUrl: _decodeHtmlEntities(src),
        imageAlt: _decodeHtmlEntities(
          _extractHtmlAttribute(attrs, 'alt') ?? '',
        ),
        imageTitle: _decodeHtmlEntities(
          _extractHtmlAttribute(attrs, 'title') ?? '',
        ),
        htmlTag: 'img',
        rawHtml: collected.$1,
      ),
      collected.$2,
    );
  }

  if (lower.startsWith('<pre')) {
    final collected = _collectHtmlElement(lines, index, 'pre');
    if (collected == null) {
      return null;
    }
    final raw = collected.$1;
    final codeMatch = RegExp(
      r'<code\b([^>]*)>([\s\S]*?)</code>',
      caseSensitive: false,
    ).firstMatch(raw);
    final language =
        _extractLanguageFromCodeAttrs(codeMatch?.group(1) ?? '') ??
        _extractLanguageFromCodeAttrs(raw);
    final codeInner = codeMatch?.group(2) ?? _extractInnerHtml(raw, 'pre');
    final code = _decodeHtmlEntities(codeInner).trimRight();
    return (
      _MarkdownBlock(
        type: _MarkdownBlockType.codeFence,
        text: code,
        language: language,
        htmlTag: 'pre',
        rawHtml: collected.$1,
      ),
      collected.$2,
    );
  }

  if (lower.startsWith('<blockquote')) {
    final collected = _collectHtmlElement(lines, index, 'blockquote');
    if (collected == null) {
      return null;
    }
    final inner = _extractInnerHtml(collected.$1, 'blockquote');
    final text = _normalizeHtmlBlockText(inner);
    if (text.isEmpty) {
      return null;
    }
    return (
      _MarkdownBlock(
        type: _MarkdownBlockType.quote,
        text: text,
        htmlTag: 'blockquote',
        rawHtml: collected.$1,
      ),
      collected.$2,
    );
  }

  if (lower.startsWith('<p') || lower.startsWith('<div')) {
    final tag = lower.startsWith('<p') ? 'p' : 'div';
    final collected = _collectHtmlElement(lines, index, tag);
    if (collected == null) {
      return null;
    }
    final text = _normalizeHtmlBlockText(_extractInnerHtml(collected.$1, tag));
    if (text.isEmpty) {
      return null;
    }
    return (
      _MarkdownBlock(
        type: _MarkdownBlockType.paragraph,
        text: text,
        htmlTag: tag,
        rawHtml: collected.$1,
      ),
      collected.$2,
    );
  }

  return null;
}

(List<_MarkdownBlock>, int)? _tryParseHtmlListBlock(
  List<String> lines,
  int index,
) {
  final lower = lines[index].trimLeft().toLowerCase();
  if (!lower.startsWith('<ul') && !lower.startsWith('<ol')) {
    return null;
  }
  final tag = lower.startsWith('<ol') ? 'ol' : 'ul';
  final collected = _collectHtmlElement(lines, index, tag);
  if (collected == null) {
    return null;
  }
  final blocks = _parseHtmlListElement(collected.$1, indentLevel: 0);
  if (blocks.isEmpty) {
    return null;
  }
  return (blocks, collected.$2);
}

List<_MarkdownBlock> _parseHtmlListElement(
  String raw, {
  required int indentLevel,
}) {
  final trimmed = raw.trimLeft();
  final openMatch = RegExp(
    r'^<\s*(ul|ol)\b([^>]*)>',
    caseSensitive: false,
  ).firstMatch(trimmed);
  if (openMatch == null) {
    return const <_MarkdownBlock>[];
  }

  final listTag = (openMatch.group(1) ?? 'ul').toLowerCase();
  final isOrdered = listTag == 'ol';
  final attrs = openMatch.group(2) ?? '';
  var nextOrderedIndex = isOrdered
      ? int.tryParse(_extractHtmlAttribute(attrs, 'start') ?? '') ?? 1
      : 1;

  final inner = _extractInnerHtml(trimmed, listTag);
  final liItems = _extractTopLevelElements(inner, 'li');
  final blocks = <_MarkdownBlock>[];
  for (final liRaw in liItems) {
    final parsed = _parseHtmlListItem(
      liRaw,
      ordered: isOrdered,
      indentLevel: indentLevel,
      orderedIndex: nextOrderedIndex,
    );
    if (parsed.$1 != null) {
      blocks.add(parsed.$1!);
    }
    blocks.addAll(parsed.$2);
    if (isOrdered) {
      nextOrderedIndex += 1;
    }
  }
  return blocks;
}

(_MarkdownBlock?, List<_MarkdownBlock>) _parseHtmlListItem(
  String raw, {
  required bool ordered,
  required int indentLevel,
  required int orderedIndex,
}) {
  final inner = _extractInnerHtml(raw, 'li');
  final nestedSegments = _extractTopLevelListSegments(inner);
  final mainHtml = _removeRanges(inner, [
    for (final segment in nestedSegments) (segment.$2, segment.$3),
  ]);
  final checkboxState = _extractHtmlCheckboxState(mainHtml);
  final normalized = _normalizeHtmlBlockText(
    _stripHtmlCheckboxInputs(mainHtml),
  );

  _MarkdownBlock? block;
  if (normalized.isNotEmpty || checkboxState != null) {
    if (checkboxState != null) {
      block = _MarkdownBlock(
        type: _MarkdownBlockType.taskList,
        text: normalized,
        checked: checkboxState,
        indentLevel: indentLevel,
      );
    } else if (ordered) {
      block = _MarkdownBlock(
        type: _MarkdownBlockType.orderedList,
        text: normalized,
        orderedIndex: orderedIndex,
        indentLevel: indentLevel,
      );
    } else {
      block = _MarkdownBlock(
        type: _MarkdownBlockType.unorderedList,
        text: normalized,
        indentLevel: indentLevel,
      );
    }
  }

  final nestedBlocks = <_MarkdownBlock>[];
  for (final segment in nestedSegments) {
    final nestedRaw = inner.substring(segment.$2, segment.$3);
    nestedBlocks.addAll(
      _parseHtmlListElement(nestedRaw, indentLevel: indentLevel + 1),
    );
  }

  return (block, nestedBlocks);
}

List<(String, int, int)> _extractTopLevelListSegments(String html) {
  final segments = <(String, int, int)>[];
  for (final tag in const <String>['ul', 'ol']) {
    final ranges = _extractTopLevelTagRanges(html, tag);
    for (final range in ranges) {
      segments.add((tag, range.$1, range.$2));
    }
  }
  segments.sort((a, b) => a.$2.compareTo(b.$2));
  return segments;
}

List<String> _extractTopLevelElements(String html, String tag) {
  final ranges = _extractTopLevelTagRanges(html, tag);
  return <String>[
    for (final range in ranges) html.substring(range.$1, range.$2),
  ];
}

List<(int, int)> _extractTopLevelTagRanges(String html, String tag) {
  final tokenPattern = RegExp('</?$tag\\b[^>]*>', caseSensitive: false);
  final ranges = <(int, int)>[];
  var depth = 0;
  int? start;

  for (final match in tokenPattern.allMatches(html)) {
    final token = match.group(0)!.toLowerCase();
    final isClosing = token.startsWith('</');
    final isSelfClosing = token.endsWith('/>');
    if (!isClosing) {
      if (depth == 0) {
        start = match.start;
      }
      if (isSelfClosing) {
        if (depth == 0 && start != null) {
          ranges.add((start, match.end));
          start = null;
        }
      } else {
        depth += 1;
      }
      continue;
    }
    if (depth == 0) {
      continue;
    }
    depth -= 1;
    if (depth == 0 && start != null) {
      ranges.add((start, match.end));
      start = null;
    }
  }

  return ranges;
}

String _removeRanges(String source, List<(int, int)> ranges) {
  if (ranges.isEmpty) {
    return source;
  }
  final sorted = <(int, int)>[...ranges]..sort((a, b) => a.$1.compareTo(b.$1));
  final buffer = StringBuffer();
  var cursor = 0;
  for (final range in sorted) {
    if (range.$1 > cursor) {
      buffer.write(source.substring(cursor, range.$1));
    }
    cursor = range.$2 > cursor ? range.$2 : cursor;
  }
  if (cursor < source.length) {
    buffer.write(source.substring(cursor));
  }
  return buffer.toString();
}

bool? _extractHtmlCheckboxState(String value) {
  final input = RegExp(
    r'<input\b([^>]*)>',
    caseSensitive: false,
  ).firstMatch(value);
  if (input == null) {
    return null;
  }
  final attrs = input.group(1) ?? '';
  final type = _extractHtmlAttribute(attrs, 'type')?.toLowerCase().trim();
  if (type != 'checkbox') {
    return null;
  }
  return RegExp(r'\bchecked\b', caseSensitive: false).hasMatch(attrs);
}

String _stripHtmlCheckboxInputs(String value) {
  return value.replaceAllMapped(
    RegExp(r'<input\b([^>]*)>', caseSensitive: false),
    (match) {
      final attrs = match.group(1) ?? '';
      final type = _extractHtmlAttribute(attrs, 'type')?.toLowerCase().trim();
      if (type == 'checkbox') {
        return '';
      }
      return match.group(0) ?? '';
    },
  );
}

(List<_MarkdownBlock>, int)? _tryParseHtmlDefinitionListBlock(
  List<String> lines,
  int index,
) {
  final lower = lines[index].trimLeft().toLowerCase();
  if (!lower.startsWith('<dl')) {
    return null;
  }

  final collected = _collectHtmlElement(lines, index, 'dl');
  if (collected == null) {
    return null;
  }

  final inner = _extractInnerHtml(collected.$1, 'dl');
  final entries = <(String, int, int)>[
    for (final range in _extractTopLevelTagRanges(inner, 'dt'))
      ('dt', range.$1, range.$2),
    for (final range in _extractTopLevelTagRanges(inner, 'dd'))
      ('dd', range.$1, range.$2),
  ]..sort((a, b) => a.$2.compareTo(b.$2));

  final blocks = <_MarkdownBlock>[];
  String? currentTerm;
  final definitions = <String>[];

  void flushCurrent() {
    if (currentTerm == null || definitions.isEmpty) {
      return;
    }
    blocks.add(
      _MarkdownBlock(
        type: _MarkdownBlockType.definitionList,
        text: currentTerm!,
        items: List<String>.unmodifiable(definitions),
      ),
    );
    currentTerm = null;
    definitions.clear();
  }

  for (final entry in entries) {
    final tag = entry.$1;
    final raw = inner.substring(entry.$2, entry.$3);
    final text = _normalizeHtmlBlockText(_extractInnerHtml(raw, tag));
    if (text.isEmpty) {
      continue;
    }
    if (tag == 'dt') {
      flushCurrent();
      currentTerm = text;
      continue;
    }
    currentTerm ??= 'Term';
    definitions.add(text);
  }
  flushCurrent();

  if (blocks.isEmpty) {
    return null;
  }
  return (blocks, collected.$2);
}
