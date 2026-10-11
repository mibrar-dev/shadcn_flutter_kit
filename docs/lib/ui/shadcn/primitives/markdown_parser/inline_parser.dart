// Inline markdown parsing: [parseMarkdownInline] turning a block's text
// into [MarkdownInlineRun]s, plus entity decoding.

import 'document.dart';

List<MarkdownInlineRun> parseMarkdownInline(
  String input, [
  Map<String, MarkdownLinkTarget>? references,
  List<String>? footnoteOrder,
]) {
  final runs = <MarkdownInlineRun>[];
  final buffer = StringBuffer();
  var bold = false;
  var italic = false;
  var strikethrough = false;
  var index = 0;

  void flush() {
    if (buffer.isEmpty) return;
    runs.add(
      MarkdownInlineRun(
        text: decodeMarkdownEntities(buffer.toString()),
        bold: bold,
        italic: italic,
        strikethrough: strikethrough,
      ),
    );
    buffer.clear();
  }

  /// Emits [label] as link runs to [target], recursing for emphasis.
  void linkRuns(String label, MarkdownLinkTarget target) {
    for (final inner in parseMarkdownInline(label)) {
      runs.add(
        MarkdownInlineRun(
          text: inner.text,
          bold: inner.bold || bold,
          italic: inner.italic || italic,
          code: inner.code,
          strikethrough: inner.strikethrough || strikethrough,
          linkUrl: inner.linkUrl ?? target.url,
          linkTitle: inner.linkTitle ?? target.title,
        ),
      );
    }
  }

  while (index < input.length) {
    final rest = input.substring(index);
    if (rest.startsWith(r'\') && index + 1 < input.length) {
      buffer.write(input[index + 1]);
      index += 2;
      continue;
    }
    if (rest.startsWith('<br>') ||
        rest.startsWith('<br/>') ||
        rest.startsWith('<br />')) {
      flush();
      runs.add(const MarkdownInlineRun(text: '\n'));
      index += rest.startsWith('<br />')
          ? 6
          : rest.startsWith('<br/>')
          ? 5
          : 4;
      continue;
    }
    if (rest.startsWith('<') && RegExp(r'^<[^<>\s]+>').hasMatch(rest)) {
      final tag = RegExp(r'^<[^<>\s]+>').firstMatch(rest)!.group(0)!;
      final inner = tag.substring(1, tag.length - 1);
      if (!inner.startsWith('/') && _looksLikeUrl(inner)) {
        flush();
        runs.add(MarkdownInlineRun(text: inner, linkUrl: inner));
        index += tag.length;
        continue;
      }
    }
    if (rest.startsWith('<')) {
      final tagEnd = rest.indexOf('>');
      if (tagEnd >= 0) {
        index += tagEnd + 1; // Benign tags are stripped, not rendered.
        continue;
      }
    }
    if (rest.startsWith('`')) {
      final end = input.indexOf('`', index + 1);
      flush();
      if (end < 0) {
        buffer.write(rest.substring(1));
        break;
      }
      runs.add(
        MarkdownInlineRun(
          text: decodeMarkdownEntities(input.substring(index + 1, end)),
          code: true,
        ),
      );
      index = end + 1;
      continue;
    }
    if (rest.startsWith('**')) {
      flush();
      bold = !bold;
      index += 2;
      continue;
    }
    if (rest.startsWith('~~')) {
      flush();
      strikethrough = !strikethrough;
      index += 2;
      continue;
    }
    if (rest.startsWith('*') || rest.startsWith('_')) {
      flush();
      italic = !italic;
      index += 1;
      continue;
    }
    if (rest.startsWith('![')) {
      final parsed = _parseInlineLink(input, index + 1);
      if (parsed != null) {
        flush();
        final alt = parsed.$1;
        runs.add(MarkdownInlineRun(text: alt.isEmpty ? parsed.$2 : alt));
        index = parsed.$4;
        continue;
      }
      final ref = _parseReferenceLink(input, index + 1, references);
      if (ref != null) {
        flush();
        runs.add(MarkdownInlineRun(text: ref.$1.isEmpty ? ref.$2 : ref.$1));
        index = ref.$4;
        continue;
      }
    }
    if (rest.startsWith('[')) {
      final parsed = _parseInlineLink(input, index);
      if (parsed != null) {
        flush();
        for (final inner in parseMarkdownInline(parsed.$1)) {
          runs.add(
            MarkdownInlineRun(
              text: inner.text,
              bold: inner.bold || bold,
              italic: inner.italic || italic,
              code: inner.code,
              strikethrough: inner.strikethrough || strikethrough,
              linkUrl: inner.linkUrl ?? parsed.$2,
              linkTitle: inner.linkTitle ?? parsed.$3,
            ),
          );
        }
        index = parsed.$4;
        continue;
      }
      final reference = _parseReferenceLink(input, index, references);
      if (reference != null) {
        flush();
        linkRuns(
          reference.$1,
          MarkdownLinkTarget(url: reference.$2, title: reference.$3),
        );
        index = reference.$4;
        continue;
      }
      final footnote = _parseFootnoteRef(input, index, footnoteOrder);
      if (footnote != null) {
        flush();
        runs.add(
          MarkdownInlineRun(
            text: footnote.$1,
            linkUrl: '#fn-${footnote.$2}',
            superscript: true,
          ),
        );
        index = footnote.$3;
        continue;
      }
    }
    buffer.write(input[index]);
    index++;
  }
  flush();
  return runs;
}

/// Parses `[label](url "title")` at [start]; returns label, url, title and
/// the index past the closing paren, or null when malformed.
(String, String, String?, int)? _parseInlineLink(String input, int start) {
  if (input[start] != '[') return null;
  var depth = 0;
  var labelEnd = -1;
  for (var i = start; i < input.length; i++) {
    if (input[i] == '[') depth++;
    if (input[i] == ']') {
      depth--;
      if (depth == 0) {
        labelEnd = i;
        break;
      }
    }
  }
  if (labelEnd < 0 ||
      labelEnd + 1 >= input.length ||
      input[labelEnd + 1] != '(') {
    return null;
  }
  final close = input.indexOf(')', labelEnd + 2);
  if (close < 0) return null;
  final target = input.substring(labelEnd + 2, close).trim();
  final match = RegExp(r'^(\S+)(?:\s+"([^"]*)")?$').firstMatch(target);
  if (match == null) return null;
  return (
    decodeMarkdownEntities(input.substring(start + 1, labelEnd)),
    decodeMarkdownEntities(match.group(1)!),
    match.group(2) == null ? null : decodeMarkdownEntities(match.group(2)!),
    close + 1,
  );
}

/// Parses `[text][ref]`, `[text][]` (collapsed) and `[ref]` (shortcut) at
/// [start] using [references]; returns label, url, title and the index past
/// the match, or null when undefined. `[^…]` labels belong to footnotes.
(String, String, String?, int)? _parseReferenceLink(
  String input,
  int start,
  Map<String, MarkdownLinkTarget>? references,
) {
  if (references == null || input[start] != '[') return null;
  var depth = 0;
  var labelEnd = -1;
  for (var i = start; i < input.length; i++) {
    if (input[i] == '[') depth++;
    if (input[i] == ']') {
      depth--;
      if (depth == 0) {
        labelEnd = i;
        break;
      }
    }
  }
  if (labelEnd < 0) return null;
  final rawLabel = input.substring(start + 1, labelEnd);
  if (rawLabel.startsWith('^')) return null;
  String key;
  var end = labelEnd + 1;
  if (end < input.length && input[end] == '[') {
    final close = input.indexOf(']', end + 1);
    if (close < 0) return null;
    final ref = input.substring(end + 1, close);
    key = ref.isEmpty ? rawLabel : ref;
    end = close + 1;
  } else {
    key = rawLabel;
  }
  final target = references[normalizeMarkdownReferenceKey(key)];
  if (target == null) return null;
  return (decodeMarkdownEntities(rawLabel), target.url, target.title, end);
}

/// Parses a `[^id]` footnote marker at [start]; returns the 1-based ordinal,
/// the id and the index past the match, or null when unreferenced.
(String, String, int)? _parseFootnoteRef(
  String input,
  int start,
  List<String>? footnoteOrder,
) {
  if (footnoteOrder == null) return null;
  final match = RegExp(r'^\[\^([^\]]+)\]').firstMatch(input.substring(start));
  if (match == null) return null;
  final id = match.group(1)!;
  final ordinal = footnoteOrder.indexOf(id);
  if (ordinal < 0) return null;
  return ('${ordinal + 1}', id, start + match.group(0)!.length);
}

/// Whether [value] reads as a linkable URL or email for autolinks.
bool _looksLikeUrl(String value) {
  final trimmed = value.trim();
  if (trimmed.startsWith('mailto:')) return true;
  final uri = Uri.tryParse(trimmed);
  if (uri == null || !uri.hasScheme) return false;
  if (trimmed.contains(' ')) return false;
  return uri.scheme == 'http' || uri.scheme == 'https' || trimmed.contains('@');
}

/// Decodes common named entities plus decimal/hex numeric references.
String decodeMarkdownEntities(String value) {
  var out = value
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll('&nbsp;', ' ');
  out = out.replaceAllMapped(RegExp(r'&#(\d+);'), (match) {
    final code = int.tryParse(match.group(1)!);
    return code == null ? match.group(0)! : String.fromCharCode(code);
  });
  return out.replaceAllMapped(RegExp(r'&#x([0-9a-fA-F]+);'), (match) {
    final code = int.tryParse(match.group(1)!, radix: 16);
    return code == null ? match.group(0)! : String.fromCharCode(code);
  });
}
