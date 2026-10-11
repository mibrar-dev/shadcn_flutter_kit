// The `multiple_choice` component: one selection protocol ([Choice]) plus two
// data scopes over it, [MultipleChoice] (single value) and [MultipleAnswer]
// (multi value).
//
// The old module had four widgets (the two scopes and their `Controlled*`
// adapters) and two controllers. The adapters are folded into the scopes
// (controller mode), and the value read/write path now resolves the theme
// through all four legs instead of `widget.theme ?? tree`.

import 'package:flutter/widgets.dart';

import '../../foundation/data.dart';
import '../../primitives/form_core/form_control.dart';
import '../../primitives/form_core/form_value.dart';
import '../../theme/theme.dart';
import 'multiple_choice_style.dart';

export 'multiple_choice_style.dart';

/// The selection protocol every choice item reads from its scope.
///
/// Items call [Choice.choose] / [Choice.getValue] with the nearest scope; any
/// widget can be a choice item as long as it does that.
mixin Choice<T> {
  /// Selects (or toggles) [item] in the nearest scope.
  static void choose<T>(BuildContext context, T item) {
    Data.of<Choice<T>>(context).selectItem(item);
  }

  /// The selected items of the nearest scope, or null when there is none.
  static Iterable<T>? getValue<T>(BuildContext context) {
    return Data.maybeOf<Choice<T>>(context)?.value;
  }

  /// Applies one user selection to this scope.
  void selectItem(T item);

  /// The current selection: one item for [MultipleChoice], all items for
  /// [MultipleAnswer].
  Iterable<T>? get value;
}

/// Holds the value of an uncontrolled [MultipleChoice].
class MultipleChoiceController<T> extends ValueNotifier<T?>
    with ComponentController<T?> {
  /// Creates a controller holding a single selected item.
  MultipleChoiceController([super.value]);
}

/// Holds the values of an uncontrolled [MultipleAnswer].
class MultipleAnswerController<T> extends ValueNotifier<Iterable<T>?>
    with ComponentController<Iterable<T>?> {
  /// Creates a controller holding the selected items.
  MultipleAnswerController([super.value]);
}

/// A single-selection scope.
///
/// Two modes:
/// * uncontrolled — pass a [controller]; `value`/`onChanged` must be null;
/// * controlled — pass `value` and `onChanged` (null `onChanged` disables).
///
/// Child items select through `Choice.choose(context, item)`.
class MultipleChoice<T> extends StatefulWidget {
  /// Creates a single-selection scope.
  const MultipleChoice({
    super.key,
    required this.child,
    this.value,
    this.controller,
    this.onChanged,
    this.enabled,
    this.allowUnselect,
    this.theme,
  }) : assert(
         controller == null || (value == null && onChanged == null),
         'A controller-driven MultipleChoice must not also receive '
         'value/onChanged',
       );

  /// The widget tree containing the choice items.
  final Widget child;

  /// Current selection in controlled mode.
  final T? value;

  /// Controller mode: the controller owns the selection.
  final MultipleChoiceController<T>? controller;

  /// Called with the next selection in controlled mode.
  final ValueChanged<T?>? onChanged;

  /// Overrides the enabled state; null means "interactive when controlled or
  /// controller-driven".
  final bool? enabled;

  /// Whether picking the current item again clears the selection; null falls
  /// back to the resolved theme (default `false`).
  final bool? allowUnselect;

  /// Widget-leg theme override, merged over the component/app/defaults.
  final MultipleChoiceTheme? theme;

  /// Creates the state object for this widget.
  @override
  State<MultipleChoice<T>> createState() => _MultipleChoiceState<T>();
}

