// JSON helpers that produce stable, sorted output for the rearch reports.

import 'dart:convert';
import 'dart:io';

import 'path_utils.dart';

/// Encodes [value] with map keys sorted so two runs diff cleanly.
String stableJsonEncode(Object? value, {bool pretty = true}) {
  final encoder = pretty
      ? const JsonEncoder.withIndent('  ')
      : const JsonEncoder();
  return '${encoder.convert(_canonicalize(value))}\n';
}

/// Writes [value] as stable JSON to [path], creating parent directories.
void writeJsonFile(String path, Object? value) {
  final file = File(path);
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(stableJsonEncode(value));
}

/// Reads and decodes a JSON file.
Object? readJsonFile(String path) => jsonDecode(File(path).readAsStringSync());

/// Resolves the default registry root from the running script location.
///
/// `$APP/tool/rearch/<script>.dart` -> `$APP/lib/registry`. Falls back to the
/// current working directory when the script was moved.
String defaultRegistryRoot() {
  final scriptPath = Platform.script.toFilePath();
  final appRoot = dirName(dirName(dirName(scriptPath)));
  final candidate = joinPath(appRoot, 'lib/registry');
  if (Directory(candidate).existsSync()) {
    return candidate;
  }
  return joinPath(Directory.current.path, 'lib/registry');
}

Object? _canonicalize(Object? value) {
  if (value is Map) {
    final keys = value.keys.map((key) => key.toString()).toList()..sort();
    final result = <String, Object?>{};
    for (final key in keys) {
      result[key] = _canonicalize(value[key]);
    }
    return result;
  }
  if (value is List) {
    return value.map(_canonicalize).toList();
  }
  return value;
}
