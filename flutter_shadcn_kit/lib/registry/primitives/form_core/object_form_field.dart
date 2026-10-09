// The object form field: a button-like trigger that opens a dialog or popover
// editor for a complex value.
//
// Ported from the old `form_field` component (absorbed into `form`) into
// `form_core` because the form component folder is capped at two code files.
// Differences from the old widget:
//
// * the trigger paints itself from tokens instead of reusing `OutlineButton`
//   (a primitive may not import the `button` component);
// * `size` / `density` / `shape` are gone (the trigger is one shape now);
// * the dialog prompt is a widgets-only `showGeneralDialog` route that captures
//   themes and data; the popover prompt reuses `PopoverController`.

import 'package:flutter/widgets.dart';

import '../../foundation/captured_wrapper.dart';
import '../../foundation/data.dart';
import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import '../clickable.dart';
import '../localizations/localizations.dart';
import '../widget_states.dart';
import '../overlay.dart';
import '../popover_controller.dart';
import 'form_value.dart';
import 'object_form_prompt.dart';

/// How an [ObjectFormField] presents its editor.
enum PromptMode {
  /// A centered modal dialog with cancel/save actions.
  dialog,

  /// An anchored popover that reports changes live.
  popover,
}

/// Controls an open object editor from inside `editorBuilder`.
abstract class ObjectFormHandler<T> {
  /// The value the editor is working on.
  T? get value;

  /// Updates the editor's working value.
  set value(T? value);

  /// Opens another prompt with [value].
  void prompt([T? value]);

  /// Closes the editor; completes when its route/overlay is gone.
  Future<void> close();

  /// The nearest handler; asserts when absent.
  static ObjectFormHandler<T> of<T>(BuildContext context) =>
      Data.of<ObjectFormHandler<T>>(context);

  /// The nearest handler, or null.
  static ObjectFormHandler<T>? find<T>(BuildContext context) =>
      Data.maybeOf<ObjectFormHandler<T>>(context);
}

/// The result a dialog prompt pops with.
class ObjectFormFieldDialogResult<T> {
  /// Creates a dialog result wrapping [value].
  ObjectFormFieldDialogResult(this.value);

  /// The edited value.
  final T? value;
}

/// A form field whose value is edited through a dialog or popover.
class ObjectFormField<T> extends StatefulWidget {
  /// Creates an object form field.
  const ObjectFormField({
    super.key,
    required this.value,
    this.onChanged,
    required this.placeholder,
    required this.builder,
    this.leading,
    this.trailing,
    this.mode = PromptMode.dialog,
    required this.editorBuilder,
    this.popoverAlignment,
    this.popoverAnchorAlignment,
    this.popoverPadding,
    this.dialogTitle,
    this.dialogActions,
    this.enabled,
    this.decorate = true,
    this.immediateValueChange,
  });

  /// The current value.
  final T? value;

  /// Called with the next value.
  final ValueChanged<T?>? onChanged;

  /// Shown while [value] is null.
  final Widget placeholder;

  /// Builds the trigger content from a non-null value.
  final Widget Function(BuildContext context, T value) builder;

  /// Optional widget before the trigger content.
  final Widget? leading;

  /// Optional widget after the trigger content.
  final Widget? trailing;

  /// Dialog or popover presentation.
  final PromptMode mode;

  /// Builds the editor; the handler reads/updates the working value.
  final Widget Function(BuildContext context, ObjectFormHandler<T> handler)
  editorBuilder;

  /// Popover alignment relative to the trigger.
  final AlignmentGeometry? popoverAlignment;

  /// Anchor alignment for popover positioning.
  final AlignmentGeometry? popoverAnchorAlignment;

  /// Padding inside the popover surface.
  final EdgeInsetsGeometry? popoverPadding;

  /// Title of the dialog prompt.
  final Widget? dialogTitle;

  /// Extra dialog actions before Cancel/Save.
  final List<Widget> Function(
    BuildContext context,
    ObjectFormHandler<T> handler,
  )?
  dialogActions;

  /// Overrides the enabled state; null means `onChanged != null`.
  final bool? enabled;

  /// Whether prompt mode paints its own surface around the editor.
  final bool decorate;

  /// Whether edits are reported live.
  ///
  /// Defaults to true in popover mode and false in dialog mode: dialogs report
  /// once on save/close.
  final bool? immediateValueChange;

  @override
  State<ObjectFormField<T>> createState() => _ObjectFormFieldState<T>();
}

