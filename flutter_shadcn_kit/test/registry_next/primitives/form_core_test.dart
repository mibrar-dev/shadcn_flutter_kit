import 'dart:async';

import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/foundation/data.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/form_core/form_control.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/form_core/form_core.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/form_core/form_value.dart';
import 'package:flutter_test/flutter_test.dart';

const _email = FormKey<String>('email');
const _age = FormKey<int>('age');
const _agreed = FormKey<bool>('agreed');

/// A form field stand-in that records what the supplier reported to it.
class _FakeFieldHandle with FormFieldHandle {
  _FakeFieldHandle(this.formKey);

  @override
  final FormKey formKey;

  @override
  bool mounted = true;

  final reported = <Object?>[];

  FutureOr<ValidationResult?> Function(dynamic value)? onReport;

  @override
  FutureOr<ValidationResult?> reportNewFormValue<T>(T? value) {
    reported.add(value);
    return onReport?.call(value);
  }

  @override
  FutureOr<ValidationResult?> revalidate() => onReport?.call(null);

  @override
  ValueListenable<ValidationResult?>? get validity => null;
}

/// Runs one frame.
///
/// [FormValueSupplier] applies replacements from a post-frame callback, and the
/// test binding only draws a frame when one is scheduled, so the tests that
/// assert on replacements schedule it explicitly.
Future<void> pumpFrame(WidgetTester tester) async {
  tester.binding.scheduleFrame();
  await tester.pump();
}

/// Wraps [child] in the minimum a [Text] needs to lay out.
Widget _app(Widget child) =>
    Directionality(textDirection: TextDirection.ltr, child: child);

