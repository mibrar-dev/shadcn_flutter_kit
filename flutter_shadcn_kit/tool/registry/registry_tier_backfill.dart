import 'dart:convert';
import 'dart:io';

typedef JsonMap = Map<String, dynamic>;

const _allowedTiers = {'primitive', 'component', 'pattern'};
const _defaultTier = 'component';

const Map<String, String> _tierOverrides = <String, String>{
  // Seeded primitives called out in task scope.
  'clickable': 'primitive',
  'control': 'primitive',
  'basic': 'primitive',
  'overlay': 'primitive',
  'wrapper': 'primitive',

  // Seeded patterns called out in task scope.
  'form_field': 'pattern',
  'app': 'pattern',
  'scaffold': 'pattern',
  'filter_bar': 'pattern',

  // Additional reviewed primitives: low-level interaction and foundation
  // pieces that other components compose around.
  'button': 'primitive',
  'hover': 'primitive',
  'patch': 'primitive',
  'scrollbar': 'primitive',
  'scrollview': 'primitive',
  'divider': 'primitive',
  'icon': 'primitive',
  'input': 'primitive',
  'text': 'primitive',
  'focus_outline': 'primitive',
  'formatter': 'primitive',

  // Additional reviewed patterns: higher-order flows or shells that bundle
  // multiple subcomponents into a page-level or task-level experience.
  'chat': 'pattern',
  'feature_carousel': 'pattern',
  'file_picker': 'pattern',
  'form': 'pattern',
  'object_input': 'pattern',
  'sortable': 'primitive',
  'steps': 'pattern',
  'stepper': 'pattern',
  'table': 'pattern',
  'tabs': 'primitive',
};

class _ParsedArgs {
  _ParsedArgs(this.values, this.flags);

  final Map<String, List<String>> values;
  final Set<String> flags;

  bool hasFlag(String name) => flags.contains(name);
  List<String> getValues(String name) => values[name] ?? const [];
  String? getValue(String name) => values[name]?.last;
}

_ParsedArgs _parseArgs(List<String> args) {
  final values = <String, List<String>>{};
  final flags = <String>{};

  for (var i = 0; i < args.length; i++) {
    final arg = args[i];
    if (arg == '-h') {
      flags.add('help');
      continue;
    }
    if (!arg.startsWith('--')) continue;

    final trimmed = arg.substring(2);
    if (trimmed.isEmpty) continue;
    final eqIndex = trimmed.indexOf('=');
    if (eqIndex != -1) {
      final key = trimmed.substring(0, eqIndex);
      final value = trimmed.substring(eqIndex + 1);
      values.putIfAbsent(key, () => <String>[]).add(value);
      continue;
    }
    if (i + 1 < args.length && !args[i + 1].startsWith('-')) {
      values.putIfAbsent(trimmed, () => <String>[]).add(args[i + 1]);
      i += 1;
      continue;
    }
    flags.add(trimmed);
  }

  return _ParsedArgs(values, flags);
}

List<String> _parseCsvValues(List<String> values) {
  final output = <String>[];
  for (final value in values) {
    for (final part in value.split(',')) {
      final trimmed = part.trim();
      if (trimmed.isNotEmpty) {
        output.add(trimmed);
      }
    }
  }
  return output;
}

void _printUsage() {
  stdout.writeln(
    'Usage: dart run flutter_shadcn_kit/tool/registry/registry_tier_backfill.dart [options]',
  );
  stdout.writeln('');
  stdout.writeln(
    'Backfills canonical component meta.json files with deterministic tier values.',
  );
  stdout.writeln('');
  stdout.writeln('Options:');
  stdout.writeln(
    '  --root <path>         Project root containing flutter_shadcn_kit/lib/registry/components.',
  );
  stdout.writeln(
    '  --components <ids>    Comma-separated component ids to update.',
  );
  stdout.writeln(
    '  --check               Report pending tier changes without writing files.',
  );
  stdout.writeln(
    '  --force, --normalize  Overwrite existing valid tiers with seeded/default classifications.',
  );
  stdout.writeln('  -h, --help            Show this help.');
}

