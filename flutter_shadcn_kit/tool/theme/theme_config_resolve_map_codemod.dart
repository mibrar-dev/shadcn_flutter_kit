import 'dart:io';

final _branchPattern = RegExp(
  r'if \(T == ([A-Za-z0-9_]+)\) \{\s*return ([A-Za-z0-9_]+) as T\?;\s*\}',
  dotAll: true,
);

final _resolveSignaturePattern = RegExp(r'^\s*static T\? resolve<');

void main() {
  final root = Directory.current.absolute;
  final componentsRoot = Directory('${root.path}/lib/registry/components');
  if (!componentsRoot.existsSync()) {
    stderr.writeln(
      'Expected to run from flutter_shadcn_kit/. Missing ${componentsRoot.path}.',
    );
    exitCode = 1;
    return;
  }

  final files = componentsRoot
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('_theme_config.dart'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  var updated = 0;
  for (final file in files) {
    final original = file.readAsStringSync();
    final rewritten = _rewriteResolveMethod(original);
    if (rewritten == null || rewritten == original) {
      continue;
    }
    file.writeAsStringSync(rewritten);
    updated += 1;
  }

  stdout.writeln('Theme config resolve codemod complete.');
  stdout.writeln('Files scanned: ${files.length}.');
  stdout.writeln('Files updated: $updated.');
}

String? _rewriteResolveMethod(String source) {
  final lines = source.split('\n');
  final startIndex = lines.indexWhere(
    (line) => _resolveSignaturePattern.hasMatch(line),
  );
  if (startIndex == -1) return null;

  var braceDepth = 0;
  var endIndex = -1;
  for (var i = startIndex; i < lines.length; i++) {
    braceDepth += '{'.allMatches(lines[i]).length;
    braceDepth -= '}'.allMatches(lines[i]).length;
    if (braceDepth == 0) {
      endIndex = i;
      break;
    }
  }
  if (endIndex == -1) {
    throw StateError('Unterminated resolve method.');
  }

  final methodText = lines.sublist(startIndex, endIndex + 1).join('\n');
  final matches = _branchPattern.allMatches(methodText).toList();
  if (matches.isEmpty) return null;

  final mapEntries = matches
      .map((match) => '    ${match.group(1)}: ${match.group(2)},')
      .join('\n');
  final replacement = <String>[
    '  static final Map<Type, Object?> _resolveByType = <Type, Object?>{',
    mapEntries,
    '  };',
    '',
    lines[startIndex],
    '    return _resolveByType[T] as T?;',
    '  }',
  ].join('\n');

  return [
    ...lines.sublist(0, startIndex),
    replacement,
    ...lines.sublist(endIndex + 1),
  ].join('\n');
}
