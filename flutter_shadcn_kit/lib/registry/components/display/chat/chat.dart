// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:math';

import 'package:data_widget/data_widget.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../../shared/theme/theme.dart';
import '../../../shared/utils/style_value.dart';
import '../../../shared/utils/axis.dart';

part '_impl/core/_chat_tail_behavior.dart';
part '_impl/core/_tail_painter.dart';
part '_impl/core/chat_bubble.dart';
part '_impl/core/chat_bubble_corner.dart';
part '_impl/core/chat_bubble_corner_directional.dart';
part '_impl/core/chat_bubble_data.dart';
part '_impl/core/chat_bubble_type.dart';
part '_impl/core/chat_group.dart';
part '_impl/core/chat_group_theme.dart';
part '_impl/core/chat_tail_theme.dart';
part '_impl/core/chat_theme.dart';
part '_impl/core/plain_chat_bubble_type.dart';
part '_impl/core/render_chat_constrained_box.dart';
part '_impl/core/sharp_corner_chat_bubble_type.dart';
part '_impl/core/tail_behavior.dart';
part '_impl/core/tail_chat_bubble_type.dart';

/// A widget that constrains the width of its child based on a factor and aligns it.
///
/// This widget is used by [ChatBubble] to limit the width of the bubble relative to
/// the available width and to align it within that space.
///
/// Parameters:
/// - [widthFactor] (`double`, required): The fraction of the available width that the child should occupy.
/// - [alignment] (`AxisAlignmentGeometry`, required): The alignment of the child within the available space.
/// - [child] (`Widget`, required): The widget below this widget in the tree.
class ChatConstrainedBox extends SingleChildRenderObjectWidget {
  /// The fraction of the available width that the child should occupy.
  final double widthFactor;

  /// The alignment of the child within the available space.
  final AxisAlignmentGeometry alignment;

  /// Creates a [ChatConstrainedBox].
  const ChatConstrainedBox({
    required this.widthFactor,
    required this.alignment,
    required super.child,
    super.key,
  });

  /// Implements `createRenderObject` behavior for chat.
  @override
  RenderChatConstrainedBox createRenderObject(BuildContext context) {
    return RenderChatConstrainedBox(
      widthFactor: widthFactor,
      alignment: alignment.resolve(
        Directionality.maybeOf(context) ?? TextDirection.ltr,
      ),
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderChatConstrainedBox renderObject,
  ) {
    renderObject
      ..widthFactor = widthFactor
      ..alignment = alignment.resolve(
        Directionality.maybeOf(context) ?? TextDirection.ltr,
      );
  }
}

Color _chatForegroundColorFor(Color background) {
  return background.computeLuminance() >= 0.5
      ? const Color(0xFF111827)
      : const Color(0xFFF9FAFB);
}
