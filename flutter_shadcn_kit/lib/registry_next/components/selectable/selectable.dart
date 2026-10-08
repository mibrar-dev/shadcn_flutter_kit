// The `selectable` component: read-only selectable text built on the
// widgets-layer [EditableText].
//
// Ported from `components/display/selectable/**` (old tree): it reuses
// `primitives/text_editing` selection controls and context menu so the
// selection experience matches `Input`, and resolves its theme per field.

import 'dart:ui' show BoxHeightStyle, BoxWidthStyle;

import 'package:flutter/gestures.dart' show TapDragUpDetails;
import 'package:flutter/widgets.dart';

import '../../primitives/text_editing/editable_text_style.dart';
import '../../primitives/text_editing/text_editing.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'selectable_style.dart';

export 'selectable_style.dart';

/// Read-only text that users can select, copy and long-press.
///
/// ```dart
/// const SelectableText('Select this text');
/// SelectableText.rich(TextSpan(children: <TextSpan>[...]));
/// ```
class SelectableText extends StatefulWidget {
  /// Creates selectable text from a plain string.
  const SelectableText(
    String this.data, {
    super.key,
    this.focusNode,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.textScaler,
    this.showCursor = false,
    this.autofocus = false,
    this.minLines,
    this.maxLines,
    this.cursorWidth,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.selectionHeightStyle,
    this.selectionWidthStyle,
    this.enableInteractiveSelection,
    this.selectionControls,
    this.contextMenuBuilder,
    this.onTap,
    this.onSelectionChanged,
    this.semanticsLabel,
    this.textHeightBehavior,
    this.textWidthBasis,
    this.theme,
  }) : assert(maxLines == null || maxLines > 0),
       assert(minLines == null || minLines > 0),
       assert(
         maxLines == null || minLines == null || maxLines >= minLines,
         "minLines can't be greater than maxLines",
       ),
       textSpan = null;

  /// Creates selectable text from a styled [TextSpan].
  const SelectableText.rich(
    TextSpan this.textSpan, {
    super.key,
    this.focusNode,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.textScaler,
    this.showCursor = false,
    this.autofocus = false,
    this.minLines,
    this.maxLines,
    this.cursorWidth,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.selectionHeightStyle,
    this.selectionWidthStyle,
    this.enableInteractiveSelection,
    this.selectionControls,
    this.contextMenuBuilder,
    this.onTap,
    this.onSelectionChanged,
    this.semanticsLabel,
    this.textHeightBehavior,
    this.textWidthBasis,
    this.theme,
  }) : assert(maxLines == null || maxLines > 0),
       assert(minLines == null || minLines > 0),
       assert(
         maxLines == null || minLines == null || maxLines >= minLines,
         "minLines can't be greater than maxLines",
       ),
       data = null;

  /// Plain text; null when the [SelectableText.rich] constructor is used.
  final String? data;

  /// Styled text; null when the default constructor is used.
  final TextSpan? textSpan;

  /// Focus node; one is created and disposed internally when null.
  final FocusNode? focusNode;

  /// Style override; merged over the theme and default text style.
  final TextStyle? style;

  /// Strut style override.
  final StrutStyle? strutStyle;

  /// Horizontal text alignment.
  final TextAlign? textAlign;

  /// Text direction override.
  final TextDirection? textDirection;

  /// Text scaling override.
  final TextScaler? textScaler;

  /// Whether to paint a blinking caret when focused.
  final bool showCursor;

  /// Whether to focus when first built.
  final bool autofocus;

  /// Minimum number of lines.
  final int? minLines;

  /// Maximum number of lines before scrolling.
  final int? maxLines;

  /// Caret width override.
  final double? cursorWidth;

  /// Caret height override.
  final double? cursorHeight;

  /// Caret corner radius override.
  final Radius? cursorRadius;

  /// Caret colour override.
  final Color? cursorColor;

