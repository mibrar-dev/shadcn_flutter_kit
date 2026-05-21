// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../shared/primitives/clickable.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/constants.dart';
import '../../../shared/utils/style_value.dart';

part '_impl/core/active_dot_item.dart';
part '_impl/core/inactive_dot_item.dart';

part '_impl/themes/base/dot_indicator_theme.dart';
part '_impl/core/dot_items.dart';

/// Builder function that creates dot widgets.
typedef DotBuilder =
    Widget Function(BuildContext context, int index, bool active);

/// Navigation indicator with a row/column of animated dots.
class DotIndicator extends StatelessWidget {
  static Widget _defaultDotBuilder(
    BuildContext context,
    int index,
    bool active,
  ) {
    return active ? const ActiveDotItem() : const InactiveDotItem();
  }

  /// Creates `DotIndicator` for configuring or rendering dot indicator.
  const DotIndicator({
    super.key,
    required this.index,
    required this.length,
    this.onChanged,
    this.spacing,
    this.direction = Axis.horizontal,
    this.padding,
    this.dotBuilder,
  });

  /// Positional/count metadata used by `DotIndicator` rendering logic.
  final int index;

  /// Positional/count metadata used by `DotIndicator` rendering logic.
  final int length;

  /// Callback invoked by dot indicator when `onChanged` is triggered.
  final ValueChanged<int>? onChanged;

  /// Layout/size setting that affects dot indicator rendering.
  final double? spacing;

  /// Input parameter used by `DotIndicator` during rendering and behavior handling.
  final Axis direction;

  /// Layout/size setting that affects dot indicator rendering.
  final EdgeInsetsGeometry? padding;

  /// Input parameter used by `DotIndicator` during rendering and behavior handling.
  final DotBuilder? dotBuilder;

  /// Builds the widget tree for dot indicator.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final directionality = Directionality.of(context);

    final scaling = theme.scaling;
    final compTheme = ComponentTheme.maybeOf<DotIndicatorTheme>(context);
    final resolvedSpacing = styleValue(
      widgetValue: spacing,
      themeValue: compTheme?.spacing,
      defaultValue: 8 * scaling,
    );
    final resolvedPadding =
        styleValue(
          widgetValue: padding,
          themeValue: compTheme?.padding,
          defaultValue: EdgeInsets.all(theme.density.baseGap),
        ).resolve(directionality) *
        scaling;
    final resolvedBuilder =
        dotBuilder ?? compTheme?.dotBuilder ?? _defaultDotBuilder;
    final children = List<Widget>.generate(length, (i) {
      final horizontalPadding = i == 0
          ? resolvedPadding.left
          : (resolvedSpacing / 2 + resolvedPadding.left);
      final trailingPadding = i == length - 1
          ? resolvedPadding.right
          : (resolvedSpacing / 2 + resolvedPadding.right);
      final itemPadding = EdgeInsets.only(
        top: resolvedPadding.top,
        bottom: resolvedPadding.bottom,
        left: horizontalPadding,
        right: trailingPadding,
      );
      return Flexible(
        child: Clickable(
          behavior: HitTestBehavior.translucent,
          onPressed: onChanged != null ? () => onChanged!(i) : null,
          mouseCursor: const WidgetStatePropertyAll(SystemMouseCursors.click),
          child: Padding(
            padding: itemPadding,
            child: resolvedBuilder(context, i, i == index),
          ),
        ),
      );
    });
    return IntrinsicHeight(
      child: Flex(
        direction: direction,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}
