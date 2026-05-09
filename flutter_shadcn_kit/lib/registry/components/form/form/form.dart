// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:async';

import 'package:data_widget/data_widget.dart';
import 'package:email_validator/email_validator.dart' as email_validator;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

import '../../../shared/localizations/shadcn_localizations.dart';
import '../../../shared/primitives/focus_outline.dart';
import '../../../shared/primitives/phone_number.dart';
import '../../../shared/primitives/slider_value.dart';
import '../../../shared/primitives/text.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/color_extensions.dart';
import '../../../shared/utils/util.dart' hide TimeOfDay;
import '../../control/button/button.dart';
import '../checkbox/checkbox.dart';
import '../text_field/text_field.dart';

part '_impl/core/validator.dart';

part '_impl/core/_form_entry_cached_value.dart';
part '_impl/core/_form_entry_handle_interceptor.dart';
part '_impl/state/_form_entry_interceptor_state.dart';
part '_impl/core/_validator_result_stash.dart';
part '_impl/core/compare_to.dart';
part '_impl/core/compare_type.dart';
part '_impl/core/compare_with.dart';
part '_impl/core/composite_validator.dart';
part '_impl/core/conditional_validator.dart';
part '_impl/core/email_validator.dart';
part '_impl/utils/form_controller.dart';
part '_impl/core/form_entry.dart';
part '_impl/utils/form_entry_error_builder.dart';
part '_impl/core/form_entry_interceptor.dart';
part '_impl/state/form_entry_state.dart';
part '_impl/utils/form_error_builder.dart';
part '_impl/core/form_field.dart';
part '_impl/core/form_field_handle.dart';
part '_impl/core/form_inline.dart';
part '_impl/core/form_key.dart';
part '_impl/utils/form_pending_builder.dart';
part '_impl/state/form_state.dart';
part '_impl/core/form_table_layout.dart';
part '_impl/core/form_validation_mode.dart';
part '_impl/core/form_validity_notification.dart';
part '_impl/state/form_value_state.dart';
part '_impl/core/form_value_supplier.dart';
part '_impl/core/ignore_form.dart';
part '_impl/core/invalid_result.dart';
part '_impl/core/length_validator.dart';
part '_impl/core/max_validator.dart';
part '_impl/core/min_validator.dart';
part '_impl/core/non_null_validator.dart';
part '_impl/core/not_empty_validator.dart';
part '_impl/core/not_validator.dart';
part '_impl/core/or_validator.dart';
part '_impl/core/range_validator.dart';
part '_impl/core/regex_validator.dart';
part '_impl/core/replace_result.dart';
part '_impl/core/safe_password_validator.dart';
part '_impl/core/submission_result.dart';
part '_impl/core/submit_button.dart';
part '_impl/core/url_validator.dart';
part '_impl/core/validation_mode.dart';
part '_impl/core/validation_result.dart';
part '_impl/utils/validator_builder.dart';
part '_impl/core/waiting_result.dart';

/// A function type that evaluates a condition on a value and returns a boolean result.
///
/// This type alias represents a predicate function that can be either synchronous
/// or asynchronous, accepting a nullable value of type [T] and returning either
/// a boolean or a `Future<bool>`. Used primarily for conditional validation logic.
///
/// The generic type [T] represents the type of value being evaluated.
///
/// Example:
/// ```dart
/// FuturePredicate<String> isValidEmail = (value) async {
///   if (value == null) return false;
///   return await validateEmailOnServer(value);
/// };
/// ```
typedef FuturePredicate<T> = FutureOr<bool> Function(T? value);

/// A function type for building custom validators.
///
/// Parameters:
/// - [value] (`T?`): The value to validate.
///
/// Returns a `FutureOr<ValidationResult?>` that is null for valid values.
typedef ValidatorBuilderFunction<T> =
    FutureOr<ValidationResult?> Function(T? value);

// Type aliases for form field keys

/// Form key type for autocomplete fields with string values.
typedef AutoCompleteKey = FormKey<String>;

/// Form key type for checkbox fields with [CheckboxState] values.
typedef CheckboxKey = FormKey<CheckboxState>;

/// Form key type for chip input fields with list values.
typedef ChipInputKey<T> = FormKey<List<T>>;

/// Form key type for color picker fields with [Color] values.
typedef ColorPickerKey = FormKey<Color>;

/// Form key type for date picker fields with [DateTime] values.
typedef DatePickerKey = FormKey<DateTime>;

/// Form key type for date input fields with [DateTime] values.
typedef DateInputKey = FormKey<DateTime>;

/// Form key type for duration picker fields with [Duration] values.
typedef DurationPickerKey = FormKey<Duration>;

/// Form key type for duration input fields with [Duration] values.
typedef DurationInputKey = FormKey<Duration>;

