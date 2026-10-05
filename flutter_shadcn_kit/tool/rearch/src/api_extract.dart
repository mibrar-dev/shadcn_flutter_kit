// Public API extraction: follows export/part directives from a component
// entry file and records the reachable public API.

import 'dart:io';

import 'package:analyzer/dart/ast/ast.dart';

import 'api_model.dart';
import 'api_symbols.dart';
import 'dart_parse.dart';
import 'path_utils.dart';
import 'registry_scan.dart';

/// Builds an API snapshot for one component directory or the whole registry.
///
/// Pass [componentDir] for a single component directory (must contain a
/// `meta.json`) or [all] for every component. When [componentDir] is set and
/// the component has no entry file an [ArgumentError] is thrown; during an
/// `--all` run such components are listed under `skipped` instead.
ApiSnapshot buildApiSnapshot({
  required String root,
  bool skipGenerated = true,
  String? componentDir,
  bool all = false,
}) {
  final scan = RegistryScan.load(root, skipGenerated: skipGenerated);
  final selected = <ComponentInfo>[];
  if (componentDir != null) {
    final absDir = normalizePath(File(componentDir).absolute.path);
    final matches = scan.components
        .where((component) => component.dir == absDir)
        .toList();
    if (matches.isEmpty) {
      throw ArgumentError('No component with meta.json found at $absDir');
    }
    selected.addAll(matches);
  } else if (all) {
    selected.addAll(scan.components);
  } else {
    throw ArgumentError('Pass a component directory or --all');
  }

  final components = <ApiComponentSnapshot>[];
  final skipped = <Map<String, Object?>>[];
  for (final component in selected) {
    final snapshot = _snapshotComponent(scan, component);
    if (snapshot == null) {
      if (componentDir != null) {
        throw ArgumentError(
          'No entry file found for component ${component.id} in ${component.dir}',
        );
      }
      skipped.add(<String, Object?>{
        'id': component.id,
        'reason':
            'no entry file found (expected <id>.dart or a single '
            'top-level dart file)',
      });
      continue;
    }
    components.add(snapshot);
  }
  components.sort((a, b) => a.id.compareTo(b.id));
  skipped.sort((a, b) => (a['id'] as String).compareTo(b['id'] as String));
  return ApiSnapshot(
    root: scan.root,
    generatedAt: DateTime.now().toUtc().toIso8601String(),
    skipGenerated: scan.skipGenerated,
    components: components,
    skipped: skipped,
  );
}

ApiComponentSnapshot? _snapshotComponent(
  RegistryScan scan,
  ComponentInfo component,
) {
  final entryRelPath = component.entryRelPath;
  if (entryRelPath == null) {
    return null;
  }
  final warnings = <String>[];
  final frames = <_Frame>[_Frame(entryRelPath, const _Visibility.all())];
  final processedStates = <String>{};
  final files = <String>{};
  final parsedCache = <String, ParsedDartFile>{};
  final fileSymbols = <String, List<ApiSymbol>>{};
  final fullyVisible = <String>{};
  final restricted = <String, Set<String>>{};

  while (frames.isNotEmpty) {
    final frame = frames.removeLast();
    final stateKey = '${frame.rel}\u0000${frame.visibility.key}';
    if (!processedStates.add(stateKey)) {
      continue;
    }
    final absPath = joinPath(scan.root, frame.rel);
    if (!File(absPath).existsSync()) {
      warnings.add('missing export/part target: ${frame.rel}');
      continue;
    }
    files.add(frame.rel);
    final parsed = parsedCache[frame.rel] ??= parseDartFile(absPath, frame.rel);
    final symbols = fileSymbols[frame.rel] ??= extractPublicSymbols(parsed);
    if (frame.visibility.isAll) {
      fullyVisible.add(frame.rel);
    } else {
      final visible = restricted.putIfAbsent(frame.rel, () => <String>{});
      for (final symbol in symbols) {
        if (frame.visibility.allows(symbol.name)) {
          visible.add(symbol.name);
        }
      }
    }
    for (final directive in parsed.unit.directives) {
      if (directive is ExportDirective) {
        final uri = directive.uri.stringValue;
        if (uri == null) {
          continue;
        }
        final target = scan.resolveUri(absPath, uri);
        if (target == null) {
          warnings.add('export target outside the registry: $uri');
          continue;
        }
        frames.add(
          _Frame(target, frame.visibility.compose(directive.combinators)),
        );
      } else if (directive is PartDirective) {
        final uri = directive.uri.stringValue;
        if (uri == null) {
          continue;
        }
        final target = scan.resolveUri(absPath, uri);
        if (target == null) {
          warnings.add('part target outside the registry: $uri');
          continue;
        }
        frames.add(_Frame(target, frame.visibility));
      }
    }
  }

  final orderedFiles = <String>[
    entryRelPath,
    ...(files.where((file) => file != entryRelPath).toList()..sort()),
  ];
  final byKey = <String, ApiSymbol>{};
  for (final relPath in orderedFiles) {
    final symbols = fileSymbols[relPath];
    if (symbols == null) {
      continue;
    }
    for (final symbol in symbols) {
      if (!fullyVisible.contains(relPath) &&
          !(restricted[relPath]?.contains(symbol.name) ?? false)) {
        continue;
      }
      final existing = byKey[symbol.key];
      if (existing != null) {
        warnings.add(
          'duplicate symbol ${symbol.key} in $relPath '
          '(also declared in ${existing.file})',
        );
        continue;
      }
      byKey[symbol.key] = symbol;
    }
  }
  final symbols = byKey.values.toList()
    ..sort((a, b) {
      final byName = a.name.compareTo(b.name);
      return byName != 0 ? byName : a.kind.compareTo(b.kind);
    });
  return ApiComponentSnapshot(
    id: component.id,
    entry: entryRelPath,
    files: files.toList()..sort(),
    symbols: symbols,
    warnings: warnings,
  );
}

class _Frame {
  _Frame(this.rel, this.visibility);

  final String rel;
  final _Visibility visibility;
}

class _Visibility {
  const _Visibility(this.show, this.hide);

  const _Visibility.all() : show = null, hide = const <String>{};

  final Set<String>? show;
  final Set<String> hide;

  bool get isAll => show == null && hide.isEmpty;

  bool allows(String name) =>
      (show == null || show!.contains(name)) && !hide.contains(name);

  String get key => show == null
      ? 'all|${_sorted(hide).join(',')}'
      : 'show:${_sorted(show!).join(',')}|hide:${_sorted(hide).join(',')}';

  _Visibility compose(List<Combinator> combinators) {
    var nextShow = show;
    final nextHide = <String>{...hide};
    for (final combinator in combinators) {
      if (combinator is ShowCombinator) {
        final names = combinator.shownNames
            .map((identifier) => identifier.name)
            .toSet();
        nextShow = nextShow == null ? names : nextShow.intersection(names);
      } else if (combinator is HideCombinator) {
        nextHide.addAll(
          combinator.hiddenNames.map((identifier) => identifier.name),
        );
      }
    }
    return _Visibility(nextShow, nextHide);
  }
}

List<String> _sorted(Set<String> values) => values.toList()..sort();
