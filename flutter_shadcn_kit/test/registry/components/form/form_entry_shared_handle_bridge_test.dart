import 'package:flutter/widgets.dart' hide Form, FormField;
import 'package:flutter_shadcn_kit/flutter_shadcn_kit.dart';
import 'package:flutter_test/flutter_test.dart';

/// Regression test for the dual form-system bridge.
///
/// `TextField` is built on the shared-primitives `FormValueSupplier`, which
/// looks up the shared `FormFieldHandle`, while [FormEntry] publishes the
/// form component's identically-shaped but distinct `FormFieldHandle` type.
/// Without the [SharedFormHandleAdapter] bridge in `FormEntryState.build`,
/// value reports never reach the [FormController] and validators silently
/// see nothing (Sign In submits with empty fields instead of showing
/// required-field errors).
void main() {
  testWidgets('TextField value reaches FormController through FormEntry', (
    tester,
  ) async {
    final controller = FormController();
    const key = FormKey<String>('name');

    await tester.pumpWidget(
      ShadcnApp(
        home: Form(
          controller: controller,
          onSubmit: (_, __) {},
          child: const FormEntry<String>(
            key: key,
            validator: NotEmptyValidator(),
            child: TextField(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'hello');
    await tester.pumpAndSettle();

    expect(controller.getValue(key), 'hello');
  });

  testWidgets('empty required TextField fails submit validation', (
    tester,
  ) async {
    final controller = FormController();
    const key = FormKey<String>('name');
    var submitted = false;
    late BuildContext formContext;

    await tester.pumpWidget(
      ShadcnApp(
        home: Form(
          controller: controller,
          onSubmit: (_, __) {
            submitted = true;
          },
          child: Builder(
            builder: (context) {
              formContext = context;
              return const FormField<String>(
                key: key,
                label: Text('Name'),
                validator: NotEmptyValidator(),
                child: TextField(),
              );
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final result = formContext.submitForm();
    final submission = result is Future<SubmissionResult>
        ? await result
        : result as SubmissionResult;
    await tester.pumpAndSettle();

    expect(submission.errors, isNotEmpty);
    expect(submission.errors.containsKey(key), isTrue);
    expect(submitted, isFalse);
    // Required-field error is displayed.
    expect(find.text('This field cannot be empty.'), findsOneWidget);
  });
}
