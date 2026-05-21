// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form.dart';

/// A validator that applies conditional validation based on form state.
///
/// [ConditionalValidator] only executes validation when a predicate condition
/// is met. This allows validation rules to depend on other form field values
/// or dynamic conditions.
///
/// Example:
/// ```dart
/// ConditionalValidator<String>(
///   (context, value, getFieldValue) async {
///     final country = await getFieldValue('country');
///     return country == 'US';
///   },
///   message: 'ZIP code required for US addresses',
///   dependencies: ['country'],
/// )
/// ```
class ConditionalValidator<T> extends Validator<T> {
  /// The predicate function that determines if validation should be applied.
  final FuturePredicate<T> predicate;

  /// The error message to display when validation fails.
  final String message;

  /// List of form field keys this validator depends on.
  final List<FormKey> dependencies;

  /// Creates a [ConditionalValidator] with the specified predicate and dependencies.
  const ConditionalValidator(
    this.predicate, {
    required this.message,
    this.dependencies = const [],
  });

  @override
  FutureOr<ValidationResult?> validate(
    BuildContext context,
    T? value,
    FormValidationMode lifecycle,
  ) {
    var result = predicate(value);
    if (result is Future<bool>) {
      return result.then((value) {
        if (!value) {
          return InvalidResult(message, state: lifecycle);
        }
        return null;
      });
    } else if (!result) {
      return InvalidResult(message, state: lifecycle);
    }

    return null;
  }

  /// Performs `shouldRevalidate` logic for this form component.
  @override
  bool shouldRevalidate(FormKey<dynamic> source) {
    return dependencies.contains(source);
  }

  /// Compares this object with another for value equality.
  @override
  operator ==(Object other) {
    return other is ConditionalValidator &&
        other.predicate == predicate &&
        other.message == message;
  }

  @override
  int get hashCode => Object.hash(predicate, message);
}
