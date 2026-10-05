// CLI: layer and hygiene rules for the registry tree.
//
// Usage:
//   dart run tool/rearch/check_layers.dart [--root <dir>] [--json <path>]
//       [--rule <id> ...] [--strict] [--no-skip-generated] [--help]

import 'dart:io';

import 'src/cli_args.dart';
import 'src/json_utils.dart';
import 'src/layers.dart';

const String _usage =
    'Usage: dart run tool/rearch/check_layers.dart '
    '[--root <dir>] [--json <path>] [--rule <id> ...] [--strict] '
    '[--no-skip-generated]\n'
    '  --root <dir>           Registry root (default: lib/registry)\n'
    '  --json <path>          Write the full report as stable JSON\n'
    '  --rule <id>            Run only this rule (repeatable); one of:\n'
    '                         $_ruleList\n'
    '  --strict               Exit 1 when any error level finding exists\n'
    '  --no-skip-generated    Include shared/theme/generated/**\n'
    '  --help                 Print this help';

const String _ruleList =
    'no-material, no-part, no-ignore-for-file, layer-direction, '
    'undeclared-dependency, file-too-long';

void main(List<String> args) {
  final cli = CliArgs.parse(
    args,
    valueOptions: <String>{'json', 'root', 'rule'},
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

  final root = cli.value('root') ?? defaultRegistryRoot();
  final skipGenerated = !cli.flag('no-skip-generated');
  final selectedRules = cli.values('rule').toSet();
  final LayersReport report;
  try {
    report = runLayersCheck(
      root: root,
      skipGenerated: skipGenerated,
      rules: selectedRules.isEmpty ? null : selectedRules,
    );
  } on ArgumentError catch (error) {
    stderr.writeln(error.message);
    exitCode = 64;
    return;
  } on FileSystemException catch (error) {
    stderr.writeln('Cannot scan $root: $error');
    exitCode = 66;
    return;
  }
  final jsonPath = cli.value('json');
  if (jsonPath != null) {
    writeJsonFile(jsonPath, report.toJson());
    stdout.writeln('json written: $jsonPath');
  }
  for (final line in report.summaryLines()) {
    stdout.writeln(line);
  }
  if (cli.flag('strict') && report.hasErrors) {
    final errors = report.findings
        .where((finding) => finding.severity == 'error')
        .length;
    stderr.writeln('strict: $errors error level finding(s)');
    exitCode = 1;
  }
}
