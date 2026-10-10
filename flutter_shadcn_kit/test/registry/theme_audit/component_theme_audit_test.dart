// Theme audit: components must follow the selected preset's tokens.
//
// Two verification paths, because components paint two different ways:
//
//  * `paintTokens` — the component paints with Container/DecoratedBox
//    decorations and Text styles. The rendered tree is scanned for each
//    required token under every preset/brightness pair.
//  * `themeColor` — the component paints inside a CustomPainter (progress,
//    slider, switch, checkbox) or only shows on interaction (tooltip), so no
//    decoration reaches the tree. Its theme default is inspected instead: the
//    default must be a token *reference* (not a literal) and must resolve to
//    that preset's token color.
//
// Presets: neutral (baseline), claude (the user-reported bug), tangerine
// (saturated).

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shadcn_kit/registry/components/button/button.dart';
import 'package:flutter_shadcn_kit/registry/components/card/card.dart';
import 'package:flutter_shadcn_kit/registry/components/badge/badge.dart';
import 'package:flutter_shadcn_kit/registry/components/input/input.dart';
import 'package:flutter_shadcn_kit/registry/components/switch/switch.dart';
import 'package:flutter_shadcn_kit/registry/components/checkbox/checkbox.dart';
import 'package:flutter_shadcn_kit/registry/components/progress/progress.dart';
import 'package:flutter_shadcn_kit/registry/components/slider/slider.dart';
import 'package:flutter_shadcn_kit/registry/components/tabs/tabs.dart';
import 'package:flutter_shadcn_kit/registry/components/accordion/accordion.dart';
import 'package:flutter_shadcn_kit/registry/components/alert/alert.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';

import 'theme_audit_helpers.dart';

/// One audited component.
class ComponentCase {
  const ComponentCase(this.id, this.build, {this.paintTokens, this.themeColor});

  final String id;
  final Widget Function() build;

  /// Tokens the rendered tree must contain, for decoration-based components.
  final List<ColorRef>? paintTokens;

  /// The component's default colour for its primary role, for
  /// painter-based components. Must be a token reference.
  final ThemedColor? themeColor;
}

const List<String> kPresets = [kNeutralPreset, kClaudePreset, kTangerinePreset];

void main() {
  final cases = <ComponentCase>[
    ComponentCase(
      'button',
      () => Button(
        variant: ButtonVariant.primary,
        onPressed: () {},
        child: const Text('Primary'),
      ),
      paintTokens: const [ColorRef.primary, ColorRef.primaryForeground],
    ),
    ComponentCase(
      'card',
      () => const Card(child: Text('Card content')),
      paintTokens: const [ColorRef.card],
    ),
    ComponentCase(
      'badge',
      () => const Badge(variant: BadgeVariant.primary, child: Text('Badge')),
      paintTokens: const [ColorRef.primary, ColorRef.primaryForeground],
    ),
    ComponentCase(
      'input',
      () => const Input(placeholder: Text('Enter text')),
      paintTokens: const [ColorRef.input],
    ),
    ComponentCase(
      'alert',
      () => const Alert(
        title: Text('Alert title'),
        content: Text('Alert content'),
      ),
      paintTokens: const [ColorRef.card, ColorRef.border],
    ),
    ComponentCase(
      'accordion',
      () => const Accordion(
        items: [
          AccordionItem(trigger: Text('Section 1'), content: Text('Content 1')),
        ],
      ),
      themeColor: accordionDefaults.dividerColor,
    ),
    ComponentCase(
      'tabs',
      () => Tabs(
        index: 0,
        onChanged: (_) {},
        children: const [
          TabItem(child: Text('Tab 1')),
          TabItem(child: Text('Tab 2')),
        ],
      ),
      paintTokens: const [ColorRef.muted, ColorRef.mutedForeground],
    ),
    ComponentCase(
      'progress',
      () => const Progress(value: 0.5),
      themeColor: progressDefaults.color,
    ),
    ComponentCase(
      'slider',
      () => Slider(value: 0.5, onChanged: (_) {}),
      themeColor: sliderDefaults.standard!.fill!.resolve(const <WidgetState>{}),
    ),
    ComponentCase(
      'switch',
      () => Switch(value: true, onChanged: (_) {}),
      themeColor: switchDefaults.on!.trackColor!.resolve(const <WidgetState>{}),
    ),
    ComponentCase(
      'checkbox',
      () => Checkbox(value: CheckboxValue.checked, onChanged: (_) {}),
      themeColor: checkboxDefaults.checked!.indicatorColor!,
    ),
  ];

  group('Component theme audit - rendered tree', () {
    for (final preset in kPresets) {
      for (final brightness in Brightness.values) {
        for (final testCase in cases.where((c) => c.paintTokens != null)) {
          testWidgets('${testCase.id} follows $preset $brightness', (
            tester,
          ) async {
            await pumpUnderPreset(
              tester,
              presetId: preset,
              brightness: brightness,
              child: testCase.build(),
            );

            final data = ShadcnTheme.of(
              tester.element(find.byType(Directionality).first),
            );
            final painted = allRenderedColors(tester);
            expect(
              painted,
              isNotEmpty,
              reason:
                  '${testCase.id} rendered no colors under '
                  '$preset $brightness',
            );

            for (final ref in testCase.paintTokens!) {
              expect(
                painted.contains(ref.resolve(data.colors)),
                isTrue,
                reason:
                    '${testCase.id} should paint token ${ref.name} under '
                    '$preset $brightness',
              );
            }
          });
        }
      }
    }
  });

  group('Component theme audit - theme defaults', () {
    for (final preset in kPresets) {
      for (final brightness in Brightness.values) {
        for (final testCase in cases.where((c) => c.themeColor != null)) {
          testWidgets('${testCase.id} default is a token ref ($preset '
              '$brightness)', (tester) async {
            await pumpUnderPreset(
              tester,
              presetId: preset,
              brightness: brightness,
              child: testCase.build(),
            );

            final data = ShadcnTheme.of(
              tester.element(find.byType(Directionality).first),
            );
            final color = testCase.themeColor!;

            expect(
              color,
              isA<RefColor>(),
              reason:
                  '${testCase.id} default must be a token reference so a '
                  'preset switch restyles it, not a literal colour',
            );

            // The resolved colour must be the preset's own token, so it moves
            // with the preset instead of staying fixed.
            final resolved = color.resolve(data.colors);
            expect(
              data.colors.primary == resolved ||
                  data.colors.secondary == resolved ||
                  data.colors.background == resolved ||
                  data.colors.input == resolved ||
                  data.colors.muted == resolved ||
                  data.colors.primaryForeground == resolved ||
                  data.colors.mutedForeground == resolved ||
                  data.colors.foreground == resolved,
              isTrue,
              reason:
                  '${testCase.id} default resolved to '
                  '${resolved.toARGB32().toRadixString(16)}, which is not a '
                  '$preset $brightness colour token',
            );
          });
        }
      }
    }
  });
}
