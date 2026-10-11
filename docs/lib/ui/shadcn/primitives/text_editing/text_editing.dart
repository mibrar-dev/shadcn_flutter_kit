// Widgets-only text selection support: selection handles and the default
// Cut / Copy / Paste / Select-all context menu.
//
// Replaces Material's text selection controls and
// `AdaptiveTextSelectionToolbar` with plain `package:flutter/widgets.dart`
// widgets. The toolbar labels come from `ShadcnLocalizations`; the button list
// comes from `EditableTextState.contextMenuButtonItems`, so a read-only field
// automatically exposes only the Copy / Select-all subset.

import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../clickable.dart';
import '../localizations/localizations.dart';

/// Default selection handle diameter in logical pixels.
const double kShadcnSelectionHandleSize = 20;

/// Widgets-only text selection controls.
///
/// Mixes in [TextSelectionHandleControls], which tells [EditableText] to use
/// `contextMenuBuilder` (see [defaultShadcnContextMenuBuilder]) instead of the
/// deprecated `buildToolbar`; cut/copy/paste/select-all availability and
/// behaviour stay with `EditableTextState` itself.
class ShadcnSelectionControls extends TextSelectionControls
    with TextSelectionHandleControls {
  /// Creates selection controls.
  ///
  /// [color] defaults to the ambient `ring` token; [handleSize] is the handle
  /// diameter.
  ShadcnSelectionControls({
    this.color,
    this.handleSize = kShadcnSelectionHandleSize,
  });

  /// Handle color; null uses the ambient `ring` token.
  final Color? color;

  /// Handle diameter in logical pixels.
  final double handleSize;

  /// Value equality: `EditableText` disposes and recreates its selection
  /// overlay whenever `selectionControls !=`, so two default-constructed
  /// controls must compare equal. Without this, every rebuild of a field
  /// (e.g. a popover re-invoking its builder, which creates fresh widgets)
  /// churns the overlay entries — removing and disposing them mid-build and
  /// crashing the overlay with a zombie entry (`_TypeError` in
  /// `_OverlayEntryWidgetState.initState`).
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShadcnSelectionControls &&
          other.color == color &&
          other.handleSize == handleSize;

  @override
  int get hashCode => Object.hash(color, handleSize);

  @override
  Size getHandleSize(double textLineHeight) => Size.square(handleSize);

  @override
  Offset getHandleAnchor(TextSelectionHandleType type, double textLineHeight) {
    // Left/right handles hang below the selection point; the collapsed cursor
    // handle sits above it. Keeping handles off the text line stops them from
    // swallowing the next tap of a double tap.
    return switch (type) {
      TextSelectionHandleType.left ||
      TextSelectionHandleType.right => Offset(handleSize / 2, 0),
      TextSelectionHandleType.collapsed => Offset(handleSize / 2, handleSize),
    };
  }

  @override
  Widget buildHandle(
    BuildContext context,
    TextSelectionHandleType type,
    double textLineHeight, [
    VoidCallback? onTap,
  ]) {
    final theme = ShadcnTheme.of(context);
    return _SelectionHandle(
      size: handleSize,
      color: color ?? theme.colors.ring,
      dotColor: theme.colors.background,
      onTap: onTap,
    );
  }
}

/// The ring circle handle painted at both ends of a selection.
class _SelectionHandle extends StatelessWidget {
  const _SelectionHandle({
    required this.size,
    required this.color,
    required this.dotColor,
    this.onTap,
  });

  final double size;
  final Color color;
  final Color dotColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget handle = CustomPaint(
      size: Size.square(size),
      painter: _SelectionHandlePainter(color: color, dotColor: dotColor),
    );
    if (onTap == null) {
      return handle;
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: handle,
    );
  }
}

class _SelectionHandlePainter extends CustomPainter {
  const _SelectionHandlePainter({required this.color, required this.dotColor});

  final Color color;
  final Color dotColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double radius = size.shortestSide / 2;
    canvas.drawCircle(center, radius, Paint()..color = color);
    canvas.drawCircle(center, radius * 0.42, Paint()..color = dotColor);
  }

  @override
  bool shouldRepaint(_SelectionHandlePainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.dotColor != dotColor;
  }
}

