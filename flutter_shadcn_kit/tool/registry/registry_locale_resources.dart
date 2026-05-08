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
      'Generates registry locale ARB files from shared ShadcnLocalizations.',
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

  final source = File(
    '${root.path}/lib/registry/shared/localizations/_impl/core/shadcn_localizations.dart',
  );
  final outputDir = Directory('${root.path}/lib/registry/locales');
  if (!outputDir.existsSync()) {
    outputDir.createSync(recursive: true);
  }
  final arb = _extractArb(source.readAsStringSync());
  final output = File('${outputDir.path}/shadcn_en.arb');
  output.writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert(arb)}\n',
  );
  stdout.writeln('Wrote ${output.path} (${arb.length} entries).');
}

Map<String, dynamic> _extractArb(String source) {
  final arb = <String, dynamic>{'@@locale': 'en'};
  final getterPattern = RegExp(
    r"String\s+get\s+([A-Za-z0-9_]+)\s*=>\s*'((?:\\'|[^'])*)';",
    multiLine: true,
  );
  for (final match in getterPattern.allMatches(source)) {
    final key = match.group(1)!;
    final value = _unescapeDartString(match.group(2)!);
    arb[key] = value;
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
    arb[key] = value;
    if (params.isNotEmpty) {
      arb['@$key'] = {
        'placeholders': {
          for (final param in params) param: <String, dynamic>{},
        },
      };
    }
  }
  return arb;
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
