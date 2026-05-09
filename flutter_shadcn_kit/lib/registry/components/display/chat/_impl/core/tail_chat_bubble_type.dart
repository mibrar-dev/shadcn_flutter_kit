// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../chat.dart';

/// A [ChatBubbleType] that draws an external triangular tail.
class TailChatBubbleType extends ChatBubbleType {
  /// The alignment of the tail along the bubble's edge.
  final AxisAlignmentGeometry? tailAlignment;

  /// The position of the tail relative to the bubble.
  final AxisDirectional? position;

  /// The size of the tail.
  final Size? size;

  /// The border radius of the bubble.
  final BorderRadiusGeometry? borderRadius;

  /// The radius of the tail's curve.
  final double? tailRadius;

  /// The behavior determining when to show the tail.
  final TailBehavior? tailBehavior;

  /// The padding inside the bubble.
  final EdgeInsetsGeometry? padding;

  /// Creates a [TailChatBubbleType].
  ///
  /// Parameters:
  /// - [tailAlignment] (`AxisAlignmentGeometry?`, optional): The alignment of the tail along the bubble's edge.
  /// - [position] (`AxisDirectional?`, optional): The position of the tail relative to the bubble.
  /// - [size] (`Size?`, optional): The size of the tail.
  /// - [borderRadius] (`BorderRadiusGeometry?`, optional): The border radius of the bubble.
  /// - [tailRadius] (`double?`, optional): The radius of the tail's curve.
  /// - [tailBehavior] (`TailBehavior?`, optional): The behavior determining when to show the tail.
  /// - [padding] (`EdgeInsetsGeometry?`, optional): The padding inside the bubble.
  const TailChatBubbleType({
    this.tailAlignment,
    this.position,
    this.size,
    this.borderRadius,
    this.tailRadius,
    this.tailBehavior,
    this.padding,
  });

  /// Creates a copy of this bubble type with the given fields replaced with the new values.
  ///
  /// Parameters:
  /// - [tailAlignment] (`ValueGetter<AxisAlignmentGeometry>?`, optional): New tail alignment value.
  /// - [position] (`ValueGetter<AxisDirectional>?`, optional): New position value.
  /// - [size] (`ValueGetter<Size>?`, optional): New size value.
  /// - [borderRadius] (`ValueGetter<BorderRadiusGeometry>?`, optional): New border radius value.
  /// - [tailRadius] (`ValueGetter<double>?`, optional): New tail radius value.
  /// - [tailBehavior] (`ValueGetter<TailBehavior>?`, optional): New tail behavior value.
  ///
  /// Returns:
  /// A new [TailChatBubbleType] with the specified values updated.
  TailChatBubbleType copyWith({
    ValueGetter<AxisAlignmentGeometry>? tailAlignment,
    ValueGetter<AxisDirectional>? position,
    ValueGetter<Size>? size,
    ValueGetter<BorderRadiusGeometry>? borderRadius,
    ValueGetter<double>? tailRadius,
    ValueGetter<TailBehavior>? tailBehavior,
  }) {
    return TailChatBubbleType(
      tailAlignment: tailAlignment?.call() ?? this.tailAlignment,
      position: position?.call() ?? this.position,
      size: size?.call() ?? this.size,
      borderRadius: borderRadius?.call() ?? this.borderRadius,
      tailRadius: tailRadius?.call() ?? this.tailRadius,
      tailBehavior: tailBehavior?.call() ?? this.tailBehavior,
    );
  }

  @override
  Widget wrap(
    BuildContext context,
    Widget child,
    ChatBubbleData data,
    ChatBubble chat,
  ) {
    final theme = Theme.of(context);

    final compTheme = ComponentTheme.maybeOf<ChatTailTheme>(context);

    final chatTheme = ComponentTheme.maybeOf<ChatTheme>(context);

    final textDirection = Directionality.maybeOf(context) ?? TextDirection.ltr;
    final tailBehavior = styleValue(
      widgetValue: this.tailBehavior,
      themeValue: compTheme?.tailBehavior,
      defaultValue: TailBehavior.last,
    );
    final color = styleValue(
      widgetValue: chat.color,
      themeValue: chatTheme?.color,
      defaultValue: theme.colorScheme.primary,
    );
    final radius = styleValue(
      widgetValue: borderRadius,
      themeValue: chatTheme?.borderRadius,
      defaultValue: theme.borderRadiusLg,
    ).resolve(textDirection);
    child = Container(
      decoration: BoxDecoration(borderRadius: radius, color: color),
      padding: EdgeInsets.symmetric(
        horizontal: 12 * theme.scaling,
        vertical: 8 * theme.scaling,
      ),
      child: child,
    );

    double leftPadding;

    double rightPadding;

    double topPadding;

    double bottomPadding;
    final size = styleValue(
      widgetValue: this.size,
      themeValue: compTheme?.size,
      defaultValue: const Size(8, 8),
    );
    final position = styleValue(
      widgetValue: this.position,
      themeValue: compTheme?.position,
      defaultValue: AxisDirectional.end,
    ).resolve(textDirection);

    bool wrapWithTail = tailBehavior.wrapWithTail(data);
    switch ((position, wrapWithTail)) {
      case (AxisDirection.left, _):
        topPadding = 0;
        leftPadding = size.width;
        rightPadding = 0;
        bottomPadding = 0;
        break;

      case (AxisDirection.right, _):
        topPadding = 0;
        leftPadding = 0;
        rightPadding = size.width;
        bottomPadding = 0;
        break;

      case (AxisDirection.up, true):
        topPadding = size.height;
        leftPadding = 0;
        rightPadding = 0;
        bottomPadding = 0;
        break;

      case (AxisDirection.down, true):
        topPadding = 0;
        leftPadding = 0;
        rightPadding = 0;
        bottomPadding = size.height;
        break;

      case (_, _):
        topPadding = 0;
        leftPadding = 0;
        rightPadding = 0;
        bottomPadding = 0;
        break;
    }

    if (tailBehavior.wrapWithTail(data)) {
      final color = styleValue(
        widgetValue: chat.color,
        themeValue: chatTheme?.color,
        defaultValue: theme.colorScheme.primary,
      );

      final tailSize = styleValue(
        widgetValue: size,
        themeValue: compTheme?.size,
        defaultValue: const Size(8, 8),
      );
      final tailRadius = styleValue(
        widgetValue: this.tailRadius,
        themeValue: compTheme?.tailRadius,
        defaultValue: theme.radiusSm,
      );
      final tailAlignment = styleValue(
        widgetValue: this.tailAlignment,
        themeValue: chatTheme?.alignment,
        defaultValue: AxisAlignmentDirectional.end,
      ).resolve(textDirection);
      final position = styleValue(
        widgetValue: this.position,
        themeValue: compTheme?.position,
        defaultValue: AxisDirectional.down,
      ).resolve(textDirection);
      child = CustomPaint(
        painter: _TailPainter(
          color: color,
          radius: radius,
          tailSize: tailSize,
          position: position,
          tailAlignment: tailAlignment,
          tailRadius: tailRadius,
        ),
        child: child,
      );
    }
    return Padding(
      padding: EdgeInsets.only(
        top: topPadding,
        left: leftPadding,
        right: rightPadding,
        bottom: bottomPadding,
      ),
      child: child,
    );
  }
}
