// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../chat.dart';

/// Overlaps a reaction badge onto one corner of a chat bubble.
///
/// The bubble is laid out normally and [reaction] is pinned to [corner],
/// hanging slightly outside the bubble's edge. When the reaction is wider than
/// the bubble, the bubble is widened to keep [extraWidth] of breathing room
/// rather than letting the reaction spill past it.
///
/// Wrap the bubble, not the chat row:
///
/// ```dart
/// ChatReaction(
///   reaction: const ChatReactionContainer(child: Text('👍 2')),
///   child: const ChatBubble(child: Text('Nice work!')),
/// );
/// ```
///
/// See also:
///  * [ChatReactionContainer], the default pill the reaction sits in.
///  * [ChatReactionTheme], which supplies the defaults for [corner] and
///    [extraWidth].
class ChatReaction extends StatelessWidget {
  /// The chat bubble the reaction is attached to.
  final Widget child;

  /// Which corner of the bubble the reaction hangs off.
  ///
  /// If null, falls back to [ChatReactionTheme.corner], and failing that to the
  /// corner opposite the bubble's alignment — a right-aligned bubble gets its
  /// reaction on the bottom left, and vice versa.
  final ChatBubbleCornerDirectional? corner;

  /// The badge to overlap onto the bubble, typically a
  /// [ChatReactionContainer].
  final Widget reaction;

  /// The minimum extra width the bubble keeps beyond the reaction when the
  /// reaction is wider than the bubble.
  final double? extraWidth;

  /// Creates a chat bubble with an overlapping reaction badge.
  const ChatReaction({
    super.key,
    this.corner,
    this.extraWidth,
    required this.reaction,
    required this.child,
  });

  /// Builds the widget tree for chat reaction.
  @override
  Widget build(BuildContext context) {
    final theme = ComponentTheme.maybeOf<ChatReactionTheme>(context);
    final chatTheme = ComponentTheme.maybeOf<ChatTheme>(context);
    final t = Theme.of(context);
    final textDirection = Directionality.maybeOf(context) ?? TextDirection.ltr;

    // The bubble's alignment within the chat row (defaults to end/right).
    final alignment = (chatTheme?.alignment ?? AxisAlignmentDirectional.end)
        .resolve(textDirection);
    final alignmentValue = alignment.resolveValue(Axis.horizontal);

    // Resolve the corner: explicit widget/theme corner first, otherwise place
    // the reaction on the side opposite the bubble's alignment (a right-aligned
    // bubble gets its reaction on the left, and vice versa).
    final directionalCorner = corner ?? theme?.corner;
    final ChatBubbleCorner resolvedCorner;
    if (directionalCorner != null) {
      resolvedCorner = directionalCorner.resolve(textDirection);
    } else {
      resolvedCorner = alignmentValue > 0
          ? ChatBubbleCorner.bottomLeft
          : ChatBubbleCorner.bottomRight;
    }

    final chatPadding =
        chatTheme?.padding?.resolve(textDirection) ??
        EdgeInsets.symmetric(
          horizontal: 12 * t.scaling,
          vertical: 8 * t.scaling,
        );
    final reactionPadding = switch (resolvedCorner) {
      ChatBubbleCorner.topLeft => EdgeInsets.only(
        left: theme?.horizontalPadding ?? 12 * t.scaling,
        top: theme?.verticalPadding ?? 12 * t.scaling,
      ),
      ChatBubbleCorner.topRight => EdgeInsets.only(
        right: theme?.horizontalPadding ?? 12 * t.scaling,
        top: theme?.verticalPadding ?? 12 * t.scaling,
      ),
      ChatBubbleCorner.bottomLeft => EdgeInsets.only(
        left: theme?.horizontalPadding ?? 12 * t.scaling,
        bottom: theme?.verticalPadding ?? 12 * t.scaling,
      ),
      ChatBubbleCorner.bottomRight => EdgeInsets.only(
        right: theme?.horizontalPadding ?? 12 * t.scaling,
        bottom: theme?.verticalPadding ?? 12 * t.scaling,
      ),
    };
    final newChatPadding =
        chatPadding +
        EdgeInsets.only(
          top: reactionPadding.top * (2 / 3),
          bottom: reactionPadding.bottom * (2 / 3),
        );

    return _ChatReaction(
      corner: resolvedCorner,
      alignment: alignment,
      extraWidth: extraWidth ?? theme?.extraWidth ?? 8 * t.scaling,
      padding: reactionPadding,
      children: [
        ComponentTheme(
          // Force the bubble to hug its content (widthFactor 1.0) so it isn't
          // squeezed to half-width by its own ChatConstrainedBox when the
          // reaction render object tightens it to its natural width.
          data: (chatTheme ?? ChatTheme()).copyWith(
            padding: () => newChatPadding,
            widthFactor: () => 1.0,
          ),
          child: child,
        ),
        reaction,
      ],
    );
  }
}

