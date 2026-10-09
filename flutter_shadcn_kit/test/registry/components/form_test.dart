// Widget and unit tests for the `form` component and the `form_core` machinery
// it re-exports.

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/button/button.dart';
import 'package:flutter_shadcn_kit/registry/components/form/form.dart';
import 'package:flutter_shadcn_kit/registry/components/input/input.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
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
    builder: (_) => Align(alignment: Alignment.topLeft, child: widget.child),
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
  Widget build(BuildContext context) =>
      Overlay(initialEntries: <OverlayEntry>[_entry]);
}

Widget _frame({
  required Widget child,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
}) {
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: _OverlayHost(child: child),
      ),
    ),
  );
}

/// Frame with a real [Navigator] for tests that push routes.
Widget _navigatorFrame({required Widget child}) {
  return ShadcnTheme(
    data: const ShadcnThemeData(),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Navigator(
        onGenerateRoute: (settings) => PageRouteBuilder<void>(
          pageBuilder: (context, animation, secondary) =>
              Align(alignment: Alignment.topLeft, child: child),
        ),
      ),
    ),
  );
}

/// Fails only during submit-time validation.
class _SubmittedOnly extends Validator<String> {
  const _SubmittedOnly();

  @override
  FutureOr<ValidationResult?> validate(
    BuildContext context,
    String? value,
    FormValidationMode lifecycle,
  ) {
    if (lifecycle != FormValidationMode.submitted) {
      return null;
    }
    return const InvalidResult(
      'required-at-submit',
      state: FormValidationMode.submitted,
    );
  }
}

const FormKey<String> _emailKey = FormKey<String>('email');

ShadcnForm _form(FormController controller, List<Widget> fields) {
  return ShadcnForm(
    controller: controller,
    child: Column(children: fields),
  );
}

