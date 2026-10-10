// D7 shell-state tests: mode handling plus the site-wide theme model.
//
// The model is a schema-v2 preset document (see `theme_document.dart`), so
// these tests cover what the pre-D7 scalar overrides used to cover (preset,
// radius, density) and what is new: every token group, persistence round-trip
// through localStorage, `Shuffle`, `Reset` and the `Open Preset` validation.

import 'dart:convert';

import 'package:docs/generated/docs_preset_sources.dart';
import 'package:docs/state/docs_state.dart';
import 'package:docs/theme/theme_document.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// In-memory [DocsStorage] so tests do not touch the platform bridge.
class MemoryDocsStorage extends DocsStorage {
  /// Creates a memory store, optionally pre-seeded.
  MemoryDocsStorage([Map<String, String>? seed])
    : values = <String, String>{...?seed};

  /// Stored key/value pairs.
  final Map<String, String> values;

  @override
  String? read(String key) => values[key];

  @override
  void write(String key, String value) => values[key] = value;
}

DocsState _state({DocsStorage? storage, Brightness? brightness}) =>
    DocsState(storage: storage ?? MemoryDocsStorage(), brightness: brightness);

void main() {
  test('defaults: neutral preset, system brightness, preset radius', () {
    final DocsState state = _state();
    addTearDown(state.dispose);
    expect(state.presetId, 'neutral');
    expect(state.followsSystem, isTrue);
    expect(state.brightness, Brightness.light, reason: 'unit-test platform');
    // The neutral preset's radius is 0.625 rem -> 10 px.
    expect(state.effectiveRadiusPx, 10);
    expect(state.theme.tokens.radius, 0.625);
    expect(state.theme.spacing.base, 4);
  });

  test('system brightness follows until an explicit mode is stored', () {
    final DocsState state = _state();
    addTearDown(state.dispose);
    int notifications = 0;
    state.addListener(() => notifications++);

    state.setSystemBrightness(Brightness.dark);
    expect(state.brightness, Brightness.dark);
    expect(notifications, 1);

    state.setSystemBrightness(Brightness.dark);
    expect(notifications, 1, reason: 'same value does not notify');

    state.setBrightness(Brightness.light);
    expect(state.brightness, Brightness.light);
    expect(state.followsSystem, isFalse);

    state.setSystemBrightness(Brightness.dark);
    expect(state.brightness, Brightness.light);
    expect(notifications, 2);
  });

  test('a preset switch reaches the shell through DocsState', () {
    final MemoryDocsStorage storage = MemoryDocsStorage();
    final DocsState state = _state(storage: storage);
    addTearDown(state.dispose);
    int notifications = 0;
    state.addListener(() => notifications++);

    state.setPreset('tangerine');
    expect(state.presetId, 'tangerine');
    expect(state.theme.colors.primary, const Color(0xFFE05D38));
    expect(notifications, 1, reason: 'the document travels through DocsState');

    // The document is the persisted source of truth, not the preset id.
    expect(storage.values[kDocsThemeDocumentKey], state.themeModel.json);
    expect(
      jsonDecode(storage.values[kDocsThemeDocumentKey]!),
      jsonDecode(kPresetSources['tangerine']!.json),
    );
  });

  test('every token group edits the live theme and the document', () {
    final MemoryDocsStorage storage = MemoryDocsStorage();
    final DocsState state = _state(storage: storage);
    addTearDown(state.dispose);
    final SiteThemeModel model = state.themeModel;

    model.setRadiusPx(16);
    expect(state.effectiveRadiusPx, 16);
    expect(state.theme.radiusLg, 16);

    model.setSpacingRem(0.3);
    expect(state.theme.spacing.base, closeTo(4.8, 1e-9));

    model.setColor('primary', '#FF0055');
    expect(state.theme.colors.primary, const Color(0xFFFF0055));

    model.setAccentColor(const Color(0xFF2563EB));
    expect(state.theme.colors.primary, isNot(const Color(0xFFFF0055)));

    model.setChartColors(const Color(0xFF16A34A));
    expect(state.theme.colors.chart1, isNot(state.theme.colors.chart2));

    model.setFont('sans', 'Inter, sans-serif');
    expect(state.theme.typography.sans.fontFamily, 'Inter');

    model.setShadow(
      Brightness.light,
      DocsShadowAtoms.fromJson(<String, Object?>{
        'color': '#000000',
        'opacity': 0.3,
        'blur': 12,
        'spread': -2,
        'offsetX': 0,
        'offsetY': 4,
      }, path: 'test'),
    );
    expect(state.theme.tokens.shadows.shadow2xs.length, 1);

    expect(
      storage.values[kDocsThemeDocumentKey],
      model.json,
      reason: 'every edit is persisted as the canonical document',
    );
  });

  test('no-op setters do not notify', () {
    final DocsState state = _state(brightness: Brightness.dark);
    addTearDown(state.dispose);
    int notifications = 0;
    state.addListener(() => notifications++);
    state.setPreset('neutral');
    state.setBrightness(Brightness.dark);
    state.themeModel.setRadiusPx(10);
    expect(notifications, 0);
  });

  test('persistence round-trips the whole document', () {
    final MemoryDocsStorage storage = MemoryDocsStorage();
    final DocsState first = _state(storage: storage);
    first.themeModel
      ..selectPreset('claude')
      ..setRadiusPx(4)
      ..setFont('mono', 'JetBrains Mono, monospace')
      ..setChartColors(const Color(0xFFEC4899));
    final String saved = first.themeModel.json;
    first.dispose();

    final DocsState second = _state(storage: storage)..restore();
    addTearDown(second.dispose);
    expect(second.presetId, 'claude');
    expect(second.effectiveRadiusPx, 4);
    expect(second.theme.typography.mono.fontFamily, 'JetBrains Mono');
    expect(second.themeModel.json, saved);
  });

  test('restore drops a broken document and keeps the default', () {
    final MemoryDocsStorage storage = MemoryDocsStorage(<String, String>{
      kDocsThemeDocumentKey: '{"id":"broken"}',
    });
    final DocsState state = _state(storage: storage)..restore();
    addTearDown(state.dispose);
    expect(state.presetId, 'neutral');
    expect(storage.values[kDocsThemeDocumentKey], isEmpty);
  });

  test('Open Preset rejects an invalid document and applies a valid one', () {
    final DocsState state = _state();
    addTearDown(state.dispose);
    final SiteThemeModel model = state.themeModel;

    expect(
      () => model.applyPresetJson('{"id":"x","schemaVersion":1}'),
      throwsA(isA<ThemeDocumentException>()),
    );
    expect(
      () => model.applyPresetJson('not json'),
      throwsA(isA<FormatException>()),
    );
    expect(
      model.presetId,
      'neutral',
      reason: 'a rejected paste changes nothing',
    );

    model.applyPresetJson(kPresetSources['ocean-breeze']!.json);
    expect(model.presetId, 'ocean-breeze');
    expect(model.matchedPresetId, 'ocean-breeze');
  });

  test(
    'Shuffle produces a valid non-preset document; Reset returns to neutral',
    () {
      final DocsState state = _state();
      addTearDown(state.dispose);
      final SiteThemeModel model = state.themeModel;

      model.shuffle();
      expect(model.presetId, 'shuffled');
      expect(model.matchedPresetId, isNull);
      expect(model.themeFor(Brightness.light).colors.primary, isNotNull);

      model.reset();
      expect(model.presetId, 'neutral');
      expect(model.json, kPresetSources['neutral']!.json);
    },
  );

  test('restore treats a stored "system" value as following the platform', () {
    final MemoryDocsStorage storage = MemoryDocsStorage(<String, String>{
      kDocsBrightnessKey: 'system',
    });
    final DocsState state = DocsState(
      storage: storage,
      systemBrightness: Brightness.dark,
    )..restore();
    addTearDown(state.dispose);
    expect(state.followsSystem, isTrue);
    expect(state.brightness, Brightness.dark);
  });

  test('an explicit mode is persisted and restored', () {
    final MemoryDocsStorage storage = MemoryDocsStorage();
    final DocsState first = _state(storage: storage);
    first.toggleBrightness();
    first.dispose();
    expect(storage.values[kDocsBrightnessKey], 'dark');
    final DocsState state = _state(storage: storage)..restore();
    addTearDown(state.dispose);
    expect(state.brightness, Brightness.dark);
    expect(state.followsSystem, isFalse);
  });

  test('preview example selection is kept per component', () {
    final DocsState state = _state();
    addTearDown(state.dispose);
    expect(state.previewExampleFor('button'), isNull);
    int notifications = 0;
    state.addListener(() => notifications++);
    state.setPreviewExample('button', 'Destructive');
    expect(state.previewExampleFor('button'), 'Destructive');
    expect(notifications, 1);
    state.setPreviewExample('button', 'Destructive');
    expect(notifications, 1, reason: 'same value does not notify');
    // Other components are independent.
    expect(state.previewExampleFor('badge'), isNull);
  });

  test('preview brightness toggle inverts only its own stage', () {
    final DocsState state = _state();
    addTearDown(state.dispose);
    expect(state.isPreviewInverted('button'), isFalse);
    int notifications = 0;
    state.addListener(() => notifications++);
    state.togglePreviewInverted('button');
    expect(state.isPreviewInverted('button'), isTrue);
    expect(notifications, 1);
    state.togglePreviewInverted('button');
    expect(state.isPreviewInverted('button'), isFalse);
    expect(notifications, 2);
    expect(state.isPreviewInverted('badge'), isFalse);
  });
}
