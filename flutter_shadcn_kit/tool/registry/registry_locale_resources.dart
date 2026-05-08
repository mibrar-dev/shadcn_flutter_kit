import 'dart:convert';
import 'dart:io';

Directory? _findRepoRoot(Directory start) {
  Directory current = start.absolute;
  while (true) {
    final candidate = File(
      '${current.path}/lib/registry/shared/localizations/_impl/core/shadcn_localizations.dart',
    );
    if (candidate.existsSync()) {
      return current;
    }
    final parent = current.parent;
    if (parent.path == current.path) {
      return null;
    }
    current = parent;
  }
}

void main(List<String> args) {
  if (args.contains('-h') || args.contains('--help')) {
    stdout.writeln(
      'Usage: dart run tool/registry/registry_locale_resources.dart',
    );
    stdout.writeln('');
    stdout.writeln(
      'Generates component-local locale JSON files from shared ShadcnLocalizations.',
    );
    return;
  }

  final root = _findRepoRoot(Directory.current);
  if (root == null) {
    stderr.writeln(
      'Error: Could not locate shared ShadcnLocalizations source.',
    );
    exitCode = 1;
    return;
  }

  final coreSource = File(
    '${root.path}/lib/registry/shared/localizations/_impl/core/shadcn_localizations.dart',
  );
  final extensionSource = File(
    '${root.path}/lib/registry/shared/localizations/shadcn_localizations_extensions.dart',
  );
  final allEntries = _extractLocaleEntries(coreSource.readAsStringSync());
  final dependencyGraph = <String, Set<String>>{};
  dependencyGraph.addAll(
    _extractHelperDependencies(coreSource.readAsStringSync(), allEntries.keys),
  );
  if (extensionSource.existsSync()) {
    dependencyGraph.addAll(
      _extractHelperDependencies(
        extensionSource.readAsStringSync(),
        allEntries.keys,
      ),
    );
  }

  final componentsRoot = Directory('${root.path}/lib/registry/components');
  var generated = 0;
  var totalEntries = 0;
  for (final entryDir in _componentEntryDirs(componentsRoot)) {
    final id = entryDir.path.split(Platform.pathSeparator).last;
    final keys = _localeKeysForComponent(
      id: id,
      entryDir: entryDir,
      localeKeys: allEntries.keys.toSet(),
      dependencyGraph: dependencyGraph,
    );
    final outputDir = Directory('${entryDir.path}/locales');
    final output = File('${outputDir.path}/en.json');
    if (keys.isEmpty) {
      if (output.existsSync()) {
        output.deleteSync();
      }
      if (outputDir.existsSync() && outputDir.listSync().isEmpty) {
        outputDir.deleteSync();
      }
      continue;
    }
    if (!outputDir.existsSync()) {
      outputDir.createSync(recursive: true);
    }
    final localeJson = _buildLocaleJson(keys, allEntries);
    output.writeAsStringSync(
      '${const JsonEncoder.withIndent('  ').convert(localeJson)}\n',
    );
    generated += 1;
    totalEntries += localeJson.length;
  }

  final legacyGlobalFile = File(
    '${root.path}/lib/registry/locales/shadcn_en.arb',
  );
  if (legacyGlobalFile.existsSync()) {
    legacyGlobalFile.deleteSync();
    final legacyDir = legacyGlobalFile.parent;
    if (legacyDir.existsSync() && legacyDir.listSync().isEmpty) {
      legacyDir.deleteSync();
    }
  }

  stdout.writeln(
    'Wrote $generated component locale files ($totalEntries total entries).',
  );
}