void main() {
  testWidgets('a field error renders, clears and dims under both token sets', (
    tester,
  ) async {
    for (final ShadcnThemeData data in <ShadcnThemeData>[
      const ShadcnThemeData(),
      const ShadcnThemeData(colors: ShadcnColors.darkFallback),
    ]) {
      final FormController controller = FormController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _frame(
          data: data,
          child: _form(controller, <Widget>[
            ShadcnFormField<String>(
              key: _emailKey,
              label: const Text('Email'),
              hint: const Text('Hint'),
              validator: const NotEmptyValidator(),
              child: const Input(),
            ),
          ]),
        ),
      );
      // Reset the reused Input element before each data variant.
      await tester.enterText(find.byType(EditableText), '');
      await tester.pump();
      await tester.pump();
      expect(find.text('This field cannot be empty.'), findsOneWidget);
      expect(find.text('Hint'), findsOneWidget);

      await tester.enterText(find.byType(EditableText), 'a');
      await tester.pump();
      await tester.pump();
      expect(find.text('This field cannot be empty.'), findsNothing);
      expect(controller.getValue(_emailKey), 'a');
    }
  });

  testWidgets('regression: revalidation uses submitted mode', (tester) async {
    final FormController controller = FormController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _frame(
        child: _form(controller, <Widget>[
          ShadcnFormField<String>(
            key: _emailKey,
            label: const Text('Email'),
            validator: const _SubmittedOnly(),
            child: const Input(),
          ),
        ]),
      ),
    );
    final BuildContext context = tester.element(find.byType(ShadcnForm));
    await tester.enterText(find.byType(EditableText), 'value');
    await tester.pump();
    await tester.pump();
    // The old `revalidate()` kept the `changed` lifecycle, so a submitted-only
    // check never ran at submit time.
    expect(controller.errors, isEmpty);

    final SubmissionResult result = await controller.submit(context);
    await tester.pump();
    expect(
      (result.errors[_emailKey] as InvalidResult?)?.message,
      'required-at-submit',
    );
  });

  testWidgets('submit calls onSubmit only when valid', (tester) async {
    final FormController controller = FormController();
    addTearDown(controller.dispose);
    FormMapValues? submitted;
    await tester.pumpWidget(
      _frame(
        child: ShadcnForm(
          controller: controller,
          onSubmit: (values) => submitted = values,
          child: ShadcnFormField<String>(
            key: _emailKey,
            label: const Text('Email'),
            validator: const NotEmptyValidator(),
            child: const Input(),
          ),
        ),
      ),
    );
    final BuildContext context = tester.element(find.byType(ShadcnForm));
    await tester.pump();
    await tester.pump();

    // Invalid: no callback.
    SubmissionResult result = await controller.submit(context);
    expect(result.isValid, isFalse);
    expect(submitted, isNull);

    await tester.enterText(find.byType(EditableText), 'a');
    await tester.pump();
    await tester.pump();
    result = await controller.submit(context);
    expect(result.isValid, isTrue);
    expect(submitted?[_emailKey], 'a');
  });

  testWidgets('regression: unmounting a field detaches it', (tester) async {
    final FormController controller = FormController();
    addTearDown(controller.dispose);
    Widget build({required bool withField}) => _frame(
      child: _form(controller, <Widget>[
        if (withField)
          ShadcnFormField<String>(
            key: _emailKey,
            label: const Text('Email'),
            child: const Input(),
          ),
        const Text('other'),
      ]),
    );

    await tester.pumpWidget(build(withField: true));
    expect(controller.values.containsKey(_emailKey), isTrue);

    await tester.pumpWidget(build(withField: false));
    // The old controller's `detach` was commented out, so the field stayed.
    expect(controller.values.containsKey(_emailKey), isFalse);
    expect(controller.errors.containsKey(_emailKey), isFalse);
  });

  testWidgets('showErrors filters the visible message', (tester) async {
    final FormController controller = FormController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _frame(
        child: _form(controller, <Widget>[
          ShadcnFormField<String>(
            key: _emailKey,
            label: const Text('Email'),
            validator: const NotEmptyValidator(),
            showErrors: const <FormValidationMode>{
              FormValidationMode.submitted,
            },
            child: const Input(),
          ),
        ]),
      ),
    );
    await tester.pump();
    await tester.pump();
    expect(find.text('This field cannot be empty.'), findsNothing);

    final BuildContext context = tester.element(find.byType(ShadcnForm));
    await controller.submit(context);
    await tester.pump();
    await tester.pump();
    expect(find.text('This field cannot be empty.'), findsOneWidget);
  });

  testWidgets('cross-field validators re-run when their dependency changes', (
    tester,
  ) async {
    final FormController controller = FormController();
    addTearDown(controller.dispose);
    const FormKey<String> passwordKey = FormKey<String>('password');
    const FormKey<String> confirmKey = FormKey<String>('confirm');
    await tester.pumpWidget(
      _frame(
        child: _form(controller, <Widget>[
          ShadcnFormField<String>(
            key: passwordKey,
            label: const Text('Password'),
            child: const Input(),
          ),
          ShadcnFormField<String>(
            key: confirmKey,
            label: const Text('Confirm'),
            validator: const CompareWith<String>(
              passwordKey,
              CompareType.equal,
              message: 'mismatch',
            ),
            child: const Input(),
          ),
        ]),
      ),
    );
    await tester.enterText(find.byType(EditableText).first, 'a');
    await tester.pump();
    await tester.enterText(find.byType(EditableText).last, 'b');
    await tester.pump();
    await tester.pump();
    expect(
      (controller.errors[confirmKey] as InvalidResult?)?.message,
      'mismatch',
    );

    await tester.enterText(find.byType(EditableText).first, 'b');
    await tester.pump();
    await tester.pump();
    expect(controller.errors.containsKey(confirmKey), isFalse);
  });

  testWidgets('label colour resolves through all four theme legs', (
    tester,
  ) async {
    Color? labelColor() {
      final DefaultTextStyle style = tester.widget<DefaultTextStyle>(
        find
            .ancestor(
              of: find.text('Email'),
              matching: find.byType(DefaultTextStyle),
            )
            .first,
      );
      return style.style.color;
    }

    final FormController controller = FormController();
    addTearDown(controller.dispose);
    Widget build({
      List<ComponentThemeData>? app,
      FormTheme? scoped,
      FormTheme? widget,
    }) {
      return _frame(
        app: app ?? const <ComponentThemeData>[],
        child: _form(controller, <Widget>[
          ShadcnFormField<String>(
            key: _emailKey,
            label: const Text('Email'),
            theme: widget,
            child: const Text('field'),
          ),
        ]),
      );
    }

    // Defaults: foreground.
    await tester.pumpWidget(build());
    final ShadcnColors light = const ShadcnThemeData().colors;
    expect(labelColor(), light.foreground);

    // App leg beats defaults.
    await tester.pumpWidget(
      build(
        app: <ComponentThemeData>[
          const FormTheme(labelColor: ThemedColor.ref(ColorRef.destructive)),
        ],
      ),
    );
    expect(labelColor(), light.destructive);

    // Tree leg beats the app leg.
    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[
          FormTheme(labelColor: ThemedColor.ref(ColorRef.destructive)),
        ],
        child: ComponentTheme<FormTheme>(
          data: const FormTheme(labelColor: ThemedColor.ref(ColorRef.primary)),
          child: _form(controller, <Widget>[
            ShadcnFormField<String>(
              key: _emailKey,
              label: const Text('Email'),
              child: const Text('field'),
            ),
          ]),
        ),
      ),
    );
    expect(labelColor(), light.primary);

    // Widget argument beats the tree leg.
    await tester.pumpWidget(
      _frame(
        child: ComponentTheme<FormTheme>(
          data: const FormTheme(labelColor: ThemedColor.ref(ColorRef.primary)),
          child: _form(controller, <Widget>[
            ShadcnFormField<String>(
              key: _emailKey,
              label: const Text('Email'),
              theme: const FormTheme(
                labelColor: ThemedColor.ref(ColorRef.secondary),
              ),
              child: const Text('field'),
            ),
          ]),
        ),
      ),
    );
    expect(labelColor(), light.secondary);
  });

  testWidgets('FormInline and FormTableLayout render labels and errors', (
    tester,
  ) async {
    final FormController controller = FormController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _frame(
        child: _form(controller, <Widget>[
          FormInline<String>(
            key: const FormKey<String>('inline'),
            label: const Text('Inline label'),
            validator: const NotEmptyValidator(),
            child: const Input(),
          ),
          FormTableLayout(
            rows: <ShadcnFormField<Object?>>[
              ShadcnFormField<Object?>(
                key: const FormKey<Object?>('table'),
                label: const Text('Table label'),
                validator: const NonNullValidator<Object?>(),
                child: const Text('table field'),
              ),
            ],
          ),
        ]),
      ),
    );
    await tester.pump();
    await tester.pump();
    expect(find.text('Inline label'), findsOneWidget);
    expect(find.text('Table label'), findsOneWidget);
    // Both the inline and the table field use the same localized message.
    expect(find.text('This field cannot be empty.'), findsNWidgets(2));
    expect(controller.errors.length, 2);
  });

  testWidgets('Validated works without a ShadcnForm scope', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: Validated<String>(
          validator: const NotEmptyValidator(),
          builder: (context, error, child) {
            return Column(
              children: <Widget>[
                child!,
                if (error is InvalidResult) Text('error: ${error.message}'),
              ],
            );
          },
          child: const Text('field'),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    expect(find.text('error: This field cannot be empty.'), findsOneWidget);
  });

  testWidgets('an object field dialog saves the edited value', (tester) async {
    DateTime? value;
    await tester.pumpWidget(
      _navigatorFrame(
        child: ObjectFormField<DateTime>(
          value: value,
          onChanged: (next) => value = next,
          placeholder: const Text('Pick a date'),
          builder: (context, current) => Text('$current'),
          dialogTitle: const Text('Choose a date'),
          editorBuilder: (context, handler) => Button(
            onPressed: () => handler.value = DateTime(2026, 1, 2),
            child: const Text('Set date'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Pick a date'));
    await tester.pumpAndSettle();
    expect(find.text('Choose a date'), findsOneWidget);

    await tester.tap(find.text('Set date'));
    await tester.pump();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(value, DateTime(2026, 1, 2));
  });
}
