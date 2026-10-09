// The `form` component: the [ShadcnForm] scope and the field layouts ([ShadcnFormField],
// [FormInline], [FormTableLayout]); the form machinery lives in
// `primitives/form_core/` and is re-exported here.

import 'package:flutter/widgets.dart';

import '../../foundation/data.dart';
import '../../foundation/gap.dart';
import '../../primitives/form_core/form_builders.dart';
import '../../primitives/form_core/form_controller.dart';
import '../../primitives/form_core/form_core.dart';
import '../../primitives/form_core/form_entry.dart';
import '../../primitives/form_core/validation.dart';
import 'form_style.dart';

export '../../primitives/form_core/form_builders.dart';
export '../../primitives/form_core/form_controller.dart';
export '../../primitives/form_core/form_core.dart';
export '../../primitives/form_core/form_entry.dart';
export '../../primitives/form_core/form_value.dart';
export '../../primitives/form_core/object_form_field.dart';
export '../../primitives/form_core/validation.dart';
export '../../primitives/form_core/validators.dart';
export '../../primitives/form_core/validators_compare.dart';
export 'form_style.dart';

/// Provides form state and installs [onSubmit] on the controller.
class ShadcnForm extends StatefulWidget {
  const ShadcnForm({
    super.key,
    required this.child,
    this.controller,
    this.onSubmit,
  });

  /// The subtree containing the form fields.
  final Widget child;

  /// External controller; a private one is created and disposed when null.
  final FormController? controller;

  /// Called by `FormController.submit` after a successful validation.
  final FormSubmitCallback? onSubmit;

  /// The nearest controller, or null outside a form.
  static FormController? maybeOf(BuildContext context) =>
      Data.maybeOf<FormController>(context);

  /// The nearest controller; asserts outside a form.
  static FormController of(BuildContext context) =>
      Data.of<FormController>(context);

  @override
  State<ShadcnForm> createState() => _FormState();
}

class _FormState extends State<ShadcnForm> {
  late FormController _controller = widget.controller ?? FormController();

  @override
  void initState() {
    super.initState();
    _controller.onSubmit = widget.onSubmit;
  }

  @override
  void didUpdateWidget(covariant ShadcnForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller == null) {
        _controller.dispose();
      }
      _controller = widget.controller ?? FormController();
    }
    _controller.onSubmit = widget.onSubmit;
  }

  @override
  void dispose() {
    _controller.onSubmit = null;
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Data<FormController>.inherit(data: _controller, child: widget.child);
  }
}

/// A labelled field with hint and validation message.
class ShadcnFormField<T> extends StatelessWidget {
  const ShadcnFormField({
    required FormKey<T> super.key,
    required this.label,
    required this.child,
    this.hint,
    this.leadingLabel,
    this.trailingLabel,
    this.labelAxisAlignment = MainAxisAlignment.start,
    this.leadingGap,
    this.trailingGap,
    this.padding = EdgeInsets.zero,
    this.validator,
    this.showErrors,
    this.theme,
  });

  @override
  FormKey<T> get key => super.key as FormKey<T>;

  final Widget label;

  final Widget child;

  final Widget? hint;

  final Widget? leadingLabel;

  final Widget? trailingLabel;

  final MainAxisAlignment labelAxisAlignment;

  final double? leadingGap;

  final double? trailingGap;

  final EdgeInsetsGeometry padding;

  final Validator<T>? validator;

  final Set<FormValidationMode>? showErrors;

  final FormTheme? theme;

