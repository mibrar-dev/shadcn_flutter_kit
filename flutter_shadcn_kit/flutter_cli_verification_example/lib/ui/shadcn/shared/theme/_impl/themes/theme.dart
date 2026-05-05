part of '../../theme.dart';

/// Theme defines a reusable type for this registry module.
class Theme extends InheritedTheme {
  /// The theme data to provide to descendants.
  final ThemeData data;

  /// Creates a [Theme].
  ///
  /// Parameters:
  /// - [data] (`ThemeData`, required): Theme data to provide.
  /// - [child] (`Widget`, required): Child widget.
  const Theme({
    super.key,
    required this.data,
    required super.child,
  });

  /// Gets the [ThemeData] from the closest [Theme] ancestor.
  ///
  /// Returns: `ThemeData` — the theme data.
  static ThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<Theme>();
    final data = theme?.data ?? const ThemeData();
    return _ensureReadableDarkTheme(data);
  }

  static ThemeData _ensureReadableDarkTheme(ThemeData data) {
    final scheme = data.colorScheme;
    if (scheme.brightness != Brightness.dark) {
      return data;
    }
    if (scheme.background.computeLuminance() >= 0.5) {
      return data;
    }

    const defaults = ColorSchemes.darkDefaultColor;
    Color readable(Color color, Color fallback, double minLuminance) {
      return color.computeLuminance() < minLuminance ? fallback : color;
    }

    final normalized = scheme.copyWith(
      foreground: () => readable(scheme.foreground, defaults.foreground, 0.5),
      mutedForeground: () =>
          readable(scheme.mutedForeground, defaults.mutedForeground, 0.35),
      cardForeground: () =>
          readable(scheme.cardForeground, defaults.cardForeground, 0.45),
      popoverForeground: () =>
          readable(scheme.popoverForeground, defaults.popoverForeground, 0.45),
      sidebarForeground: () =>
          readable(scheme.sidebarForeground, defaults.sidebarForeground, 0.45),
    );
    if (normalized == scheme) {
      return data;
    }
    return data.copyWith(colorScheme: () => normalized);
  }

  @override
/// Executes `updateShouldNotify` behavior for this component/composite.
  bool updateShouldNotify(covariant Theme oldWidget) {
    return oldWidget.data != data;
  }

  @override
/// Executes `wrap` behavior for this component/composite.
  Widget wrap(BuildContext context, Widget child) {
    final Theme? ancestorTheme = context.findAncestorWidgetOfExactType<Theme>();
    return identical(this, ancestorTheme)
        ? child
        : Theme(data: data, child: child);
  }

  @override
/// Executes `debugFillProperties` behavior for this component/composite.
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ThemeData>('data', data));
  }
}

/// A tween for animating between two [ThemeData] values.
