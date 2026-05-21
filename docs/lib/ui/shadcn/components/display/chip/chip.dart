// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../control/button/button.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/style_value.dart';

part '_impl/core/chip_button.dart';
part '_impl/themes/base/chip_theme.dart';

/// Compact interactive chip with optional leading/trailing widgets.
class Chip extends StatelessWidget {
  /// Creates `Chip` for configuring or rendering chip.
  const Chip({
    super.key,
    required this.child,
    this.leading,
    this.trailing,
    this.onPressed,
    this.style,
  });

  /// Child content displayed inside the chip widget.
  final Widget child;

  /// Text/content element used by `Chip` when composing its visual layout.
  final Widget? leading;

  /// Text/content element used by `Chip` when composing its visual layout.
  final Widget? trailing;

  /// Callback invoked by chip when `onPressed` is triggered.
  final VoidCallback? onPressed;

  /// Style/theme override that customizes `Chip` appearance.
  final AbstractButtonStyle? style;

  /// Builds the widget tree for chip.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final componentTheme = ComponentTheme.maybeOf<ChipTheme>(context);
    final resolvedStyle =
        style ?? componentTheme?.style ?? ButtonVariance.secondary;

    return Button(
      style: resolvedStyle.copyWith(
        mouseCursor: (context, states, value) {
          return onPressed != null
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic;
        },
        padding: (context, states, value) {
          return styleValue(
            themeValue: componentTheme?.padding,
            defaultValue: EdgeInsets.symmetric(
              horizontal:
                  theme.density.baseContentPadding * theme.scaling * padXs,
              vertical: theme.density.baseContentPadding * theme.scaling * 0.25,
            ),
          );
        },
      ),
      onPressed: onPressed ?? () {},
      leading: leading,
      trailing: trailing,
      child: child,
    );
  }
}
