// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form.dart';

/// A widget that prevents form components from submitting their values to form controllers.
///
/// This widget creates a boundary that blocks form-related data propagation,
/// effectively isolating child components from parent form controllers. When
/// [ignoring] is true, any form components within the child widget tree will
/// not participate in form validation or data collection.
///
/// This is useful for creating UI components that look like form fields but
/// should not be included in form submission or validation, such as search
/// fields, filters, or decorative input elements.
///
/// Example:
/// ```dart
/// Form(
///   child: Column(
///     children: [
///       TextInput(label: 'Name'), // Participates in form
///       IgnoreForm(
///         child: TextInput(label: 'Search'), // Ignored by form
///       ),
///     ],
///   ),
/// );
/// ```
class IgnoreForm<T> extends StatelessWidget {
  /// Whether to ignore form participation for child components.
  ///
  /// When true, creates a boundary that prevents child form components
  /// from registering with parent form controllers. When false, child
  /// components behave normally and participate in form operations.
  final bool ignoring;

  /// The widget subtree to optionally isolate from form participation.
  final Widget child;

  /// Creates an [IgnoreForm] widget.
  ///
  /// Parameters:
  /// - [child] (Widget, required): The widget subtree to wrap
  /// - [ignoring] (bool, default: true): Whether to block form participation
  ///
  /// Example:
  /// ```dart
  /// IgnoreForm(
  ///   ignoring: shouldIgnore,
  ///   child: MyFormField(),
  /// );
  /// ```
  const IgnoreForm({super.key, this.ignoring = true, required this.child});

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return MultiData(
      data: ignoring
          ? const [
              Data<FormFieldHandle>.boundary(),
              Data<FormController>.boundary(),
            ]
          : const [],
      child: child,
    );
  }
}
