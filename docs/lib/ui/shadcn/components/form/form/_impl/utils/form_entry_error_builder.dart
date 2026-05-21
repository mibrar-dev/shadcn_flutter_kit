// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form.dart';

/// Widget builder for displaying form entry validation errors.
///
/// Conditionally renders error messages based on validation state and modes.
class FormEntryErrorBuilder extends StatelessWidget {
  /// Builder function that creates the error display widget.
  final Widget Function(
    BuildContext context,
    ValidationResult? error,
    Widget? child,
  )
  builder;

  /// Optional child widget passed to the builder.
  final Widget? child;

  /// Validation modes that trigger error display.
  final Set<FormValidationMode>? modes;

  /// Creates a form entry error builder.
  const FormEntryErrorBuilder({
    super.key,
    required this.builder,
    this.child,
    this.modes,
  });

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    final formController = Data.maybeOf<FormFieldHandle>(context);
    if (formController != null) {
      var validityListenable = formController.validity;
      return ListenableBuilder(
        listenable: Listenable.merge([
          if (validityListenable != null) validityListenable,
        ]),
        builder: (context, child) {
          var validity = validityListenable?.value;
          if (modes != null && !modes!.contains(validity?.state)) {
            return builder(context, null, child);
          }
          return builder(context, validity, child);
        },
        child: child,
      );
    }
    return builder(context, null, child);
  }
}