/// Context-menu button types the shadcn toolbar renders.
const Set<ContextMenuButtonType> kShadcnContextMenuTypes =
    <ContextMenuButtonType>{
      ContextMenuButtonType.cut,
      ContextMenuButtonType.copy,
      ContextMenuButtonType.paste,
      ContextMenuButtonType.selectAll,
    };

/// Builds the default shadcn context menu for an [EditableText].
///
/// Filters `contextMenuButtonItems` down to
/// [kShadcnContextMenuTypes] and positions them at the selection anchors.
Widget defaultShadcnContextMenuBuilder(
  BuildContext context,
  EditableTextState editableTextState,
) {
  final anchors = editableTextState.contextMenuAnchors;
  final items = editableTextState.contextMenuButtonItems
      .where((item) => kShadcnContextMenuTypes.contains(item.type))
      .toList(growable: false);
  if (items.isEmpty) {
    return const SizedBox.shrink();
  }
  return ShadcnTextSelectionToolbar(
    anchorAbove: anchors.primaryAnchor,
    anchorBelow: anchors.secondaryAnchor ?? anchors.primaryAnchor,
    buttonItems: items,
  );
}

/// Cut / Copy / Paste / Select-all toolbar positioned at a selection anchor.
///
/// Placed by `EditableText.contextMenuBuilder` in the app overlay; the anchors
/// are global coordinates, which is what the overlay uses too.
class ShadcnTextSelectionToolbar extends StatelessWidget {
  /// Creates a selection toolbar.
  const ShadcnTextSelectionToolbar({
    super.key,
    required this.anchorAbove,
    required this.anchorBelow,
    required this.buttonItems,
  });

  /// Preferred position (above the selection), in global coordinates.
  final Offset anchorAbove;

  /// Fallback position (below the selection), in global coordinates.
  final Offset anchorBelow;

  /// Items to render, usually [EditableTextState.contextMenuButtonItems].
  final List<ContextMenuButtonItem> buttonItems;

  @override
  Widget build(BuildContext context) {
    return CustomSingleChildLayout(
      delegate: TextSelectionToolbarLayoutDelegate(
        anchorAbove: anchorAbove,
        anchorBelow: anchorBelow,
      ),
      child: _ToolbarSurface(buttonItems: buttonItems),
    );
  }
}

class _ToolbarSurface extends StatelessWidget {
  const _ToolbarSurface({required this.buttonItems});

  final List<ContextMenuButtonItem> buttonItems;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final localizations = ShadcnLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colors.popover,
        border: Border.all(color: theme.colors.border),
        borderRadius: theme.borderRadiusMd,
        boxShadow: theme.tokens.shadows.shadowMd,
      ),
      padding: EdgeInsets.all(theme.spacing.xs),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (final item in buttonItems)
            _ToolbarButton(item: item, label: _labelFor(item, localizations)),
        ],
      ),
    );
  }
}

String _labelFor(
  ContextMenuButtonItem item,
  ShadcnLocalizations localizations,
) {
  return switch (item.type) {
    ContextMenuButtonType.cut => localizations.menuCut,
    ContextMenuButtonType.copy => localizations.menuCopy,
    ContextMenuButtonType.paste => localizations.menuPaste,
    ContextMenuButtonType.selectAll => localizations.menuSelectAll,
    ContextMenuButtonType.custom => item.label ?? '',
    _ => item.label ?? '',
  };
}

class _ToolbarButton extends StatelessWidget {
  const _ToolbarButton({required this.item, required this.label});

  final ContextMenuButtonItem item;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Clickable(
      onPressed: item.onPressed,
      focusOutline: false,
      padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
        EdgeInsets.symmetric(
          horizontal: theme.spacing.sm,
          vertical: theme.spacing.xs,
        ),
      ),
      decoration: WidgetStateProperty.resolveWith<Decoration?>((states) {
        final bool highlighted =
            states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.pressed);
        if (!highlighted) {
          return null;
        }
        return BoxDecoration(
          color: theme.colors.accent,
          borderRadius: theme.borderRadiusSm,
        );
      }),
      textStyle: WidgetStatePropertyAll<TextStyle>(
        theme.typography.small.copyWith(color: theme.colors.popoverForeground),
      ),
      child: Text(label, maxLines: 1, overflow: TextOverflow.fade),
    );
  }
}
