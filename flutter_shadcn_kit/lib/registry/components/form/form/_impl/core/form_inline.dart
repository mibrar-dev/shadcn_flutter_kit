// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form.dart';

/// An inline form field widget with label next to the input.
///
/// Provides a compact horizontal layout for form inputs with labels
/// and validation.
class FormInline<T> extends StatelessWidget {
  /// The label widget for the form field.
  final Widget label;

  /// Optional hint text displayed below the field.
  final Widget? hint;

  /// The main input widget.
  final Widget child;

  /// Validator function for this field.
  final Validator<T>? validator;

  /// Validation modes that trigger error display.
  final Set<FormValidationMode>? showErrors;

  /// Creates an inline form field.
  const FormInline({
    required FormKey<T> super.key,
    required this.label,
    required this.child,
    this.validator,
    this.hint,
    this.showErrors,
  });

  /// Field storing `key` for this form implementation.
  @override
  FormKey<T> get key => super.key as FormKey<T>;

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FormEntry<T>(
      key: key,
      validator: validator,
      child: FormEntryErrorBuilder(
        modes: showErrors,
        builder: (context, error, child) {
          return IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DefaultTextStyle.merge(
                        style: error != null
                            ? TextStyle(color: theme.colorScheme.destructive)
                            : null,
                        child: label.textSmall(),
                      ),
                      DensityGap(gapSm),
                      Expanded(child: child!),
                    ],
                  ),
                ),
                if (hint != null) ...[
                  const DensityGap(gapSm),
                  hint!.xSmall().muted(),
                ],
                if (error is InvalidResult) ...[
                  const DensityGap(gapSm),
                  DefaultTextStyle.merge(
                    style: TextStyle(color: theme.colorScheme.destructive),
                    child: Text(error.message).xSmall().medium(),
                  ),
                ],
              ],
            ),
          );
        },
        child: child,
      ),
    );
  }
}
