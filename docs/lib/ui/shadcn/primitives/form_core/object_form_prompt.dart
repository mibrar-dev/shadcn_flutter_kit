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
import '../../theme/density.dart';
import '../../theme/theme.dart';
import '../clickable.dart';
import '../localizations/localizations.dart';
import '../overlay.dart';
import 'object_form_field.dart';

/// The dialog presentation of an object editor.
///
/// The card shrink-wraps its content: a caller that hands it an editor which
/// hugs its own width (the picker dialogs do) gets a dialog exactly as wide
/// as that editor plus its padding — never the 480px frame the old fixed
/// `Column(stretch)` produced. [objectFormDialogMinWidth] is the floor for
/// wide editors, [objectFormDialogMaxWidth] the ceiling.
///
///
/// Object-form dialog card padding: shadcn `p-6` (24) as density
/// multipliers, resolved at build. A compact editor (a calendar, a time
/// wheel) passes a smaller value; `p-0` is what shadcn uses on its picker
/// dialogs, where the editor paints its own shell.
const EdgeInsetsGeometry objectFormDialogPadding = EdgeInsetsDensity.pxAll(24);

/// Object-form popover card padding: shadcn `p-4` (16) as density
/// multipliers, resolved at build.
const EdgeInsetsGeometry objectFormPopupPadding = EdgeInsetsDensity.pxAll(16);

/// Object-form action-row padding: shadcn `px-4 py-2` (16/8) as density
/// multipliers, resolved at build.
const EdgeInsetsGeometry objectFormButtonPadding =
    EdgeInsetsDensity.pxSymmetric(horizontal: 16, vertical: 8);

/// Object-form footer row padding when the footer paints its own top border:
/// shadcn `p-3` (12).
const EdgeInsetsGeometry objectFormFooterPadding = EdgeInsetsDensity.pxAll(12);

/// Object-form dialog inset from the screen edge: shadcn `p-4` (16).
const EdgeInsetsGeometry objectFormScreenPadding = EdgeInsetsDensity.pxAll(16);

/// Narrowest a shrink-wrapping object-form dialog card gets. An editor whose
/// intrinsic width is small (a text field measures its placeholder) would
/// otherwise collapse the card around it. It stays below the calendar's natural
/// width, so a picker still hugs its grid exactly.
const double objectFormDialogMinWidth = 240;

/// Widest an object-form dialog card gets: shadcn `sm:max-w-lg`.
const double objectFormDialogMaxWidth = 480;

/// Lookup key of the object-form dialog card surface.
const ValueKey<String> kObjectFormDialogSurfaceKey = ValueKey<String>(
  'shadcn.object_form.dialog.surface',
);

class ObjectFormPromptDialog<T> extends StatefulWidget {
  /// Creates the dialog page.
  const ObjectFormPromptDialog({
    super.key,
    required this.initialValue,
    required this.editorBuilder,
    this.dialogTitle,
    this.dialogActions,
    this.padding = objectFormDialogPadding,
    this.footerPadding,
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

  /// Padding between the card border and the editor; null means the caller
  /// paints the shell (a `p-0` dialog around a `p-3` calendar, as shadcn
  /// does).
  final EdgeInsetsGeometry? padding;

  /// Padding of the footer row when it paints a top border; null means the
  /// footer sits in the card padding with no separator.
  final EdgeInsetsGeometry? footerPadding;

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
    final double density = theme.density.baseContentPadding * theme.scaling;
    final EdgeInsetsGeometry? cardPadding = widget.padding;
    final EdgeInsetsGeometry? footerPadding = widget.footerPadding;
    Widget footer = Row(
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
          onPressed: () =>
              Navigator.of(context).pop(ObjectFormFieldDialogResult<T>(_value)),
        ),
      ],
    );
    if (footerPadding != null) {
      // shadcn's picker dialogs: the action row keeps its own `p-3` and a
      // hairline top border, so the card itself can be `p-0`.
      footer = DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: theme.colors.border)),
        ),
        child: Padding(
          padding: resolveEdgeInsets(footerPadding, density),
          child: footer,
        ),
      );
    }
    return Center(
      child: Padding(
        padding: resolveEdgeInsets(objectFormScreenPadding, density),
        // `IntrinsicWidth` is what makes the card shrink-wrap: the column
        // inside is stretch-aligned (so the footer still ends at the card's
        // right edge) but the card is only as wide as the widest of title,
        // editor and footer.
        child: IntrinsicWidth(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: objectFormDialogMinWidth * theme.density.scale,
              maxWidth: objectFormDialogMaxWidth,
            ),
            child: DecoratedBox(
              key: kObjectFormDialogSurfaceKey,
              decoration: BoxDecoration(
                color: theme.colors.card,
                border: Border.all(color: theme.colors.border),
                borderRadius: theme.borderRadiusLg,
                boxShadow: theme.tokens.shadows.shadowLg,
              ),
              child: Data<ObjectFormHandler<T>>.inherit(
                data: this,
                child: Padding(
                  padding: cardPadding == null
                      ? EdgeInsets.zero
                      : resolveEdgeInsets(cardPadding, density),
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
                      footer,
                    ],
                  ),
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
          padding: resolveEdgeInsets(
            widget.popoverPadding ?? objectFormPopupPadding,
            theme.density.baseContentPadding * theme.scaling,
          ),
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
      padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
        resolveEdgeInsets(
          objectFormButtonPadding,
          theme.density.baseContentPadding * theme.scaling,
        ),
      ),
      child: Text(label),
    );
  }
}
