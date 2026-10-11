// Widget tests for the `multiple_choice` component.
//
// Covers both scopes (single and multi), the controlled/controller modes, the
// `allowUnselect` four-leg resolution, form participation and the old
// "cannot move off an existing selection" bug.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/multiple_choice/multiple_choice.dart';
import 'package:flutter_shadcn_kit/registry/foundation/data.dart';
import 'package:flutter_shadcn_kit/registry/primitives/clickable.dart';
import 'package:flutter_shadcn_kit/registry/primitives/form_core/form_core.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame({
  required Widget child,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  MultipleChoiceTheme? scoped,
  FormFieldHandle? formHandle,
}) {
  Widget body = child;
  if (scoped != null) {
    body = ComponentTheme<MultipleChoiceTheme>(data: scoped, child: body);
  }
  if (formHandle != null) {
    body = Data<FormFieldHandle>.inherit(data: formHandle, child: body);
  }
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: body),
      ),
    ),
  );
}

/// A minimal choice item: selecting through the scope, rendering with the
/// ambient theme.
class _Item extends StatelessWidget {
  const _Item(this.value);

  final String value;

  @override
  Widget build(BuildContext context) {
    return Clickable(
      padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
        EdgeInsets.all(4),
      ),
      onPressed: () => Choice.choose<String>(context, value),
      child: Text(value),
    );
  }
}

/// Renders the selection seen through the nearest scope.
class _Selection extends StatelessWidget {
  const _Selection();

  @override
  Widget build(BuildContext context) {
    final Iterable<String>? value = Choice.getValue<String>(context);
    return Text('selection:${value == null ? 'none' : value.join('+')}');
  }
}

class _FakeFormHandle with FormFieldHandle {
  final List<Object?> reported = <Object?>[];
  Object? replaceWith;

  @override
  final FormKey<Object?> formKey = const FormKey<Object?>('multiple_choice');

  @override
  bool get mounted => true;

  @override
  ValueListenable<ValidationResult?>? get validity => null;

  @override
  FutureOr<ValidationResult?> reportNewFormValue<T>(T? value) {
    reported.add(value);
    final Object? replacement = replaceWith;
    if (replacement == null) {
      return null;
    }
    return ReplaceResult<T>(
      replacement as T,
      state: FormValidationMode.changed,
    );
  }

  @override
  FutureOr<ValidationResult?> revalidate() => null;
}