class _ChatReaction extends MultiChildRenderObjectWidget {
  final ChatBubbleCorner corner;
  final EdgeInsets padding;
  final double extraWidth;
  final AxisAlignment alignment;
  const _ChatReaction({
    required this.corner,
    required this.padding,
    required this.extraWidth,
    required this.alignment,
    required super.children,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _ChatReactionRenderObject(
      corner: corner,
      padding: padding,
      extraWidth: extraWidth,
      alignment: alignment,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _ChatReactionRenderObject renderObject,
  ) {
    if (renderObject.corner != corner) {
      renderObject.corner = corner;
      renderObject.markNeedsLayout();
    }
    if (renderObject.padding != padding) {
      renderObject.padding = padding;
      renderObject.markNeedsLayout();
    }
    if (renderObject.extraWidth != extraWidth) {
      renderObject.extraWidth = extraWidth;
      renderObject.markNeedsLayout();
    }
    if (renderObject.alignment != alignment) {
      renderObject.alignment = alignment;
      renderObject.markNeedsLayout();
    }
  }
}

class _ChatReactionParentData extends ContainerBoxParentData<RenderBox> {}

/// Lays out a chat bubble with a reaction badge protruding from one of its
/// corners.
///
/// The first child is the bubble and the second child is the reaction. The
/// bubble and reaction each size themselves; if the reaction is wider than the
/// bubble, the bubble is expanded to at least the reaction width plus
/// [extraWidth]. The reaction is then anchored to [corner] — above the bubble
/// for the top corners and below it for the bottom corners — with [padding]
/// pulling it toward the widget's center. The render box grows to contain both
/// children so nothing is clipped.
class _ChatReactionRenderObject extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _ChatReactionParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _ChatReactionParentData> {
  ChatBubbleCorner corner;
  EdgeInsets padding;
  double extraWidth;
  AxisAlignment alignment;
  _ChatReactionRenderObject({
    required this.corner,
    required this.padding,
    required this.extraWidth,
    required this.alignment,
  });

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! _ChatReactionParentData) {
      child.parentData = _ChatReactionParentData();
    }
  }

  /// Computes the reaction offset relative to the bubble's top-left corner.
  Offset _reactionOffset(Size bubbleSize, Size reactionSize) {
    return switch (corner) {
      ChatBubbleCorner.topLeft => Offset(
        padding.left,
        padding.top - reactionSize.height,
      ),
      ChatBubbleCorner.topRight => Offset(
        bubbleSize.width - reactionSize.width - padding.right,
        padding.top - reactionSize.height,
      ),
      ChatBubbleCorner.bottomLeft => Offset(
        padding.left,
        bubbleSize.height - padding.bottom,
      ),
      ChatBubbleCorner.bottomRight => Offset(
        bubbleSize.width - reactionSize.width - padding.right,
        bubbleSize.height - padding.bottom,
      ),
    };
  }

