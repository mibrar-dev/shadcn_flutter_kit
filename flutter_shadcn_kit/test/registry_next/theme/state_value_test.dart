import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StateValue.resolve precedence', () {
    const value = StateValue<String>(
      rest: 'rest',
      hovered: 'hovered',
      pressed: 'pressed',
      focused: 'focused',
      selected: 'selected',
      disabled: 'disabled',
    );
    test('empty states resolve rest', () {
      expect(value.resolve({}), 'rest');
    });
    test('each state resolves its own cell', () {
      expect(value.resolve({WidgetState.hovered}), 'hovered');
      expect(value.resolve({WidgetState.pressed}), 'pressed');
      expect(value.resolve({WidgetState.focused}), 'focused');
      expect(value.resolve({WidgetState.selected}), 'selected');
      expect(value.resolve({WidgetState.disabled}), 'disabled');
    });
    test('disabled beats pressed beats hovered beats focused', () {
      expect(
        value.resolve({
          WidgetState.disabled,
          WidgetState.pressed,
          WidgetState.hovered,
        }),
        'disabled',
      );
      expect(
        value.resolve({WidgetState.pressed, WidgetState.hovered}),
        'pressed',
      );
      expect(
        value.resolve({WidgetState.hovered, WidgetState.focused}),
        'hovered',
      );
      expect(
        value.resolve({WidgetState.focused, WidgetState.selected}),
        'focused',
      );
    });
    test('a missing cell falls back to rest, never to another state', () {
      const sparse = StateValue<String>(rest: 'rest', hovered: 'hovered');
      expect(sparse.resolve({WidgetState.pressed}), 'rest');
      expect(sparse.resolve({WidgetState.hovered}), 'hovered');
      expect(
        const StateValue<String>().resolve({WidgetState.disabled}),
        isNull,
      );
    });
  });

  group('StateValue.merge', () {
    test('per-state first-non-null-wins with this winning', () {
      const over = StateValue<String>(hovered: 'over-hover');
      const base = StateValue<String>(rest: 'base-rest', hovered: 'base-hover');
      final merged = over.merge(base);
      expect(merged.rest, 'base-rest');
      expect(merged.hovered, 'over-hover');
    });
    test('null other returns this', () {
      const value = StateValue<String>(rest: 'rest');
      expect(value.merge(null), same(value));
    });
  });
}