Map<String, dynamic> _extractLocaleEntries(String source) {
  final entries = <String, dynamic>{};
  final getterPattern = RegExp(
    r"String\s+get\s+([A-Za-z0-9_]+)\s*=>\s*'((?:\\'|[^'])*)';",
    multiLine: true,
  );
  for (final match in getterPattern.allMatches(source)) {
    final key = match.group(1)!;
    final value = _unescapeDartString(match.group(2)!);
    entries[key] = value;
  }

  final methodPattern = RegExp(
    r"String\s+([A-Za-z0-9_]+)\s*\(([^)]*)\)\s*=>\s*'((?:\\'|[^'])*)';",
    multiLine: true,
    dotAll: true,
  );
  for (final match in methodPattern.allMatches(source)) {
    final key = match.group(1)!;
    final params = _parseParams(match.group(2)!);
    final value = _replaceDartInterpolations(
      _unescapeDartString(match.group(3)!),
      params,
    );
    entries[key] = value;
    if (params.isNotEmpty) {
      entries['@$key'] = {
        'placeholders': {
          for (final param in params) param: <String, dynamic>{},
        },
      };
    }
  }
  return entries;
}

Map<String, Set<String>> _extractHelperDependencies(
  String source,
  Iterable<String> localeKeys,
) {
  final helpers = <String, Set<String>>{};
  final keySet = localeKeys.where((key) => !key.startsWith('@')).toSet();

  final getterPattern = RegExp(
    r"(?:String|List<[^>]+>)\s+get\s+([A-Za-z0-9_]+)\s*=>\s*([^;]+);",
    multiLine: true,
    dotAll: true,
  );
  for (final match in getterPattern.allMatches(source)) {
    helpers[match.group(1)!] = _referencedSymbols(match.group(2)!, keySet);
  }

  var searchFrom = 0;
  final methodPattern = RegExp(
    r"(?:String|List<[^>]+>)\s+([A-Za-z0-9_]+)\s*\([^)]*\)\s*\{",
    multiLine: true,
  );
  while (true) {
    final match =
        methodPattern.matchAsPrefix(source, searchFrom) ??
        methodPattern.firstMatch(source.substring(searchFrom));
    if (match == null) {
      break;
    }
    final absoluteStart = match.start < searchFrom
        ? searchFrom + match.start
        : match.start;
    final absoluteEnd = match.end < searchFrom
        ? searchFrom + match.end
        : match.end;
    final name = match.group(1)!;
    final body = _balancedBody(source, absoluteEnd - 1);
    if (body != null) {
      helpers[name] = _referencedSymbols(body.text, keySet);
      searchFrom = body.end;
    } else {
      searchFrom = absoluteEnd;
    }
    if (absoluteStart >= source.length) {
      break;
    }
  }
  return helpers;
}

({String text, int end})? _balancedBody(String source, int openBraceIndex) {
  var depth = 0;
  for (var i = openBraceIndex; i < source.length; i++) {
    final char = source.codeUnitAt(i);
    if (char == 123) {
      depth += 1;
    } else if (char == 125) {
      depth -= 1;
      if (depth == 0) {
        return (text: source.substring(openBraceIndex + 1, i), end: i + 1);
      }
    }
  }
  return null;
}

Set<String> _referencedSymbols(String source, Set<String> localeKeys) {
  final symbols = <String>{};
  final identifierPattern = RegExp(r'\b[A-Za-z_][A-Za-z0-9_]*\b');
  for (final match in identifierPattern.allMatches(source)) {
    final symbol = match.group(0)!;
    if (localeKeys.contains(symbol)) {
      symbols.add(symbol);
    }
  }
  return symbols;
}

List<Directory> _componentEntryDirs(Directory componentsRoot) {
  final entries = <Directory>[];
  if (!componentsRoot.existsSync()) {
    return entries;
  }
  for (final entity in componentsRoot.listSync(recursive: true)) {
    if (entity is! Directory) {
      continue;
    }
    if (File('${entity.path}/meta.json').existsSync()) {
      entries.add(entity);
    }
  }
  entries.sort((a, b) => a.path.compareTo(b.path));
  return entries;
}

