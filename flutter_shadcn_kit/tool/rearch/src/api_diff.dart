// API snapshot diffing: added/removed/changed public symbols and members.

import 'json_utils.dart';

/// Reference to a symbol inside a component snapshot.
class ApiSymbolRef {
  ApiSymbolRef({
    required this.component,
    required this.kind,
    required this.name,
  });

  /// Component id.
  final String component;

  /// Symbol kind.
  final String kind;

  /// Symbol name.
  final String name;

  @override
  String toString() => '$kind $name';
}

/// A symbol present in both snapshots with a different signature or members.
class ChangedApiSymbol {
  ChangedApiSymbol({
    required this.ref,
    required this.signatureChanged,
    required this.addedMembers,
    required this.removedMembers,
    required this.changedMembers,
  });

  /// Symbol identity.
  final ApiSymbolRef ref;

  /// Whether fields other than the member list changed.
  final bool signatureChanged;

  /// Member keys added in the new snapshot.
  final List<String> addedMembers;

  /// Member keys removed in the new snapshot.
  final List<String> removedMembers;

  /// Member keys whose signature changed.
  final List<String> changedMembers;
}

/// Difference between two API snapshots.
class ApiDiff {
  ApiDiff({
    required this.addedSymbols,
    required this.removedSymbols,
    required this.changedSymbols,
  });

  /// Symbols only present in the new snapshot.
  final List<ApiSymbolRef> addedSymbols;

  /// Symbols only present in the old snapshot.
  final List<ApiSymbolRef> removedSymbols;

  /// Symbols present in both with changes.
  final List<ChangedApiSymbol> changedSymbols;

  /// Whether the snapshots match.
  bool get isEmpty =>
      addedSymbols.isEmpty && removedSymbols.isEmpty && changedSymbols.isEmpty;

  /// Human readable, deterministic diff.
  String format() {
    if (isEmpty) {
      return 'api diff: no changes';
    }
    final lines = <String>[
      'api diff: '
          '+${addedSymbols.length} symbols, '
          '-${removedSymbols.length} symbols, '
          '~${changedSymbols.length} symbols',
    ];
    final changesByComponent = <String, List<String>>{};
    for (final symbol in addedSymbols) {
      changesByComponent
          .putIfAbsent(symbol.component, () => <String>[])
          .add('  + ${symbol.kind} ${symbol.name}');
    }
    for (final symbol in removedSymbols) {
      changesByComponent
          .putIfAbsent(symbol.component, () => <String>[])
          .add('  - ${symbol.kind} ${symbol.name}');
    }
    for (final changed in changedSymbols) {
      final linesForComponent = changesByComponent.putIfAbsent(
        changed.ref.component,
        () => <String>[],
      );
      linesForComponent.add('  ~ ${changed.ref.kind} ${changed.ref.name}');
      if (changed.signatureChanged) {
        linesForComponent.add('      signature changed');
      }
      for (final member in changed.addedMembers) {
        linesForComponent.add('      + ${_displayMemberKey(member)}');
      }
      for (final member in changed.removedMembers) {
        linesForComponent.add('      - ${_displayMemberKey(member)}');
      }
      for (final member in changed.changedMembers) {
        linesForComponent.add('      ~ ${_displayMemberKey(member)}');
      }
    }
    final componentIds = changesByComponent.keys.toList()..sort();
    for (final component in componentIds) {
      lines.add('$component:');
      lines.addAll(changesByComponent[component]!);
    }
    return lines.join('\n');
  }
}

