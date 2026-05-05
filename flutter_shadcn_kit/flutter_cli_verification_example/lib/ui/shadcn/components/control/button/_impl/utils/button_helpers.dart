import 'package:data_widget/data_widget.dart';
import 'package:flutter/widgets.dart';

import '../../../../../shared/primitives/clickable.dart';
import '../../../../../shared/primitives/menu_group.dart';
import '../../../../../shared/theme/generated_colors.dart';
import '../../../../../shared/theme/theme.dart';
import '../../../../../shared/utils/color_extensions.dart';

/// Executes `buttonZeroMargin` behavior for this component/composite.
EdgeInsets buttonZeroMargin(BuildContext context, Set<WidgetState> states) {
  return EdgeInsets.zero;
}

/// Executes `buttonMouseCursor` behavior for this component/composite.
MouseCursor buttonMouseCursor(BuildContext context, Set<WidgetState> states) {
  return states.contains(WidgetState.disabled)
      ? SystemMouseCursors.basic
      : SystemMouseCursors.click;
}

/// Executes `buttonPadding` behavior for this component/composite.
EdgeInsets buttonPadding(BuildContext context, Set<WidgetState> states) {
  final theme = Theme.of(context);
  return EdgeInsets.symmetric(
    horizontal: theme.density.baseContentPadding * theme.scaling * padSm,
    vertical: theme.density.baseContentPadding * theme.scaling * padXs,
  );
}

// CARD
/// Executes `buttonCardTextStyle` behavior for this component/composite.
TextStyle buttonCardTextStyle(BuildContext context, Set<WidgetState> states) {
  var themeData = Theme.of(context);
  return themeData.typography.small.copyWith(
    color: themeData.colorScheme.cardForeground,
  );
}

IconThemeData buttonCardIconTheme(
  BuildContext context,
  Set<WidgetState> states,
) {
  var themeData = Theme.of(context);
  return IconThemeData(color: themeData.colorScheme.cardForeground);
}

/// Executes `buttonCardDecoration` behavior for this component/composite.
Decoration buttonCardDecoration(BuildContext context, Set<WidgetState> states) {
  var themeData = Theme.of(context);
  if (states.contains(WidgetState.disabled)) {
    return BoxDecoration(
      color: themeData.colorScheme.muted,
      borderRadius: BorderRadius.circular(themeData.radiusXl),
      border: Border.all(color: themeData.colorScheme.border, width: 1),
    );
  }
  if (states.contains(WidgetState.hovered) ||
/// Creates a `states.contains` instance.
      states.contains(WidgetState.selected)) {
    return BoxDecoration(
      color: themeData.colorScheme.border,
      borderRadius: BorderRadius.circular(themeData.radiusXl),
      border: Border.all(color: themeData.colorScheme.border, width: 1),
    );
  }
  return BoxDecoration(
    color: themeData.colorScheme.card,
    borderRadius: BorderRadius.circular(themeData.radiusXl),
    border: Border.all(color: themeData.colorScheme.border, width: 1),
  );
}

/// Executes `buttonCardPadding` behavior for this component/composite.
EdgeInsets buttonCardPadding(BuildContext context, Set<WidgetState> states) {
  final theme = Theme.of(context);
  return EdgeInsets.all(
    theme.density.baseContainerPadding * theme.scaling * padSm,
  );
}

// MENUBUTTON
/// Executes `buttonMenuDecoration` behavior for this component/composite.
Decoration buttonMenuDecoration(BuildContext context, Set<WidgetState> states) {
  var themeData = Theme.of(context);
  if (states.contains(WidgetState.disabled)) {
    return const BoxDecoration();
  }
  if (states.contains(WidgetState.focused) ||
/// Creates a `states.contains` instance.
      states.contains(WidgetState.hovered) ||
/// Creates a `states.contains` instance.
      states.contains(WidgetState.selected)) {
    return BoxDecoration(
      color: themeData.colorScheme.accent,
      borderRadius: BorderRadius.circular(themeData.radiusSm),
    );
  }
  return const BoxDecoration();
}

/// Executes `buttonMenuTextStyle` behavior for this component/composite.
TextStyle buttonMenuTextStyle(BuildContext context, Set<WidgetState> states) {
  var themeData = Theme.of(context);
  if (states.contains(WidgetState.disabled)) {
    return themeData.typography.small.copyWith(
      color: themeData.colorScheme.accentForeground.scaleAlpha(0.5),
    );
  }
  return themeData.typography.small.copyWith(
    color: themeData.colorScheme.accentForeground,
  );
}

