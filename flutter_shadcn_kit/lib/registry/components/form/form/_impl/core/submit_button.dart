// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form.dart';

/// A button that automatically handles form submission states.
///
/// Renders different content based on form validation state:
/// - Default: Shows [child] with optional leading/trailing widgets
/// - Loading: Shows [loading] during async validation
/// - Error: Shows [error] when validation fails
///
/// Automatically disables during validation and enables when form is valid.
///
/// Example:
/// ```dart
/// SubmitButton(
///   child: Text('Submit'),
///   loading: Text('Validating...'),
///   error: Text('Fix errors'),
/// )
/// ```
class SubmitButton extends StatelessWidget {
  /// Button style configuration.
  final AbstractButtonStyle? style;

  /// Default button content.
  final Widget child;

  /// Content shown during async validation (loading state).
  final Widget? loading;

  /// Content shown when validation errors exist.
  final Widget? error;

  /// Leading widget in default state.
  final Widget? leading;

  /// Trailing widget in default state.
  final Widget? trailing;

  /// Leading widget in loading state.
  final Widget? loadingLeading;

  /// Trailing widget in loading state.
  final Widget? loadingTrailing;

  /// Leading widget in error state.
  final Widget? errorLeading;

  /// Trailing widget in error state.
  final Widget? errorTrailing;

  /// Content alignment within the button.
  final AlignmentGeometry? alignment;

  /// Whether to disable hover effects.
  final bool disableHoverEffect;

  /// Whether the button is enabled (null uses form state).
  final bool? enabled;

  /// Whether to enable haptic feedback on press.
  final bool? enableFeedback;

  /// Whether to disable state transition animations.
  final bool disableTransition;

  /// Focus node for keyboard navigation.
  final FocusNode? focusNode;

  /// Creates a [SubmitButton].
  ///
  /// Parameters:
  /// - [child] (`Widget`, required): Default button content.
  /// - [style] (`AbstractButtonStyle?`, optional): Button styling.
  /// - [loading] (`Widget?`, optional): Loading state content.
  /// - [error] (`Widget?`, optional): Error state content.
  /// - [leading] (`Widget?`, optional): Leading widget (default state).
  /// - [trailing] (`Widget?`, optional): Trailing widget (default state).
  /// - [loadingLeading] (`Widget?`, optional): Leading widget (loading state).
  /// - [loadingTrailing] (`Widget?`, optional): Trailing widget (loading state).
  /// - [errorLeading] (`Widget?`, optional): Leading widget (error state).
  /// - [errorTrailing] (`Widget?`, optional): Trailing widget (error state).
  /// - [alignment] (`AlignmentGeometry?`, optional): Content alignment.
  /// - [disableHoverEffect] (`bool`, default: `false`): Disable hover.
  /// - [enabled] (`bool?`, optional): Override enabled state.
  /// - [enableFeedback] (`bool?`, optional): Enable haptic feedback.
  /// - [disableTransition] (`bool`, default: `false`): Disable animations.
  /// - [focusNode] (`FocusNode?`, optional): Focus node.
  const SubmitButton({
    super.key,
    required this.child,
    this.style,
    this.loading,
    this.error,
    this.leading,
    this.trailing,
    this.alignment,
    this.loadingLeading,
    this.loadingTrailing,
    this.errorLeading,
    this.errorTrailing,
    this.disableHoverEffect = false,
    this.enabled,
    this.enableFeedback,
    this.disableTransition = false,
    this.focusNode,
  });

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return FormErrorBuilder(
      builder: (context, errors, child) {
        var hasWaitingError = errors.values.any((element) {
          return element is WaitingResult;
        });
        var hasError = errors.values.any((element) {
          return element is InvalidResult;
        });
        if (hasWaitingError) {
          return Button(
            leading: loadingLeading ?? leading,
            trailing: loadingTrailing ?? trailing,
            alignment: alignment,
            disableHoverEffect: disableHoverEffect,
            enabled: false,
            enableFeedback: false,
            disableTransition: disableTransition,
            focusNode: focusNode,
            style: style ?? const ButtonStyle.primary(),
            child: loading ?? child!,
          );
        }
        if (hasError) {
          return Button(
            leading: errorLeading ?? leading,
            trailing: errorTrailing ?? trailing,
            alignment: alignment,
            disableHoverEffect: disableHoverEffect,
            enabled: enabled ?? true,
            enableFeedback: true,
            onPressed: () {
              context.submitForm();
            },
            disableTransition: disableTransition,
            focusNode: focusNode,
            style: style ?? const ButtonStyle.primary(),
            child: error ?? child!,
          );
        }
        return Button(
          leading: leading,
          trailing: trailing,
          alignment: alignment,
          disableHoverEffect: disableHoverEffect,
          enabled: enabled ?? true,
          enableFeedback: enableFeedback ?? true,
          onPressed: () {
            context.submitForm();
          },
          disableTransition: disableTransition,
          focusNode: focusNode,
          style: style ?? const ButtonStyle.primary(),
          child: child!,
        );
      },
      child: child,
    );
  }
}