void main() {
  group('MultipleChoice', () {
    testWidgets('renders under light and dark tokens', (tester) async {
      for (final ShadcnThemeData data in <ShadcnThemeData>[
        const ShadcnThemeData(),
        const ShadcnThemeData(colors: ShadcnColors.darkFallback),
      ]) {
        await tester.pumpWidget(
          _frame(
            data: data,
            child: MultipleChoice<String>(
              value: 'A',
              onChanged: (_) {},
              child: const Row(children: <Widget>[_Item('A'), _Selection()]),
            ),
          ),
        );
        expect(find.text('selection:A'), findsOneWidget);
      }
    });

    testWidgets('regression: a new tap replaces the current selection', (
      tester,
    ) async {
      final List<String?> changes = <String?>[];
      await tester.pumpWidget(
        _frame(
          child: MultipleChoice<String>(
            value: 'A',
            onChanged: changes.add,
            child: const Row(children: <Widget>[_Item('A'), _Item('B')]),
          ),
        ),
      );
      await tester.tap(find.text('B'));
      // The old state returned early when a value was set, so B was ignored.
      expect(changes, <String?>['B']);
    });

    testWidgets('re-selecting clears only when allowUnselect is on', (
      tester,
    ) async {
      final List<String?> changes = <String?>[];
      await tester.pumpWidget(
        _frame(
          child: MultipleChoice<String>(
            value: 'A',
            onChanged: changes.add,
            allowUnselect: true,
            child: const _Item('A'),
          ),
        ),
      );
      await tester.tap(find.text('A'));
      expect(changes, <String?>[null]);

      changes.clear();
      await tester.pumpWidget(
        _frame(
          child: MultipleChoice<String>(
            value: 'A',
            onChanged: changes.add,
            child: const _Item('A'),
          ),
        ),
      );
      await tester.tap(find.text('A'));
      expect(changes, isEmpty, reason: 'defaults keep the selection');
    });

    testWidgets('allowUnselect resolves through all four legs', (tester) async {
      Future<List<String?>> tapSelected({
        List<ComponentThemeData>? app,
        MultipleChoiceTheme? scoped,
        bool? widgetArg,
      }) async {
        final List<String?> changes = <String?>[];
        await tester.pumpWidget(
          _frame(
            app: app ?? const <ComponentThemeData>[],
            scoped: scoped,
            child: MultipleChoice<String>(
              value: 'A',
              onChanged: changes.add,
              allowUnselect: widgetArg,
              child: const _Item('A'),
            ),
          ),
        );
        await tester.tap(find.text('A'));
        return changes;
      }

      // app leg beats defaults (false -> true)
      expect(
        await tapSelected(
          app: const <ComponentThemeData>[
            MultipleChoiceTheme(allowUnselect: true),
          ],
        ),
        <String?>[null],
      );
      // tree leg beats the app leg
      expect(
        await tapSelected(
          app: const <ComponentThemeData>[
            MultipleChoiceTheme(allowUnselect: true),
          ],
          scoped: const MultipleChoiceTheme(allowUnselect: false),
        ),
        isEmpty,
      );
      // widget argument beats the tree leg
      expect(
        await tapSelected(
          scoped: const MultipleChoiceTheme(allowUnselect: false),
          widgetArg: true,
        ),
        <String?>[null],
      );
    });

    testWidgets('controller mode owns the selection', (tester) async {
      final MultipleChoiceController<String> controller =
          MultipleChoiceController<String>('A');
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _frame(
          child: MultipleChoice<String>(
            controller: controller,
            child: const Row(children: <Widget>[_Item('B'), _Selection()]),
          ),
        ),
      );
      expect(find.text('selection:A'), findsOneWidget);

      await tester.tap(find.text('B'));
      expect(controller.value, 'B');
      await tester.pump();
      expect(find.text('selection:B'), findsOneWidget);
    });

    testWidgets('a disabled scope ignores taps', (tester) async {
      final List<String?> changes = <String?>[];
      await tester.pumpWidget(
        _frame(
          child: MultipleChoice<String>(
            value: 'A',
            onChanged: changes.add,
            enabled: false,
            child: const _Item('B'),
          ),
        ),
      );
      await tester.tap(find.text('B'));
      expect(changes, isEmpty);
    });

    testWidgets('a form handle receives and can replace the value', (
      tester,
    ) async {
      final _FakeFormHandle handle = _FakeFormHandle();
      final List<String?> changes = <String?>[];
      Widget build(String? value) => _frame(
        formHandle: handle,
        child: MultipleChoice<String>(
          value: value,
          onChanged: changes.add,
          child: const _Item('B'),
        ),
      );

      await tester.pumpWidget(build('A'));
      expect(handle.reported.last, 'A');

      // Reporting a new value lets the handle replace it; the replacement
      // flows back through `didReplaceFormValue`.
      handle.replaceWith = 'C';
      await tester.pumpWidget(build('B'));
      await tester.pump(); // apply the post-frame replacement
      expect(changes, contains('C'));
    });
  });

  group('MultipleAnswer', () {
    testWidgets('adds and removes items by default', (tester) async {
      final List<Iterable<String>?> changes = <Iterable<String>?>[];
      Widget build(Iterable<String>? value) => _frame(
        child: MultipleAnswer<String>(
          value: value,
          onChanged: changes.add,
          child: const Row(children: <Widget>[_Item('A'), _Item('B')]),
        ),
      );

      await tester.pumpWidget(build(<String>['A']));
      await tester.tap(find.text('B'));
      expect(changes.last, <String>['A', 'B']);

      // Controlled mode: the parent feeds the new value back.
      await tester.pumpWidget(build(changes.last));
      await tester.tap(find.text('A'));
      expect(changes.last, <String>['B']);
    });

    testWidgets('allowUnselect false keeps selected items', (tester) async {
      final List<Iterable<String>?> changes = <Iterable<String>?>[];
      await tester.pumpWidget(
        _frame(
          child: MultipleAnswer<String>(
            value: <String>['A'],
            onChanged: changes.add,
            allowUnselect: false,
            child: const _Item('A'),
          ),
        ),
      );
      await tester.tap(find.text('A'));
      expect(changes, isEmpty);
    });

    testWidgets('the answer default is unselect-true and resolves legs', (
      tester,
    ) async {
      final List<Iterable<String>?> changes = <Iterable<String>?>[];
      await tester.pumpWidget(
        _frame(
          app: const <ComponentThemeData>[
            MultipleChoiceTheme(allowUnselect: false),
          ],
          child: MultipleAnswer<String>(
            value: <String>['A'],
            onChanged: changes.add,
            child: const _Item('A'),
          ),
        ),
      );
      await tester.tap(find.text('A'));
      expect(changes, isEmpty, reason: 'app leg overrides the true default');

      await tester.pumpWidget(
        _frame(
          app: const <ComponentThemeData>[
            MultipleChoiceTheme(allowUnselect: false),
          ],
          child: MultipleAnswer<String>(
            value: <String>['A'],
            onChanged: changes.add,
            allowUnselect: true,
            child: const _Item('A'),
          ),
        ),
      );
      await tester.tap(find.text('A'));
      expect(changes.last, isEmpty);
    });

    testWidgets('controller mode owns the values', (tester) async {
      final MultipleAnswerController<String> controller =
          MultipleAnswerController<String>(<String>['A']);
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _frame(
          child: MultipleAnswer<String>(
            controller: controller,
            child: const _Item('B'),
          ),
        ),
      );
      await tester.tap(find.text('B'));
      expect(controller.value, <String>['A', 'B']);
    });
  });
}