Set<String> _localeKeysForComponent({
  required String id,
  required Directory entryDir,
  required Set<String> localeKeys,
  required Map<String, Set<String>> dependencyGraph,
}) {
  final keys = <String>{};
  final helperRefs = <String>{};
  final componentPrefixes = _componentLocalePrefixes(id);

  for (final key in localeKeys) {
    if (key.startsWith('@')) {
      continue;
    }
    final lowerKey = key.toLowerCase();
    if (componentPrefixes.any(lowerKey.startsWith)) {
      keys.add(key);
    }
  }

  final knownSymbols = {...localeKeys, ...dependencyGraph.keys};
  final symbolPattern = RegExp(r'\.([A-Za-z_][A-Za-z0-9_]*)');
  for (final file in entryDir.listSync(recursive: true).whereType<File>()) {
    if (!file.path.endsWith('.dart')) {
      continue;
    }
    final source = file.readAsStringSync();
    for (final match in symbolPattern.allMatches(source)) {
      final symbol = match.group(1)!;
      if (!knownSymbols.contains(symbol)) {
        continue;
      }
      if (localeKeys.contains(symbol)) {
        keys.add(symbol);
      } else {
        helperRefs.add(symbol);
      }
    }
  }

  for (final helper in helperRefs) {
    keys.addAll(_expandHelperDependencies(helper, dependencyGraph));
  }
  return keys;
}

Set<String> _expandHelperDependencies(
  String helper,
  Map<String, Set<String>> dependencyGraph,
) {
  final output = <String>{};
  final seen = <String>{};

  void visit(String symbol) {
    if (!seen.add(symbol)) {
      return;
    }
    final deps = dependencyGraph[symbol];
    if (deps == null) {
      output.add(symbol);
      return;
    }
    for (final dep in deps) {
      if (dependencyGraph.containsKey(dep)) {
        visit(dep);
      } else {
        output.add(dep);
      }
    }
  }

  visit(helper);
  return output;
}

Set<String> _componentLocalePrefixes(String id) {
  final words = id
      .split(RegExp(r'[_\-\s]+'))
      .where((word) => word.trim().isNotEmpty)
      .map((word) => word.toLowerCase())
      .toList();
  if (words.isEmpty) {
    return const {};
  }
  final lowerCamel =
      words.first +
      words
          .skip(1)
          .map((word) => word[0].toUpperCase() + word.substring(1))
          .join();
  final prefixes = <String>{lowerCamel.toLowerCase()};
  if (words.first.length > 3) {
    prefixes.add(words.first);
  }
  prefixes.add(
    'placeholder${lowerCamel[0].toUpperCase()}${lowerCamel.substring(1)}'
        .toLowerCase(),
  );
  return prefixes;
}

Map<String, dynamic> _buildLocaleJson(
  Set<String> keys,
  Map<String, dynamic> allEntries,
) {
  final output = <String, dynamic>{'@@locale': 'en'};
  final sortedKeys = keys.toList()..sort();
  for (final key in sortedKeys) {
    final value = allEntries[key];
    if (value == null) {
      continue;
    }
    output[key] = value;
    final metadata = allEntries['@$key'];
    if (metadata != null) {
      output['@$key'] = metadata;
    }
  }
  return output;
}

List<String> _parseParams(String raw) {
  final params = <String>[];
  for (final part in raw.split(',')) {
    final tokens = part.trim().split(RegExp(r'\s+'));
    if (tokens.isEmpty) {
      continue;
    }
    final name = tokens.last.replaceAll(RegExp(r'[^A-Za-z0-9_]'), '');
    if (name.isNotEmpty) {
      params.add(name);
    }
  }
  return params;
}

String _replaceDartInterpolations(String value, List<String> params) {
  var result = value;
  for (final param in params) {
    result = result.replaceAll('\$$param', '{$param}');
    result = result.replaceAll('\${$param}', '{$param}');
  }
  return result;
}

String _unescapeDartString(String value) {
  return value
      .replaceAll(r"\'", "'")
      .replaceAll(r'\n', '\n')
      .replaceAll(r'\r', '\r')
      .replaceAll(r'\t', '\t');
}
