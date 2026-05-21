// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' hide Theme, TextField;

import '../../../../../shared/primitives/clickable.dart';
import '../../../../../shared/primitives/subfocus.dart';
import '../../../../../shared/theme/theme.dart';
import '../../../../../shared/utils/constants.dart';
import '../../../../../shared/utils/color_extensions.dart';
import '../../../../../shared/primitives/text.dart';
import '../core/command_item_widget.dart';

/// CommandItemState defines a reusable type for this registry module.
class CommandItemState extends State<CommandItem> {
  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Actions(
      actions: {
        ActivateIntent: CallbackAction<Intent>(
          onInvoke: (intent) {
            widget.onTap?.call();
            return null;
          },
        ),
      },
      child: SubFocus(
        builder: (context, state) {
          return Clickable(
            onPressed: widget.onTap,
            onHover: (hovered) {
              if (hovered) {
                state.requestFocus();
              }
            },
            child: AnimatedContainer(
              duration: kDefaultDuration,
              decoration: BoxDecoration(
                color: state.isFocused
                    ? themeData.colorScheme.accent
                    : themeData.colorScheme.accent.withValues(alpha: 0),
                borderRadius: BorderRadius.circular(themeData.radiusSm),
              ),
              padding: EdgeInsets.symmetric(
                horizontal:
                    themeData.density.baseGap * themeData.scaling * gapSm,
                vertical: themeData.density.baseGap * themeData.scaling * 0.75,
              ),
              child: IconTheme(
                data: themeData.iconTheme.small.copyWith(
                  color: widget.onTap != null
                      ? themeData.colorScheme.accentForeground
                      : themeData.colorScheme.accentForeground.scaleAlpha(0.5),
                ),
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: widget.onTap != null
                        ? themeData.colorScheme.accentForeground
                        : themeData.colorScheme.accentForeground.scaleAlpha(
                            0.5,
                          ),
                  ),
                  child: Row(
                    children: [
                      if (widget.leading != null) widget.leading!,
                      if (widget.leading != null) DensityGap(gapSm),

                      /// Creates a `Expanded` instance.
                      Expanded(child: widget.title),
                      if (widget.trailing != null) DensityGap(gapSm),
                      if (widget.trailing != null)
                        widget.trailing!.muted().xSmall(),
                    ],
                  ).small(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
