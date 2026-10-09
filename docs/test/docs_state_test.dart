import 'package:docs/state/docs_state.dart';
import 'package:docs/ui/shadcn/theme/theme.dart';
import 'package:docs/ui/shadcn/theme/tokens.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// In-memory [DocsStorage] so tests do not touch the platform bridge.
class MemoryDocsStorage extends DocsStorage {
  MemoryDocsStorage([Map<String, String>? seed])
    : values = <String, String>{...?seed};

  final Map<String, String> values;

  @override
  String? read(String key) => values[key];

  @override
  void write(String key, String value) => values[key] = value;
}

DocsState _state({DocsStorage? storage}) => DocsState(
  resolveTheme: (String preset, Brightness brightness) =>
      const ShadcnThemeData(tokens: ShadcnTokens(radius: 0.5)),
  storage: storage ?? MemoryDocsStorage(),
);

void main() {
  test('defaults follow the design: modern-minimal, dark, preset radius', () {
    final DocsState state = _state();
    addTearDown(state.dispose);
    expect(state.presetId, 'modern-minimal');
    expect(state.brightness, Brightness.dark);
    expect(state.radiusPx, isNull);
    expect(state.densityScale, 1);
    expect(state.effectiveRadiusPx, 8);
    expect(state.theme.tokens.radius, 0.5);
  });

  test('setters notify, clamp and persist', () {
    final MemoryDocsStorage storage = MemoryDocsStorage();
    final DocsState state = _state(storage: storage);
    addTearDown(state.dispose);
    int notifications = 0;
    state.addListener(() => notifications++);

    state.setPreset('tangerine');
    expect(state.presetId, 'tangerine');
    expect(storage.values[kDocsPresetKey], 'tangerine');

    state.setRadiusPx(32); // clamps to 16
    expect(state.radiusPx, 16);
    expect(state.theme.radiusLg, 16);
    expect(storage.values[kDocsRadiusKey], '16.0');

    state.setRadiusPx(null);
    expect(state.radiusPx, isNull);
    expect(state.effectiveRadiusPx, 8);

    state.setDensityScale(2); // clamps to 1.15
    expect(state.densityScale, 1.15);
    expect(state.theme.density.baseGap, closeTo(8 * 1.15, 1e-9));

    state.toggleBrightness();
    expect(state.brightness, Brightness.light);
    expect(storage.values[kDocsBrightnessKey], 'light');

    expect(notifications, 5);
  });

  test('no-op setters do not notify', () {
    final DocsState state = _state();
    addTearDown(state.dispose);
    int notifications = 0;
    state.addListener(() => notifications++);
    state.setPreset('modern-minimal');
    state.setBrightness(Brightness.dark);
    state.setRadiusPx(null);
    state.setDensityScale(1);
    expect(notifications, 0);
  });

  test('restore applies persisted values once', () {
    final MemoryDocsStorage storage = MemoryDocsStorage(<String, String>{
      kDocsPresetKey: 'claude',
      kDocsBrightnessKey: 'light',
      kDocsRadiusKey: '12.5',
      kDocsDensityKey: '0.9',
    });
    final DocsState state = _state(storage: storage);
    addTearDown(state.dispose);
    int notifications = 0;
    state.addListener(() => notifications++);

    state.restore();
    expect(state.presetId, 'claude');
    expect(state.brightness, Brightness.light);
    expect(state.radiusPx, 12.5);
    expect(state.densityScale, 0.9);
    expect(notifications, 1);

    state.restore(); // unchanged: no extra notification.
    expect(notifications, 1);
  });
}
