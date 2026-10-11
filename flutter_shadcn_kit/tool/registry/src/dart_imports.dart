// Import/export URI extraction and relative-path normalisation for the
// manifest generator. The layer trees have no meta.json, so their
// dependencies are derived from real Dart directives.

import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

/// Every import/export URI in [absPath], including conditional-import
/// configuration branches.
List<String> directiveUris(String absPath) {
  final result = parseString(
    content: File(absPath).readAsStringSync(),
    path: absPath,
    throwIfDiagnostics: false,
  );
  final uris = <String>[];
  for (final directive in result.unit.directives) {
    if (directive is ImportDirective) {
      final uri = directive.uri.stringValue;
      if (uri != null) {
        uris.add(uri);
      }
      for (final configuration in directive.configurations) {
        final configured = configuration.uri.stringValue;
        if (configured != null) {
          uris.add(configured);
        }
      }
    } else if (directive is ExportDirective) {
      final uri = directive.uri.stringValue;
      if (uri != null) {
        uris.add(uri);
      }
    }
  }
  return uris;
}

/// Resolves `.` and `..` segments in [path] (forward slashes).
///
/// Throws [ArgumentError] when the path climbs above the root.
String normalizeRelPath(String path) {
  final parts = <String>[];
  for (final segment in path.split('/')) {
    if (segment.isEmpty || segment == '.') {
      continue;
    }
    if (segment == '..') {
      if (parts.isEmpty) {
        throw ArgumentError('path escapes the root: $path');
      }
      parts.removeLast();
    } else {
      parts.add(segment);
    }
  }
  return parts.join('/');
}
