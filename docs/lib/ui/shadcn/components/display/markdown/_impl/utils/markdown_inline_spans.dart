// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../markdown.dart';

List<InlineSpan> _buildInlineSpans(
  BuildContext context,
  String text,
  TextStyle baseStyle,
  _MarkdownDocument document, {
  MarkdownTapLinkCallback? onTapLink,
  required bool followLinks,
  TextStyle? linkStyle,
}) {
  return _MarkdownInlineParser(
    baseStyle: baseStyle,
    document: document,
    onTapLink: onTapLink,
    followLinks: followLinks,
    linkStyle: linkStyle,
  ).parse(text);
}

class _MarkdownInlineParser {
  const _MarkdownInlineParser({
    required this.baseStyle,
    required this.document,
    required this.onTapLink,
    required this.followLinks,
    required this.linkStyle,
  });

  final TextStyle baseStyle;
  final _MarkdownDocument document;
  final MarkdownTapLinkCallback? onTapLink;
  final bool followLinks;
  final TextStyle? linkStyle;

  List<InlineSpan> parse(String input) {
    final spans = <InlineSpan>[];
    final buffer = StringBuffer();
    var index = 0;

    void flushBuffer() {
      if (buffer.isEmpty) {
        return;
      }
      spans.add(TextSpan(text: _decodeHtmlEntities(buffer.toString())));
      buffer.clear();
    }

    while (index < input.length) {
      final remaining = input.substring(index);

      if (remaining.startsWith(r'\') && index + 1 < input.length) {
        buffer.write(input[index + 1]);
        index += 2;
        continue;
      }

      if (remaining.startsWith('<br>') ||
          remaining.startsWith('<br/>') ||
          remaining.startsWith('<br />')) {
        flushBuffer();
        spans.add(const TextSpan(text: '\n'));
        index += remaining.startsWith('<br />')
            ? 6
            : remaining.startsWith('<br/>')
            ? 5
            : 4;
        continue;
      }

      final htmlInline = _tryParseHtmlInline(input, index);
      if (htmlInline != null) {
        flushBuffer();
        spans.add(htmlInline.$1);
        index = htmlInline.$2;
        continue;
      }

      final autolink = _tryParseAngleAutolink(input, index);
      if (autolink != null) {
        flushBuffer();
        spans.add(_buildLinkSpan(autolink.$1, autolink.$2));
        index = autolink.$3;
        continue;
      }

      final inlineCode = _tryParseDelimited(input, index, '`');
      if (inlineCode != null) {
        flushBuffer();
        spans.add(
          TextSpan(
            style: const TextStyle(fontFamily: 'GeistMono'),
            children: parse(inlineCode.$1),
          ),
        );
        index = inlineCode.$2;
        continue;
      }

      final footnote = _tryParseFootnoteReference(input, index);
      if (footnote != null) {
        flushBuffer();
        spans.add(
          TextSpan(
            text: '[${footnote.$1}]',
            style: baseStyle.copyWith(
              fontSize: (baseStyle.fontSize ?? 14) * 0.8,
              color: const Color(0xFF2F6FEB),
            ),
          ),
        );
        index = footnote.$2;
        continue;
      }

      final link = _tryParseLinkLike(input, index);
      if (link != null) {
        flushBuffer();
        spans.add(_buildLinkSpan(link.$1, link.$2));
        index = link.$3;
        continue;
      }

      final math = _tryParseDelimited(input, index, r'$');
      if (math != null && math.$1.trim().isNotEmpty) {
        flushBuffer();
        spans.add(
          TextSpan(
            text: math.$1,
            style: const TextStyle(
              fontFamily: 'GeistMono',
              fontStyle: FontStyle.italic,
            ),
          ),
        );
        index = math.$2;
        continue;
      }

      final emphasis = _tryParseStyled(input, index, '***');
      if (emphasis != null) {
        flushBuffer();
        spans.add(
          TextSpan(
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
            ),
            children: parse(emphasis.$1),
          ),
        );
        index = emphasis.$2;
        continue;
      }

      final bold =
          _tryParseStyled(input, index, '**') ??
          _tryParseStyled(input, index, '__');
      if (bold != null) {
        flushBuffer();
        spans.add(
          TextSpan(
            style: const TextStyle(fontWeight: FontWeight.w700),
            children: parse(bold.$1),
          ),
        );
        index = bold.$2;
        continue;
      }

      final italic =
          _tryParseStyled(input, index, '*') ??
          _tryParseStyled(input, index, '_');
      if (italic != null) {
        flushBuffer();
        spans.add(
          TextSpan(
            style: const TextStyle(fontStyle: FontStyle.italic),
            children: parse(italic.$1),
          ),
        );
        index = italic.$2;
        continue;
      }

      final strike = _tryParseStyled(input, index, '~~');
      if (strike != null) {
        flushBuffer();
        spans.add(
          TextSpan(
            style: const TextStyle(decoration: TextDecoration.lineThrough),
            children: parse(strike.$1),
          ),
        );
        index = strike.$2;
        continue;
      }

      final plainUrl = _tryParsePlainUrl(input, index);
      if (plainUrl != null) {
        flushBuffer();
        spans.add(_buildLinkSpan(plainUrl.$1, plainUrl.$2));
        index = plainUrl.$3;
        continue;
      }

      final email = _tryParseEmail(input, index);
      if (email != null) {
        flushBuffer();
        spans.add(_buildLinkSpan(email.$1, 'mailto:${email.$1}'));
        index = email.$2;
        continue;
      }

      buffer.write(input[index]);
      index += 1;
    }

    flushBuffer();
    return spans;
  }

