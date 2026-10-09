# form

ShadcnForm state for a subtree: `ShadcnForm` publishes a `FormController`,
`ShadcnFormField` / `FormInline` / `FormTableLayout` render labelled fields, and
`FormEntry` wires any value supplier (`Input`, `Checkbox`, `StarRating`,
`ObjectFormField`, …) to the controller for validation and submission.

The widgets are `ShadcnForm` / `ShadcnFormField`, not `Form` / `FormField`:
`package:flutter/widgets.dart` exports both of those names, so the plain names
would make any file importing both libraries fail to compile. Same rule as
`ShadcnTheme` / `ShadcnImage` / `ShadcnTable`.

## When to use

- Multi-field screens with validation and a submit flow.
- One-off validated fields (`Validated`) without a full form.

## Snippets

```dart
final controller = FormController();
const emailKey = FormKey<String>('email');

ShadcnForm(
  controller: controller,
  onSubmit: (values) => save(values),
  child: Column(
    children: <Widget>[
      ShadcnFormField<String>(
        key: emailKey,
        label: const Text('Email'),
        validator: const NotEmptyValidator() & const EmailValidator(),
        child: const Input(),
      ),
      Button(
        onPressed: () => controller.submit(context),
        child: const Text('Submit'),
      ),
    ],
  ),
);
```

Inline and table layouts:

```dart
FormInline<String>(key: key, label: const Text('Name'), child: const Input());
FormTableLayout(rows: <ShadcnFormField<Object?>>[titleRow, slugRow]);
```

Object fields (dialog or popover editor):

```dart
ObjectFormField<DateTime>(
  value: date,
  onChanged: (value) => setState(() => date = value),
  placeholder: const Text('Pick a date'),
  builder: (context, value) => Text('$value'),
  editorBuilder: (context, handler) => Calendar(
    onChanged: (value) {
      handler.value = value;
    },
  ),
);
```

## API

| Member | Purpose |
|---|---|
| `ShadcnForm` | Publishes a `FormController`; `ShadcnForm.of` / `ShadcnForm.maybeOf` |
| `FormController` | `values`, `errors`, `pending`, `getValue`, `attach`, `detach`, `revalidateAll`, `submit` |
| `ShadcnFormField<T>` | Label row + hint + error message; per-field validator |
| `FormInline<T>` | Label beside the field |
| `FormTableLayout` | Two-column table of `ShadcnFormField`s |
| `FormFieldMessages` | The hint/message column, reusable in custom layouts |
| `Validated<T>` | One validated field with its own controller (no `ShadcnForm` needed) |
| `FormEntry<T>` | Low-level `FormKey` + validator registration |
| `FormEntryErrorBuilder` / `FormErrorBuilder` / `FormPending` | Error/pending views |
| `FormKey<T>` | Typed field identity (also a `LocalKey`) |
| `Validator<T>` + built-ins | `NotEmptyValidator`, `EmailValidator`, `LengthValidator`, `RangeValidator`, `CompareWith`, … |
| `ObjectFormField<T>` | Button-like trigger + dialog/popover editor |

## Theme resolution

`widget FormTheme > ComponentTheme<FormTheme> in tree > app overrides
(ComponentThemes) > formDefaults`, per field. Fields: `spacing`, `labelStyle`,
`hintStyle`, `messageStyle`, `labelColor`, `hintColor`, `messageColor`.

The error message paints with `messageColor` (`destructive`) and the label
follows it while the field is invalid.

## Differences from the old `form` / `form_field` / `validated`

- One form system: `FormKey`, `ValidationResult`, `FormFieldHandle` and
  `FormValueSupplier` live in `primitives/form_core/`; the old
  `SharedFormHandleAdapter` bridge between two handle types is gone.
- Per-component key aliases (`TextFieldKey`, `CheckboxKey`, `SelectKey`, 25+)
  are dropped — use `FormKey<String>`, `FormKey<CheckboxValue>`, etc.
- **Fixed:** detached fields leaked. The old `FormController.detach` was
  commented out, so unmounted fields stayed in `values`/`errors`; `FormEntry`
  now detaches on unmount and the controller removes the registration.
- **Fixed:** `revalidate()` kept the `changed` validation mode (the old
  `forceRevalidate` flag did not change the lifecycle), so submit-time checks
  that only run in `submitted` mode never ran. Revalidation uses `submitted`.
- **Fixed:** `EmailValidator` no longer needs the `email_validator` pub
  dependency, and `URLValidator` actually checks something (`Uri.parse` accepted
  almost any string, so the old URL check never failed).
- `SubmitButton` is dropped; use `Button` with
  `onPressed: () => controller.submit(context)`.
- `IgnoreForm`, `FormValidityNotification`, `FormEntryInterceptor`,
  `FormEntryHandleInterceptor` and `DynamicFormKey` are dropped (no users in the
  old tree); `Data.boundary` covers the isolation use case.
- Error decoration no longer wraps the child in other components' themes
  (`FocusOutlineTheme` / `TextFieldTheme`); fields style their own error state.
