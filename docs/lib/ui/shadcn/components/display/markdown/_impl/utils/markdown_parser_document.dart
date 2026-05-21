// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../markdown.dart';

_MarkdownDocument _parseMarkdownDocument(String data) {
  if (data.trim().isEmpty) {
    return const _MarkdownDocument(blocks: <_MarkdownBlock>[]);
  }

  final normalized = data.replaceAll('\r\n', '\n');
  final source = _normalizeMarkdownWithHtmlBridges(normalized);
  final lines = source.split('\n');
  final blocks = <_MarkdownBlock>[];
  final references = <String, _MarkdownLinkTarget>{};
  final footnotes = <String, String>{};

  var i = 0;
  while (i < lines.length) {
    final line = lines[i];
    final trimmed = line.trimRight();

    if (trimmed.isEmpty) {
      blocks.add(
        const _MarkdownBlock(type: _MarkdownBlockType.blank, text: ''),
      );
      i += 1;
      continue;
    }

    final reference = _tryParseReferenceDefinition(trimmed);
    if (reference != null) {
      references[reference.$1] = reference.$2;
      i += 1;
      continue;
    }

    final footnote = _tryParseFootnoteDefinition(lines, i);
    if (footnote != null) {
      footnotes[footnote.$1] = footnote.$2;
      i = footnote.$3;
      continue;
    }

    final details = _tryParseDetailsBlock(lines, i);
    if (details != null) {
      blocks.add(details.$1);
      i = details.$2;
      continue;
    }

    final codeFence = _tryParseCodeFence(lines, i);
    if (codeFence != null) {
      blocks.add(codeFence.$1);
      i = codeFence.$2;
      continue;
    }

    final blockMath = _tryParseBlockMath(lines, i);
    if (blockMath != null) {
      blocks.add(blockMath.$1);
      i = blockMath.$2;
      continue;
    }

    final indentedCode = _tryParseIndentedCode(lines, i);
    if (indentedCode != null) {
      blocks.add(indentedCode.$1);
      i = indentedCode.$2;
      continue;
    }

    final htmlTable = _tryParseHtmlTable(lines, i);
    if (htmlTable != null) {
      blocks.add(htmlTable.$1);
      i = htmlTable.$2;
      continue;
    }

    final htmlList = _tryParseHtmlListBlock(lines, i);
    if (htmlList != null) {
      blocks.addAll(htmlList.$1);
      i = htmlList.$2;
      continue;
    }

    final htmlDefinitionList = _tryParseHtmlDefinitionListBlock(lines, i);
    if (htmlDefinitionList != null) {
      blocks.addAll(htmlDefinitionList.$1);
      i = htmlDefinitionList.$2;
      continue;
    }

    final htmlSemantic = _tryParseSemanticHtmlBlock(lines, i);
    if (htmlSemantic != null) {
      blocks.add(htmlSemantic.$1);
      i = htmlSemantic.$2;
      continue;
    }

    final htmlBlock = _tryParseHtmlBlock(lines, i);
    if (htmlBlock != null) {
      blocks.add(htmlBlock.$1);
      i = htmlBlock.$2;
      continue;
    }

    final hr = RegExp(r'^\s*([-_*])\s*\1\s*\1[\s\1]*$');
    if (hr.hasMatch(trimmed)) {
      blocks.add(
        const _MarkdownBlock(type: _MarkdownBlockType.horizontalRule, text: ''),
      );
      i += 1;
      continue;
    }

    final heading = RegExp(r'^(#{1,6})\s+(.+)$').firstMatch(trimmed);
    if (heading != null) {
      final level = heading.group(1)!.length;
      blocks.add(
        _MarkdownBlock(
          type: switch (level) {
            1 => _MarkdownBlockType.heading1,
            2 => _MarkdownBlockType.heading2,
            3 => _MarkdownBlockType.heading3,
            4 => _MarkdownBlockType.heading4,
            5 => _MarkdownBlockType.heading5,
            _ => _MarkdownBlockType.heading6,
          },
          text: heading.group(2)!,
        ),
      );
      i += 1;
      continue;
    }

    final wrappedHeading = _tryParseWrappedAtxHeading(trimmed);
    if (wrappedHeading != null) {
      final level = wrappedHeading.$1;
      blocks.add(
        _MarkdownBlock(
          type: switch (level) {
            1 => _MarkdownBlockType.heading1,
            2 => _MarkdownBlockType.heading2,
            3 => _MarkdownBlockType.heading3,
            4 => _MarkdownBlockType.heading4,
            5 => _MarkdownBlockType.heading5,
            _ => _MarkdownBlockType.heading6,
          },
          text: wrappedHeading.$2,
        ),
      );
      i += 1;
      continue;
    }

    final setextHeading = _tryParseSetextHeading(lines, i);
    if (setextHeading != null) {
      blocks.add(setextHeading.$1);
      i = setextHeading.$2;
      continue;
    }

    final image = _tryParseImageSyntax(trimmed);
    if (image != null) {
      blocks.add(
        _MarkdownBlock(
          type: _MarkdownBlockType.image,
          text: '',
          imageAlt: image.$1,
          imageUrl: image.$2,
          imageTitle: image.$3,
        ),
      );
      i += 1;
      continue;
    }

    if (_looksLikeTableHeader(lines, i)) {
      final rows = <List<String>>[_parseTableRow(lines[i])];
      final alignments = _tableAlignments(lines[i + 1]);
      final bodyResult = _consumeMarkdownTableRows(
        lines,
        i + 2,
        expectedColumns: rows.first.length,
      );
      rows.addAll(bodyResult.$1);
      i = bodyResult.$2;
      final maxColumns = rows.fold<int>(
        0,
        (max, row) => row.length > max ? row.length : max,
      );
      blocks.add(
        _MarkdownBlock(
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
        ),
      );
      continue;
    }

    final quote = _tryParseQuote(lines, i);
    if (quote != null) {
      blocks.add(quote.$1);
      i = quote.$2;
      continue;
    }

    final definition = _tryParseDefinitionList(lines, i);
    if (definition != null) {
      blocks.add(definition.$1);
      i = definition.$2;
      continue;
    }

    final listBlock = _parseListItem(trimmed);
    if (listBlock != null) {
      blocks.add(listBlock);
      i += 1;
      continue;
    }

    final paragraph = <String>[trimmed];
    i += 1;
    while (i < lines.length) {
      final next = lines[i].trimRight();
      if (next.isEmpty ||
          _tryParseReferenceDefinition(next) != null ||
          _tryParseCodeFence(lines, i) != null ||
          _tryParseBlockMath(lines, i) != null ||
          _tryParseIndentedCode(lines, i) != null ||
          _tryParseDetailsBlock(lines, i) != null ||
          _tryParseHtmlTable(lines, i) != null ||
          _tryParseHtmlListBlock(lines, i) != null ||
          _tryParseHtmlDefinitionListBlock(lines, i) != null ||
          _tryParseSemanticHtmlBlock(lines, i) != null ||
          _tryParseHtmlBlock(lines, i) != null ||
          RegExp(r'^(#{1,6})\s+').hasMatch(next) ||
          _tryParseSetextHeading(lines, i) != null ||
          _parseListItem(next) != null ||
          _isQuoteLine(next) ||
          RegExp(r'^\s*([-_*])\s*\1\s*\1').hasMatch(next) ||
          _looksLikeTableHeader(lines, i) ||
          _tryParseImageSyntax(next) != null ||
          _tryParseFootnoteDefinition(lines, i) != null ||
          _tryParseDefinitionList(lines, i) != null) {
        break;
      }
      paragraph.add(next);
      i += 1;
    }

    blocks.add(
      _MarkdownBlock(
        type: _MarkdownBlockType.paragraph,
        text: paragraph.join('\n'),
      ),
    );
  }

  if (footnotes.isNotEmpty) {
    blocks.add(const _MarkdownBlock(type: _MarkdownBlockType.blank, text: ''));
    for (final entry in footnotes.entries) {
      blocks.add(
        _MarkdownBlock(
          type: _MarkdownBlockType.footnote,
          text: entry.value,
          label: entry.key,
        ),
      );
    }
  }

  return _MarkdownDocument(
    blocks: List<_MarkdownBlock>.unmodifiable(blocks),
    references: Map<String, _MarkdownLinkTarget>.unmodifiable(references),
    footnotes: Map<String, String>.unmodifiable(footnotes),
  );
}

(int, String)? _tryParseWrappedAtxHeading(String line) {
  final tokens = <String>[];
  final source = line.trimLeft();
  var cursor = 0;
  const markers = <String>['***', '~~', '**', '__', '`', '*', '_'];
  while (cursor < source.length) {
    String? matched;
    for (final marker in markers) {
      if (source.startsWith(marker, cursor)) {
        matched = marker;
        break;
      }
    }
    if (matched == null) {
      break;
    }
    tokens.add(matched);
    cursor += matched.length;
  }
  if (tokens.isEmpty) {
    return null;
  }

  final heading = RegExp(
    r'^\s*(#{1,6})\s+(.+)$',
  ).firstMatch(source.substring(cursor));
  if (heading == null) {
    return null;
  }

  final level = heading.group(1)!.length;
  var body = heading.group(2)!.trimRight();
  for (final marker in tokens.reversed) {
    if (!body.endsWith(marker)) {
      return null;
    }
    body = body.substring(0, body.length - marker.length).trimRight();
  }
  if (body.isEmpty) {
    return null;
  }

  final prefix = tokens.join();
  final suffix = tokens.reversed.join();
  return (level, '$prefix$body$suffix');
}
