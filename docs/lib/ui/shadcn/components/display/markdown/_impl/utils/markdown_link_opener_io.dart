// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:io';

import 'package:flutter/services.dart';

const MethodChannel _markdownLinkChannel = MethodChannel(
  'shadcn_flutter_kit/markdown_link_opener',
);

Future<bool> openMarkdownLink(String url) async {
  final normalized = _normalizeOpenableUrl(url);
  if (normalized == null) {
    return false;
  }
  if (normalized.startsWith('#')) {
    return false;
  }

  if (Platform.isAndroid || Platform.isIOS) {
    try {
      final result = await _markdownLinkChannel.invokeMethod<bool>('openLink', {
        'url': normalized,
      });
      return result ?? false;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }

  ProcessResult result;
  if (Platform.isMacOS) {
    result = await Process.run('open', <String>[normalized]);
  } else if (Platform.isWindows) {
    result = await Process.run('cmd', <String>['/c', 'start', '', normalized]);
  } else if (Platform.isLinux) {
    result = await Process.run('xdg-open', <String>[normalized]);
  } else {
    return false;
  }
  return result.exitCode == 0;
}

String? _normalizeOpenableUrl(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    return null;
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
