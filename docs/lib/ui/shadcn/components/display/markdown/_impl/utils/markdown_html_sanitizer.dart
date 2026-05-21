// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../markdown.dart';

String _sanitizeMarkdownHtml(
  String source,
  MarkdownHtmlSanitizationStrategy strategy,
) {
  return switch (strategy) {
    MarkdownHtmlSanitizationStrategy.permissive => source,
    MarkdownHtmlSanitizationStrategy.stripDangerousHtml => _stripDangerousHtml(
      source,
    ),
    MarkdownHtmlSanitizationStrategy.stripAllHtml => _stripAllHtml(source),
  };
}

String _stripDangerousHtml(String value) {
  var sanitized = value;
  for (final tag in const <String>[
    'script',
    'style',
    'iframe',
    'object',
    'embed',
    'meta',
    'link',
    'base',
  ]) {
    sanitized = sanitized.replaceAll(
      RegExp('<$tag\\b[^>]*>[\\s\\S]*?</$tag>', caseSensitive: false),
      '',
    );
    sanitized = sanitized.replaceAll(
      RegExp('<$tag\\b[^>]*/?>', caseSensitive: false),
      '',
    );
  }

  sanitized = sanitized.replaceAll(RegExp(r'<!--([\s\S]*?)-->'), '');
  sanitized = sanitized.replaceAll(
    RegExp(r'<!DOCTYPE[^>]*>', caseSensitive: false),
    '',
  );
  sanitized = sanitized.replaceAll(
    RegExp(
      r'''\s+on[a-z0-9_-]+\s*=\s*("[^"]*"|'[^']*'|[^\s>]+)''',
      caseSensitive: false,
    ),
    '',
  );
  sanitized = sanitized.replaceAll(
    RegExp(
      r'''\s+srcdoc\s*=\s*("[^"]*"|'[^']*'|[^\s>]+)''',
      caseSensitive: false,
    ),
    '',
  );
  sanitized = sanitized.replaceAllMapped(
    RegExp(
      r'''\b(href|src)\s*=\s*("([^"]*)"|'([^']*)'|([^\s>]+))''',
      caseSensitive: false,
    ),
    (match) {
      final attribute = match.group(1) ?? 'href';
      final value = match.group(3) ?? match.group(4) ?? match.group(5) ?? '';
      if (_isUnsafeHtmlUrl(value)) {
        return '$attribute="#"';
      }
      return match.group(0) ?? '';
    },
  );
  return sanitized;
}

String _stripAllHtml(String value) {
  var sanitized = value;
  sanitized = sanitized.replaceAll(
    RegExp(r'<br\s*/?>', caseSensitive: false),
    '\n',
  );
  sanitized = sanitized.replaceAll(
    RegExp(
      r'</?(p|div|section|article|blockquote|details|summary|li|ul|ol|table|thead|tbody|tr|td|th|h[1-6])\b[^>]*>',
      caseSensitive: false,
    ),
    '\n',
  );
  sanitized = _stripHtmlTags(sanitized);
  sanitized = _decodeHtmlEntities(sanitized);
  sanitized = sanitized.replaceAll(RegExp(r'\n{3,}'), '\n\n');
  return sanitized;
}

bool _isUnsafeHtmlUrl(String value) {
  final normalized = value.trim().toLowerCase();
  if (normalized.isEmpty) {
    return false;
  }
  return normalized.startsWith('javascript:') ||
      normalized.startsWith('vbscript:') ||
      normalized.startsWith('file:') ||
      normalized.startsWith('data:text/html');
}