  InlineSpan _buildLinkSpan(String label, String url) {
    final resolvedLinkStyle =
        linkStyle ??
        baseStyle.copyWith(
          color: const Color(0xFF2F6FEB),
          decoration: TextDecoration.underline,
        );

    final callback = onTapLink;
    if (callback == null && !followLinks) {
      return TextSpan(text: label, style: resolvedLinkStyle);
    }

    return TextSpan(
      text: label,
      style: resolvedLinkStyle,
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          if (callback != null) {
            callback(label, url);
            return;
          }
          unawaited(openMarkdownLink(url));
        },
    );
  }

  (String, int)? _tryParseDelimited(String input, int start, String delimiter) {
    if (!input.startsWith(delimiter, start)) {
      return null;
    }
    final end = _findClosingDelimiter(
      input,
      start + delimiter.length,
      delimiter,
    );
    if (end == -1) {
      return null;
    }
    return (
      input.substring(start + delimiter.length, end),
      end + delimiter.length,
    );
  }

  (String, int)? _tryParseStyled(String input, int start, String delimiter) {
    final result = _tryParseDelimited(input, start, delimiter);
    if (result == null || result.$1.isEmpty) {
      return null;
    }
    return result;
  }

  (String, String, int)? _tryParseAngleAutolink(String input, int start) {
    if (input[start] != '<') {
      return null;
    }
    final close = input.indexOf('>', start + 1);
    if (close == -1) {
      return null;
    }
    final content = input.substring(start + 1, close);
    if (_looksLikeUrl(content)) {
      return (content, content, close + 1);
    }
    if (_looksLikeEmail(content)) {
      return (content, 'mailto:$content', close + 1);
    }
    return null;
  }

  (String, String, int)? _tryParseLinkLike(String input, int start) {
    if (input[start] != '[') {
      return null;
    }
    final close = _findMatchingBracket(input, start);
    if (close == -1) {
      return null;
    }

    final label = input.substring(start + 1, close);
    if (label.startsWith('^')) {
      return null;
    }

    if (close + 1 < input.length && input[close + 1] == '(') {
      final destination = _findClosingParen(input, close + 1);
      if (destination != -1) {
        final target = input.substring(close + 2, destination).trim();
        final parsed = _parseLinkTarget(target);
        return (label, parsed.$1, destination + 1);
      }
    }

    if (close + 1 < input.length && input[close + 1] == '[') {
      final refClose = input.indexOf(']', close + 2);
      if (refClose != -1) {
        final refLabel = input.substring(close + 2, refClose);
        final target =
            document.references[_normalizeReferenceKey(
              refLabel.isEmpty ? label : refLabel,
            )];
        if (target != null) {
          return (label, target.url, refClose + 1);
        }
      }
    }

    final shortcut = document.references[_normalizeReferenceKey(label)];
    if (shortcut != null) {
      return (label, shortcut.url, close + 1);
    }

    return null;
  }

  (String, int)? _tryParseFootnoteReference(String input, int start) {
    final match = RegExp(
      r'^\[\^([^\]]+)\]',
    ).matchAsPrefix(input.substring(start));
    if (match == null) {
      return null;
    }
    return (match.group(1)!, start + match.group(0)!.length);
  }

  (String, String, int)? _tryParsePlainUrl(String input, int start) {
    final match = RegExp(
      r'^(https?:\/\/[^\s<]+)',
    ).matchAsPrefix(input.substring(start));
    if (match == null) {
      return null;
    }
    final url = match.group(1)!;
    return (url, url, start + url.length);
  }

  (String, int)? _tryParseEmail(String input, int start) {
    final match = RegExp(
      r'^([A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,})',
    ).matchAsPrefix(input.substring(start));
    if (match == null) {
      return null;
    }
    final email = match.group(1)!;
    return (email, start + email.length);
  }

  (InlineSpan, int)? _tryParseHtmlInline(String input, int start) {
    final anchor = RegExp(
      r'''^<a\b[^>]*href\s*=\s*["']([^"']+)["'][^>]*>([\s\S]*?)</a>''',
      caseSensitive: false,
    ).matchAsPrefix(input.substring(start));
    if (anchor != null) {
      final href = _decodeHtmlEntities(anchor.group(1) ?? '');
      final rawLabel = anchor.group(2) ?? '';
      final label = _decodeHtmlEntities(_stripInlineHtmlTags(rawLabel));
      final length = anchor.group(0)!.length;
      return (
        _buildLinkSpan(label.isEmpty ? href : label, href),
        start + length,
      );
    }

    for (final tag in <String>['strong', 'em', 'code', 'kbd']) {
      final open = '<$tag>';
      final close = '</$tag>';
      if (!input.startsWith(open, start)) {
        continue;
      }
      final end = input.indexOf(close, start + open.length);
      if (end == -1) {
        return null;
      }
      final content = input.substring(start + open.length, end);
      final span = switch (tag) {
        'strong' => TextSpan(
          style: baseStyle.copyWith(fontWeight: FontWeight.w700),
          children: parse(content),
        ),
        'em' => TextSpan(
          style: baseStyle.copyWith(fontStyle: FontStyle.italic),
          children: parse(content),
        ),
        'code' => TextSpan(
          text: _decodeHtmlEntities(content),
          style: baseStyle.copyWith(fontFamily: 'GeistMono'),
        ),
        'kbd' => WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 1),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0x22000000)),
              color: const Color(0x11000000),
            ),
            child: Text(
              _decodeHtmlEntities(content),
              style: baseStyle.copyWith(
                fontFamily: 'GeistMono',
                fontSize: (baseStyle.fontSize ?? 14) * 0.9,
              ),
            ),
          ),
        ),
        _ => TextSpan(text: _decodeHtmlEntities(content)),
      };
      return (span, end + close.length);
    }
    return null;
  }
}