/// Form key type for text input fields with string values.
typedef InputKey = FormKey<String>;

/// Form key type for OTP input fields with lists of nullable integers.
typedef InputOTPKey = FormKey<List<int?>>;

/// Form key type for multi-select fields with iterable values.
typedef MultiSelectKey<T> = FormKey<Iterable<T>>;

/// Form key type for multiple answer fields with iterable values.
typedef MultipleAnswerKey<T> = FormKey<Iterable<T>>;

/// Form key type for multiple choice fields with single selected values.
typedef MultipleChoiceKey<T> = FormKey<T>;

/// Form key type for number input fields with numeric values.
typedef NumberInputKey = FormKey<num>;

/// Form key type for phone input fields with [PhoneNumber] values.
typedef PhoneInputKey = FormKey<PhoneNumber>;

/// Form key type for radio card fields with integer index values.
typedef RadioCardKey = FormKey<int>;

/// Form key type for radio group fields with integer index values.
typedef RadioGroupKey = FormKey<int>;

/// Form key type for select dropdown fields with typed values.
typedef SelectKey<T> = FormKey<T>;

/// Form key type for slider fields with [SliderValue] values.
typedef SliderKey = FormKey<SliderValue>;

/// Form key type for star rating fields with double values.
typedef StarRatingKey = FormKey<double>;

/// Form key type for switch fields with boolean values.
typedef SwitchKey = FormKey<bool>;

/// Form key type for text area fields with string values.
typedef TextAreaKey = FormKey<String>;

/// Form key type for text field inputs with string values.
typedef TextFieldKey = FormKey<String>;

/// Form key type for time picker fields with [TimeOfDay] values.
typedef TimePickerKey = FormKey<TimeOfDay>;

/// Form key type for time input fields with [TimeOfDay] values.
typedef TimeInputKey = FormKey<TimeOfDay>;

/// Form key type for toggle fields with boolean values.
typedef ToggleKey = FormKey<bool>;

/// A map of form field keys to their values.
///
/// Used to collect and pass around form data, where each key uniquely identifies
/// a form field and maps to its current value.
typedef FormMapValues = Map<FormKey, dynamic>;

/// Callback function for form submission.
///
/// Parameters:
/// - [context] (`BuildContext`): The build context.
/// - [values] (`FormMapValues`): Map of all form field values.
typedef FormSubmitCallback =
    void Function(BuildContext context, FormMapValues values);

/// Extension methods for [FormMapValues].
extension FormMapValuesExtension on FormMapValues {
  /// Retrieves a typed value for a specific form key.
  ///
  /// Parameters:
  /// - [key] (`FormKey<T>`, required): The form key to look up.
  ///
  /// Returns: `T?` — the value if found and correctly typed, null otherwise.
  T? getValue<T>(FormKey<T> key) {
    Object? value = this[key];
    if (value == null) {
      return null;
    }
    assert(
      key.isInstanceOf(value),
      'The value for key $key is not of type ${key.type}',
    );
    return value as T?;
  }
}

/// A widget that provides form management capabilities for collecting and validating user input.
///
/// The Form widget creates a container that manages multiple form fields, providing
/// centralized validation, data collection, and submission handling. It maintains
/// form state through a [FormController] and coordinates validation across all
/// participating form fields.
///
/// Form components within the widget tree automatically register themselves with
/// the nearest Form ancestor, allowing centralized management of field values,
/// validation states, and error handling. The Form provides validation lifecycle
/// management and supports both synchronous and asynchronous validation.
///
/// Example:
/// ```dart
/// final controller = FormController();
///
/// Form(
///   controller: controller,
///   onSubmit: (values) async {
///     print('Form submitted with values: $values');
///   },
///   child: Column(
///     children: [
///       TextInput(
///         key: FormKey<String>('name'),
///         label: 'Name',
///         validator: RequiredValidator(),
///       ),
///       Button(
///         onPressed: () => controller.submit(),
///         child: Text('Submit'),
///       ),
///     ],
///   ),
/// );
/// ```
class Form extends StatefulWidget {
  /// Retrieves the nearest [FormController] from the widget tree, if any.
  ///
  /// Returns the [FormController] instance from the nearest Form ancestor,
  /// or null if no Form is found in the widget tree. This method is safe
  /// to call even when no Form is present.
  ///
  /// Parameters:
  /// - [context] (BuildContext): The build context to search from
  ///
  /// Returns the [FormController] if found, null otherwise.
  static FormController? maybeOf(BuildContext context) {
    return Data.maybeOf<FormController>(context);
  }