  /// Selection box height style override.
  final BoxHeightStyle? selectionHeightStyle;

  /// Selection box width style override.
  final BoxWidthStyle? selectionWidthStyle;

  /// Whether drag/double-tap/long-press selection is enabled.
  final bool? enableInteractiveSelection;

  /// Selection controls override; defaults to `ShadcnSelectionControls`.
  final TextSelectionControls? selectionControls;

  /// Context menu builder override; defaults to the shadcn toolbar.
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  /// Called when the text is tapped.
  final VoidCallback? onTap;

  /// Called when the selection changes.
  final SelectionChangedCallback? onSelectionChanged;

  /// Semantic label; replaces the text semantics when set.
  final String? semanticsLabel;

  /// Text height behavior override.
  final TextHeightBehavior? textHeightBehavior;

  /// Text width basis override.
  final TextWidthBasis? textWidthBasis;

  /// Widget-leg theme override, merged on top of the other legs.
  final SelectableTextTheme? theme;

  @override
  State<SelectableText> createState() => _SelectableTextState();
}

/// Renders [textSpan] instead of the controller's plain text.
class _TextSpanEditingController extends TextEditingController {
  _TextSpanEditingController({required TextSpan textSpan})
    : _textSpan = textSpan,
      super(text: textSpan.toPlainText(includeSemanticsLabels: false));

  final TextSpan _textSpan;

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    return TextSpan(style: style, children: <TextSpan>[_textSpan]);
  }

  @override
  set text(String? newText) {
    throw UnimplementedError('SelectableText content is immutable');
  }
}

