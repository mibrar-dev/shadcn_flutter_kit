// CLI: validate user-owned component theme files in the registry tree.
//
// Usage:
//   dart run tool/rearch/check_user_theme.dart [--root <dir>] [--json <path>]
//       [--strict]

import 'dart:io';

import 'src/cli_args.dart';
import 'src/json_utils.dart';
import 'src/path_utils.dart';
import 'src/user_theme.dart';

const String _usage =
    'Usage: dart run tool/rearch/check_user_theme.dart '
    '[--root <dir>] [--json <path>] [--strict]\n'
    '  --root <dir>    Registry root (default: lib/registry)\n'
    '  --json <path>   Write the full report as stable JSON\n'
    '  --strict        Exit 1 when any finding exists\n'
    '  --help          Print this help';

void main(List<String> args) {
  final cli = CliArgs.parse(args, valueOptions: <String>{'root', 'json'});
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
  final root = cli.value('root') ?? _defaultRegistryRoot();
  final findings = checkUserThemes(root);
  final jsonPath = cli.value('json');
  if (jsonPath != null) {
    writeJsonFile(jsonPath, <String, Object?>{
      'tool': 'check_user_theme',
      'schemaVersion': 1,
      'generatedAt': DateTime.now().toUtc().toIso8601String(),
      'root': root,
      'summary': <String, Object?>{'findings': findings.length},
      'findings': [for (final f in findings) f.toJson()],
    });
    stdout.writeln('json written: $jsonPath');
  }
  stdout.writeln('check_user_theme: ${findings.length} finding(s)');
  for (final finding in findings) {
    stdout.writeln('  ${finding.file}:${finding.line}: ${finding.message}');
  }
  if (cli.flag('strict') && findings.isNotEmpty) {
    exitCode = 1;
  }
}

String _defaultRegistryRoot() {
  final scriptPath = Platform.script.toFilePath();
  final appRoot = dirName(dirName(dirName(scriptPath)));
  final candidate = joinPath(appRoot, 'lib/registry');
  if (Directory(candidate).existsSync()) {
    return candidate;
  }
  return joinPath(Directory.current.path, 'lib/registry');
}