void main() {
  group('FormKey', () {
    test('compares and hashes on the wrapped identity', () {
      expect(_email, const FormKey<String>('email'));
      expect(_email, isNot(const FormKey<String>('other')));
      expect(_email.hashCode, 'email'.hashCode);
      expect(_email.toString(), 'FormKey(email)');
    });

    test('equality ignores the type parameter, as in the old registry', () {
      // Both copies compared only the wrapped key, so two FormKeys for the same
      // field name are the same key even when their value types differ.
      expect(_email, const FormKey<int>('email'));
      expect(<FormKey, String>{_email: 'x'}[const FormKey<int>('email')], 'x');
    });

    test('exposes its type parameter and tests values against it', () {
      expect(_age.type, int);
      expect(_age.isInstanceOf(3), isTrue);
      expect(_age.isInstanceOf('3'), isFalse);
      expect(_agreed.isInstanceOf(null), isFalse);
    });

    test('reads its value from FormMapValues by getValue and operator []', () {
      final FormMapValues values = <FormKey, dynamic>{_email: 'a@b.c', _age: 3};
      expect(_email.getValue(values), 'a@b.c');
      expect(values[_email], 'a@b.c');
      expect(_age.getValue(values), 3);
    });

    test('returns null for an absent key', () {
      expect(_email.getValue(const {}), isNull);
    });

    test('getValue asserts when the stored value has the wrong type', () {
      final FormMapValues values = <FormKey, dynamic>{_email: 42};
      expect(() => _email.getValue(values), throwsAssertionError);
    });
  });

  group('ValidationResult', () {
    test('carries the mode that produced it', () {
      const result = ReplaceResult<String>(
        'x',
        state: FormValidationMode.submitted,
      );
      expect(result.state, FormValidationMode.submitted);
    });

    test('attach binds the key and keeps the payload', () {
      const result = ReplaceResult<String>(
        'trimmed',
        state: FormValidationMode.changed,
      );
      final attached = result.attach(_email);
      expect(attached.key, _email);
      expect(attached.value, 'trimmed');
      expect(attached.state, FormValidationMode.changed);
    });

    test('the attached constructor takes the key directly', () {
      const result = ReplaceResult.attached(
        1,
        key: _age,
        state: FormValidationMode.initial,
      );
      expect(result.key, _age);
      expect(result.value, 1);
    });

    test('reading the key before attaching asserts', () {
      const result = ReplaceResult<int>(1, state: FormValidationMode.initial);
      expect(() => result.key, throwsAssertionError);
    });

    test('FormValidationMode keeps its three cases in order', () {
      expect(FormValidationMode.values, [
        FormValidationMode.initial,
        FormValidationMode.changed,
        FormValidationMode.submitted,
      ]);
    });
  });

  group('FormPendingBuilder', () {
    testWidgets('builds with an empty pending map and the given child', (
      tester,
    ) async {
      const child = Text('child');
      Map<FormKey, Future<ValidationResult?>>? seenPending;
      Widget? seenChild;

      await tester.pumpWidget(
        _app(
          FormPendingBuilder(
            child: child,
            builder: (context, pending, widgetChild) {
              seenPending = pending;
              seenChild = widgetChild;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(seenPending, isEmpty);
      expect(seenChild, same(child));
    });
  });

  group('FormValueSupplier', () {
    testWidgets('reports the assigned value to the nearest field handle', (
      tester,
    ) async {
      final handle = _FakeFieldHandle(_email);
      final field = GlobalKey<_StringFieldState>();
      await tester.pumpWidget(
        _app(
          Data<FormFieldHandle>.inherit(
            data: handle,
            child: _StringField(key: field),
          ),
        ),
      );

      expect(field.currentState!.formValue, isNull);
      // Registering with the form reports the (still empty) current value once.
      expect(handle.reported, [null]);

      field.currentState!.formValue = 'hello';
      await tester.pump();

      expect(handle.reported, [null, 'hello']);
      expect(field.currentState!.formValue, 'hello');
    });

    testWidgets('does not re-report an unchanged value', (tester) async {
      final handle = _FakeFieldHandle(_email);
      final field = GlobalKey<_StringFieldState>();
      await tester.pumpWidget(
        _app(
          Data<FormFieldHandle>.inherit(
            data: handle,
            child: _StringField(key: field),
          ),
        ),
      );

      handle.reported.clear();

      field.currentState!.formValue = 'a';
      field.currentState!.formValue = 'a';
      field.currentState!.formValue = 'b';
      await tester.pump();

      expect(handle.reported, ['a', 'b']);
    });

    testWidgets('reports nothing when there is no form above', (tester) async {
      final field = GlobalKey<_StringFieldState>();
      await tester.pumpWidget(_app(_StringField(key: field)));

      field.currentState!.formValue = 'orphan';
      await tester.pump();

      expect(field.currentState!.formValue, 'orphan');
    });

    testWidgets('applies a synchronous ReplaceResult after the frame', (
      tester,
    ) async {
      final handle = _FakeFieldHandle(_email)
        // Only answer real edits, so the registration report stays quiet.
        ..onReport = (value) => value == null
            ? null
            : ReplaceResult<String>.attached(
                'trimmed',
                key: _email,
                state: FormValidationMode.changed,
              );
      final field = GlobalKey<_StringFieldState>();
      await tester.pumpWidget(
        _app(
          Data<FormFieldHandle>.inherit(
            data: handle,
            child: _StringField(key: field),
          ),
        ),
      );

      field.currentState!.formValue = '  padded  ';
      expect(
        field.currentState!.replaced,
        isEmpty,
        reason: 'applied after the frame',
      );

      await pumpFrame(tester);
      expect(field.currentState!.replaced, ['trimmed']);
    });

    testWidgets('applies an asynchronous ReplaceResult', (tester) async {
      final completer = Completer<ValidationResult?>();
      var answered = false;
      final handle = _FakeFieldHandle(_email)
        // Answer one report only: re-answering would loop, because the test's
        // didReplaceFormValue assigns the replaced value back to formValue.
        ..onReport = (value) {
          if (value == null || answered) return null;
          answered = true;
          return completer.future;
        };
      final field = GlobalKey<_StringFieldState>();
      await tester.pumpWidget(
        _app(
          Data<FormFieldHandle>.inherit(
            data: handle,
            child: _StringField(key: field),
          ),
        ),
      );

      field.currentState!.formValue = 'async';
      completer.complete(
        ReplaceResult<String>.attached(
          'async-trimmed',
          key: _email,
          state: FormValidationMode.changed,
        ),
      );
      await pumpFrame(tester);
      await pumpFrame(tester);

      expect(field.currentState!.replaced, ['async-trimmed']);
    });

    testWidgets('drops a stale async result once a newer value is reported', (
      tester,
    ) async {
      final first = Completer<ValidationResult?>();
      final second = Completer<ValidationResult?>();
      var call = 0;
      final handle = _FakeFieldHandle(_email)
        ..onReport = (value) {
          if (value == null || call > 1) return null;
          return call++ == 0 ? first.future : second.future;
        };
      final field = GlobalKey<_StringFieldState>();
      await tester.pumpWidget(
        _app(
          Data<FormFieldHandle>.inherit(
            data: handle,
            child: _StringField(key: field),
          ),
        ),
      );

      field.currentState!.formValue = 'one';
      field.currentState!.formValue = 'two';

      first.complete(
        ReplaceResult<String>.attached(
          'stale',
          key: _email,
          state: FormValidationMode.changed,
        ),
      );
      second.complete(
        ReplaceResult<String>.attached(
          'fresh',
          key: _email,
          state: FormValidationMode.changed,
        ),
      );
      await pumpFrame(tester);
      await pumpFrame(tester);

      expect(field.currentState!.replaced, ['fresh']);
    });
  });

  group('ControlledComponentAdapter', () {
    testWidgets('uncontrolled: initialValue seeds the widget and updates it', (
      tester,
    ) async {
      final changes = <String>[];
      await tester.pumpWidget(
        _app(
          ControlledComponentAdapter<String>(
            initialValue: 'a',
            onChanged: changes.add,
            builder: (context, data) => GestureDetector(
              onTap: () => data.onChanged('b'),
              child: Text(data.value, textDirection: TextDirection.ltr),
            ),
          ),
        ),
      );

      expect(find.text('a'), findsOneWidget);
      await tester.tap(find.text('a'));
      await tester.pump();

      expect(find.text('b'), findsOneWidget);
      expect(changes, ['b']);
    });

    testWidgets('controlled: the controller is the source of truth', (
      tester,
    ) async {
      final controller = ComponentValueController<String>('a');
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _app(
          ControlledComponentAdapter<String>(
            controller: controller,
            builder: (context, data) => GestureDetector(
              onTap: () => data.onChanged('b'),
              child: Text(data.value, textDirection: TextDirection.ltr),
            ),
          ),
        ),
      );

      expect(find.text('a'), findsOneWidget);

      // A programmatic change on the controller must reach the widget.
      controller.value = 'external';
      await tester.pump();
      expect(find.text('external'), findsOneWidget);

      // A widget-driven change must reach the controller.
      await tester.tap(find.text('external'));
      await tester.pump();
      expect(controller.value, 'b');
      expect(find.text('b'), findsOneWidget);
    });

    testWidgets('enabled: false is reported to the builder', (tester) async {
      late bool enabled;
      await tester.pumpWidget(
        _app(
          ControlledComponentAdapter<int>(
            initialValue: 0,
            enabled: false,
            builder: (context, data) {
              enabled = data.enabled;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(enabled, isFalse);
    });

    test('asserts when neither controller nor initialValue is given', () {
      expect(
        () => ControlledComponentAdapter<int>(
          builder: (context, data) => const SizedBox.shrink(),
        ),
        throwsAssertionError,
      );
    });

    testWidgets('swapping the controller re-reads its value', (tester) async {
      final first = ComponentValueController<String>('first');
      final second = ComponentValueController<String>('second');
      addTearDown(first.dispose);
      addTearDown(second.dispose);

      Widget build(ComponentController<String> controller) => _app(
        ControlledComponentAdapter<String>(
          controller: controller,
          builder: (context, data) =>
              Text(data.value, textDirection: TextDirection.ltr),
        ),
      );

      await tester.pumpWidget(build(first));
      expect(find.text('first'), findsOneWidget);

      await tester.pumpWidget(build(second));
      expect(find.text('second'), findsOneWidget);

      // The old controller must no longer drive the widget.
      first.value = 'ignored';
      await tester.pump();
      expect(find.text('second'), findsOneWidget);
    });

    testWidgets('dropping the controller keeps the current value', (
      tester,
    ) async {
      final controller = ComponentValueController<String>('from-controller');
      addTearDown(controller.dispose);

      Widget build({
        ComponentController<String>? controller,
        String? initial,
      }) => _app(
        ControlledComponentAdapter<String>(
          controller: controller,
          initialValue: initial,
          builder: (context, data) =>
              Text(data.value, textDirection: TextDirection.ltr),
        ),
      );

      await tester.pumpWidget(build(controller: controller));
      expect(find.text('from-controller'), findsOneWidget);

      // Controlled -> uncontrolled: the value stays put instead of snapping
      // back to initialValue.
      await tester.pumpWidget(build(initial: 'seed'));
      expect(find.text('from-controller'), findsOneWidget);

      // The dropped controller no longer drives the widget.
      controller.value = 'ignored';
      await tester.pump();
      expect(find.text('from-controller'), findsOneWidget);

      // ...and the adapter is genuinely uncontrolled now: edits apply locally.
      await tester.pumpWidget(build(initial: 'seed'));
      expect(find.text('from-controller'), findsOneWidget);
    });

    testWidgets('adding a controller takes over from initialValue', (
      tester,
    ) async {
      final controller = ComponentValueController<String>('from-controller');
      addTearDown(controller.dispose);

      Widget build({ComponentController<String>? controller}) => _app(
        ControlledComponentAdapter<String>(
          controller: controller,
          initialValue: 'seed',
          builder: (context, data) =>
              Text(data.value, textDirection: TextDirection.ltr),
        ),
      );

      // Uncontrolled -> controlled: the controller wins.
      await tester.pumpWidget(build());
      expect(find.text('seed'), findsOneWidget);

      await tester.pumpWidget(build(controller: controller));
      expect(find.text('from-controller'), findsOneWidget);

      controller.value = 'later';
      await tester.pump();
      expect(find.text('later'), findsOneWidget);
    });

    test('ComponentValueController notifies on change', () {
      final controller = ComponentValueController<int>(0);
      addTearDown(controller.dispose);

      var notified = 0;
      controller.addListener(() => notified++);
      controller.value = 1;

      expect(notified, 1);
      expect(controller.value, 1);
    });
  });
}

/// A widget whose state mixes in [FormValueSupplier]; reached through its
/// [GlobalKey] so the test can drive `formValue` and read replacements.
class _StringField extends StatefulWidget {
  const _StringField({super.key});

  @override
  State<_StringField> createState() => _StringFieldState();
}

class _StringFieldState extends State<_StringField>
    with FormValueSupplier<String, _StringField> {
  /// Values pushed back in by validation replacements, in order.
  final replaced = <String>[];

  @override
  void didReplaceFormValue(String value) {
    replaced.add(value);
    formValue = value;
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
