// Copy/export payloads of the Theme Studio (spec §2.7 requirement 3).
//
//  * `Get Code` → Dart — the exact `app_theme.dart` that
//    `flutter_shadcn theme apply <id>` writes into an installed project. It is
//    rendered from the live document by `themeDartSource`, the port of the kit
//    generator that `theme_dart_source_test.dart` pins byte-for-byte against
//    the generated per-preset sources.
//  * `Get Code` → JSON — the canonical schema-v2 preset document, which is
//    also what `Open Preset` accepts, so the round-trip is lossless.
//  * `Get Code` → CLI — how to apply the document in a project.

import '../generated/docs_preset_sources.dart';
import 'theme_dart_source.dart' show camelCaseId;
import 'theme_document.dart';

/// The command that regenerates `app_theme.dart` for a registry preset.
String themeApplyCommand(String presetId) =>
    'flutter_shadcn theme apply $presetId';

/// The CLI tab of the `Get Code` dialog.
String themeCliGuide(ThemeDocument document) {
  final String? matched = _matchedPresetId(document);
  final StringBuffer out = StringBuffer()
    ..writeln('# 1. Install the theme layer')
    ..writeln('flutter pub add flutter_shadcn_kit')
    ..writeln()
    ..writeln('# 2. Write the generated file into your project');
  if (matched != null) {
    out.writeln('flutter_shadcn theme apply $matched');
  } else {
    out.writeln('# Not a registry preset: save the JSON tab as');
    out.writeln(
      '# lib/registry/themes/${document.id}.json in your project, then',
    );
    out.writeln('flutter_shadcn theme apply ${document.id}');
  }
  out
    ..writeln()
    ..writeln('# 3. Use it')
    ..writeln('runApp(ShadcnApp(theme: build${_classPrefix(document.id)}Theme(')
    ..writeln(
      '  WidgetsBinding.instance.platformDispatcher.platformBrightness,',
    )
    ..writeln('), home: const HomePage()));');
  return out.toString();
}

/// The registry preset id whose document is exactly [document], or null.
String? _matchedPresetId(ThemeDocument document) {
  final String json = document.json;
  for (final DocsPresetSource source in kPresetSources.values) {
    if (source.json == json) {
      return source.id;
    }
  }
  return null;
}

String _classPrefix(String id) {
  final String camel = camelCaseId(id);
  return camel.isEmpty ? camel : camel[0].toUpperCase() + camel.substring(1);
}
