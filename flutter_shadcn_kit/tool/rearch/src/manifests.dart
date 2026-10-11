// Shared id -> file mapping loaded from the registry manifests.
//
// Two manifests describe shared modules and are merged:
//   * `shared/shared_manifest.json` - `groups[]` with `id`, `files[].source`
//     (fallback: `root` + `files[].path`).
//   * `manifests/components.json` - `shared[]` with `id`, `files[].source`.
// Sources are relative to `lib/` (`registry/shared/...`); the leading
// `registry/` prefix is stripped so keys are relative to the registry root.

import 'dart:convert';
import 'dart:io';

import 'path_utils.dart';

/// Loads the shared id -> file mapping for the registry rooted at [root].
///
/// Returns a map from registry-relative path to the set of shared ids that
/// cover it. Missing or malformed manifests yield an empty/partial map.
Map<String, Set<String>> loadSharedIdsByRelPath(String root) {
  final result = <String, Set<String>>{};
  _registerSharedManifest(root, result);
  _registerComponentsManifest(root, result);
  return result;
}

void _registerSharedManifest(String root, Map<String, Set<String>> result) {
  final manifestFile = File(joinPath(root, 'shared/shared_manifest.json'));
  if (!manifestFile.existsSync()) {
    return;
  }
  final data = jsonDecode(manifestFile.readAsStringSync());
  if (data is! Map) {
    return;
  }
  final manifestRoot = data['root'];
  final prefix = manifestRoot is String && manifestRoot.startsWith('registry/')
      ? manifestRoot.substring('registry/'.length)
      : 'shared';
  final groups = data['groups'];
  if (groups is! List) {
    return;
  }
  for (final group in groups.whereType<Map>()) {
    final id = group['id'];
    final files = group['files'];
    if (id is! String || files is! List) {
      continue;
    }
    for (final file in files.whereType<Map>()) {
      var relPath = _sourceToRel(file['source']);
      if (relPath == null) {
        final path = file['path'];
        if (path is String) {
          relPath = joinPath(prefix, path);
        }
      }
      if (relPath != null) {
        _register(result, id, relPath);
      }
    }
  }
}

void _registerComponentsManifest(String root, Map<String, Set<String>> result) {
  final manifestFile = File(joinPath(root, 'manifests/components.json'));
  if (!manifestFile.existsSync()) {
    return;
  }
  final data = jsonDecode(manifestFile.readAsStringSync());
  if (data is! Map) {
    return;
  }
  final shared = data['shared'];
  if (shared is! List) {
    return;
  }
  for (final entry in shared.whereType<Map>()) {
    final id = entry['id'];
    final files = entry['files'];
    if (id is! String || files is! List) {
      continue;
    }
    for (final file in files.whereType<Map>()) {
      final relPath = _sourceToRel(file['source']);
      if (relPath != null) {
        _register(result, id, relPath);
      }
    }
  }
}

void _register(Map<String, Set<String>> result, String id, String relPath) {
  final normalized = normalizePath(relPath);
  (result[normalized] ??= <String>{}).add(id);
}

String? _sourceToRel(Object? source) {
  if (source is! String || source.isEmpty) {
    return null;
  }
  const prefix = 'registry/';
  return source.startsWith(prefix) ? source.substring(prefix.length) : source;
}
