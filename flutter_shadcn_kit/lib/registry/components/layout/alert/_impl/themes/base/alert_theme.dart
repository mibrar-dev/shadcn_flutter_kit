// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../alert.dart';

/// Theme extensions used by [Alert].
class AlertTheme extends ComponentThemeData {
  /// Creates a `AlertTheme` instance.
  const AlertTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.padding,
    this.backgroundColor,
    this.borderColor,
  });

  /// Stores `padding` state/configuration for this implementation.
  final EdgeInsetsGeometry? padding;

  /// Stores `backgroundColor` state/configuration for this implementation.
  final Color? backgroundColor;

  /// Stores `borderColor` state/configuration for this implementation.
  final Color? borderColor;

  /// Creates a `AlertTheme` instance.
  AlertTheme copyWith({
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<Color?>? backgroundColor,
    ValueGetter<Color?>? borderColor,
  }) {
    return AlertTheme(
      padding: padding == null ? this.padding : padding(),
      backgroundColor: backgroundColor == null
          ? this.backgroundColor
          : backgroundColor(),
      borderColor: borderColor == null ? this.borderColor : borderColor(),
    );
  }

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    return other is AlertTheme &&
        other.padding == padding &&
        other.backgroundColor == backgroundColor &&
        other.borderColor == borderColor;
  }

  @override
  int get hashCode => Object.hash(padding, backgroundColor, borderColor);
}