class _ObjectFormFieldState<T> extends State<ObjectFormField<T>>
    with FormValueSupplier<T, ObjectFormField<T>> {
  final PopoverController _popoverController = PopoverController();

  bool get _enabled => widget.enabled ?? (widget.onChanged != null);

  @override
  void dispose() {
    _popoverController.dispose();
    super.dispose();
  }

  void _setValue(T? value) {
    widget.onChanged?.call(value);
    formValue = value;
  }

  @override
  void didReplaceFormValue(T value) => _setValue(value);

  void prompt([T? value]) {
    if (widget.mode == PromptMode.dialog) {
      _showDialog(value);
    } else {
      _showPopover(value);
    }
  }

  void _showDialog([T? initial]) {
    final T? value = initial ?? formValue;
    final NavigatorState navigator = Navigator.of(context, rootNavigator: true);
    final CapturedThemes themes = InheritedTheme.capture(
      from: context,
      to: navigator.context,
    );
    final CapturedData data = Data.capture(
      from: context,
      to: navigator.context,
    );
    showGeneralDialog<ObjectFormFieldDialogResult<T>>(
      context: context,
      barrierDismissible: true,
      barrierLabel: ShadcnLocalizations.of(context).dialogDismiss,
      barrierColor: const Color(0x80000000),
      transitionDuration: const Duration(milliseconds: 150),
      pageBuilder: (context, animation, secondaryAnimation) {
        return CapturedWrapper(
          themes: themes,
          data: data,
          child: ObjectFormPromptDialog<T>(
            initialValue: value,
            editorBuilder: widget.editorBuilder,
            dialogTitle: widget.dialogTitle,
            dialogActions: widget.dialogActions,
            decorate: widget.decorate,
            onPrompt: prompt,
            onChanged: (changed) {
              if (widget.immediateValueChange == true) {
                _setValue(changed);
              }
            },
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final Animation<double> curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
          reverseCurve: Curves.easeIn,
        );
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.7, end: 1).animate(curved),
            child: child,
          ),
        );
      },
    ).then((result) {
      if (!mounted) {
        return;
      }
      if (result is ObjectFormFieldDialogResult<T> &&
          widget.immediateValueChange != true) {
        _setValue(result.value);
      }
    });
  }

  void _showPopover([T? initial]) {
    final T? value = initial ?? formValue;
    T? delayed = value;
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    _popoverController
        .show<void>(
          context: context,
          alignment: widget.popoverAlignment ?? Alignment.topLeft,
          anchorAlignment:
              widget.popoverAnchorAlignment ?? Alignment.bottomLeft,
          offset: Offset(0, theme.spacing.xs),
          modal: true,
          overlayBarrier: OverlayBarrier(borderRadius: theme.borderRadiusLg),
          builder: (context) {
            return ObjectFormPromptPopup<T>(
              initialValue: value,
              editorBuilder: widget.editorBuilder,
              popoverPadding: widget.popoverPadding,
              decorate: widget.decorate,
              onPrompt: prompt,
              onChanged: (changed) {
                if (widget.immediateValueChange != false) {
                  _setValue(changed);
                } else {
                  delayed = changed;
                }
              },
            );
          },
        )
        .then((_) {
          if (mounted && widget.immediateValueChange == false) {
            _setValue(delayed);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    // Report the current value to the nearest form; a no-op without one.
    formValue = widget.value;
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final bool enabled = _enabled;
    final Color foreground = theme.colors.foreground;
    final Color muted = theme.colors.mutedForeground;
    final Color borderColor = theme.colors.input;

    Decoration decoration(Set<WidgetState> states) {
      final double alpha = states.hovered || states.pressed ? 0.5 : 0.3;
      return BoxDecoration(
        color: theme.colors.input.withValues(
          alpha: theme.colors.input.a * alpha,
        ),
        border: Border.all(color: borderColor),
        borderRadius: theme.borderRadiusMd,
      );
    }

    Widget content = widget.value == null
        ? DefaultTextStyle.merge(
            style: TextStyle(color: muted),
            child: widget.placeholder,
          )
        : widget.builder(context, widget.value as T);
    content = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ?widget.leading,
        if (widget.leading != null) Gap(theme.spacing.sm),
        Flexible(child: content),
        if (widget.trailing != null) Gap(theme.spacing.sm),
        ?widget.trailing,
      ],
    );

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Clickable(
        enabled: enabled,
        onPressed: enabled ? prompt : null,
        mouseCursor: const StateValue<MouseCursor>(
          rest: SystemMouseCursors.click,
          disabled: SystemMouseCursors.basic,
        ),
        decoration: WidgetStateProperty.resolveWith(decoration),
        textStyle: WidgetStatePropertyAll<TextStyle>(
          theme.typography.small.copyWith(color: foreground),
        ),
        padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 36),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[Expanded(child: content)],
          ),
        ),
      ),
    );
  }
}
