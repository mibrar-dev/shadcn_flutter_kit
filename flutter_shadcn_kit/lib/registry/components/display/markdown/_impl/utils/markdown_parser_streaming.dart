// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../markdown.dart';

int _computeStableMarkdownPrefixLength(String data) {
  if (data.isEmpty) {
    return 0;
  }

  final source = data.replaceAll('\r\n', '\n');
  final lines = source.split('\n');
  var offset = 0;
  var lastStable = 0;
  var inFence = false;
  String? openFence;
  var inMath = false;
  var inDetails = false;
  var inTable = false;
  var inHtmlTable = false;
  String? inHtmlContainerTag;

  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    final trimmed = line.trimRight();
    final hasTrailingNewline = i < lines.length - 1;
    final lineEnd = offset + line.length + (hasTrailingNewline ? 1 : 0);

    if (inFence) {
      if (openFence != null && _isClosingFenceLine(trimmed, openFence)) {
        inFence = false;
        openFence = null;
        lastStable = lineEnd;
      }
      offset = lineEnd;
      continue;
    }

    if (inMath) {
      if (trimmed == r'$$') {
        inMath = false;
        lastStable = lineEnd;
      }
      offset = lineEnd;
      continue;
    }

    if (inDetails) {
      if (trimmed.toLowerCase().startsWith('</details')) {
        inDetails = false;
        lastStable = lineEnd;
      }
      offset = lineEnd;
      continue;
    }

    if (inTable) {
      if (trimmed.isEmpty) {
        inTable = false;
        lastStable = lineEnd;
        offset = lineEnd;
        continue;
      }
      if (trimmed.contains('|')) {
        if (hasTrailingNewline) {
          lastStable = lineEnd;
        }
        offset = lineEnd;
        continue;
      }
      inTable = false;
    }

    if (inHtmlTable) {
      final lower = trimmed.toLowerCase();
      if (lower.contains('</table>')) {
        inHtmlTable = false;
        lastStable = lineEnd;
      }
      offset = lineEnd;
      continue;
    }

    if (inHtmlContainerTag != null) {
      final lower = trimmed.toLowerCase();
      if (lower.contains('</$inHtmlContainerTag>')) {
        inHtmlContainerTag = null;
        lastStable = lineEnd;
      }
      offset = lineEnd;
      continue;
    }

    if (trimmed.isEmpty) {
      lastStable = lineEnd;
      offset = lineEnd;
      continue;
    }

    final fenceInfo = _parseFenceMarker(trimmed);
    if (fenceInfo != null) {
      inFence = true;
      openFence = fenceInfo.$1;
      offset = lineEnd;
      continue;
    }

    if (trimmed == r'$$') {
      inMath = true;
      offset = lineEnd;
      continue;
    }

    if (trimmed.toLowerCase().startsWith('<details')) {
      inDetails = true;
      offset = lineEnd;
      continue;
    }

    final lower = trimmed.toLowerCase();
    if (lower.startsWith('<table')) {
      if (lower.contains('</table>')) {
        if (hasTrailingNewline) {
          lastStable = lineEnd;
        }
      } else {
        inHtmlTable = true;
      }
      offset = lineEnd;
      continue;
    }

    final htmlContainer = _openingHtmlContainerTag(trimmed);
    if (htmlContainer != null) {
      if (trimmed.toLowerCase().contains('</$htmlContainer>')) {
        if (hasTrailingNewline) {
          lastStable = lineEnd;
        }
      } else {
        inHtmlContainerTag = htmlContainer;
      }
      offset = lineEnd;
      continue;
    }

    if (_isTableSeparatorLine(trimmed) && i > 0 && lines[i - 1].contains('|')) {
      inTable = true;
      if (hasTrailingNewline) {
        lastStable = lineEnd;
      }
      offset = lineEnd;
      continue;
    }

    if (trimmed.contains('|')) {
      final nextLine = i + 1 < lines.length ? lines[i + 1].trimRight() : null;
      final canBecomeTable =
          nextLine != null && _isTableSeparatorLine(nextLine);
      if (canBecomeTable) {
        offset = lineEnd;
        continue;
      }
    }

    if (hasTrailingNewline && _isStandaloneStableLine(trimmed)) {
      lastStable = lineEnd;
    }

    offset = lineEnd;
  }

  return lastStable.clamp(0, source.length);
}

String _normalizeMarkdownWithHtmlBridges(String source) {
  return _convertMarkdownTablesToHtml(source);
}

