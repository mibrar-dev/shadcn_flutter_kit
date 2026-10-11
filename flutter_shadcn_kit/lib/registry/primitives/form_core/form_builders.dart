// The form-side builder widgets: per-field error rendering, form-wide error
// and pending views, and `Validated` (the absorbed `validated` component).

import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/widgets.dart';

import '../../foundation/data.dart';
import 'form_controller.dart';
import 'form_core.dart';
import 'form_entry.dart';
import 'validation.dart';

/// Renders [builder] with the nearest field's validation result.
///
/// [modes] filters which [FormValidationMode] a result is shown for; results
/// from other modes read as valid.
class FormEntryErrorBuilder extends StatelessWidget {
  /// Creates an error builder over the nearest field.
  const FormEntryErrorBuilder({
    super.key,
    required this.builder,
    this.child,
    this.modes,
  });

  /// Builds the field from its validation result.
  final Widget Function(
    BuildContext context,
    ValidationResult? error,
    Widget? child,
  )
  builder;

  /// Passed through to [builder].
  final Widget? child;

  /// Validation modes that surface the error.
  final Set<FormValidationMode>? modes;

  @override
  Widget build(BuildContext context) {
    final FormFieldHandle? handle = Data.maybeOf<FormFieldHandle>(context);
    final ValueListenable<ValidationResult?>? validity = handle?.validity;
    if (validity == null) {
      return builder(context, null, child);
    }
    return ValueListenableBuilder<ValidationResult?>(
      valueListenable: validity,
      builder: (context, result, _) {
        if (modes != null && !modes!.contains(result?.state)) {
          return builder(context, null, child);
        }
        return builder(context, result, child);
      },
      child: child,
    );
  }
}

/// Renders [builder] with every failure in the nearest form.
class FormErrorBuilder extends StatelessWidget {
  /// Creates a form-wide error builder.
  const FormErrorBuilder({super.key, required this.builder, this.child});

  /// Builds from the aggregated errors.
  final Widget Function(
    BuildContext context,
    Map<FormKey, ValidationResult> errors,
    Widget? child,
  )
  builder;

  /// Passed through to [builder].
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final FormController? controller = Data.maybeOf<FormController>(context);
    if (controller == null) {
      return builder(context, const <FormKey, ValidationResult>{}, child);
    }
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => builder(context, controller.errors, child),
      child: child,
    );
  }
}

/// Renders [builder] with the form's in-flight validations.
///
/// The `form_core` [FormPendingBuilder] is controller-free; this widget is the
/// controller-aware counterpart the form component owns.
class FormPending extends StatelessWidget {
  /// Creates a pending builder over the nearest form.
  const FormPending({super.key, required this.builder, this.child});

  /// Builds from the pending futures.
  final FormPendingWidgetBuilder builder;

  /// Passed through to [builder].
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final FormController? controller = Data.maybeOf<FormController>(context);
    if (controller == null) {
      return builder(
        context,
        const <FormKey, Future<ValidationResult?>>{},
        child,
      );
    }
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => builder(context, controller.pending, child),
      child: child,
    );
  }
}

/// Builds validation feedback from a field's result.
typedef ValidatedBuilder =
    Widget Function(
      BuildContext context,
      ValidationResult? error,
      Widget? child,
    );

/// Wraps a field with its own validator and exposes the result to [builder].
///
/// Creates a private controller, so it works without an enclosing `ShadcnForm`
/// (the old `validated` component wrapped a local `ShadcnForm`; this is equivalent
/// without the extra widget).
class Validated<T> extends StatefulWidget {
  /// Creates a validated field.
  const Validated({
    super.key,
    required this.builder,
    required this.validator,
    this.child,
  });

  /// Builds the field from its validation result.
  final ValidatedBuilder builder;

  /// The field's validator.
  final Validator<T> validator;

  /// The field subtree.
  final Widget? child;

  @override
  State<Validated<T>> createState() => _ValidatedState<T>();
}

class _ValidatedState<T> extends State<Validated<T>> {
  final FormController _controller = FormController();
  final FormKey<T> _key = FormKey<T>(#validated);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Data<FormController>.inherit(
      data: _controller,
      child: FormEntry<T>(
        key: _key,
        validator: widget.validator,
        child: FormEntryErrorBuilder(
          builder: widget.builder,
          child: widget.child,
        ),
      ),
    );
  }
}