  @override
  void performLayout() {
    final bubbleChild = firstChild!;
    final reactionChild = childAfter(bubbleChild)!;
    final childConstraints = constraints;

    reactionChild.layout(childConstraints.loosen(), parentUsesSize: true);
    final reactionSize = reactionChild.size;
    var bubbleWidth = bubbleChild.getMaxIntrinsicWidth(double.infinity);
    if (reactionSize.width + extraWidth > bubbleWidth) {
      bubbleWidth = reactionSize.width + extraWidth;
    }
    bubbleChild.layout(
      childConstraints.tighten(width: bubbleWidth),
      parentUsesSize: true,
    );
    final bubbleSize = bubbleChild.size;

    // Anchor the reaction to the corner, then shift both children so the
    // combined bounds start at the origin (nothing is clipped).
    final reactionOffset = _reactionOffset(
      Size(bubbleWidth, bubbleSize.height),
      reactionSize,
    );
    final union = (Offset.zero & bubbleSize).expandToInclude(
      reactionOffset & reactionSize,
    );
    var shift = -union.topLeft;

    // Fill the available width (like a bare ChatBubble) and align the assembly
    // to the bubble's side, so the parent doesn't center a narrow box.
    final double width;
    if (constraints.hasBoundedWidth) {
      width = constraints.maxWidth;
      shift += Offset(
        alignment.alongValue(Axis.horizontal, width - union.width),
        0,
      );
    } else {
      width = union.width;
    }

    (bubbleChild.parentData! as _ChatReactionParentData).offset = shift;
    (reactionChild.parentData! as _ChatReactionParentData).offset =
        reactionOffset + shift;

    size = constraints.constrain(Size(width, union.height));
  }

  @override
  Size computeDryLayout(covariant BoxConstraints constraints) {
    final bubbleChild = firstChild;
    if (bubbleChild == null) return constraints.smallest;
    final reactionChild = childAfter(bubbleChild)!;
    final childConstraints = constraints.loosen();

    final reactionSize = reactionChild.getDryLayout(childConstraints);
    var bubbleWidth = bubbleChild.getMaxIntrinsicWidth(double.infinity);
    if (reactionSize.width + extraWidth > bubbleWidth) {
      bubbleWidth = reactionSize.width + extraWidth;
    }
    final bubbleSize = bubbleChild.getDryLayout(
      childConstraints.tighten(width: bubbleWidth),
    );

    final reactionOffset = _reactionOffset(bubbleSize, reactionSize);
    final union = (Offset.zero & bubbleSize).expandToInclude(
      reactionOffset & reactionSize,
    );
    final width = constraints.hasBoundedWidth
        ? constraints.maxWidth
        : union.width;
    return constraints.constrain(Size(width, union.height));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // Paints the bubble first, then the reaction badge on top.
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  /// The extra height the reaction adds beyond the bubble edge for [corner].
  double _protrusion(double reactionHeight) {
    final overlap = switch (corner) {
      ChatBubbleCorner.topLeft || ChatBubbleCorner.topRight => padding.top,
      ChatBubbleCorner.bottomLeft ||
      ChatBubbleCorner.bottomRight => padding.bottom,
    };
    return max(0.0, reactionHeight - overlap);
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    final bubbleChild = firstChild;
    if (bubbleChild == null) return 0.0;
    final reactionChild = childAfter(bubbleChild)!;
    return bubbleChild.getMaxIntrinsicHeight(width) +
        _protrusion(reactionChild.getMaxIntrinsicHeight(double.infinity));
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    final bubbleChild = firstChild;
    if (bubbleChild == null) return 0.0;
    final reactionChild = childAfter(bubbleChild)!;
    return bubbleChild.getMinIntrinsicHeight(width) +
        _protrusion(reactionChild.getMinIntrinsicHeight(double.infinity));
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final bubbleChild = firstChild;
    if (bubbleChild == null) return 0.0;
    final reactionChild = childAfter(bubbleChild)!;
    final bubbleWidth = bubbleChild.getMaxIntrinsicWidth(height);
    final reactionWidth = reactionChild.getMaxIntrinsicWidth(double.infinity);
    // The bubble expands to the reaction width plus [extraWidth] when narrower.
    return reactionWidth > bubbleWidth
        ? reactionWidth + extraWidth
        : bubbleWidth;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    final bubbleChild = firstChild;
    if (bubbleChild == null) return 0.0;
    final reactionChild = childAfter(bubbleChild)!;
    final bubbleWidth = bubbleChild.getMinIntrinsicWidth(height);
    final reactionWidth = reactionChild.getMinIntrinsicWidth(double.infinity);
    return reactionWidth > bubbleWidth
        ? reactionWidth + extraWidth
        : bubbleWidth;
  }
}
