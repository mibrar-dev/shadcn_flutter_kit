// Generates lib/registry/manifests/registry.json (schemaVersion 2).
//
// Usage:
//   dart run tool/registry/gen_registry_manifest.dart [--root <app dir>]
//       [--out <file>] [--check]
//
// --root defaults to the flutter_shadcn_kit package root found by walking up
// from the current directory. --check regenerates in memory and exits 1 when
// the file on disk differs (no write). The build logic lives in
// src/registry_manifest.dart; the contract in
// rearch/reports/registry_manifest.v2.schema.json.

import 'dart:io';

import 'src/manifest_error.dart';
import 'src/registry_manifest.dart';

const String _usage =
    'Usage: dart run tool/registry/gen_registry_manifest.dart '
    '[--root <app dir>] [--out <file>] [--check]\n'
    '  --root <app dir>   flutter_shadcn_kit package root '
    '(default: found from cwd)\n'
    '  --out <file>       Output path '
    '(default: <root>/lib/registry/manifests/registry.json)\n'
    '  --check            Exit 1 when the output file is not up to date\n'
    '  --help             Print this help';

void main(List<String> args) {
  final parsed = _Args.parse(args);
  if (parsed == null) {
    stdout.writeln(_usage);
    exitCode = 64;
    return;
  }
  final appRoot = parsed.root ?? _findAppRoot();
  if (appRoot == null) {
    stderr.writeln('Cannot locate the flutter_shadcn_kit root (pass --root).');
    exitCode = 66;
    return;
  }

  final String json;
  try {
    json = buildRegistryManifest(appRoot);
  } on ManifestBuildException catch (error) {
    stderr.writeln(error);
    exitCode = 1;
    return;
  }

  final outPath = parsed.out ?? '$appRoot/lib/registry/manifests/registry.json';
  final outFile = File(outPath);
  if (parsed.check) {
    final current = outFile.existsSync() ? outFile.readAsStringSync() : '';
    if (current != json) {
      stderr.writeln('$outPath is not up to date.');
      exitCode = 1;
      return;
    }
    stdout.writeln('$outPath is up to date.');
    return;
  }
  outFile.parent.createSync(recursive: true);
  outFile.writeAsStringSync(json);
  stdout.writeln('Generated $outPath.');
}

String? _findAppRoot() {
  var dir = Directory.current.absolute;
  while (true) {
    if (File('${dir.path}/pubspec.yaml').existsSync() &&
        Directory('${dir.path}/lib/registry').existsSync()) {
      return dir.path;
    }
    final parent = dir.parent;
    if (parent.path == dir.path) {
      return null;
    }
    dir = parent;
  }
}

class _Args {
  _Args({this.root, this.out, this.check = false});

  final String? root;
  final String? out;
  final bool check;

  static _Args? parse(List<String> args) {
    String? root;
    String? out;
    var check = false;
    for (var i = 0; i < args.length; i += 1) {
      final arg = args[i];
      if (arg == '--root') {
        if (i + 1 >= args.length) return null;
        root = args[i + 1];
        i += 1;
      } else if (arg == '--out') {
        if (i + 1 >= args.length) return null;
        out = args[i + 1];
        i += 1;
      } else if (arg == '--check') {
        check = true;
      } else {
        return null;
      }
    }
    return _Args(root: root, out: out, check: check);
  }
}