/// Executes `buttonMenuPadding` behavior for this component/composite.
EdgeInsets buttonMenuPadding(BuildContext context, Set<WidgetState> states) {
  final theme = Theme.of(context);
/// Stores `scaling` state/configuration for this implementation.
  final scaling = theme.scaling;
  final menuGroupData = Data.maybeOf<MenuGroupData>(context);
  if (menuGroupData != null && menuGroupData.direction == Axis.horizontal) {
    return EdgeInsets.symmetric(
      horizontal: theme.density.baseContentPadding * scaling * 1.125,
      vertical: theme.density.baseContentPadding * scaling * 0.375,
    );
  }
  return EdgeInsets.only(
    left: theme.density.baseContentPadding * scaling * padXs,
    top: theme.density.baseContentPadding * scaling * 0.375,
    right: theme.density.baseContentPadding * scaling * 0.375,
    bottom: theme.density.baseContentPadding * scaling * 0.375,
  );
}

/// Executes `buttonMenubarPadding` behavior for this component/composite.
EdgeInsets buttonMenubarPadding(BuildContext context, Set<WidgetState> states) {
  final theme = Theme.of(context);
/// Stores `scaling` state/configuration for this implementation.
  final scaling = theme.scaling;
  return EdgeInsets.symmetric(
    horizontal: theme.density.baseContentPadding * scaling * 0.75,
    vertical: theme.density.baseContentPadding * scaling * 0.25,
  );
}

IconThemeData buttonMenuIconTheme(
  BuildContext context,
  Set<WidgetState> states,
) {
  var themeData = Theme.of(context);
  return IconThemeData(color: themeData.colorScheme.accentForeground);
}

// PRIMARY
Decoration buttonPrimaryDecoration(
  BuildContext context,
  Set<WidgetState> states,
) {
  var themeData = Theme.of(context);
  if (states.contains(WidgetState.disabled)) {
    return BoxDecoration(
      color: themeData.colorScheme.mutedForeground,
      borderRadius: BorderRadius.circular(themeData.radiusMd),
    );
  }
  if (states.contains(WidgetState.hovered)) {
    return BoxDecoration(
      color: themeData.colorScheme.primary.scaleAlpha(0.8),
      borderRadius: BorderRadius.circular(themeData.radiusMd),
    );
  }
  return BoxDecoration(
    color: themeData.colorScheme.primary,
    borderRadius: BorderRadius.circular(themeData.radiusMd),
  );
}

TextStyle buttonPrimaryTextStyle(
  BuildContext context,
  Set<WidgetState> states,
) {
  var themeData = Theme.of(context);
  return themeData.typography.small
      .merge(themeData.typography.medium)
      .copyWith(color: themeData.colorScheme.primaryForeground);
}

IconThemeData buttonPrimaryIconTheme(
  BuildContext context,
  Set<WidgetState> states,
) {
  var themeData = Theme.of(context);
  return IconThemeData(color: themeData.colorScheme.primaryForeground);
}

// SECONDARY
Decoration buttonSecondaryDecoration(
  BuildContext context,
  Set<WidgetState> states,
) {
  var themeData = Theme.of(context);
  if (states.contains(WidgetState.disabled)) {
    return BoxDecoration(
      color: themeData.colorScheme.primaryForeground,
      borderRadius: BorderRadius.circular(themeData.radiusMd),
    );
  }
  if (states.contains(WidgetState.hovered)) {
    return BoxDecoration(
      color: themeData.colorScheme.secondary.scaleAlpha(0.8),
      borderRadius: BorderRadius.circular(themeData.radiusMd),
    );
  }
  return BoxDecoration(
    color: themeData.colorScheme.secondary,
    borderRadius: BorderRadius.circular(themeData.radiusMd),
  );
}

TextStyle buttonSecondaryTextStyle(
  BuildContext context,
  Set<WidgetState> states,
) {
  var themeData = Theme.of(context);
  return themeData.typography.small
      .merge(themeData.typography.medium)
      .copyWith(
        color: states.contains(WidgetState.disabled)
            ? themeData.colorScheme.mutedForeground
            : themeData.colorScheme.secondaryForeground,
      );
}

IconThemeData buttonSecondaryIconTheme(
  BuildContext context,
  Set<WidgetState> states,
) {
  var themeData = Theme.of(context);
  return IconThemeData(
    color: states.contains(WidgetState.disabled)
        ? themeData.colorScheme.mutedForeground
        : themeData.colorScheme.secondaryForeground,
  );
}

