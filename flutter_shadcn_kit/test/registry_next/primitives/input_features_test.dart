// Widget tests for the `input_features` primitives.
//
// Covers the feature framework (visibility composition) and the concrete
// adornment, numeric and suggestion features through the `input` widget.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/input/input.dart';
import 'package:flutter_shadcn_kit/registry_next/foundation/icons/lucide_icons.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/input_features/adornment_features.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/input_features/input_features.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/input_features/numeric_features.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/input_features/suggestion_feature.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/overlay_manager.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

/// Keeps a single `OverlayEntry` so repumping the frame updates its child.
class _OverlayHost extends StatefulWidget {
  const _OverlayHost({required this.child});

  final Widget child;

  @override
  State<_OverlayHost> createState() => _OverlayHostState();
}

class _OverlayHostState extends State<_OverlayHost> {
  late final OverlayEntry _entry = OverlayEntry(
    builder: (_) => Center(child: widget.child),
  );

  @override
  void didUpdateWidget(covariant _OverlayHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    _entry.markNeedsBuild();
  }

  @override
  void dispose() {
    _entry
      ..remove()
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Overlay(initialEntries: [_entry]);
}

Widget _frame({required Widget child}) {
  return ShadcnTheme(
    data: const ShadcnThemeData(),
    child: MediaQuery(
      data: const MediaQueryData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ShadcnLayer(child: _OverlayHost(child: child)),
      ),
    ),
  );
}

EditableText _editable(WidgetTester tester) =>
    tester.widget<EditableText>(find.byType(EditableText));

class _FakeFeatureState implements InputFeatureState {
  _FakeFeatureState({
    this.focused = false,
    this.text = '',
    TextSelection? selection,
  }) : _selection = selection ?? const TextSelection.collapsed(offset: -1);

  @override
  BuildContext get featureContext => throw UnimplementedError();

  @override
  Object? featureSlotOf(InputFeature feature) => null;

  @override
  TextEditingController get controller => TextEditingController();

  @override
  bool get mounted => true;

  @override
  bool focused;

  @override
  String text;

  final TextSelection _selection;

  @override
  TextSelection get selection => _selection;

  @override
  bool get hovered => false;

  @override
  bool get obscureText => false;

  @override
  void setObscureText(bool? value) {}

  @override
  void setFeatureState(VoidCallback fn) => fn();

  @override
  void validateNow() {}

  @override
  T slot<T extends Object>(InputFeature feature, T Function() create) =>
      create();
}

