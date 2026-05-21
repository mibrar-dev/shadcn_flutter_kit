// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../shared/theme/theme.dart';

/// Extension on Widget providing icon theme utilities.
extension IconExtension on Widget {
  WrappedIcon get iconX4Small {
    return WrappedIcon(
      data: (context, theme) => theme.iconTheme.x4Small,
      child: this,
    );
  }

  WrappedIcon get iconX3Small {
    return WrappedIcon(
      data: (context, theme) => theme.iconTheme.x3Small,
      child: this,
    );
  }

  WrappedIcon get iconX2Small {
    return WrappedIcon(
      data: (context, theme) => theme.iconTheme.x2Small,
      child: this,
    );
  }

  WrappedIcon get iconXSmall {
    return WrappedIcon(
      data: (context, theme) => theme.iconTheme.xSmall,
      child: this,
    );
  }

  WrappedIcon get iconSmall {
    return WrappedIcon(
      data: (context, theme) => theme.iconTheme.small,
      child: this,
    );
  }

  WrappedIcon get iconMedium {
    return WrappedIcon(
      data: (context, theme) => theme.iconTheme.medium,
      child: this,
    );
  }

  WrappedIcon get iconLarge {
    return WrappedIcon(
      data: (context, theme) => theme.iconTheme.large,
      child: this,
    );
  }

  WrappedIcon get iconXLarge {
    return WrappedIcon(
      data: (context, theme) => theme.iconTheme.xLarge,
      child: this,
    );
  }

  WrappedIcon get iconX2Large {
    return WrappedIcon(
      data: (context, theme) => theme.iconTheme.x2Large,
      child: this,
    );
  }

  WrappedIcon get iconX3Large {
    return WrappedIcon(
      data: (context, theme) => theme.iconTheme.x3Large,
      child: this,
    );
  }

  WrappedIcon get iconX4Large {
    return WrappedIcon(
      data: (context, theme) => theme.iconTheme.x4Large,
      child: this,
    );
  }

  WrappedIcon get iconMutedForeground {
    return WrappedIcon(
      data: (context, theme) =>
          IconThemeData(color: theme.colorScheme.mutedForeground),
      child: this,
    );
  }

  @Deprecated('Legacy color')
  WrappedIcon get iconDestructiveForeground {
    return WrappedIcon(
      data: (context, theme) =>
          IconThemeData(color: theme.colorScheme.destructiveForeground),
      child: this,
    );
  }

  WrappedIcon get iconPrimaryForeground {
    return WrappedIcon(
      data: (context, theme) =>
          IconThemeData(color: theme.colorScheme.primaryForeground),
      child: this,
    );
  }

  WrappedIcon get iconPrimary {
    return WrappedIcon(
      data: (context, theme) => IconThemeData(color: theme.colorScheme.primary),
      child: this,
    );
  }

  WrappedIcon get iconSecondary {
    return WrappedIcon(
      data: (context, theme) =>
          IconThemeData(color: theme.colorScheme.secondary),
      child: this,
    );
  }

  WrappedIcon get iconSecondaryForeground {
    return WrappedIcon(
      data: (context, theme) =>
          IconThemeData(color: theme.colorScheme.secondaryForeground),
      child: this,
    );
  }
}

/// Function/type signature used by icon APIs.
typedef WrappedIconDataBuilder<T> =
    T Function(BuildContext context, ThemeData theme);

/// Core class used by the icon component.
class WrappedIcon extends StatelessWidget {
  /// Data consumed by `WrappedIcon` to render icon content.
  final WrappedIconDataBuilder<IconThemeData> data;

  /// Child content displayed inside the icon widget.
  final Widget child;

  const WrappedIcon({super.key, required this.data, required this.child});

  /// Implements `call` behavior for icon.
  Widget call() {
    return this;
  }

  /// Builds the widget tree for icon.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconTheme = data(context, theme);
    return IconTheme.merge(data: iconTheme, child: child);
  }

  /// Returns a copy with selected icon properties overridden.
  WrappedIcon copyWith({WrappedIconDataBuilder<IconThemeData>? data}) {
    return WrappedIcon(
      data: (context, theme) {
        return data?.call(context, theme).merge(this.data(context, theme)) ??
            this.data(context, theme);
      },
      child: child,
    );
  }
}
