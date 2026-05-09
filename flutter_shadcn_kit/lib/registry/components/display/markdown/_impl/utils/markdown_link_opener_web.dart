// ignore_for_file: avoid_web_libraries_in_flutter,dead_code,deprecated_member_use,duplicate_import,sort_child_properties_last,unnecessary_import,unnecessary_null_comparison,unused_import,use_null_aware_elements

import 'dart:html' as html;

Future<bool> openMarkdownLink(String url) async {
  final normalized = _normalizeOpenableUrl(url);
  if (normalized == null) {
    return false;
  }
  if (normalized.startsWith('#')) {
    html.window.location.hash = normalized.substring(1);
    return true;
  }
  html.window.open(normalized, '_blank');
  return true;
}

String? _normalizeOpenableUrl(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    return null;
  }
  if (trimmed.startsWith('#')) {
    return trimmed;
  }

  final uri = Uri.tryParse(trimmed);
  if (uri == null) {
    return null;
  }
  if (!uri.hasScheme) {
    return trimmed;
  }

  final scheme = uri.scheme.toLowerCase();
  if ((scheme == 'http' || scheme == 'https') && uri.host.isEmpty) {
    return null;
  }
  if (scheme == 'mailto' && uri.path.isEmpty) {
    return null;
  }
  return trimmed;
}