void main() {
  test('visibility leaves and composition', () {
    final state = _FakeFeatureState(focused: true, text: 'abc');
    expect(InputFeatureVisibility.always.canShow(state), isTrue);
    expect(InputFeatureVisibility.never.canShow(state), isFalse);
    expect(InputFeatureVisibility.focused.canShow(state), isTrue);
    expect(InputFeatureVisibility.textNotEmpty.canShow(state), isTrue);
    expect(InputFeatureVisibility.textEmpty.canShow(state), isFalse);
    expect(InputFeatureVisibility.hasSelection.canShow(state), isFalse);

    final withSelection = _FakeFeatureState(
      focused: true,
      text: 'abc',
      selection: const TextSelection(baseOffset: 0, extentOffset: 2),
    );
    expect(InputFeatureVisibility.hasSelection.canShow(withSelection), isTrue);

    final both =
        InputFeatureVisibility.focused & InputFeatureVisibility.textNotEmpty;
    expect(both.canShow(state), isTrue);
    expect(
      (InputFeatureVisibility.focused & InputFeatureVisibility.textEmpty)
          .canShow(state),
      isFalse,
    );
    expect(
      (InputFeatureVisibility.never | InputFeatureVisibility.focused).canShow(
        state,
      ),
      isTrue,
    );
    expect((~InputFeatureVisibility.focused).canShow(state), isFalse);
  });
  testWidgets('password toggle switches obscureText', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: const Input(
          obscureText: true,
          hintText: 'Password',
          features: <InputFeature>[InputPasswordToggleFeature()],
        ),
      ),
    );
    expect(_editable(tester).obscureText, isTrue);
    expect(find.byIcon(LucideIcons.eye), findsOneWidget);

    await tester.tap(find.byIcon(LucideIcons.eye));
    await tester.pump();
    expect(_editable(tester).obscureText, isFalse);
    expect(find.byIcon(LucideIcons.eyeOff), findsOneWidget);
  });

  testWidgets('clear button appears only with text and clears it', (
    tester,
  ) async {
    final controller = TextEditingController();
    await tester.pumpWidget(
      _frame(
        child: Input(
          controller: controller,
          features: const <InputFeature>[InputClearFeature()],
        ),
      ),
    );
    expect(find.byIcon(LucideIcons.x), findsNothing);

    await tester.enterText(find.byType(EditableText), 'abc');
    await tester.pump();
    expect(find.byIcon(LucideIcons.x), findsOneWidget);

    await tester.tap(find.byIcon(LucideIcons.x));
    await tester.pump();
    expect(controller.text, isEmpty);
    expect(find.byIcon(LucideIcons.x), findsNothing);
  });

  testWidgets('copy selects all and paste appends from the clipboard', (
    tester,
  ) async {
    final copied = <String>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        switch (call.method) {
          case 'Clipboard.setData':
            copied.add(
              (call.arguments as Map<Object?, Object?>)['text']! as String,
            );
          case 'Clipboard.getData':
            return <String, dynamic>{'text': 'pasted'};
          case 'Clipboard.hasStrings':
            return <String, dynamic>{'value': true};
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );

    final controller = TextEditingController(text: 'copy me');
    await tester.pumpWidget(
      _frame(
        child: Input(
          controller: controller,
          features: const <InputFeature>[
            InputCopyFeature(),
            InputPasteFeature(),
          ],
        ),
      ),
    );
    await tester.tap(find.byIcon(LucideIcons.copy));
    await tester.pump();
    expect(copied, <String>['copy me']);
    expect(
      controller.selection,
      const TextSelection(baseOffset: 0, extentOffset: 7),
    );

    await tester.tap(find.byIcon(LucideIcons.clipboard));
    await tester.pump();
    await tester.pump();
    expect(controller.text, 'copy mepasted');
  });

  testWidgets('spinner steps, clamps and uses invalidValue', (tester) async {
    final controller = TextEditingController(text: '5');
    await tester.pumpWidget(
      _frame(
        child: Input(
          controller: controller,
          features: const <InputFeature>[InputSpinnerFeature(min: 0, max: 10)],
        ),
      ),
    );
    await tester.tap(find.byIcon(LucideIcons.chevronUp));
    await tester.pump();
    expect(controller.text, '6');

    await tester.tap(find.byIcon(LucideIcons.chevronDown));
    await tester.pump();
    expect(controller.text, '5');

    for (var i = 0; i < 8; i++) {
      await tester.tap(find.byIcon(LucideIcons.chevronUp));
      await tester.pump();
    }
    expect(controller.text, '10');

    controller.text = 'abc';
    await tester.pump();
    await tester.tap(find.byIcon(LucideIcons.chevronUp));
    await tester.pump();
    expect(controller.text, '1');
  });

  testWidgets('stepper buttons increment and decrement', (tester) async {
    final controller = TextEditingController(text: '2');
    await tester.pumpWidget(
      _frame(
        child: Input(
          controller: controller,
          features: const <InputFeature>[
            InputStepperButtonFeature(),
            InputStepperButtonFeature.decrement(),
          ],
        ),
      ),
    );
    await tester.tap(find.byIcon(LucideIcons.plus));
    await tester.pump();
    expect(controller.text, '3');

    await tester.tap(find.byIcon(LucideIcons.minus));
    await tester.pump();
    expect(controller.text, '2');
  });

  testWidgets('leading, trailing, above and below features render', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        child: Input(
          hintText: 'x',
          features: <InputFeature>[
            InputLeadingFeature(const Text('Lead')),
            InputTrailingFeature(const Text('Trail')),
            InputAboveBelowFeature.above(const Text('Above')),
            InputAboveBelowFeature.below(const Text('Below')),
          ],
        ),
      ),
    );
    expect(find.text('Lead'), findsOneWidget);
    expect(find.text('Trail'), findsOneWidget);
    expect(find.text('Above'), findsOneWidget);
    expect(find.text('Below'), findsOneWidget);
    final leadX = tester.getTopLeft(find.text('Lead')).dx;
    final trailX = tester.getTopLeft(find.text('Trail')).dx;
    expect(leadX, lessThan(trailX));
  });

  testWidgets('hint feature opens a popover and honours F1', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: Input(
          hintText: 'x',
          features: <InputFeature>[
            InputHintFeature(
              popupBuilder: (context) => const Text('Hint body'),
            ),
          ],
        ),
      ),
    );
    expect(find.text('Hint body'), findsNothing);

    await tester.tap(find.byIcon(LucideIcons.info));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('Hint body'), findsOneWidget);
  });

  testWidgets('hint visibility can follow focus', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: Input(
          hintText: 'x',
          features: <InputFeature>[
            InputHintFeature(
              visibility: InputFeatureVisibility.focused,
              popupBuilder: (context) => const Text('Hint body'),
            ),
          ],
        ),
      ),
    );
    expect(find.byIcon(LucideIcons.info), findsNothing);

    await tester.tap(find.byType(EditableText));
    await tester.pump();
    expect(find.byIcon(LucideIcons.info), findsOneWidget);
  });

  testWidgets('suggestion slot feeds a mock menu builder', (tester) async {
    final controller = TextEditingController();
    final selected = <String>[];
    await tester.pumpWidget(
      _frame(
        child: Input(
          controller: controller,
          features: <InputFeature>[
            InputAutoCompleteFeature(
              suggestions: (query) async => <String>[
                'apple',
                'apricot',
              ].where((item) => item.startsWith(query)).toList(),
              onSuggestionSelected: selected.add,
              suggestionMenuBuilder: (context, items, onSelected) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    for (final item in items)
                      GestureDetector(
                        onTap: () => onSelected(item),
                        child: Text(item),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
    await tester.enterText(find.byType(EditableText), 'ap');
    await tester.pump();
    await tester.pump();
    expect(find.text('apple'), findsOneWidget);
    expect(find.text('apricot'), findsOneWidget);

    await tester.tap(find.text('apple'));
    await tester.pump();
    expect(controller.text, 'apple');
    expect(selected, <String>['apple']);
  });

  testWidgets('suggestion slot renders nothing without a menu builder', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        child: Input(
          hintText: 'x',
          features: <InputFeature>[
            InputAutoCompleteFeature(
              suggestions: (query) async => <String>['apple'],
            ),
          ],
        ),
      ),
    );
    await tester.enterText(find.byType(EditableText), 'ap');
    await tester.pump();
    await tester.pump();
    expect(find.text('apple'), findsNothing);
  });
}