  /// Retrieves the nearest [FormController] from the widget tree.
  ///
  /// Returns the [FormController] instance from the nearest Form ancestor.
  /// Throws an assertion error if no Form is found in the widget tree.
  /// Use [maybeOf] if the Form might not be present.
  ///
  /// Parameters:
  /// - [context] (BuildContext): The build context to search from
  ///
  /// Returns the [FormController] from the nearest Form ancestor.
  ///
  /// Throws [AssertionError] if no Form is found in the widget tree.
  static FormController of(BuildContext context) {
    return Data.of<FormController>(context);
  }

  /// Optional controller for programmatic form management.
  ///
  /// When provided, this controller manages form state externally and allows
  /// programmatic access to form values, validation states, and submission.
  /// If null, the Form creates and manages its own internal controller.
  final FormController? controller;

  /// The widget subtree containing form fields.
  ///
  /// This child widget should contain the form fields and other UI elements
  /// that participate in the form. Form fields within this subtree automatically
  /// register with this Form instance.
  final Widget child;

  /// Callback invoked when the form is submitted.
  ///
  /// This callback receives a map of form values keyed by their [FormKey]
  /// identifiers. It is called when [FormController.submit] is invoked and
  /// all form validations pass successfully.
  ///
  /// The callback can return a Future for asynchronous submission processing.
  final FormSubmitCallback? onSubmit;

  /// Creates a [Form] widget.
  ///
  /// The [child] parameter is required and should contain the form fields
  /// and UI elements that participate in the form. The [controller] and
  /// [onSubmit] parameters are optional but commonly used for form management.
  ///
  /// Parameters:
  /// - [child] (Widget, required): The widget subtree containing form fields
  /// - [onSubmit] (FormSubmitCallback?, optional): Callback for form submission
  /// - [controller] (FormController?, optional): External form state controller
  ///
  /// Example:
  /// ```dart
  /// Form(
  ///   onSubmit: (values) => print('Submitted: $values'),
  ///   child: Column(
  ///     children: [
  ///       TextInput(key: FormKey('email'), label: 'Email'),
  ///       Button(child: Text('Submit')),
  ///     ],
  ///   ),
  /// );
  /// ```
  const Form({super.key, required this.child, this.onSubmit, this.controller});

  /// Creates the `State` object for this widget.
  @override
  State<Form> createState() => FormState();
}

/// Builder function type for displaying pending form validations.
///
/// Takes the context, map of pending validation futures, and optional child widget.
typedef FormPendingWidgetBuilder =
    Widget Function(
      BuildContext context,
      Map<FormKey, Future<ValidationResult?>> errors,
      Widget? child,
    );

/// Extension methods on [BuildContext] for form operations.
extension FormExtension on BuildContext {
  /// Gets the current value for a form field by key.
  ///
  /// Returns null if the form or field is not found.
  T? getFormValue<T>(FormKey<T> key) {
    final formController = Data.maybeFind<FormController>(this);
    if (formController != null) {
      final state = formController.getValue(key);
      return state;
    }
    return null;
  }

  /// Submits the form and triggers validation.
  ///
  /// Returns a [SubmissionResult] with form values and any validation errors.
  /// May return a Future if asynchronous validation is in progress.
  FutureOr<SubmissionResult> submitForm() {
    final formState = Data.maybeFind<FormState>(this);
    assert(formState != null, 'Form not found');
    final formController = Data.maybeFind<FormController>(this);
    assert(formController != null, 'Form not found');
    final values = <FormKey, Object?>{};
    for (var entry in formController!._attachedInputs.entries) {
      var key = entry.key;
      var value = entry.value;
      values[key] = value.value;
    }
    formController.revalidate(this, FormValidationMode.submitted);
    var errors = <FormKey, ValidationResult>{};
    var iterator = formController._validity.entries.iterator;
    var result = _chainedSubmitForm(values, errors, iterator);
    if (result is Future<SubmissionResult>) {
      return result.then((value) {
        if (value.errors.isNotEmpty) {
          return value;
        }
        formState?.widget.onSubmit?.call(this, values);
        return value;
      });
    }
    if (result.errors.isNotEmpty) {
      return result;
    }
    formState?.widget.onSubmit?.call(this, values);
    return result;
  }

  FutureOr<SubmissionResult> _chainedSubmitForm(
    Map<FormKey, Object?> values,
    Map<FormKey, ValidationResult> errors,
    Iterator<MapEntry<FormKey, _ValidatorResultStash>> iterator,
  ) {
    if (!iterator.moveNext()) {
      return SubmissionResult(values, errors);
    }
    var entry = iterator.current;
    var value = entry.value.result;
    if (value is Future<ValidationResult?>) {
      return value.then((value) {
        if (value != null) {
          errors[entry.key] = value;
        }
        return _chainedSubmitForm(values, errors, iterator);
      });
    }
    if (value != null) {
      errors[entry.key] = value;
    }
    return _chainedSubmitForm(values, errors, iterator);
  }
}
