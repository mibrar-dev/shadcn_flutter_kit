// Docs codegen entry point: turns the post-cutover registry into the docs
// app's generated data (`lib/generated/*.dart`) and the deferred preview
// registry (`lib/previews/component_previews.dart`).
//
// Usage:
//   dart run tool/gen_docs_data.dart [options]
//     --registry <path>      registry root (default: discovered from the
//                            checkout: flutter_shadcn_kit/lib/registry)
//     --out <dir>            generated data dir (default: lib/generated)
//     --previews <path>      deferred preview registry
//                            (default: lib/previews/component_previews.dart)
//     --block-sources <path> deferred block code sources
//                            (default: lib/blocks/block_sources.dart)
//     --block-previews <path> deferred block preview registry
//                            (default: lib/previews/block_previews.dart)
//     --theme-import <uri>   library exporting ShadcnThemeData for
//                            app_theme.dart (default: the docs mirror)
//     --check                regenerate into temp, format and diff against
//                            the checked-in files; exit 1 on any drift
//     --help
//
// Every run formats its outputs with `dart format --output=write`, so the
// generated files are always format-clean; `--check` formats the temp copies
// the same way before diffing.
//
// Exit codes: 0 ok, 1 `--check` drift, 64 usage, 65 input, 70 format.

import 'dart:io';

import 'src/dart_scan.dart';
import 'src/model_build.dart';
import 'src/registry_scan.dart';
import 'src/render_code.dart';
import 'src/render_common.dart';

export 'src/api_members.dart';
export 'src/api_model.dart';
export 'src/ast_docs.dart';
export 'src/block_class.dart';
export 'src/block_scan.dart';
export 'src/dart_highlight.dart';
export 'src/model_build.dart';
export 'src/dart_scan.dart';
export 'src/readme_scan.dart';
export 'src/registry_scan.dart';
export 'src/render_api.dart';
export 'src/render_blocks.dart';
export 'src/render_code.dart';
export 'src/render_common.dart';
export 'src/render_files.dart';
export 'src/render_presets.dart';
export 'src/render_previews.dart';
export 'src/render_tables.dart';

const String _usage =
    'Usage: dart run tool/gen_docs_data.dart [options]\n'
    '  --registry <path>     registry root (default: discovered from the '
    'checkout)\n'
    '  --out <dir>           generated data dir (default: lib/generated)\n'
    '  --previews <path>     deferred preview registry (default: '
    'lib/previews/component_previews.dart)\n'
    '  --block-sources <path> deferred block code sources (default: '
    'lib/blocks/block_sources.dart)\n'
    '  --block-previews <path> deferred block preview registry (default: '
    'lib/previews/block_previews.dart)\n'
    '  --theme-import <uri>  library exporting ShadcnThemeData '
    '(default: $kDocsThemeImport)\n'
    '  --check               verify checked-in files are fresh (exit 1 on '
    'drift)\n'
    '  --help                Print this help';

/// Locates the post-cutover registry by walking up from `Directory.current`
/// (checks `<dir>/flutter_shadcn_kit/lib/registry` and `<dir>/lib/registry`).
String? findDefaultRegistry() {
  Directory dir = Directory.current.absolute;
  for (int depth = 0; depth < 4; depth++) {
    for (final String suffix in const <String>[
      'flutter_shadcn_kit/lib/registry',
      'lib/registry',
    ]) {
      final Directory candidate = Directory('${dir.path}/$suffix');
      if (File('${candidate.path}/manifests/registry.json').existsSync()) {
        return candidate.path;
      }
    }
    final Directory parent = dir.parent;
    if (parent.path == dir.path) {
      break;
    }
    dir = parent;
  }
  return null;
}

/// Runs the tool; returns the process exit code.
///
/// [out] and [err] default to the real stdout/stderr; tests pass buffers.
int runDocsGen(List<String> args, {StringSink? out, StringSink? err}) {
  final StringSink stdoutSink = out ?? stdout;
  final StringSink stderrSink = err ?? stderr;
  final _Options? options = _parseArgs(args, stderrSink);
  if (options == null) {
    return 64;
  }
  if (options.help) {
    stdoutSink.writeln(_usage);
    return 0;
  }

  try {
    final String registryRoot =
        options.registry ??
        findDefaultRegistry() ??
        (throw _DocsGenException(
          'registry root not found: pass --registry (expected '
          'flutter_shadcn_kit/lib/registry in the checkout)',
        ));
    final DocsModel model = buildDocsModel(registryRoot);
    final Map<String, String> bundle = renderBundle(
      model,
      outDir: options.out,
      previewsPath: options.previews,
      blockSourcesPath: options.blockSources,
      blockPreviewsPath: options.blockPreviews,
      themeImport: options.themeImport,
    );

    stdoutSink
      ..writeln('registry: $registryRoot')
      ..writeln(describeModel(model));

    if (options.check) {
      return _checkBundle(bundle, stdoutSink, stderrSink);
    }
    return _writeBundle(bundle, stdoutSink, stderrSink);
  } on _DocsGenException catch (error) {
    stderrSink.writeln('gen_docs_data: ${error.message}');
    return error.exitCode;
  } on RegistryScanException catch (error) {
    stderrSink.writeln('gen_docs_data: $error');
    return 65;
  } on DartScanException catch (error) {
    stderrSink.writeln('gen_docs_data: $error');
    return 65;
  } on FormatException catch (error) {
    stderrSink.writeln('gen_docs_data: ${error.message}');
    return 65;
  } on FileSystemException catch (error) {
    stderrSink.writeln('gen_docs_data: ${error.message}');
    return 65;
  }
}

