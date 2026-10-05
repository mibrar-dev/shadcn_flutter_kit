// CLI: public API snapshot for a component directory or the whole registry,
// plus snapshot diffing.
//
// Usage:
//   dart run tool/rearch/api_snapshot.dart --all --out <path> [--root <dir>]
//   dart run tool/rearch/api_snapshot.dart <component-dir> --out <path>
//   dart run tool/rearch/api_snapshot.dart --diff <old.json> <new.json>
//       [--strict]

import 'dart:convert';
import 'dart:io';

import 'src/api_diff.dart';
import 'src/api_extract.dart';
import 'src/api_model.dart';
import 'src/cli_args.dart';
import 'src/json_utils.dart';

const String _usage =
    'Usage: dart run tool/rearch/api_snapshot.dart '
    '(--all | <component-dir>) [--out <path>] [--root <dir>] '
    '[--no-skip-generated]\n'
    '       dart run tool/rearch/api_snapshot.dart '
    '--diff <old.json> <new.json> [--strict]\n'
    '  --all                  Snapshot every component in the registry\n'
    '  <component-dir>        Snapshot one component directory\n'
    '  --out <path>           Write JSON to this path (default: stdout)\n'
    '  --root <dir>           Registry root (default: lib/registry)\n'
    '  --diff <old> <new>     Print the API diff of two snapshots\n'
    '  --strict               With --diff: exit 1 when differences exist\n'
    '  --no-skip-generated    Include shared/theme/generated/**\n'
    '  --help                 Print this help';

void main(List<String> args) {
  final cli = CliArgs.parse(
    args,
    valueOptions: <String>{'out', 'root'},
    twoValueOptions: <String>{'diff'},
  );
  if (cli.flag('help')) {
    stdout.writeln(_usage);
    return;
  }
  if (cli.errors.isNotEmpty) {
    stderr.writeln(cli.errors.join('\n'));
    stderr.writeln(_usage);
    exitCode = 64;
    return;
  }

  if (cli.flag('diff')) {
    _runDiff(cli);
    return;
  }

  final root = cli.value('root') ?? defaultRegistryRoot();
  final skipGenerated = !cli.flag('no-skip-generated');
  final all = cli.flag('all');
  final componentDir = cli.positional(0);
  if (!all && componentDir == null) {
    stderr.writeln('Pass --all or a component directory.');
    stderr.writeln(_usage);
    exitCode = 64;
    return;
  }

  final ApiSnapshot snapshot;
  try {
    snapshot = buildApiSnapshot(
      root: root,
      skipGenerated: skipGenerated,
      componentDir: componentDir,
      all: all,
    );
  } on ArgumentError catch (error) {
    stderr.writeln(error.message);
    exitCode = 66;
    return;
  } on FileSystemException catch (error) {
    stderr.writeln('Cannot scan $root: $error');
    exitCode = 66;
    return;
  }
  final outPath = cli.value('out');
  if (outPath != null) {
    writeJsonFile(outPath, snapshot.toJson());
    stdout.writeln('json written: $outPath');
  }
  for (final line in snapshot.summaryLines()) {
    stdout.writeln(line);
  }
  if (outPath == null) {
    stdout.write(stableJsonEncode(snapshot.toJson()));
  }
}

void _runDiff(CliArgs cli) {
  final paths = cli.values('diff');
  if (paths.length != 2) {
    stderr.writeln('--diff requires two snapshot paths.');
    exitCode = 64;
    return;
  }
  final Map<String, Object?> oldJson;
  final Map<String, Object?> newJson;
  try {
    oldJson = _readSnapshot(paths[0]);
    newJson = _readSnapshot(paths[1]);
  } on FileSystemException catch (error) {
    stderr.writeln('Cannot read snapshot: $error');
    exitCode = 66;
    return;
  } on FormatException catch (error) {
    stderr.writeln('Invalid snapshot JSON: $error');
    exitCode = 65;
    return;
  }
  final diff = diffApiSnapshots(oldJson, newJson);
  stdout.writeln(diff.format());
  if (cli.flag('strict') && !diff.isEmpty) {
    exitCode = 1;
  }
}

Map<String, Object?> _readSnapshot(String path) {
  final decoded = jsonDecode(File(path).readAsStringSync());
  if (decoded is! Map) {
    throw FormatException('$path is not a JSON object');
  }
  return decoded.cast<String, Object?>();
}