Decoration buttonOutlineDecoration(
  BuildContext context,
  Set<WidgetState> states,
) {
  var themeData = Theme.of(context);
  if (states.contains(WidgetState.disabled)) {
    return BoxDecoration(
      color: themeData.colorScheme.border.withValues(alpha: 0),
      border: Border.all(color: themeData.colorScheme.border, width: 1),
      borderRadius: BorderRadius.circular(themeData.radiusMd),
    );
  }
  if (states.contains(WidgetState.hovered)) {
    return BoxDecoration(
      color: themeData.colorScheme.input.scaleAlpha(0.5),
      border: Border.all(color: themeData.colorScheme.input, width: 1),
      borderRadius: BorderRadius.circular(themeData.radiusMd),
    );
  }
  return BoxDecoration(
    color: themeData.colorScheme.input.scaleAlpha(0.3),
    border: Border.all(color: themeData.colorScheme.input, width: 1),
    borderRadius: BorderRadius.circular(themeData.radiusMd),
  );
}

TextStyle buttonOutlineTextStyle(
  BuildContext context,
  Set<WidgetState> states,
) {
  var themeData = Theme.of(context);
  return themeData.typography.small
      .merge(themeData.typography.medium)
      .copyWith(
        color: states.contains(WidgetState.disabled)
            ? themeData.colorScheme.mutedForeground
            : themeData.colorScheme.foreground,
      );
}

IconThemeData buttonOutlineIconTheme(
  BuildContext context,
  Set<WidgetState> states,
) {
  var themeData = Theme.of(context);
  return IconThemeData(
    color: states.contains(WidgetState.disabled)
        ? themeData.colorScheme.mutedForeground
        : themeData.colorScheme.foreground,
  );
}

Decoration buttonGhostDecoration(
  BuildContext context,
  Set<WidgetState> states,
) {
  var themeData = Theme.of(context);
  if (states.contains(WidgetState.disabled)) {
    return BoxDecoration(
      color: themeData.colorScheme.muted.withValues(alpha: 0),
      borderRadius: BorderRadius.circular(themeData.radiusMd),
    );
  }
  if (states.contains(WidgetState.hovered)) {
    return BoxDecoration(
      color: themeData.colorScheme.muted.scaleAlpha(0.8),
      borderRadius: BorderRadius.circular(themeData.radiusMd),
    );
  }
  return BoxDecoration(
    color: themeData.colorScheme.muted.withValues(alpha: 0),
    borderRadius: BorderRadius.circular(themeData.radiusMd),
  );
}

/// Executes `buttonGhostTextStyle` behavior for this component/composite.
TextStyle buttonGhostTextStyle(BuildContext context, Set<WidgetState> states) {
  var themeData = Theme.of(context);
  return themeData.typography.small
      .merge(themeData.typography.medium)
      .copyWith(
        color: states.contains(WidgetState.disabled)
            ? themeData.colorScheme.mutedForeground
            : themeData.colorScheme.foreground,
      );
}

IconThemeData buttonGhostIconTheme(
  BuildContext context,
  Set<WidgetState> states,
) {
  var themeData = Theme.of(context);
  return IconThemeData(
    color: states.contains(WidgetState.disabled)
        ? themeData.colorScheme.mutedForeground
        : themeData.colorScheme.foreground,
  );
}

/// Executes `buttonMutedTextStyle` behavior for this component/composite.
TextStyle buttonMutedTextStyle(BuildContext context, Set<WidgetState> states) {
  var themeData = Theme.of(context);
  return themeData.typography.small
      .merge(themeData.typography.medium)
      .copyWith(color: themeData.colorScheme.mutedForeground);
}

IconThemeData buttonMutedIconTheme(
  BuildContext context,
  Set<WidgetState> states,
) {
  var themeData = Theme.of(context);
  return IconThemeData(color: themeData.colorScheme.mutedForeground);
}

/// Executes `buttonLinkDecoration` behavior for this component/composite.
Decoration buttonLinkDecoration(BuildContext context, Set<WidgetState> states) {
  var themeData = Theme.of(context);
  return BoxDecoration(borderRadius: BorderRadius.circular(themeData.radiusMd));
}

