// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../../../shared/theme/theme.dart';
import '../../../../../shared/primitives/text.dart';
import '../../../../../shared/utils/util.dart';

/// Groups command items under an optional heading.
class CommandCategory extends StatelessWidget {
  /// Creates a command category.
  const CommandCategory({super.key, required this.children, this.title});

  /// Items belonging to this category.
  final List<Widget> children;

  /// Optional header.
  final Widget? title;

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null)
          title!
              .withPadding(
                horizontal: theme.density.baseGap * theme.scaling * gapSm,
                vertical: theme.density.baseGap * theme.scaling * 0.75,
              )
              .medium()
              .xSmall()
              .muted(),
        ...children,
      ],
    ).withPadding(all: theme.density.baseGap * theme.scaling * gapXs);
  }
}
