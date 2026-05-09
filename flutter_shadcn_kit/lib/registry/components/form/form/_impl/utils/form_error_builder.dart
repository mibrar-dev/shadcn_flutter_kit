// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form.dart';

/// Widget builder for displaying form-wide validation errors.
///
/// Provides access to all form validation errors for rendering error summaries.
class FormErrorBuilder extends StatelessWidget {
  /// Optional child widget passed to the builder.
  final Widget? child;

  /// Builder function that creates the error display from all form errors.
  final Widget Function(
    BuildContext context,
    Map<FormKey, ValidationResult> errors,
    Widget? child,
  )
  builder;

  /// Creates a form error builder.
  const FormErrorBuilder({super.key, required this.builder, this.child});

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    final formController = Data.of<FormController>(context);
    return ListenableBuilder(
      listenable: formController,
      child: child,
      builder: (context, child) {
        return builder(context, formController.errors, child);
      },
    );
  }
}