class _MultipleChoiceState<T> extends State<MultipleChoice<T>>
    with Choice<T>, FormValueSupplier<T?, MultipleChoice<T>>, AlwaysUpdateData {
  T? get _current => widget.controller?.value ?? widget.value;

  bool get _enabled =>
      widget.enabled ?? (widget.controller != null || widget.onChanged != null);

  bool get _allowUnselect {
    final MultipleChoiceTheme resolved =
        resolveComponentStyle<MultipleChoiceTheme, MultipleChoiceTheme>(
          context,
          widget: widget.theme,
          select: (t) => t,
          defaults: multipleChoiceDefaults,
        );
    return widget.allowUnselect ?? resolved.allowUnselect ?? false;
  }

  void _setValue(T? value) {
    final MultipleChoiceController<T>? controller = widget.controller;
    if (controller != null) {
      controller.value = value;
    } else {
      widget.onChanged?.call(value);
    }
  }

  @override
  void selectItem(T item) {
    if (!_enabled) {
      return;
    }
    // The old state refused to move off an existing selection
    // (`value != null && value != item` returned), so a second tap on another
    // item did nothing. Selecting replaces, exactly as a radio group should.
    if (_current == item) {
      if (_allowUnselect) {
        _setValue(null);
      }
      return;
    }
    _setValue(item);
  }

  @override
  Iterable<T>? get value {
    final T? current = _current;
    return current == null ? null : <T>[current];
  }

  /// Form validation asked for a different value.
  @override
  void didReplaceFormValue(T? value) => _setValue(value);

  @override
  Widget build(BuildContext context) {
    // Report the current value to the nearest form; a no-op without one.
    formValue = _current;
    final MultipleChoiceController<T>? controller = widget.controller;
    if (controller == null) {
      return _build();
    }
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => _build(),
    );
  }

  Widget _build() {
    return Data<Choice<T>>.inherit(data: this, child: widget.child);
  }
}

/// A multi-selection scope.
///
/// Two modes:
/// * uncontrolled — pass a [controller]; `value`/`onChanged` must be null;
/// * controlled — pass `value` and `onChanged` (null `onChanged` disables).
///
/// Child items select through `Choice.choose(context, item)`.
class MultipleAnswer<T> extends StatefulWidget {
  /// Creates a multi-selection scope.
  const MultipleAnswer({
    super.key,
    required this.child,
    this.value,
    this.controller,
    this.onChanged,
    this.enabled,
    this.allowUnselect,
    this.theme,
  }) : assert(
         controller == null || (value == null && onChanged == null),
         'A controller-driven MultipleAnswer must not also receive '
         'value/onChanged',
       );

  /// The widget tree containing the choice items.
  final Widget child;

  /// Current selection in controlled mode.
  final Iterable<T>? value;

  /// Controller mode: the controller owns the selection.
  final MultipleAnswerController<T>? controller;

  /// Called with the next selection in controlled mode.
  final ValueChanged<Iterable<T>?>? onChanged;

  /// Overrides the enabled state; null means "interactive when controlled or
  /// controller-driven".
  final bool? enabled;

  /// Whether picking a selected item again removes it; null falls back to the
  /// resolved theme (default `true`).
  final bool? allowUnselect;

  /// Widget-leg theme override, merged over the component/app/defaults.
  final MultipleChoiceTheme? theme;

  /// Creates the state object for this widget.
  @override
  State<MultipleAnswer<T>> createState() => _MultipleAnswerState<T>();
}

class _MultipleAnswerState<T> extends State<MultipleAnswer<T>>
    with
        Choice<T>,
        FormValueSupplier<Iterable<T>, MultipleAnswer<T>>,
        AlwaysUpdateData {
  Iterable<T>? get _current => widget.controller?.value ?? widget.value;

  bool get _enabled =>
      widget.enabled ?? (widget.controller != null || widget.onChanged != null);

  bool get _allowUnselect {
    final MultipleChoiceTheme resolved =
        resolveComponentStyle<MultipleChoiceTheme, MultipleChoiceTheme>(
          context,
          widget: widget.theme,
          select: (t) => t,
          defaults: multipleAnswerDefaults,
        );
    return widget.allowUnselect ?? resolved.allowUnselect ?? true;
  }

  void _setValue(List<T> value) {
    final MultipleAnswerController<T>? controller = widget.controller;
    if (controller != null) {
      controller.value = value;
    } else {
      widget.onChanged?.call(value);
    }
  }

  @override
  void selectItem(T item) {
    if (!_enabled) {
      return;
    }
    final Iterable<T>? currentValue = _current;
    final List<T> current = currentValue == null
        ? <T>[]
        : List<T>.of(currentValue);
    if (current.remove(item)) {
      if (_allowUnselect) {
        _setValue(current);
      }
      return;
    }
    _setValue(<T>[...current, item]);
  }

  @override
  Iterable<T>? get value => _current;

  /// Form validation asked for a different selection.
  @override
  void didReplaceFormValue(Iterable<T> value) => _setValue(value.toList());

  @override
  Widget build(BuildContext context) {
    // Report the current value to the nearest form; a no-op without one.
    formValue = _current;
    final MultipleAnswerController<T>? controller = widget.controller;
    if (controller == null) {
      return _build();
    }
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => _build(),
    );
  }

  Widget _build() {
    return Data<Choice<T>>.inherit(data: this, child: widget.child);
  }
}
