// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' as material;
import 'package:flutter/widgets.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../avatar/avatar.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/color_extensions.dart';
import '../../../shared/utils/style_value.dart';

part '_impl/themes/base/skeleton_theme.dart';

/// Applies Skeletonizer configuration using shadcn theming.
class ShadcnSkeletonizerConfigLayer extends StatelessWidget {
  /// Creates `ShadcnSkeletonizerConfigLayer` for configuring or rendering skeleton.
  const ShadcnSkeletonizerConfigLayer({
    super.key,
    required this.theme,
    required this.child,
    this.duration,
    this.fromColor,
    this.toColor,
    this.enableSwitchAnimation,
  });

  final material.ThemeData theme;

  /// Child content displayed inside the skeleton widget.
  final Widget child;

  /// Animation/progress setting used by skeleton transitions.
  final Duration? duration;

  /// Color value used by skeleton painting or state styling.
  final Color? fromColor;

  /// Color value used by skeleton painting or state styling.
  final Color? toColor;

  /// Animation/progress setting used by skeleton transitions.
  final bool? enableSwitchAnimation;

  /// Builds the widget tree for skeleton.
  @override
  Widget build(BuildContext context) {
    final compTheme = ComponentTheme.maybeOf<SkeletonTheme>(context);
    final durationValue = styleValue(
      widgetValue: duration,
      themeValue: compTheme?.duration,
      defaultValue: const Duration(seconds: 1),
    );
    final fromValue = styleValue(
      widgetValue: fromColor,
      themeValue: compTheme?.fromColor,
      defaultValue: theme.colorScheme.primary.scaleAlpha(0.05),
    );
    final toValue = styleValue(
      widgetValue: toColor,
      themeValue: compTheme?.toColor,
      defaultValue: theme.colorScheme.primary.scaleAlpha(0.1),
    );
    final enableSwitchAnimationValue = styleValue(
      widgetValue: enableSwitchAnimation,
      themeValue: compTheme?.enableSwitchAnimation,
      defaultValue: true,
    );

    return SkeletonizerConfig(
      data: SkeletonizerConfigData(
        effect: PulseEffect(
          duration: durationValue,
          from: fromValue,
          to: toValue,
        ),
        enableSwitchAnimation: enableSwitchAnimationValue,
      ),
      child: child,
    );
  }
}

/// Convenient skeleton extension helpers.
extension SkeletonExtension on Widget {
  /// Implements `asSkeletonSliver` behavior for skeleton.
  Widget asSkeletonSliver({bool enabled = true}) {
    return Skeletonizer(enabled: enabled, ignoreContainers: false, child: this);
  }

  Widget asSkeleton({
    bool enabled = true,
    bool leaf = false,
    Widget? replacement,
    bool unite = false,
    AsyncSnapshot? snapshot,
  }) {
    if (snapshot != null) {
      enabled = !snapshot.hasData;
    }
    if (this is Avatar || this is Image) {
      return Skeleton.leaf(enabled: enabled, child: this);
    }
    if (unite) {
      return Skeleton.unite(unite: enabled, child: this);
    }
    if (replacement != null) {
      return Skeleton.replace(replace: enabled, child: replacement);
    }
    if (leaf) {
      return Skeleton.leaf(enabled: enabled, child: this);
    }
    return Skeletonizer(enabled: enabled, child: this);
  }

  /// Implements `ignoreSkeleton` behavior for skeleton.
  Widget ignoreSkeleton() {
    return Skeleton.ignore(child: this);
  }

  /// Implements `excludeSkeleton` behavior for skeleton.
  Widget excludeSkeleton({bool exclude = true}) {
    return Skeleton.keep(keep: exclude, child: this);
  }
}
