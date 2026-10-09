// Renderer for `docs_preset_sources.dart`: the exact per-preset JSON and
// `app_theme.dart` sources behind the themes-page copy actions.
//
// The Dart file bytes come from the kit generator (the same one that produced
// `lib/generated/app_theme.dart`), rendered with the CLI's import
// (`defaultAppThemeImport` in flutter_shadcn_cli = a sibling `theme.dart`),
// so `Copy Dart` is byte-equal to `flutter_shadcn theme apply <id>`.

import 'dart:convert';

import 'literals.dart';
import 'registry_scan.dart';
import 'render_common.dart';

import '../../../flutter_shadcn_kit/tool/rearch/gen_app_theme.dart' as kit;

/// The import line the CLI's generator uses inside an installed project.
const String kCliThemeImport = 'theme.dart';

/// Renders `lib/generated/docs_preset_sources.dart`.
String renderPresetSources(RegistryScan scan) {
  final StringBuffer out = StringBuffer()
    ..write(
      banner(
        sources: const <String>[
          'flutter_shadcn_kit/lib/registry/themes/*.json',
        ],
        regenerate: kRegenerateCommand,
        notes: <String>[
          '`json` is the canonical preset document (registry values, 2-space',
          'indent); the themes rail applies the radius slider value before',
          'copying. `dart` is the byte-exact `app_theme.dart` the CLI writes',
          'for the preset: `flutter_shadcn theme apply <id>` (import',
          '"$kCliThemeImport"). gen_docs_data_test.dart re-renders both with',
          'the kit generator and asserts byte equality per preset.',
        ],
      ),
    )
    ..writeln()
    ..writeln('/// The exact copy payloads of one theme preset.')
    ..writeln('class DocsPresetSource {')
    ..writeln('  /// Creates the source.')
    ..writeln('  const DocsPresetSource({')
    ..writeln('    required this.id,')
    ..writeln('    required this.json,')
    ..writeln('    required this.dart,')
    ..writeln('  });')
    ..writeln()
    ..writeln('  /// Preset id (`neutral`).')
    ..writeln('  final String id;')
    ..writeln()
    ..writeln('  /// Canonical preset JSON as checked into the registry.')
    ..writeln('  final String json;')
    ..writeln()
    ..writeln('  /// Byte-exact `app_theme.dart` for `theme apply <id>`.')
    ..writeln('  final String dart;')
    ..writeln('}')
    ..writeln()
    ..writeln('/// Preset sources keyed by preset id (every preset present).')
    ..writeln(
      'const Map<String, DocsPresetSource> kPresetSources = '
      '<String, DocsPresetSource>{',
    );
  for (final PresetFacts preset in scan.presets) {
    final Map<String, Object?> decoded = kit.readPreset(
      '${scan.root}/${preset.file}',
    );
    final String json = const JsonEncoder.withIndent('  ').convert(decoded);
    final String dart = kit.ThemeValues.fromJson(
      decoded,
    ).toDartSource(themeImport: kCliThemeImport);
    out
      ..writeln('  ${dartString(preset.id)}: DocsPresetSource(')
      ..writeln('    id: ${dartString(preset.id)},')
      ..writeln('    json: ${dartCodeString(json)},')
      ..writeln('    dart: ${dartCodeString(dart)},')
      ..writeln('  ),');
  }
  out.writeln('};');
  return out.toString();
}
