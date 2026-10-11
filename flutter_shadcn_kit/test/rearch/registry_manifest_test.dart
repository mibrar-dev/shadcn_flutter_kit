// Guards the generated registry manifest (lib/registry/manifests/registry.json):
// it must be up to date with the tree, validate against the P5-A JSON Schema,
// and every dependency id it references must exist.

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/registry/src/registry_manifest.dart';

void main() {
  final manifestFile = File(
    '${Directory.current.path}/lib/registry/manifests/registry.json',
  );
  final schemaFile = File(
    '${Directory.current.path}/../rearch/reports/'
    'registry_manifest.v2.schema.json',
  );

  late Map<String, dynamic> manifest;

  setUpAll(() {
    manifest =
        jsonDecode(manifestFile.readAsStringSync()) as Map<String, dynamic>;
  });

  test('manifest is up to date with the tree', () {
    expect(schemaFile.existsSync(), isTrue, reason: 'P5-A schema is missing');
    expect(
      buildRegistryManifest(Directory.current.path),
      manifestFile.readAsStringSync(),
      reason: 'run dart run tool/registry/gen_registry_manifest.dart',
    );
  });

  test('manifest validates against registry_manifest.v2.schema.json', () {
    final schema = jsonDecode(schemaFile.readAsStringSync());
    final validator = _SchemaValidator(schema);
    validator.validate(manifest);
    expect(validator.errors, isEmpty);
  });

  test('every component dependency id exists', () {
    final components = manifest['components'] as Map<String, dynamic>;
    final layers = <String, Map<String, dynamic>>{
      'foundation': manifest['foundation'] as Map<String, dynamic>,
      'theme': manifest['theme'] as Map<String, dynamic>,
      'primitives': manifest['primitives'] as Map<String, dynamic>,
      'components': components,
    };
    for (final entry in components.entries) {
      final deps = entry.value['deps'] as Map<String, dynamic>;
      for (final layer in layers.keys) {
        for (final id in deps[layer] as List) {
          expect(
            layers[layer]!.containsKey(id),
            isTrue,
            reason: '${entry.key} deps.$layer references missing "$id"',
          );
        }
      }
    }
  });

  test('every primitive closure terminates and exists', () {
    final primitives = manifest['primitives'] as Map<String, dynamic>;
    for (final id in primitives.keys) {
      final seen = <String>{};
      final work = <String>[id];
      while (work.isNotEmpty) {
        final current = work.removeLast();
        if (!seen.add(current)) {
          continue;
        }
        final deps =
            (primitives[current] as Map<String, dynamic>)['deps']
                as Map<String, dynamic>;
        for (final dep in deps['primitives'] as List) {
          expect(
            primitives.containsKey(dep),
            isTrue,
            reason: 'primitive "$current" depends on missing "$dep"',
          );
          work.add(dep as String);
        }
      }
    }
  });
}

/// A JSON Schema (draft 2020-12 subset) validator covering exactly the
/// keywords registry_manifest.v2.schema.json uses: $ref, type, const, enum,
/// required, properties, additionalProperties, items, minItems, uniqueItems,
/// minLength, pattern and oneOf.
class _SchemaValidator {
  _SchemaValidator(this.schema);

  final Object? schema;
  final List<String> errors = <String>[];

  void validate(Object? instance) => _validate(instance, r'$', schema);

  void _validate(Object? instance, String path, Object? node) {
    if (node is bool) {
      if (!node) {
        errors.add('$path: value is forbidden by the schema');
      }
      return;
    }
    if (node is! Map) {
      return;
    }
    final ref = node[r'$ref'];
    if (ref is String) {
      _validate(instance, path, _resolveRef(ref));
      return;
    }
    if (node.containsKey('const') && instance != node['const']) {
      errors.add('$path: expected const ${node['const']}');
    }
    final enumValues = node['enum'];
    if (enumValues is List && !enumValues.contains(instance)) {
      errors.add('$path: value is not one of $enumValues');
    }
    final type = node['type'];
    if (type != null && !_matchesType(instance, type)) {
      errors.add('$path: expected type $type, got ${instance.runtimeType}');
      return;
    }
    if (instance is String) {
      final pattern = node['pattern'];
      if (pattern is String && !RegExp(pattern).hasMatch(instance)) {
        errors.add('$path: "$instance" does not match $pattern');
      }
      final minLength = node['minLength'];
      if (minLength is int && instance.length < minLength) {
        errors.add('$path: shorter than $minLength');
      }
    }
    if (instance is List) {
      final minItems = node['minItems'];
      if (minItems is int && instance.length < minItems) {
        errors.add('$path: fewer than $minItems items');
      }
      if (node['uniqueItems'] == true) {
        final seen = <String>{};
        for (final item in instance) {
          if (!seen.add(jsonEncode(item))) {
            errors.add('$path: duplicate item');
          }
        }
      }
      final items = node['items'];
      if (items != null) {
        for (var i = 0; i < instance.length; i += 1) {
          _validate(instance[i], '$path[$i]', items);
        }
      }
    }
    if (instance is Map) {
      final required = node['required'];
      if (required is List) {
        for (final key in required) {
          if (!instance.containsKey(key)) {
            errors.add('$path: missing required "$key"');
          }
        }
      }
      final properties = node['properties'];
      if (properties is Map) {
        for (final entry in properties.entries) {
          if (instance.containsKey(entry.key)) {
            _validate(instance[entry.key], '$path.${entry.key}', entry.value);
          }
        }
      }
      final additional = node['additionalProperties'];
      if (additional == false && properties is Map) {
        for (final key in instance.keys) {
          if (!properties.containsKey(key)) {
            errors.add('$path: unexpected property "$key"');
          }
        }
      } else if (additional is Map) {
        for (final entry in instance.entries) {
          if (properties is Map && properties.containsKey(entry.key)) {
            continue;
          }
          _validate(entry.value, '$path.${entry.key}', additional);
        }
      }
      final oneOf = node['oneOf'];
      if (oneOf is List) {
        final matches = oneOf.where((sub) {
          final probe = _SchemaValidator(schema)
            .._validate(instance, path, sub);
          return probe.errors.isEmpty;
        }).length;
        if (matches != 1) {
          errors.add('$path: oneOf matched $matches subschemas');
        }
      }
    }
  }

  Object? _resolveRef(String ref) {
    Object? node = schema;
    for (final segment in ref.replaceFirst('#/', '').split('/')) {
      if (node is! Map) {
        return null;
      }
      node = node[segment];
    }
    return node;
  }

  bool _matchesType(Object? value, Object? type) {
    final types = type is List ? type : <Object?>[type];
    for (final candidate in types) {
      final matches = switch (candidate) {
        'object' => value is Map,
        'array' => value is List,
        'string' => value is String,
        'boolean' => value is bool,
        'integer' => value is int,
        'number' => value is num,
        'null' => value == null,
        _ => false,
      };
      if (matches) {
        return true;
      }
    }
    return false;
  }
}