  @override
  Widget build(BuildContext context) {
    return FormEntry<T>(
      key: key,
      validator: validator,
      child: FormEntryErrorBuilder(
        modes: showErrors,
        child: child,
        builder: (context, error, content) {
          final FormResolvedTheme resolved = resolveFormTheme(context, theme);
          final String? message = error is InvalidResult ? error.message : null;
          final Widget? leading = leadingLabel;
          final Widget? trailing = trailingLabel;
          final TextStyle labelStyle = message != null
              ? resolved.labelStyle.copyWith(color: resolved.messageStyle.color)
              : resolved.labelStyle;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: padding,
                child: Row(
                  mainAxisAlignment: labelAxisAlignment,
                  children: <Widget>[
                    if (leading != null) ...<Widget>[
                      DefaultTextStyle.merge(
                        style: resolved.hintStyle,
                        child: leading,
                      ),
                      Gap(leadingGap ?? resolved.spacing),
                    ],
                    Expanded(
                      child: DefaultTextStyle.merge(
                        style: labelStyle,
                        child: label,
                      ),
                    ),
                    if (trailing != null) ...<Widget>[
                      Gap(trailingGap ?? resolved.spacing),
                      DefaultTextStyle.merge(
                        style: resolved.hintStyle,
                        child: trailing,
                      ),
                    ],
                  ],
                ),
              ),
              Gap(resolved.spacing),
              content!,
              FormFieldMessages(
                hint: hint,
                message: message,
                spacing: resolved.spacing,
                hintStyle: resolved.hintStyle,
                messageStyle: resolved.messageStyle,
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Hint and error message below a field, used by every form layout.
class FormFieldMessages extends StatelessWidget {
  const FormFieldMessages({
    super.key,
    required this.spacing,
    required this.hintStyle,
    required this.messageStyle,
    this.hint,
    this.message,
  });

  final double spacing;

  final TextStyle hintStyle;

  final TextStyle messageStyle;

  final Widget? hint;

  final String? message;

  @override
  Widget build(BuildContext context) {
    final Widget? hintWidget = hint;
    final String? messageText = message;
    if (hintWidget == null && messageText == null) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (hintWidget != null) ...<Widget>[
          Gap(spacing),
          DefaultTextStyle.merge(style: hintStyle, child: hintWidget),
        ],
        if (messageText != null) ...<Widget>[
          Gap(spacing),
          DefaultTextStyle.merge(style: messageStyle, child: Text(messageText)),
        ],
      ],
    );
  }
}

/// A compact field with the label beside the input.
class FormInline<T> extends StatelessWidget {
  const FormInline({
    required FormKey<T> super.key,
    required this.label,
    required this.child,
    this.hint,
    this.validator,
    this.showErrors,
    this.theme,
  });

  @override
  FormKey<T> get key => super.key as FormKey<T>;

  final Widget label;

  final Widget child;

  final Widget? hint;

  final Validator<T>? validator;

  final Set<FormValidationMode>? showErrors;

  final FormTheme? theme;

  @override
  Widget build(BuildContext context) {
    return FormEntry<T>(
      key: key,
      validator: validator,
      child: FormEntryErrorBuilder(
        modes: showErrors,
        child: child,
        builder: (context, error, content) {
          final FormResolvedTheme resolved = resolveFormTheme(context, theme);
          final String? message = error is InvalidResult ? error.message : null;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  DefaultTextStyle.merge(
                    style: message != null
                        ? resolved.labelStyle.copyWith(
                            color: resolved.messageStyle.color,
                          )
                        : resolved.labelStyle,
                    child: label,
                  ),
                  Gap(resolved.spacing),
                  Expanded(child: content!),
                ],
              ),
              FormFieldMessages(
                hint: hint,
                message: message,
                spacing: resolved.spacing,
                hintStyle: resolved.hintStyle,
                messageStyle: resolved.messageStyle,
              ),
            ],
          );
        },
      ),
    );
  }
}

/// A two-column table of labelled fields.
class FormTableLayout extends StatelessWidget {
  const FormTableLayout({
    super.key,
    required this.rows,
    this.spacing,
    this.theme,
  });

  final List<ShadcnFormField<Object?>> rows;

  final double? spacing;

  final FormTheme? theme;

  @override
  Widget build(BuildContext context) {
    final FormResolvedTheme resolved = resolveFormTheme(context, theme);
    final double gap = spacing ?? resolved.spacing * 2;
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(),
        1: FlexColumnWidth(),
      },
      children: <TableRow>[
        for (int i = 0; i < rows.length; i += 1)
          TableRow(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  top: i == 0 ? 0 : gap,
                  right: resolved.spacing * 2,
                ),
                child: DefaultTextStyle.merge(
                  style: resolved.labelStyle,
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: rows[i].label,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: i == 0 ? 0 : gap),
                child: FormEntry<Object?>(
                  key: rows[i].key,
                  validator: rows[i].validator,
                  child: FormEntryErrorBuilder(
                    modes: rows[i].showErrors,
                    child: rows[i].child,
                    builder: (context, error, content) {
                      final String? message = error is InvalidResult
                          ? error.message
                          : null;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          content!,
                          FormFieldMessages(
                            hint: rows[i].hint,
                            message: message,
                            spacing: resolved.spacing,
                            hintStyle: resolved.hintStyle,
                            messageStyle: resolved.messageStyle,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
