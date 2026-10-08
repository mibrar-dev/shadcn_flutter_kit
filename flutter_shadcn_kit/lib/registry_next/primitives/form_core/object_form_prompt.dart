// The two presentations of an `ObjectFormField` editor: a centered dialog and
// an anchored popover. Both implement `ObjectFormHandler` for `editorBuilder`.
//
// Moved from the old `form_field` component. The dialog is a widgets-only
// `showGeneralDialog` page (the old one used the Material `AlertDialog`); the
// popover reads `Data<OverlayHandlerStateMixin>` through `closeOverlay`. The
// action buttons paint from tokens because a primitive cannot import the
// `button` component.

import 'package:flutter/widgets.dart';

import '../../foundation/data.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';
import '../clickable.dart';
import '../localizations/localizations.dart';
import '../overlay.dart';
import 'object_form_field.dart';

/// The dialog presentation of an object editor.
class ObjectFormPromptDialog<T> extends StatefulWidget {
  /// Creates the dialog page.
  const ObjectFormPromptDialog({
    super.key,
    required this.initialValue,
    required this.editorBuilder,
    this.dialogTitle,
    this.dialogActions,
    this.decorate = true,
    required this.onPrompt,
    required this.onChanged,
  });

  /// Value the editor starts with.
  final T? initialValue;

  /// Builds the editor body.
  final Widget Function(BuildContext context, ObjectFormHandler<T> handler)
  editorBuilder;

  /// Optional heading above the editor.
  final Widget? dialogTitle;

  /// Extra actions before Cancel/Save.
  final List<Widget> Function(
    BuildContext context,
    ObjectFormHandler<T> handler,
  )?
  dialogActions;

  /// Whether to paint the dialog surface.
  final bool decorate;

  /// Re-opens another prompt with a value.
  final ValueChanged<T?> onPrompt;

  /// Reports value changes to the field.
  final ValueChanged<T?> onChanged;

  @override
  State<ObjectFormPromptDialog<T>> createState() =>
      _ObjectFormPromptDialogState<T>();
}

class _ObjectFormPromptDialogState<T> extends State<ObjectFormPromptDialog<T>>
    implements ObjectFormHandler<T> {
  late T? _value = widget.initialValue;

  @override
  T? get value => _value;

  @override
  set value(T? value) {
    setState(() => _value = value);
    widget.onChanged(value);
  }

  @override
  void prompt([T? value]) => widget.onPrompt(value);

  @override
  Future<void> close() {
    final ModalRoute<Object?>? route = ModalRoute.of(context);
    Navigator.of(context).pop();
    return route?.completed ?? Future<void>.value();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.decorate) {
      return Data<ObjectFormHandler<T>>.inherit(
        data: this,
        child: widget.editorBuilder(context, this),
      );
    }
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final ShadcnLocalizations localizations = ShadcnLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colors.card,
              border: Border.all(color: theme.colors.border),
              borderRadius: theme.borderRadiusLg,
              boxShadow: theme.tokens.shadows.shadowLg,
            ),
            child: Data<ObjectFormHandler<T>>.inherit(
              data: this,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    if (widget.dialogTitle != null) ...<Widget>[
                      DefaultTextStyle.merge(
                        style: theme.typography.large.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        child: widget.dialogTitle!,
                      ),
                      Gap(theme.spacing.md),
                    ],
                    widget.editorBuilder(context, this),
                    Gap(theme.spacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        if (widget.dialogActions != null)
                          ...widget.dialogActions!(context, this),
                        _PromptButton(
                          label: localizations.buttonCancel,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        Gap(theme.spacing.sm),
                        _PromptButton(
                          label: localizations.buttonSave,
                          primary: true,
                          onPressed: () => Navigator.of(
                            context,
                          ).pop(ObjectFormFieldDialogResult<T>(_value)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The popover presentation of an object editor.
class ObjectFormPromptPopup<T> extends StatefulWidget {
  /// Creates the popover body.
  const ObjectFormPromptPopup({
    super.key,
    required this.initialValue,
    required this.editorBuilder,
    this.popoverPadding,
    this.decorate = true,
    required this.onPrompt,
    required this.onChanged,
  });

  /// Value the editor starts with.
  final T? initialValue;

  /// Builds the editor body.
  final Widget Function(BuildContext context, ObjectFormHandler<T> handler)
  editorBuilder;

  /// Padding inside the popover surface.
  final EdgeInsetsGeometry? popoverPadding;

  /// Whether to paint the popover surface.
  final bool decorate;

  /// Re-opens another prompt with a value.
  final ValueChanged<T?> onPrompt;

  /// Reports value changes to the field.
  final ValueChanged<T?> onChanged;

  @override
  State<ObjectFormPromptPopup<T>> createState() =>
      _ObjectFormPromptPopupState<T>();
}

class _ObjectFormPromptPopupState<T> extends State<ObjectFormPromptPopup<T>>
    implements ObjectFormHandler<T> {
  late T? _value = widget.initialValue;

  @override
  T? get value => _value;

  @override
  set value(T? value) {
    setState(() => _value = value);
    widget.onChanged(value);
  }

  @override
  void prompt([T? value]) => widget.onPrompt(value);

  @override
  Future<void> close() => closeOverlay<void>(context);

  @override
  Widget build(BuildContext context) {
    if (!widget.decorate) {
      return Data<ObjectFormHandler<T>>.inherit(
        data: this,
        child: widget.editorBuilder(context, this),
      );
    }
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Data<ObjectFormHandler<T>>.inherit(
      data: this,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colors.popover,
          border: Border.all(color: theme.colors.border),
          borderRadius: theme.borderRadiusLg,
          boxShadow: theme.tokens.shadows.shadowLg,
        ),
        child: Padding(
          padding: widget.popoverPadding ?? const EdgeInsets.all(16),
          child: widget.editorBuilder(context, this),
        ),
      ),
    );
  }
}

/// A minimal token-painted action button for the dialog footer.
class _PromptButton extends StatelessWidget {
  const _PromptButton({
    required this.label,
    required this.onPressed,
    this.primary = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final Color background = primary
        ? theme.colors.primary
        : theme.colors.input.withValues(alpha: theme.colors.input.a * 0.3);
    final Color foreground = primary
        ? theme.colors.primaryForeground
        : theme.colors.foreground;
    return Clickable(
      onPressed: onPressed,
      decoration: WidgetStatePropertyAll<Decoration>(
        BoxDecoration(
          color: background,
          border: primary ? null : Border.all(color: theme.colors.input),
          borderRadius: theme.borderRadiusMd,
        ),
      ),
      textStyle: WidgetStatePropertyAll<TextStyle>(
        theme.typography.small.copyWith(color: foreground),
      ),
      padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(label),
    );
  }
}