String _convertMarkdownTablesToHtml(String source) {
  final lines = source.split('\n');
  final output = <String>[];
  String? openFence;
  var inMath = false;
  var i = 0;

  while (i < lines.length) {
    final line = lines[i];
    final trimmed = line.trimRight();

    final fenceInfo = _parseFenceMarker(trimmed);
    if (openFence == null && fenceInfo != null) {
      openFence = fenceInfo.$1;
      output.add(line);
      i += 1;
      continue;
    }
    if (openFence != null && _isClosingFenceLine(trimmed, openFence)) {
      openFence = null;
      output.add(line);
      i += 1;
      continue;
    }

    if (openFence == null && trimmed == r'$$') {
      inMath = !inMath;
      output.add(line);
      i += 1;
      continue;
    }

    if (openFence != null || inMath) {
      output.add(line);
      i += 1;
      continue;
    }

    if (_looksLikeTableHeader(lines, i)) {
      final header = _parseTableRow(lines[i]);
      final alignments = _tableAlignments(lines[i + 1]);
      final bodyResult = _consumeMarkdownTableRows(
        lines,
        i + 2,
        expectedColumns: header.length,
      );
      final bodyRows = bodyResult.$1;
      i = bodyResult.$2;
      output.addAll(_buildHtmlTableLines(header, bodyRows, alignments));
      continue;
    }

    output.add(line);
    i += 1;
  }

  return output.join('\n');
}

List<String> _buildHtmlTableLines(
  List<String> header,
  List<List<String>> bodyRows,
  List<TextAlign> alignments,
) {
  final rows = <List<String>>[header, ...bodyRows];
  final maxColumns = rows.fold<int>(
    0,
    (max, row) => row.length > max ? row.length : max,
  );
  final normalizedHeader = [
    for (var col = 0; col < maxColumns; col++)
      col < header.length ? header[col] : '',
  ];

  final lines = <String>['<table>', '  <thead>', '    <tr>'];
  for (var col = 0; col < normalizedHeader.length; col++) {
    final align = col < alignments.length ? alignments[col] : TextAlign.left;
    lines.add(
      '      <th style="text-align: ${_alignmentToCss(align)}">${_escapeHtmlText(normalizedHeader[col])}</th>',
    );
  }
  lines.addAll(<String>['    </tr>', '  </thead>']);

  if (bodyRows.isNotEmpty) {
    lines.add('  <tbody>');
    for (final row in bodyRows) {
      lines.add('    <tr>');
      for (var col = 0; col < maxColumns; col++) {
        final value = col < row.length ? row[col] : '';
        final align = col < alignments.length
            ? alignments[col]
            : TextAlign.left;
        lines.add(
          '      <td style="text-align: ${_alignmentToCss(align)}">${_escapeHtmlText(value)}</td>',
        );
      }
      lines.add('    </tr>');
    }
    lines.add('  </tbody>');
  }

  lines.add('</table>');
  return lines;
}

String _alignmentToCss(TextAlign align) {
  return switch (align) {
    TextAlign.center => 'center',
    TextAlign.right => 'right',
    _ => 'left',
  };
}

String _escapeHtmlText(String value) {
  return value
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;');
}

String? _openingHtmlContainerTag(String line) {
  final trimmed = line.trimLeft();
  final lower = trimmed.toLowerCase();
  for (final tag in const <String>[
    'ul',
    'ol',
    'dl',
    'blockquote',
    'pre',
    'p',
    'div',
    'section',
    'article',
  ]) {
    if (lower.startsWith('<$tag')) {
      return tag;
    }
  }
  final heading = RegExp(
    r'^<h([1-6])\b',
    caseSensitive: false,
  ).firstMatch(trimmed);
  if (heading != null) {
    return 'h${heading.group(1)}';
  }
  return null;
}

(String, String?)? _parseFenceMarker(String line) {
  final match = RegExp(
    r'^\s*(`{3,}|~{3,})(?:\s*([\w-]+))?\s*$',
  ).firstMatch(line.trimRight());
  if (match == null) {
    return null;
  }
  return (match.group(1)!, match.group(2)?.trim());
}

bool _isClosingFenceLine(String line, String marker) {
  final char = marker[0];
  final length = marker.length;
  return RegExp(
    '^\\s*${RegExp.escape(char)}{$length,}\\s*\$',
  ).hasMatch(line.trimRight());
}

bool _isStandaloneStableLine(String line) {
  return RegExp(r'^(#{1,6})\s+').hasMatch(line) ||
      _looksLikeWrappedHeadingLine(line) ||
      RegExp(r'^\s*(=+|-+)\s*$').hasMatch(line) ||
      RegExp(r'^\s*([-_*])\s*\1\s*\1').hasMatch(line) ||
      RegExp(r'^\s*[-*+]\s+').hasMatch(line) ||
      RegExp(r'^\s*\d+\.\s+').hasMatch(line) ||
      RegExp(r'^\s*>\s?').hasMatch(line) ||
      RegExp(r'^\s*!\[').hasMatch(line) ||
      RegExp(r'^\s*\[[^\]]+\]:').hasMatch(line) ||
      RegExp(r'^\s*\[\^[^\]]+\]:').hasMatch(line) ||
      _openingHtmlContainerTag(line) != null;
}

bool _looksLikeWrappedHeadingLine(String line) {
  const markers = <String>['***', '~~', '**', '__', '`', '*', '_'];
  final source = line.trimLeft();
  var cursor = 0;
  var sawWrapper = false;
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
    sawWrapper = true;
    cursor += matched.length;
  }
  if (!sawWrapper || cursor >= source.length) {
    return false;
  }
  return RegExp(r'^\s*#{1,6}\s+.+$').hasMatch(source.substring(cursor));
}
