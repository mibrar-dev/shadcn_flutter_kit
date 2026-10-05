// POSIX path helpers for the rearch tooling.
//
// The scripts only ever run on macOS/Linux against repository-relative paths,
// so a small local implementation keeps package:path (a transitive
// dependency) out of the import graph.

/// Joins [base] and [child], normalizing the result.
String joinPath(String base, String child) {
  if (child.isEmpty) {
    return normalizePath(base);
  }
  if (child.startsWith('/')) {
    return normalizePath(child);
  }
  if (base.isEmpty) {
    return normalizePath(child);
  }
  return normalizePath('$base/$child');
}

/// Collapses `.`, `..` and duplicate separators in [path].
String normalizePath(String path) {
  final isAbsolute = path.startsWith('/');
  final result = <String>[];
  for (final segment in path.split('/')) {
    if (segment.isEmpty || segment == '.') {
      continue;
    }
    if (segment == '..') {
      if (result.isNotEmpty && result.last != '..') {
        result.removeLast();
      } else if (!isAbsolute) {
        result.add('..');
      }
      continue;
    }
    result.add(segment);
  }
  final joined = result.join('/');
  if (isAbsolute) {
    return '/$joined';
  }
  return joined.isEmpty ? '.' : joined;
}

/// The parent directory of [path].
String dirName(String path) {
  final normalized = normalizePath(path);
  final index = normalized.lastIndexOf('/');
  if (index < 0) {
    return '.';
  }
  if (index == 0) {
    return '/';
  }
  return normalized.substring(0, index);
}

/// The last segment of [path].
String baseName(String path) {
  final normalized = normalizePath(path);
  final index = normalized.lastIndexOf('/');
  return index < 0 ? normalized : normalized.substring(index + 1);
}

/// The file extension of [path] including the dot, or an empty string.
String extensionOf(String path) {
  final base = baseName(path);
  final dot = base.lastIndexOf('.');
  return dot <= 0 ? '' : base.substring(dot);
}

/// [path] without its extension.
String stemOf(String path) {
  final base = baseName(path);
  final dot = base.lastIndexOf('.');
  return dot <= 0 ? base : base.substring(0, dot);
}

/// The relative path of [path] with respect to [from].
///
/// Both arguments are normalized; the result uses forward slashes and never
/// starts with a separator.
String relativePath(String path, String from) {
  final target = _segments(path);
  final base = _segments(from);
  var common = 0;
  while (common < target.length &&
      common < base.length &&
      target[common] == base[common]) {
    common += 1;
  }
  final parts = <String>[
    for (var i = common; i < base.length; i++) '..',
    ...target.sublist(common),
  ];
  return parts.isEmpty ? '.' : parts.join('/');
}

/// Whether [path] is [dir] itself or lives below it.
bool isWithin(String path, String dir) {
  final normalizedPath = normalizePath(path);
  final normalizedDir = normalizePath(dir);
  return normalizedPath == normalizedDir ||
      normalizedPath.startsWith('$normalizedDir/');
}

List<String> _segments(String path) => normalizePath(
  path,
).split('/').where((segment) => segment.isNotEmpty).toList();
