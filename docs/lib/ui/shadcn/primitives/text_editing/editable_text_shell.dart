// The visual machinery of a text field: the surface shell (decoration,
// gesture detector, focus ring, hover/disabled states, error text) and the
// row that lays out adornments around the editable text.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../focus_outline.dart';

/// The standard visual shell around a text field's content.
///
/// Paints [decoration], wraps [child] in the gesture detector, draws the focus
/// ring, tracks hover through [onHover] and dims/ignores input while disabled.
/// An optional [errorText] is rendered below the field.
class EditableTextShell extends StatelessWidget {
  /// Creates a shell.
  const EditableTextShell({
    super.key,
    required this.child,
    required this.decoration,
    required this.padding,
    required this.gestureBuilder,
    required this.focused,
    required this.enabled,
    required this.minHeight,
    this.borderRadius,
    this.errorText,
    this.errorStyle,
    this.gap = 4,
    this.hitBehavior = HitTestBehavior.translucent,
    this.onHover,
  });

  /// The field content, usually an [EditableTextFieldRow].
  final Widget child;

  /// Field surface decoration.
  final Decoration decoration;

  /// Corner radius of the focus ring.
  final BorderRadiusGeometry? borderRadius;

  /// Padding between the surface and [child].
  final EdgeInsetsGeometry padding;

  /// Gesture builder from the [EditableTextHost].
  final TextSelectionGestureDetectorBuilder gestureBuilder;

  /// Whether the focus ring is shown.
  final bool focused;

  /// Whether the field accepts input; false dims and ignores pointers.
  final bool enabled;

  /// Minimum field height.
  final double minHeight;

  /// Error message rendered below the field.
  final String? errorText;

  /// Style of [errorText].
  final TextStyle? errorStyle;

  /// Gap between the field and [errorText].
  final double gap;

  /// Hit-test behavior of the gesture detector.
  final HitTestBehavior hitBehavior;

  /// Called when the hover state changes.
  final ValueChanged<bool>? onHover;

  @override
  Widget build(BuildContext context) {
    Widget field = Container(
      decoration: decoration,
      child: gestureBuilder.buildGestureDetector(
        behavior: hitBehavior,
        child: Padding(padding: padding, child: child),
      ),
    );
    field = MouseRegion(
      cursor: enabled ? SystemMouseCursors.text : SystemMouseCursors.forbidden,
      onEnter: (_) => onHover?.call(true),
      onExit: (_) => onHover?.call(false),
      child: FocusOutline(
        focused: focused,
        borderRadius: borderRadius,
        child: field,
      ),
    );
    field = ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: field,
    );
    field = Semantics(
      enabled: enabled,
      child: Opacity(
        opacity: enabled ? 1 : 0.5,
        child: IgnorePointer(ignoring: !enabled, child: field),
      ),
    );
    final message = errorText;
    if (message != null) {
      field = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          field,
          Padding(
            padding: EdgeInsets.only(top: gap),
            child: Text(message, style: errorStyle),
          ),
        ],
      );
    }
    return field;
  }
}

/// Lays out leading/trailing adornments around an editable child, with a
/// placeholder (widget or hint text) stacked under the text while empty.
class EditableTextFieldRow extends StatelessWidget {
  /// Creates a field row.
  const EditableTextFieldRow({
    super.key,
    required this.editable,
    required this.showPlaceholder,
    this.placeholder,
    this.hintText,
    this.hintStyle,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.leading = const <Widget>[],
    this.trailing = const <Widget>[],
    this.gap = 4,
  });

  /// The editable text widget.
  final Widget editable;

  /// Whether the field is empty and the placeholder may show.
  final bool showPlaceholder;

  /// Placeholder widget; wins over [hintText].
  final Widget? placeholder;

  /// Placeholder text.
  final String? hintText;

  /// Style of [hintText].
  final TextStyle? hintStyle;

  /// Alignment of [hintText].
  final TextAlign textAlign;

  /// Maximum lines of [hintText].
  final int? maxLines;

  /// Widgets before the editable text.
  final List<Widget> leading;

  /// Widgets after the editable text.
  final List<Widget> trailing;

  /// Gap between adornments and the text.
  final double gap;

  Widget? _resolvedPlaceholder() {
    if (!showPlaceholder) {
      return null;
    }
    if (placeholder != null) {
      return placeholder;
    }
    final hint = hintText;
    if (hint == null) {
      return null;
    }
    return Text(
      hint,
      style: hintStyle,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }

  Widget _group(List<Widget> children) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (var i = 0; i < children.length; i++) ...<Widget>[
          if (i > 0) Gap(gap),
          children[i],
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final placeholder = _resolvedPlaceholder();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (leading.isNotEmpty) ...<Widget>[_group(leading), Gap(gap)],
        Expanded(
          child: Stack(
            alignment: AlignmentDirectional.centerStart,
            children: <Widget>[
              if (placeholder != null) IgnorePointer(child: placeholder),
              editable,
            ],
          ),
        ),
        if (trailing.isNotEmpty) ...<Widget>[Gap(gap), _group(trailing)],
      ],
    );
  }
}