/// Executes `buttonLinkTextStyle` behavior for this component/composite.
TextStyle buttonLinkTextStyle(BuildContext context, Set<WidgetState> states) {
  var themeData = Theme.of(context);
  return themeData.typography.small
      .merge(themeData.typography.medium)
      .copyWith(
        color: states.contains(WidgetState.disabled)
            ? themeData.colorScheme.mutedForeground
            : themeData.colorScheme.foreground,
        decoration: states.contains(WidgetState.hovered)
            ? TextDecoration.underline
            : TextDecoration.none,
      );
}

IconThemeData buttonLinkIconTheme(
  BuildContext context,
  Set<WidgetState> states,
) {
  var themeData = Theme.of(context);
  return IconThemeData(
    color: states.contains(WidgetState.disabled)
        ? themeData.colorScheme.mutedForeground
        : themeData.colorScheme.foreground,
  );
}

/// Executes `buttonTextDecoration` behavior for this component/composite.
Decoration buttonTextDecoration(BuildContext context, Set<WidgetState> states) {
  var themeData = Theme.of(context);
  return BoxDecoration(borderRadius: BorderRadius.circular(themeData.radiusMd));
}

/// Executes `buttonTextTextStyle` behavior for this component/composite.
TextStyle buttonTextTextStyle(BuildContext context, Set<WidgetState> states) {
  var themeData = Theme.of(context);
  return themeData.typography.small
      .merge(themeData.typography.medium)
      .copyWith(
        color: states.contains(WidgetState.hovered)
            ? themeData.colorScheme.primary
            : themeData.colorScheme.mutedForeground,
      );
}

IconThemeData buttonTextIconTheme(
  BuildContext context,
  Set<WidgetState> states,
) {
  var themeData = Theme.of(context);
  return IconThemeData(
    color: states.contains(WidgetState.hovered)
        ? themeData.colorScheme.primary
        : themeData.colorScheme.mutedForeground,
  );
}

Decoration buttonDestructiveDecoration(
  BuildContext context,
  Set<WidgetState> states,
) {
  var themeData = Theme.of(context);
  if (states.contains(WidgetState.disabled)) {
    return BoxDecoration(
      color: themeData.colorScheme.primaryForeground,
      borderRadius: BorderRadius.circular(themeData.radiusMd),
    );
  }
  if (states.contains(WidgetState.hovered)) {
    return BoxDecoration(
      color: themeData.colorScheme.destructive.scaleAlpha(0.8),
      borderRadius: BorderRadius.circular(themeData.radiusMd),
    );
  }
  return BoxDecoration(
    color: themeData.colorScheme.destructive.scaleAlpha(0.5),
    borderRadius: BorderRadius.circular(themeData.radiusMd),
  );
}

TextStyle buttonDestructiveTextStyle(
  BuildContext context,
  Set<WidgetState> states,
) {
  var themeData = Theme.of(context);
  return themeData.typography.small
      .merge(themeData.typography.medium)
      .copyWith(
        color: states.contains(WidgetState.disabled)
            ? themeData.colorScheme.mutedForeground
            : Colors
                  .white, // yeah ik, its straight up white regardless light or dark mode
      );
}

IconThemeData buttonDestructiveIconTheme(
  BuildContext context,
  Set<WidgetState> states,
) {
  var themeData = Theme.of(context);
  return IconThemeData(
    color: states.contains(WidgetState.disabled)
        ? themeData.colorScheme.mutedForeground
        : Colors.white,
  );
}

// STATIC BUTTON
/// Executes `buttonStaticTextStyle` behavior for this component/composite.
TextStyle buttonStaticTextStyle(BuildContext context, Set<WidgetState> states) {
  final theme = Theme.of(context);
  return theme.typography.small
      .merge(theme.typography.medium)
      .copyWith(color: theme.colorScheme.foreground);
}

IconThemeData buttonStaticIconTheme(
  BuildContext context,
  Set<WidgetState> states,
) {
  return const IconThemeData();
}

/// Convenience widget for creating a primary button.
///
/// [PrimaryButton] is a simplified wrapper around [Button] that automatically
/// applies the primary button style. It provides a cleaner API for the common
/// case of creating primary buttons without manually specifying the style.
///
/// This widget exposes all the same properties as [Button] but defaults to
/// [ButtonStyle.primary] for consistent styling.
///
/// Example:
/// ```dart
/// PrimaryButton(
///   onPressed: () => submitForm(),
///   leading: Icon(Icons.check),
///   child: Text('Submit'),
/// )
/// ```
// Backward compatibility
