// Minimal JSON Schema (draft 2020-12) validator for the preset schema.
//
// Only the keywords `lib/registry/themes/themes.schema.json` actually uses
// are implemented, so the schema file - not a duplicated key list - is what the
// tests assert against. Supported: `$ref` into `#/$defs`, `type`, `properties`,
// `required`, `additionalProperties: false`, `pattern`, `minLength`,
// `minProperties`, `minimum`, `maximum`, `exclusiveMinimum`, `const`, `enum`.
// Unknown keywords are ignored; anything they would have rejected is reported
// as unsupported so the test cannot silently pass on a schema change.

import 'dart:convert';
import 'dart:io';

/// Reads a JSON file as a string-keyed map.
Map<String, Object?> readJsonMap(String path) =>
    jsonDecode(File(path).readAsStringSync()) as Map<String, Object?>;

/// `flutter_shadcn_kit` package root. `flutter test` runs with the package root
/// as the working directory, the same convention `test/rearch` uses.
String get packageRoot => Directory.current.path;

/// Preset directory of the new theme layer.
String get themesDir => '$packageRoot/lib/registry/themes';

/// Scratch directory for generated files (inside the package so `dart analyze`
/// resolves the `package:flutter_shadcn_kit` imports).
String get genDir => '$packageRoot/.dart_tool/rearch_gen';

/// Preset file names of the new theme layer, sorted (`index.json` and the
/// schema are not presets).
List<String> presetFiles() {
  return Directory(themesDir)
      .listSync()
      .whereType<File>()
      .map((file) => file.path.split('/').last)
      .where(
        (name) =>
            name.endsWith('.json') &&
            name != 'index.json' &&
            name != 'themes.schema.json',
      )
      .toList()
    ..sort();
}

/// Validates [instance] against [schema], returning one message per violation.
List<String> validateSchema(
  Object? instance,
  Map<String, Object?> schema, {
  Map<String, Object?>? root,
  String path = r'$',
}) {
  final document = root ?? schema;
  final ref = schema[r'$ref'];
  if (ref is String) {
    if (!ref.startsWith('#/')) {
      return <String>['$path: unsupported $ref "$ref"'];
    }
    Object? target = document;
    for (final segment in ref.substring(2).split('/')) {
      if (target is! Map || target[segment] is! Map) {
        return <String>['$path: cannot resolve $ref'];
      }
      target = (target[segment]! as Map).cast<String, Object?>();
    }
    return validateSchema(
      instance,
      target as Map<String, Object?>,
      root: document,
      path: path,
    );
  }

  final errors = <String>[];
  const known = <String>{
    r'$defs',
    r'$id',
    r'$ref',
    r'$schema',
    'additionalProperties',
    'const',
    'default',
    'deprecated',
    'description',
    'enum',
    'examples',
    'exclusiveMinimum',
    'maximum',
    'minItems',
    'minLength',
    'minProperties',
    'minimum',
    'pattern',
    'properties',
    'required',
    'title',
    'type',
  };
  for (final keyword in schema.keys) {
    if (!known.contains(keyword)) errors.add('$path: unsupported $keyword');
  }

  if (schema.containsKey('const') && instance != schema['const']) {
    errors.add('$path: expected const ${schema['const']}, got $instance');
  }
  final enumValues = schema['enum'];
  if (enumValues is List && !enumValues.contains(instance)) {
    errors.add('$path: $instance is not one of $enumValues');
  }
  final type = schema['type'];
  if (type is String && !_isType(instance, type)) {
    errors.add('$path: expected $type, got ${instance.runtimeType}');
    return errors;
  }

  if (instance is String) {
    final pattern = schema['pattern'];
    if (pattern is String && !RegExp(pattern).hasMatch(instance)) {
      errors.add('$path: "$instance" does not match $pattern');
    }
    final minLength = schema['minLength'];
    if (minLength is int && instance.length < minLength) {
      errors.add('$path: shorter than minLength $minLength');
    }
  }
  if (instance is num) {
    _checkBound(errors, path, schema, 'minimum', instance, (a, b) => a >= b);
    _checkBound(errors, path, schema, 'maximum', instance, (a, b) => a <= b);
    _checkBound(
      errors,
      path,
      schema,
      'exclusiveMinimum',
      instance,
      (a, b) => a > b,
    );
  }
  if (instance is Map) {
    final properties = (schema['properties'] as Map?)?.cast<String, Object?>();
    final required = (schema['required'] as List?)?.cast<String>();
    if (required != null) {
      for (final key in required) {
        if (!instance.containsKey(key)) {
          errors.add('$path: missing required "$key"');
        }
      }
    }
    final minProperties = schema['minProperties'];
    if (minProperties is int && instance.length < minProperties) {
      errors.add('$path: fewer than minProperties $minProperties');
    }
    if (schema['additionalProperties'] == false) {
      for (final key in instance.keys) {
        if (properties == null || !properties.containsKey(key)) {
          errors.add('$path: additional property "$key" is not allowed');
        }
      }
    }
    if (properties != null) {
      for (final entry in properties.entries) {
        final value = instance[entry.key];
        if (value == null) continue;
        errors.addAll(
          validateSchema(
            value,
            entry.value as Map<String, Object?>,
            root: document,
            path: '$path.${entry.key}',
          ),
        );
      }
    }
  }
  return errors;
}

void _checkBound(
  List<String> errors,
  String path,
  Map<String, Object?> schema,
  String keyword,
  num instance,
  bool Function(num, num) ok,
) {
  final bound = schema[keyword];
  if (bound is num && !ok(instance, bound)) {
    errors.add('$path: $instance violates $keyword $bound');
  }
}

bool _isType(Object? instance, String type) {
  return switch (type) {
    'object' => instance is Map,
    'array' => instance is List,
    'string' => instance is String,
    'boolean' => instance is bool,
    'integer' => instance is int,
    'number' => instance is num,
    _ => throw ArgumentError('Unsupported schema type "$type"'),
  };
}