/// Diffs two decoded snapshot JSON documents.
ApiDiff diffApiSnapshots(
  Map<String, Object?> oldJson,
  Map<String, Object?> newJson,
) {
  final oldComponents = _indexComponents(oldJson);
  final newComponents = _indexComponents(newJson);
  final componentIds = <String>{
    ...oldComponents.keys,
    ...newComponents.keys,
  }.toList()..sort();

  final added = <ApiSymbolRef>[];
  final removed = <ApiSymbolRef>[];
  final changed = <ChangedApiSymbol>[];
  for (final componentId in componentIds) {
    final oldSymbols =
        oldComponents[componentId] ?? <String, Map<String, Object?>>{};
    final newSymbols =
        newComponents[componentId] ?? <String, Map<String, Object?>>{};
    final symbolKeys = <String>{...oldSymbols.keys, ...newSymbols.keys}.toList()
      ..sort();
    for (final key in symbolKeys) {
      final oldSymbol = oldSymbols[key];
      final newSymbol = newSymbols[key];
      if (oldSymbol == null) {
        added.add(_ref(componentId, newSymbol!));
        continue;
      }
      if (newSymbol == null) {
        removed.add(_ref(componentId, oldSymbol));
        continue;
      }
      final changedSymbol = _diffSymbol(componentId, oldSymbol, newSymbol);
      if (changedSymbol != null) {
        changed.add(changedSymbol);
      }
    }
  }
  return ApiDiff(
    addedSymbols: added,
    removedSymbols: removed,
    changedSymbols: changed,
  );
}

ChangedApiSymbol? _diffSymbol(
  String componentId,
  Map<String, Object?> oldSymbol,
  Map<String, Object?> newSymbol,
) {
  final signatureChanged =
      _canonical(_withoutKeys(oldSymbol, const <String>{'file', 'members'})) !=
      _canonical(_withoutKeys(newSymbol, const <String>{'file', 'members'}));
  final oldMembers = _indexMembers(oldSymbol);
  final newMembers = _indexMembers(newSymbol);
  final memberKeys = <String>{...oldMembers.keys, ...newMembers.keys}.toList()
    ..sort();
  final addedMembers = <String>[];
  final removedMembers = <String>[];
  final changedMembers = <String>[];
  for (final key in memberKeys) {
    final oldMember = oldMembers[key];
    final newMember = newMembers[key];
    if (oldMember == null) {
      addedMembers.add(key);
    } else if (newMember == null) {
      removedMembers.add(key);
    } else if (_canonical(oldMember) != _canonical(newMember)) {
      changedMembers.add(key);
    }
  }
  if (!signatureChanged &&
      addedMembers.isEmpty &&
      removedMembers.isEmpty &&
      changedMembers.isEmpty) {
    return null;
  }
  return ChangedApiSymbol(
    ref: _ref(componentId, newSymbol),
    signatureChanged: signatureChanged,
    addedMembers: addedMembers,
    removedMembers: removedMembers,
    changedMembers: changedMembers,
  );
}

Map<String, Map<String, Map<String, Object?>>> _indexComponents(
  Map<String, Object?> json,
) {
  final result = <String, Map<String, Map<String, Object?>>>{};
  final components = json['components'];
  if (components is! List) {
    return result;
  }
  for (final component in components.whereType<Map>()) {
    final id = component['id'];
    if (id is! String) {
      continue;
    }
    final symbols = <String, Map<String, Object?>>{};
    final symbolList = component['symbols'];
    if (symbolList is List) {
      for (final symbol in symbolList.whereType<Map>()) {
        final kind = symbol['kind'];
        final name = symbol['name'];
        if (kind is String && name is String) {
          symbols['$kind:$name'] = symbol.cast<String, Object?>();
        }
      }
    }
    result[id] = symbols;
  }
  return result;
}

Map<String, Map<String, Object?>> _indexMembers(Map<String, Object?> symbol) {
  final result = <String, Map<String, Object?>>{};
  final members = symbol['members'];
  if (members is! List) {
    return result;
  }
  for (final member in members.whereType<Map>()) {
    final kind = member['kind'];
    final name = member['name'];
    if (kind is String && name is String) {
      result['$kind:$name'] = member.cast<String, Object?>();
    }
  }
  return result;
}

ApiSymbolRef _ref(String componentId, Map<String, Object?> symbol) {
  return ApiSymbolRef(
    component: componentId,
    kind: symbol['kind'] as String? ?? '?',
    name: symbol['name'] as String? ?? '?',
  );
}

Map<String, Object?> _withoutKeys(Map<String, Object?> map, Set<String> keys) {
  return <String, Object?>{
    for (final entry in map.entries)
      if (!keys.contains(entry.key)) entry.key: entry.value,
  };
}

String _canonical(Object? value) => stableJsonEncode(value, pretty: false);

String _displayMemberKey(String key) => key.replaceFirst(':', ' ');
