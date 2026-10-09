// D2 codegen tests: checked-in golden expectations for button/dialog/command
// (API + theme tables), byte-equality of app_theme.dart against the kit
// generator, freshness (`--check`) and snippet/README round-trips.
//
// Run from `docs/`:  flutter test tool/gen_docs_data_test.dart
//
// The checked-in expectations in this file are the D2 review artifact: they
// freeze the generated facts for three representative components (one widget
// with a full constructor, one function-first component, one overlay).

import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:docs/generated/app_theme.dart';
import 'package:docs/generated/docs_api.dart';
import 'package:docs/generated/docs_data.dart';
import 'package:docs/generated/docs_preset_sources.dart';
import 'package:docs/generated/docs_search.dart';
import 'package:docs/generated/docs_snippets.dart';
import 'package:docs/generated/docs_tables.dart';
import 'package:docs/previews/component_previews.dart';
import 'package:docs/state/docs_state.dart';
import 'package:docs/ui/shadcn/theme/theme.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../flutter_shadcn_kit/tool/rearch/gen_app_theme.dart' as kit;
import 'gen_docs_data.dart';

void main() {
  final String? discovered = findDefaultRegistry();
  if (discovered == null) {
    test('registry discovery', () {
      fail(
        'registry not found; run `flutter test` from docs/ (expected '
        'flutter_shadcn_kit/lib/registry in the checkout)',
      );
    });
    return;
  }
  final String registry = discovered;

  group('goldens: button', () {
    test('API table', () {
      final DocsApiTable table = kApiTables['button']!;
      expect(table.symbol, 'Button');
      expect(table.hasApiTable, isTrue);
      expect(table.parseClean, isTrue);
      expect(table.summary, contains('pressable action control'));
      expect(table.summary, isNot(startsWith('///')));
      expect(table.params.map((DocsApiParam p) => p.name).toList(), <String>[
        'child',
        'variant',
        'size',
        'onPressed',
        'onLongPress',
        'onHover',
        'onFocusChange',
        'leading',
        'trailing',
        'focusNode',
        'autofocus',
        'enabled',
        'theme',
      ]);
      expect(table.params.first.isRequired, isTrue);
      expect(table.params.first.type, 'Widget');
      expect(
        table.params.first.doc,
        'Button content, usually a `Text` or an `Icon`.',
      );
      final DocsApiParam variant = table.params[1];
      expect(variant.type, 'ButtonVariant');
      expect(variant.defaultValue, 'ButtonVariant.primary');
      expect(
        variant.doc,
        'Visual variant. Defaults to [ButtonVariant.primary].',
      );
      expect(table.params.where((DocsApiParam p) => p.isRequired).length, 1);
    });

    test('theme table', () {
      final DocsThemeTable table = kThemeTables['button']!;
      expect(table.themeClass, 'ButtonTheme');
      expect(table.themeDefaults, 'buttonDefaults');
      expect(table.userFile, 'button_theme.dart');
      expect(table.userOwned, isTrue);
      expect(table.hasTheme, isTrue);
      expect(table.fields.map((DocsThemeField f) => f.name).toList(), <String>[
        'background',
        'borderColor',
        'borderWidth',
        'decoration',
        'destructive',
        'foreground',
        'ghost',
        'link',
        'outline',
        'padding',
        'primary',
        'secondary',
        'text',
        'textStyle',
      ]);
      expect(table.fields.first.type, 'StateValue<ThemedColor>?');
      expect(table.fields.first.description, 'per-state fill');
    });
  });

  group('goldens: dialog', () {
    test('function-first API extracts showShadcnDialog params', () {
      final DocsApiTable table = kApiTables['dialog']!;
      expect(table.hasApiTable, isTrue);
      expect(table.symbol, 'showShadcnDialog');
      expect(table.parseClean, isTrue);
      expect(table.summary, contains('shadcn modal dialog'));
      expect(table.params.map((DocsApiParam p) => p.name).toList(), <String>[
        'context',
        'builder',
        'useRootNavigator',
        'barrierDismissible',
        'barrierColor',
        'barrierLabel',
        'useSafeArea',
        'routeSettings',
        'traversalEdgeBehavior',
        'alignment',
        'fullScreen',
        'theme',
      ]);
      expect(table.params.first.isRequired, isTrue);
      expect(table.params.first.type, 'BuildContext');
      final DocsApiParam builder = table.params[1];
      expect(builder.name, 'builder');
      expect(builder.isRequired, isTrue);
      expect(builder.type, 'WidgetBuilder');
      final DocsApiParam fullScreen = table.params.firstWhere(
        (DocsApiParam p) => p.name == 'fullScreen',
      );
      expect(fullScreen.defaultValue, 'false');
    });

    test('theme table', () {
      final DocsThemeTable table = kThemeTables['dialog']!;
      expect(table.themeClass, 'DialogTheme');
      expect(table.themeDefaults, 'dialogDefaults');
      expect(table.userFile, 'dialog_theme.dart');
      expect(table.userOwned, isTrue);
      expect(
        table.fields.map((DocsThemeField f) => f.name).toList(),
        containsAll(<String>['background', 'barrierColor', 'borderColor']),
      );
    });
  });

  group('goldens: command', () {
    test('API table', () {
      final DocsApiTable table = kApiTables['command']!;
      expect(table.symbol, 'Command');
      expect(table.hasApiTable, isTrue);
      expect(table.params.first.name, 'builder');
      expect(table.params.first.isRequired, isTrue);
      expect(table.params.first.type, 'CommandBuilder');
      expect(
        table.params.first.doc,
        'Builds the results for the current query.',
      );
      expect(table.params.where((DocsApiParam p) => p.isRequired).length, 1);
    });

    test('theme table', () {
      final DocsThemeTable table = kThemeTables['command']!;
      expect(table.themeClass, 'CommandTheme');
      expect(table.themeDefaults, 'commandDefaults');
      expect(table.userFile, 'command_theme.dart');
      expect(table.userOwned, isTrue);
      expect(table.fields, isNotEmpty);
    });
  });

  group('irregular primary classes (manifest api.classes fallback)', () {
    test('every component resolves a primary class or function', () {
      final List<String> missing = <String>[
        for (final DocsComponent component in kComponents)
          if (!kApiTables[component.id]!.hasApiTable) component.id,
      ];
      expect(missing, isEmpty, reason: 'no API table for $missing');
    });

    test('the five formerly-missing tables pick the manifest classes', () {
      expect(kApiTables['autocomplete']!.symbol, 'AutoCompleteFeature');
      expect(kApiTables['autocomplete']!.params.first.name, 'suggestions');
      expect(kApiTables['formatter']!.symbol, 'TextInputFormatters');
      expect(kApiTables['alpha']!.symbol, 'AlphaPainter');
      expect(
        kApiTables['alpha']!.params.map((DocsApiParam p) => p.name),
        containsAll(<String>['primary', 'secondary', 'squareSize']),
      );
      expect(kApiTables['color']!.symbol, 'ColorDerivative');
      expect(kApiTables['locale_utils']!.symbol, 'SizeUnitLocale');
      expect(
        kApiTables['locale_utils']!.params.map((DocsApiParam p) => p.name),
        containsAll(<String>['base', 'units', 'separator']),
      );
    });

    test('formatter surfaces the factory set, not TimeFormatter.length', () {
      final DocsApiTable table = kApiTables['formatter']!;
      // `TextInputFormatters._()` is private, so the declared factories win.
      expect(table.symbol, 'TextInputFormatters');
      expect(
        table.summary,
        'Factory methods for common text input formatters.',
      );
      expect(table.parseClean, isTrue);
      // Constructor rows are empty: the class cannot be constructed.
      expect(table.params, isEmpty);
      expect(table.members.map((DocsApiMember m) => m.name).toList(), <String>[
        'TextInputFormatters.time',
        'TextInputFormatters.integerOnly',
        'TextInputFormatters.digitsOnly',
        'TextInputFormatters.mathExpression',
        'TextInputFormatters.hex',
        'TextInputFormatters.toUpperCase',
        'TextInputFormatters.toLowerCase',
        'constraintToNewText',
      ]);
      final DocsApiMember time = table.members.first;
      expect(time.kind, 'method');
      expect(time.returnType, 'TextInputFormatter');
      expect(time.isStatic, isTrue);
      expect(time.params.single.name, 'length');
      expect(time.params.single.type, 'int');
      expect(time.params.single.isRequired, isTrue);
      expect(
        time.doc,
        'Creates a time formatter padded left with zeros to [length].',
      );
      final DocsApiMember hex = table.members.firstWhere(
        (DocsApiMember m) => m.name == 'TextInputFormatters.hex',
      );
      final DocsApiParam hashPrefix = hex.params.single;
      expect(hashPrefix.type, 'bool');
      expect(hashPrefix.defaultValue, 'false');
      final DocsApiMember toUpperCase = table.members.firstWhere(
        (DocsApiMember m) => m.name == 'TextInputFormatters.toUpperCase',
      );
      expect(toUpperCase.kind, 'constant');
      expect(toUpperCase.returnType, 'TextInputFormatter');
      expect(toUpperCase.params, isEmpty);
      final DocsApiMember constraint = table.members.last;
      expect(constraint.kind, 'function');
      expect(constraint.returnType, 'TextSelection');
      expect(
        constraint.params.map((DocsApiParam p) => p.name).toList(),
        <String>['newValue', 'newText'],
      );
      expect(
        constraint.doc,
        'Constrains the text selection to fit within the new text length.',
      );
    });

    test('color surfaces the ColorDerivative factories and conversions', () {
      final DocsApiTable table = kApiTables['color']!;
      // `const ColorDerivative();` takes no parameters: the declared entry
      // points are the component's API.
      expect(table.symbol, 'ColorDerivative');
      expect(table.hasApiTable, isTrue);
      expect(table.parseClean, isTrue);
      expect(table.summary, contains('abstract base class'));
      expect(table.params, isEmpty);
      final List<String> names = table.members
          .map((DocsApiMember m) => m.name)
          .toList();
      expect(names.first, 'ColorDerivative.fromColor');
      expect(names, contains('ColorDerivative.fromHex'));
      expect(names, contains('ColorDerivative.fromHSV'));
      expect(names, contains('ColorDerivative.fromHSL'));
      expect(names.last, 'ColorDerivative.toHSLColor');
      expect(names.length, 22);
      for (final DocsApiMember member in table.members) {
        expect(
          member.name,
          startsWith('ColorDerivative.'),
          reason: member.name,
        );
        expect(member.returnType, isNotEmpty, reason: member.name);
      }
      final DocsApiMember fromHSV = table.members.firstWhere(
        (DocsApiMember m) => m.name == 'ColorDerivative.fromHSV',
      );
      expect(fromHSV.kind, 'factory');
      expect(fromHSV.isStatic, isFalse);
      expect(fromHSV.params.single.name, 'color');
      expect(fromHSV.params.single.type, 'HSVColor');
      expect(fromHSV.doc, 'Creates a [ColorDerivative] from an [HSVColor].');
      final DocsApiMember fromHex = table.members.firstWhere(
        (DocsApiMember m) => m.name == 'ColorDerivative.fromHex',
      );
      expect(fromHex.isStatic, isTrue);
      expect(fromHex.returnType, 'ColorDerivative?');
      final DocsApiMember toColor = table.members.firstWhere(
        (DocsApiMember m) => m.name == 'ColorDerivative.toColor',
      );
      expect(toColor.kind, 'method');
      expect(toColor.params, isEmpty);
      expect(toColor.returnType, 'Color');
    });

    test('every declared api.methods/constants/functions name resolves', () {
      // A declared name that does not resolve in the entry file would silently
      // shrink the table, so the generator must report it.
      final RegistryScan scan = scanRegistry(registry);
      final List<String> unresolved = <String>[];
      for (final ComponentFacts component in scan.components) {
        final DeclaredMembers declared = DeclaredMembers(
          methods: component.apiMethods,
          constants: component.apiConstants,
          functions: component.apiFunctions,
        );
        if (declared.isEmpty) {
          continue;
        }
        final String source = File(
          '${scan.root}/${component.entry}',
        ).readAsStringSync();
        final ApiFacts facts = extractApi(
          source: source,
          nameCandidates: <String>[
            pascalCase(component.name),
            pascalCase(component.id),
            ...component.apiClasses,
          ],
          declared: declared,
        );
        extractDeclaredMembers(
          unit: parseString(content: source, throwIfDiagnostics: false).unit,
          source: source,
          declared: declared,
          unresolved: unresolved,
        );
        expect(facts.members, isNotEmpty, reason: component.id);
      }
      expect(
        unresolved,
        isEmpty,
        reason: 'declared API entries missing from the entry files',
      );
    });

    test('member rows only appear for static/factory-first components', () {
      final List<String> withMembers = <String>[
        for (final DocsComponent component in kComponents)
          if (kApiTables[component.id]!.members.isNotEmpty) component.id,
      ];
      expect(withMembers, <String>[
        'formatter',
        'overlay_configuration',
        'color',
      ]);
    });
  });

  group('preset sources (themes actions payloads)', () {
    test('every preset has json and the exact CLI dart file', () {
      expect(kPresetSources.length, kPresets.length);
      for (final DocsPreset preset in kPresets) {
        final DocsPresetSource source = kPresetSources[preset.id]!;
        expect(source.id, preset.id);
        final Object? decoded = jsonDecode(source.json);
        expect(decoded, isA<Map<String, Object?>>());
        expect((decoded! as Map<String, Object?>)['id'], preset.id);
        expect(
          source.dart,
          startsWith(
            '// Generated by flutter_shadcn — regenerate with: '
            'flutter_shadcn theme apply ${preset.id} --refresh',
          ),
          reason: preset.id,
        );
        expect(source.dart, contains("import 'theme.dart';"));
      }
    });

    test('dart is byte-equal to the kit generator (CLI import)', () {
      final Map<String, Object?> index =
          jsonDecode(File('$registry/themes/index.json').readAsStringSync())
              as Map<String, Object?>;
      final List<Object?> themes = index['themes']! as List<Object?>;
      for (final Object? entry in themes) {
        final Map<String, Object?> item = entry! as Map<String, Object?>;
        final String id = item['id']! as String;
        final kit.ThemeValues values = kit.ThemeValues.fromJson(
          kit.readPreset('$registry/themes/$id.json'),
        );
        expect(
          kPresetSources[id]!.dart,
          values.toDartSource(themeImport: 'theme.dart'),
          reason: id,
        );
      }
    });

    test('json is the canonical registry document', () {
      for (final DocsPreset preset in kPresets) {
        final String raw = File(
          '$registry/themes/${preset.id}.json',
        ).readAsStringSync();
        final String canonical = const JsonEncoder.withIndent(
          '  ',
        ).convert(jsonDecode(raw));
        expect(kPresetSources[preset.id]!.json, canonical, reason: preset.id);
      }
    });
  });

  test('catalog is complete and self-consistent', () {
    expect(kStats.components, kComponents.length);
    expect(kStats.presets, kPresets.length);
    expect(kStats.presets, 43);
    expect(kStats.materialImports, 0);
    expect(kStats.modes, 2);
    expect(
      kComponents.map((DocsComponent c) => c.id).toSet().length,
      kComponents.length,
    );
    expect(
      kCategories.fold<int>(0, (int sum, DocsCategory c) => sum + c.count),
      kComponents.length,
    );
    for (final DocsComponent component in kComponents) {
      expect(
        kApiTables.containsKey(component.id),
        isTrue,
        reason: component.id,
      );
      expect(
        kThemeTables.containsKey(component.id),
        isTrue,
        reason: component.id,
      );
      expect(
        kDocsSnippets.containsKey(component.id),
        isTrue,
        reason: component.id,
      );
      expect(
        kComponentDeps.containsKey(component.id),
        isTrue,
        reason: component.id,
      );
      expect(
        kComponentFileLists.containsKey(component.id),
        isTrue,
        reason: component.id,
      );
      expect(component.fileCount, greaterThan(0), reason: component.id);
      expect(component.install, 'flutter_shadcn add ${component.id}');
      expect(
        component.import,
        contains('/ui/shadcn/components/${component.id}/'),
      );
      final DocsFileList list = kComponentFileLists[component.id]!;
      expect(
        list.files.length + list.userOwned.length,
        component.fileCount,
        reason: component.id,
      );
      for (final String file in list.files) {
        expect(file, startsWith('lib/ui/shadcn/'));
      }
    }
  });

  test('search index covers components, commands and presets', () {
    final Iterable<DocsSearchEntry> components = kDocsSearchIndex.where(
      (DocsSearchEntry entry) => entry.kind == DocsSearchKind.component,
    );
    final Iterable<DocsSearchEntry> commands = kDocsSearchIndex.where(
      (DocsSearchEntry entry) => entry.kind == DocsSearchKind.command,
    );
    final Iterable<DocsSearchEntry> presets = kDocsSearchIndex.where(
      (DocsSearchEntry entry) => entry.kind == DocsSearchKind.preset,
    );
    expect(components.length, kComponents.length);
    expect(presets.length, kPresets.length);
    expect(commands.length, kCliCommands.length);
    expect(commands, isNotEmpty);
    for (final DocsComponent component in kComponents) {
      final DocsSearchEntry entry = components.firstWhere(
        (DocsSearchEntry e) => e.label == component.id,
      );
      expect(entry.route, '/docs/components/${component.id}');
      expect(entry.keywords, contains(component.name));
    }
  });

  test(
    'keyboard tables: rows for calendar, gaps for dialog (never invented)',
    () {
      expect(kKeyboardGaps, contains('dialog'));
      expect(kKeyboardGaps, contains('button'));
      expect(kKeyboardRows['dialog'], isEmpty);
      final List<DocsKeyboardRow> calendar = kKeyboardRows['calendar']!;
      expect(calendar, isNotEmpty);
      final DocsKeyboardRow homeEnd = calendar.firstWhere(
        (DocsKeyboardRow row) => row.keys == 'Home / End',
      );
      expect(homeEnd.action, 'the first or last day of the focused week');
      expect(homeEnd.source, 'Keyboard');
      // Exactly four components document keyboard rows; `app` gained its
      // shortcuts section, so the gap count dropped by one.
      expect(kKeyboardGaps.length, kComponents.length - 4);
    },
  );

  test('CLI snapshot parses into commands with flags', () {
    expect(kCliCommands, isNotEmpty);
    final DocsCliCommand add = kCliCommands.firstWhere(
      (DocsCliCommand command) => command.label == 'flutter_shadcn add',
    );
    expect(add.usage, contains('add <ids...>'));
    expect(
      add.flags.map((DocsCliFlag flag) => flag.name).toList(),
      containsAll(<String>['--dry-run', '--json', '--force', '--all']),
    );
    final DocsCliFlag dryRun = add.flags.firstWhere(
      (DocsCliFlag flag) => flag.name == '--dry-run',
    );
    expect(dryRun.description, 'Print the plan without writing files.');
    final DocsCliCommand init = kCliCommands.firstWhere(
      (DocsCliCommand command) => command.label == 'flutter_shadcn init',
    );
    final DocsCliFlag dir = init.flags.firstWhere(
      (DocsCliFlag flag) => flag.name == '--dir',
    );
    expect(dir.placeholder, '<path>');
  });

  group('app_theme', () {
    test('byte-equal to the kit generator output for all 43 presets', () {
      final String app = File(
        'lib/generated/app_theme.dart',
      ).readAsStringSync();
      final Map<String, Object?> index =
          jsonDecode(File('$registry/themes/index.json').readAsStringSync())
              as Map<String, Object?>;
      final List<Object?> themes = index['themes']! as List<Object?>;
      expect(themes.length, 43);
      for (final Object? entry in themes) {
        final Map<String, Object?> item = entry! as Map<String, Object?>;
        final String id = item['id']! as String;
        final kit.ThemeValues values = kit.ThemeValues.fromJson(
          kit.readPreset('$registry/themes/$id.json'),
        );
        final String source = values.toDartSource(
          themeImport: kDocsThemeImport,
        );
        final String body = source.substring(
          source.indexOf('/// Colour tokens for '),
        );
        expect(app.contains(body), isTrue, reason: id);
      }
    });

    test('resolver covers every preset and falls back to the docs default', () {
      expect(kDocsDefaultPresetId, kDefaultDocsPresetId);
      for (final DocsPreset preset in kPresets) {
        final ShadcnThemeData data = buildDocsTheme(preset.id, Brightness.dark);
        expect(data.colors.background, isNotNull, reason: preset.id);
      }
      final ShadcnThemeData fallback = buildDocsTheme(
        'not-a-preset',
        Brightness.dark,
      );
      final ShadcnThemeData docsDefault = buildDocsTheme(
        kDocsDefaultPresetId,
        Brightness.dark,
      );
      expect(
        fallback.colors.primary.toARGB32(),
        docsDefault.colors.primary.toARGB32(),
      );
    });
  });

  test('snippet code and highlight maps match the READMEs', () {
    for (final String id in <String>['button', 'dialog', 'command']) {
      final ReadmeDoc readme = parseReadme(
        File('$registry/components/$id/README.md').readAsStringSync(),
      );
      final List<ReadmeBlock> blocks = readme.blocks
          .where(
            (ReadmeBlock block) => kSnippetLanguages.contains(block.language),
          )
          .toList(growable: false);
      final List<DocsSnippet> generated = kDocsSnippets[id]!;
      expect(generated.length, blocks.length, reason: id);
      for (int i = 0; i < blocks.length; i++) {
        expect(generated[i].code, blocks[i].code, reason: '$id.$i');
        expect(
          generated[i].tokenClasses.length,
          generated[i].code.length,
          reason: '$id.$i',
        );
        expect(
          RegExp(r'^[pcks]*$').hasMatch(generated[i].tokenClasses),
          isTrue,
          reason: '$id.$i',
        );
      }
    }
  });

  test('spans builder maps the generated classes to text styles', () {
    final DocsSnippet snippet = kDocsSnippets['button']!.first;
    const TextStyle plain = TextStyle();
    const TextStyle keyword = TextStyle(fontWeight: FontWeight.bold);
    const TextStyle string = TextStyle(fontStyle: FontStyle.italic);
    final List<TextSpan> spans = snippet.spans(
      plain: plain,
      comment: const TextStyle(decoration: TextDecoration.lineThrough),
      keyword: keyword,
      string: string,
    );
    expect(spans.map((TextSpan span) => span.text).join(), snippet.code);
    final TextSpan constSpan = spans.firstWhere(
      (TextSpan span) => span.text == 'const',
    );
    expect(constSpan.style?.fontWeight, FontWeight.bold);
    final TextSpan stringSpan = spans.firstWhere(
      (TextSpan span) => span.text!.startsWith("'"),
    );
    expect(stringSpan.style?.fontStyle, FontStyle.italic);
  });

  test('preview registry loads previews and rejects unknown ids', () async {
    final Widget button = await loadComponentPreview('button');
    expect(button, isA<Widget>());
    final Widget command = await loadComponentPreview('command');
    expect(command, isA<Widget>());
    expect(() => loadComponentPreview('not-a-component'), throwsArgumentError);
  });

  group('theme tokens', () {
    test('generated from the registry theme layer, camelCase + CSS var', () {
      // 32 ShadcnColors colour fields + the radius token.
      expect(kThemeTokens.length, 33);
      expect(kThemeTokens.first.name, 'background');
      expect(kThemeTokens.first.cssVar, '--background');
      expect(
        kThemeTokens
            .firstWhere((DocsThemeToken t) => t.name == 'cardForeground')
            .cssVar,
        '--card-foreground',
      );
      expect(
        kThemeTokens
            .firstWhere((DocsThemeToken t) => t.name == 'chart1')
            .cssVar,
        '--chart-1',
      );
      expect(kThemeTokens.last.name, 'radius');
      expect(kThemeTokens.last.cssVar, '--radius');
      // `brightness` is not a token.
      expect(
        kThemeTokens.where((DocsThemeToken t) => t.name == 'brightness'),
        isEmpty,
      );
    });
  });

  test('--check self-test: fresh passes, drift fails', () {
    Directory('.dart_tool').createSync(recursive: true);
    final Directory temp = Directory(
      '.dart_tool',
    ).createTempSync('docs_gen_selftest');
    addTearDown(() => temp.deleteSync(recursive: true));
    final List<String> args = <String>[
      '--registry',
      registry,
      '--out',
      '${temp.path}/gen',
      '--previews',
      '${temp.path}/previews/component_previews.dart',
    ];

    final StringBuffer out1 = StringBuffer();
    expect(runDocsGen(args, out: out1, err: StringBuffer()), 0);

    // The regenerated files are byte-identical to the checked-in ones.
    final Map<String, String> checkedIn = <String, String>{
      'lib/generated/docs_data.dart': '${temp.path}/gen/docs_data.dart',
      'lib/generated/docs_api.dart': '${temp.path}/gen/docs_api.dart',
      'lib/generated/docs_tables.dart': '${temp.path}/gen/docs_tables.dart',
      'lib/generated/docs_search.dart': '${temp.path}/gen/docs_search.dart',
      'lib/generated/docs_snippets.dart': '${temp.path}/gen/docs_snippets.dart',
      'lib/generated/app_theme.dart': '${temp.path}/gen/app_theme.dart',
      'lib/previews/component_previews.dart':
          '${temp.path}/previews/component_previews.dart',
    };
    for (final MapEntry<String, String> entry in checkedIn.entries) {
      expect(
        File(entry.value).readAsStringSync(),
        File(entry.key).readAsStringSync(),
        reason: entry.key,
      );
    }

    final StringBuffer checkOut = StringBuffer();
    expect(
      runDocsGen(
        <String>[...args, '--check'],
        out: checkOut,
        err: StringBuffer(),
      ),
      0,
    );
    expect(checkOut.toString(), contains('up to date'));

    File('${temp.path}/gen/docs_data.dart').writeAsStringSync('// drift\n');
    final StringBuffer driftOut = StringBuffer();
    final StringBuffer driftErr = StringBuffer();
    expect(
      runDocsGen(<String>[...args, '--check'], out: driftOut, err: driftErr),
      1,
    );
    expect(driftOut.toString(), contains('out of date'));
    expect(driftErr.toString(), contains('1 generated file(s) out of date'));
  });
}