class _SelectableTextState extends State<SelectableText>
    implements TextSelectionGestureDetectorBuilderDelegate {
  late _TextSpanEditingController _controller;
  FocusNode? _ownedFocusNode;
  bool _showSelectionHandles = false;
  bool _selectionEnabled = true;

  FocusNode get _effectiveFocusNode =>
      widget.focusNode ??
      (_ownedFocusNode ??= FocusNode(debugLabel: 'SelectableText'));

  @override
  final GlobalKey<EditableTextState> editableTextKey =
      GlobalKey<EditableTextState>();

  // Force-press selection is not part of the kit's gesture vocabulary.
  @override
  bool get forcePressEnabled => false;

  @override
  bool get selectionEnabled => _selectionEnabled;

  late final TextSelectionGestureDetectorBuilder _gestureBuilder =
      _SelectableGestureDetectorBuilder(state: this);

  @override
  void initState() {
    super.initState();
    _controller = _createController();
    _controller.addListener(_handleControllerChanged);
    _effectiveFocusNode.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(covariant SelectableText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data ||
        widget.textSpan != oldWidget.textSpan) {
      _controller.removeListener(_handleControllerChanged);
      _controller.dispose();
      _controller = _createController();
      _controller.addListener(_handleControllerChanged);
    }
    if (widget.focusNode != oldWidget.focusNode) {
      (oldWidget.focusNode ?? _ownedFocusNode)?.removeListener(
        _handleFocusChanged,
      );
      _effectiveFocusNode.addListener(_handleFocusChanged);
    }
    if (_effectiveFocusNode.hasFocus && _controller.selection.isCollapsed) {
      _showSelectionHandles = false;
    } else {
      _showSelectionHandles = true;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);
    _effectiveFocusNode.removeListener(_handleFocusChanged);
    _controller.dispose();
    _ownedFocusNode?.dispose();
    super.dispose();
  }

  _TextSpanEditingController _createController() {
    return _TextSpanEditingController(
      textSpan: widget.textSpan ?? TextSpan(text: widget.data ?? ''),
    );
  }

  void _handleControllerChanged() {
    final bool showSelectionHandles =
        !_effectiveFocusNode.hasFocus || !_controller.selection.isCollapsed;
    if (showSelectionHandles == _showSelectionHandles) {
      return;
    }
    setState(() => _showSelectionHandles = showSelectionHandles);
  }

  void _handleFocusChanged() {
    _handleControllerChanged();
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData shadcnTheme = ShadcnTheme.of(context);
    final ShadcnColors colors = shadcnTheme.colors;
    final resolved =
        resolveComponentStyle<SelectableTextTheme, SelectableTextTheme>(
          context,
          widget: widget.theme,
          select: (t) => t,
          defaults: selectableDefaults,
        );
    _selectionEnabled =
        widget.enableInteractiveSelection ??
        resolved.enableInteractiveSelection ??
        true;
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    // EditableText ignores ambient inheritance: resolve the theme font.
    final TextStyle effectiveStyle = resolveEditableTextStyle(
      context,
      base: defaultTextStyle.style,
      overrides: [resolved.textStyle, widget.textSpan?.style, widget.style],
      color: colors.foreground,
    );
    final Color cursorColor =
        widget.cursorColor ??
        resolved.cursorColor?.resolve(colors) ??
        colors.primary;
    final Color selectionColor =
        DefaultSelectionStyle.of(context).selectionColor ??
        colors.primary.withValues(alpha: colors.primary.a * 0.2);

    final Widget editable = EditableText(
      key: editableTextKey,
      controller: _controller,
      focusNode: _effectiveFocusNode,
      style: effectiveStyle,
      readOnly: true,
      showCursor: widget.showCursor,
      showSelectionHandles: _showSelectionHandles,
      cursorWidth: widget.cursorWidth ?? resolved.cursorWidth ?? 2,
      cursorHeight: widget.cursorHeight ?? resolved.cursorHeight,
      cursorRadius: widget.cursorRadius ?? resolved.cursorRadius,
      cursorColor: cursorColor,
      backgroundCursorColor: colors.border,
      selectionColor: selectionColor,
      selectionControls: _selectionEnabled
          ? widget.selectionControls ?? ShadcnSelectionControls()
          : null,
      contextMenuBuilder:
          widget.contextMenuBuilder ?? defaultShadcnContextMenuBuilder,
      selectionHeightStyle:
          widget.selectionHeightStyle ??
          resolved.selectionHeightStyle ??
          BoxHeightStyle.tight,
      selectionWidthStyle:
          widget.selectionWidthStyle ??
          resolved.selectionWidthStyle ??
          BoxWidthStyle.tight,
      enableInteractiveSelection: _selectionEnabled,
      textAlign:
          widget.textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start,
      textDirection: widget.textDirection,
      textScaler: widget.textScaler,
      strutStyle: widget.strutStyle,
      maxLines: widget.maxLines ?? defaultTextStyle.maxLines,
      minLines: widget.minLines,
      autofocus: widget.autofocus,
      textWidthBasis: widget.textWidthBasis ?? defaultTextStyle.textWidthBasis,
      textHeightBehavior:
          widget.textHeightBehavior ?? defaultTextStyle.textHeightBehavior,
      onSelectionChanged: widget.onSelectionChanged,
      rendererIgnoresPointer: true,
    );

    return Semantics(
      label: widget.semanticsLabel,
      excludeSemantics: widget.semanticsLabel != null,
      onLongPress: _effectiveFocusNode.requestFocus,
      child: RepaintBoundary(
        child: _gestureBuilder.buildGestureDetector(
          behavior: HitTestBehavior.translucent,
          child: editable,
        ),
      ),
    );
  }
}

/// Adds [SelectableText.onTap] on top of the standard tap handling.
class _SelectableGestureDetectorBuilder
    extends TextSelectionGestureDetectorBuilder {
  _SelectableGestureDetectorBuilder({required _SelectableTextState state})
    : _state = state,
      super(delegate: state);

  final _SelectableTextState _state;

  @override
  void onSingleTapUp(TapDragUpDetails details) {
    if (!delegate.selectionEnabled) {
      return;
    }
    super.onSingleTapUp(details);
    _state.widget.onTap?.call();
  }
}
