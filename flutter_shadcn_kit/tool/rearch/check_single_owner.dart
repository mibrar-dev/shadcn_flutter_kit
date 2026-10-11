// CLI: report top-level Dart declarations that exist in more than one owner
// unit (component or shared module).
//
// Usage:
//   dart run tool/rearch/check_single_owner.dart [--root <dir>] [--json <path>]
//       [--strict] [--no-skip-generated] [--help]

import 'dart:io';

import 'src/cli_args.dart';
import 'src/json_utils.dart';
import 'src/single_owner.dart';

const String _usage =
    'Usage: dart run tool/rearch/check_single_owner.dart '
    '[--root <dir>] [--json <path>] [--strict] [--no-skip-generated]\n'
    '  --root <dir>           Registry root (default: lib/registry)\n'
    '  --json <path>          Write the full report as stable JSON\n'
    '  --strict               Exit 1 when any public duplicate exists\n'
    '  --no-skip-generated    Include shared/theme/generated/**\n'
    '  --help                 Print this help';

void main(List<String> args) {
  final cli = CliArgs.parse(args, valueOptions: <String>{'json', 'root'});
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
  final SingleOwnerReport report;
  try {
    report = runSingleOwnerCheck(root: root, skipGenerated: skipGenerated);
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
    stderr.writeln(
      'strict: ${report.publicDuplicates} public duplicate name(s) found',
    );
    exitCode = 1;
  }
}