String _stripInlineHtmlTags(String value) {
  return value.replaceAll(RegExp(r'<[^>]+>'), '');
}

int _findClosingDelimiter(String input, int start, String delimiter) {
  var index = start;
  while (index <= input.length - delimiter.length) {
    if (input.startsWith(r'\', index)) {
      index += 2;
      continue;
    }
    if (input.startsWith(delimiter, index)) {
      return index;
    }
    index += 1;
  }
  return -1;
}

int _findMatchingBracket(String input, int start) {
  var depth = 0;
  for (var i = start; i < input.length; i++) {
    if (input[i] == '[') {
      depth += 1;
    } else if (input[i] == ']') {
      depth -= 1;
      if (depth == 0) {
        return i;
      }
    }
  }
  return -1;
}

int _findClosingParen(String input, int start) {
  var depth = 0;
  for (var i = start; i < input.length; i++) {
    if (input[i] == '(') {
      depth += 1;
    } else if (input[i] == ')') {
      depth -= 1;
      if (depth == 0) {
        return i;
      }
    }
  }
  return -1;
}

(String, String?) _parseLinkTarget(String input) {
  final match = RegExp(
    r'''^(\S+?)(?:\s+(?:"([^"]+)"|'([^']+)'))?$''',
  ).firstMatch(input);
  if (match == null) {
    return (input, null);
  }
  return (match.group(1)!, match.group(2) ?? match.group(3));
}

bool _looksLikeUrl(String value) {
  return value.startsWith('http://') || value.startsWith('https://');
}

bool _looksLikeEmail(String value) {
  return RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  ).hasMatch(value);
}

String _decodeHtmlEntities(String value) {
  return value
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll('&copy;', '©')
      .replaceAll('&mdash;', '—')
      .replaceAll('&nbsp;', ' ');
}