Directory? _findProjectRoot(Directory start) {
  Directory current = start.absolute;
  while (true) {
    final candidate = Directory(
      '${current.path}/flutter_shadcn_kit/lib/registry/components',
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

JsonMap _readJson(File file) {
  return jsonDecode(file.readAsStringSync()) as JsonMap;
}

void _writeJson(File file, JsonMap data) {
  final encoder = const JsonEncoder.withIndent('  ');
  file.writeAsStringSync('${encoder.convert(data)}\n');
}

List<Directory> _sortedDirectories(Directory directory) {
  final entries = directory.listSync().whereType<Directory>().toList()
    ..sort((a, b) => a.path.compareTo(b.path));
  return entries;
}

String _basename(String path) {
  final normalized = path.replaceAll('\\', '/');
  final parts = normalized.split('/');
  for (var i = parts.length - 1; i >= 0; i--) {
    if (parts[i].isNotEmpty) return parts[i];
  }
  return '';
}

String _resolveTier(String id) {
  final override = _tierOverrides[id];
  if (override != null && _allowedTiers.contains(override)) {
    return override;
  }
  return _defaultTier;
}

String? _normalizedTier(dynamic value) {
  if (value is! String) {
    return null;
  }
  final normalized = value.trim();
  if (_allowedTiers.contains(normalized)) {
    return normalized;
  }
  return null;
}

String _describeTier(dynamic value) {
  final normalized = _normalizedTier(value);
  if (normalized != null) {
    return normalized;
  }
  if (value is String && value.trim().isNotEmpty) {
    return '<invalid:${value.trim()}>';
  }
  if (value == null) {
    return '<missing>';
  }
  return '<invalid:${value.toString()}>';
}

JsonMap _withResolvedTier(JsonMap source, String resolvedTier) {
  final ordered = <String, dynamic>{};
  var tierInserted = false;

  void addTier() {
    if (tierInserted) return;
    ordered['tier'] = resolvedTier;
    tierInserted = true;
  }

  for (final entry in source.entries) {
    if (entry.key == 'tier') continue;
    ordered[entry.key] = entry.value;
    if (entry.key == 'category') {
      addTier();
    }
  }

  if (!tierInserted) {
    addTier();
  }

  return ordered;
}

Iterable<File> _metaFiles(Directory componentsRoot) sync* {
  for (final categoryDir in _sortedDirectories(componentsRoot)) {
    for (final componentDir in _sortedDirectories(categoryDir)) {
      final metaFile = File('${componentDir.path}/meta.json');
      if (metaFile.existsSync()) {
        yield metaFile;
      }
    }
  }
}

void main(List<String> args) {
  final parsed = _parseArgs(args);
  if (parsed.hasFlag('help')) {
    _printUsage();
    return;
  }

  final rootArg = parsed.getValue('root');
  final root = rootArg == null
      ? _findProjectRoot(Directory.current)
      : Directory(rootArg).absolute;
  if (root == null) {
    stderr.writeln(
      'Error: Could not locate project root containing flutter_shadcn_kit/lib/registry/components.',
    );
    exitCode = 2;
    return;
  }

  final componentsRoot = Directory(
    '${root.path}/flutter_shadcn_kit/lib/registry/components',
  );
  if (!componentsRoot.existsSync()) {
    stderr.writeln(
      'Error: Components directory not found: ${componentsRoot.path}',
    );
    exitCode = 2;
    return;
  }

  final targets = _parseCsvValues(parsed.getValues('components')).toSet();
  final checkOnly = parsed.hasFlag('check');
  final forceResolvedTiers =
      parsed.hasFlag('force') || parsed.hasFlag('normalize');
  final matchedTargets = <String>{};

  var visited = 0;
  var changed = 0;

  for (final metaFile in _metaFiles(componentsRoot)) {
    final componentDir = metaFile.parent;
    final id = _basename(componentDir.path);
    if (targets.isNotEmpty && !targets.contains(id)) {
      continue;
    }
    matchedTargets.add(id);

    visited += 1;
    final meta = _readJson(metaFile);
    final resolvedTier = _resolveTier(id);
    final currentTier = meta['tier'];
    final existingValidTier = _normalizedTier(currentTier);
    final targetTier = forceResolvedTiers
        ? resolvedTier
        : existingValidTier ?? resolvedTier;
    final updated = _withResolvedTier(meta, targetTier);
    final tierChanged = currentTier != targetTier;
    final fileChanged =
        const JsonEncoder().convert(meta) !=
        const JsonEncoder().convert(updated);

    if (!fileChanged) {
      stdout.writeln('OK ${metaFile.path} ($targetTier)');
      continue;
    }

    changed += 1;
    if (checkOnly) {
      final fromTier = _describeTier(currentTier);
      stdout.writeln('PENDING ${metaFile.path} $fromTier -> $targetTier');
      continue;
    }

    _writeJson(metaFile, updated);
    final status = tierChanged ? 'UPDATED' : 'NORMALIZED';
    stdout.writeln('$status ${metaFile.path} -> $targetTier');
  }

  if (targets.isNotEmpty && visited == 0) {
    stderr.writeln(
      'Error: No matching components found for ${targets.toList()..sort()}.',
    );
    exitCode = 2;
    return;
  }

  final missingTargets = targets.difference(matchedTargets);
  if (missingTargets.isNotEmpty) {
    stderr.writeln(
      'Error: Unknown component ids: ${missingTargets.toList()..sort()}.',
    );
    exitCode = 2;
    return;
  }

  if (checkOnly) {
    stdout.writeln(
      'Checked $visited component metadata file(s); $changed pending change(s).',
    );
    if (changed > 0) {
      exitCode = 1;
    }
    return;
  }

  stdout.writeln(
    'Processed $visited component metadata file(s); updated $changed file(s).',
  );
}
