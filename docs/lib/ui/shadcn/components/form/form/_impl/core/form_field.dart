// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form.dart';

/// A standard form field widget with label, validation, and error display.
///
/// Provides a consistent layout for form inputs with labels, hints,
/// validation, and error messaging.
class FormField<T> extends StatelessWidget {
  /// The label widget for the form field.
  final Widget label;

  /// Optional hint text displayed below the field.
  final Widget? hint;

  /// The main input widget.
  final Widget child;

  /// Optional widget displayed before the label.
  final Widget? leadingLabel;

  /// Optional widget displayed after the label.
  final Widget? trailingLabel;

  /// Alignment of the label axis.
  final MainAxisAlignment? labelAxisAlignment;

  /// Gap between leading label and main label.
  final double? leadingGap;

  /// Gap between main label and trailing label.
  final double? trailingGap;

  /// Padding around the form field.
  final EdgeInsetsGeometry? padding;

  /// Validator function for this field.
  final Validator<T>? validator;

  /// Validation modes that trigger error display.
  final Set<FormValidationMode>? showErrors;

  /// Creates a form field.
  const FormField({
    required FormKey<T> super.key,
    required this.label,
    required this.child,
    this.leadingLabel,
    this.trailingLabel,
    this.labelAxisAlignment = MainAxisAlignment.start,
    this.leadingGap,
    this.trailingGap,
    this.padding = EdgeInsets.zero,
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
          return ComponentTheme(
            data: FocusOutlineTheme(
              border: error != null
                  ? Border.all(
                      color: theme.colorScheme.destructive.scaleAlpha(0.2),
                      width: 3.0,
                    )
                  : null,
            ),
            child: ComponentTheme(
              data: TextFieldTheme(
                border: error != null
                    ? Border.all(color: theme.colorScheme.destructive)
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: padding!,
                    child: Row(
                      mainAxisAlignment: labelAxisAlignment!,
                      children: [
                        if (leadingLabel != null)
                          leadingLabel!.textSmall().muted(),
                        if (leadingLabel != null)
                          Gap(
                            leadingGap ??
                                theme.density.baseGap * theme.scaling * gapSm,
                          ),
                        Expanded(
                          child: DefaultTextStyle.merge(
                            style: error != null
                                ? TextStyle(
                                    color: theme.colorScheme.destructive,
                                  )
                                : null,
                            child: label.textSmall(),
                          ),
                        ),
                        if (trailingLabel != null)
                          Gap(
                            trailingGap ??
                                theme.density.baseGap * theme.scaling * gapSm,
                          ),
                        if (trailingLabel != null)
                          trailingLabel!.textSmall().muted(),
                      ],
                    ),
                  ),
                  DensityGap(gapSm),
                  child!,
                  if (hint != null) ...[
                    DensityGap(gapSm),
                    hint!.xSmall().muted(),
                  ],
                  if (error is InvalidResult) ...[
                    DensityGap(gapSm),
                    DefaultTextStyle.merge(
                      style: TextStyle(color: theme.colorScheme.destructive),
                      child: Text(error.message).xSmall().medium(),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
        child: child,
      ),
    );
  }
}