// ---------------------------------------------------------------------------
// Argument parsing + write/check helpers.
// ---------------------------------------------------------------------------

class _Options {
  const _Options({
    this.registry,
    this.out = 'lib/generated',
    this.previews = 'lib/previews/component_previews.dart',
    this.blockSources = 'lib/blocks/block_sources.dart',
    this.blockPreviews = 'lib/previews/block_previews.dart',
    this.themeImport = kDocsThemeImport,
    this.check = false,
    this.help = false,
  });

  final String? registry;
  final String out;
  final String previews;
  final String blockSources;
  final String blockPreviews;
  final String themeImport;
  final bool check;
  final bool help;
}

_Options? _parseArgs(List<String> args, StringSink err) {
  String? registry;
  String out = 'lib/generated';
  String previews = 'lib/previews/component_previews.dart';
  String blockSources = 'lib/blocks/block_sources.dart';
  String blockPreviews = 'lib/previews/block_previews.dart';
  String themeImport = kDocsThemeImport;
  bool check = false;
  bool help = false;
  bool missingValue = false;

  for (int i = 0; i < args.length; i++) {
    final String arg = args[i];
    String value(String name) {
      if (i + 1 >= args.length) {
        err.writeln('gen_docs_data: `$name` needs a value');
        missingValue = true;
        return '';
      }
      return args[++i];
    }

    switch (arg) {
      case '--registry':
        registry = value(arg);
      case '--out':
        out = value(arg);
      case '--previews':
        previews = value(arg);
      case '--block-sources':
        blockSources = value(arg);
      case '--block-previews':
        blockPreviews = value(arg);
      case '--theme-import':
        themeImport = value(arg);
      case '--check':
        check = true;
      case '--help':
      case '-h':
        help = true;
      default:
        err.writeln('gen_docs_data: unknown argument `$arg`');
        err.writeln(_usage);
        return null;
    }
  }
  if (missingValue) {
    return null;
  }
  return _Options(
    registry: registry,
    out: out,
    previews: previews,
    blockSources: blockSources,
    blockPreviews: blockPreviews,
    themeImport: themeImport,
    check: check,
    help: help,
  );
}

int _writeBundle(Map<String, String> bundle, StringSink out, StringSink err) {
  final List<String> written = <String>[];
  for (final MapEntry<String, String> entry in bundle.entries) {
    final File file = File(entry.key);
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(entry.value);
    written.add(file.absolute.path);
  }
  _format(written);
  for (final String path in written) {
    out.writeln('wrote $path (${File(path).lengthSync()} bytes)');
  }
  out.writeln('generated data written.');
  return 0;
}

int _checkBundle(Map<String, String> bundle, StringSink out, StringSink err) {
  // The temp copies must live inside the package so `dart format` applies the
  // same language version as the checked-in files (formatting outside the
  // package uses the SDK's latest defaults and can differ).
  Directory work = Directory('.dart_tool');
  try {
    work.createSync(recursive: true);
  } on FileSystemException {
    work = Directory.systemTemp;
  }
  final Directory temp = work.createTempSync('gen_docs_data_check');
  try {
    final Map<String, String> formatted = <String, String>{};
    final List<String> tempFiles = <String>[];
    for (final MapEntry<String, String> entry in bundle.entries) {
      final File file = File('${temp.path}/${_basename(entry.key)}');
      file.writeAsStringSync(entry.value);
      tempFiles.add(file.path);
    }
    _format(tempFiles);
    for (final MapEntry<String, String> entry in bundle.entries) {
      formatted[entry.key] = File(
        '${temp.path}/${_basename(entry.key)}',
      ).readAsStringSync();
    }

    final List<String> stale = <String>[];
    for (final MapEntry<String, String> entry in formatted.entries) {
      final File file = File(entry.key);
      if (!file.existsSync() || file.readAsStringSync() != entry.value) {
        stale.add(entry.key);
        out.writeln('out of date: ${entry.key}');
      }
    }
    if (stale.isEmpty) {
      out.writeln(
        'generated data is up to date (${formatted.length} files checked).',
      );
      return 0;
    }
    err.writeln(
      'gen_docs_data: ${stale.length} generated file(s) out of date; '
      'run `dart run tool/gen_docs_data.dart`.',
    );
    return 1;
  } finally {
    temp.deleteSync(recursive: true);
  }
}

String _basename(String path) => path.split(Platform.pathSeparator).last;

void _format(List<String> paths) {
  if (paths.isEmpty) {
    return;
  }
  final ProcessResult result;
  try {
    result = Process.runSync('dart', <String>[
      'format',
      '--output=write',
      ...paths,
    ]);
  } on ProcessException catch (error) {
    throw _DocsGenException(
      'cannot run `dart format` (is the Dart SDK on PATH?): ${error.message}',
      exitCode: 70,
    );
  }
  if (result.exitCode != 0) {
    throw _DocsGenException(
      'dart format failed:\n${result.stdout}${result.stderr}',
      exitCode: 70,
    );
  }
}

class _DocsGenException implements Exception {
  _DocsGenException(this.message, {this.exitCode = 65});

  final String message;
  final int exitCode;
}

void main(List<String> args) {
  exitCode = runDocsGen(args);
}
