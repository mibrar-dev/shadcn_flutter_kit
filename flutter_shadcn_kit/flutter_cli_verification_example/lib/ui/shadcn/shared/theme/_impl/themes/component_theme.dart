part of '../../theme.dart';

/// ComponentTheme defines a reusable type for this registry module.
class ComponentTheme<T extends ComponentThemeData> extends InheritedTheme {
  /// The component theme data to provide to descendants.
  final T data;

  /// Creates a [ComponentTheme].
  ///
  /// Parameters:
  /// - [data] (`T`, required): Theme data for this component type.
  /// - [child] (`Widget`, required): Child widget.
  const ComponentTheme({super.key, required this.data, required super.child});

  @override
  /// Executes `wrap` behavior for this component/composite.
  Widget wrap(BuildContext context, Widget child) {
    ComponentTheme<T>? ancestorTheme = context
        .findAncestorWidgetOfExactType<ComponentTheme<T>>();
    // if it's the same type, we don't need to wrap it
    if (identical(this, ancestorTheme)) {
      return child;
    }
    return ComponentTheme<T>(data: data, child: child);
  }

  /// Gets the component theme data of type `T` from the closest ancestor.
  ///
  /// Throws if no [ComponentTheme] of type `T` is found.
  ///
  /// Returns: `T` — the component theme data.
  static T of<T extends ComponentThemeData>(BuildContext context) {
    final data = maybeOf<T>(context);
    assert(data != null, 'No ComponentTheme<$T> found in context');
    return data!;
  }

  /// Gets the component theme data of type `T` from the closest ancestor.
  ///
  /// Returns `null` if no [ComponentTheme] of type `T` is found.
  ///
  /// Returns: `T?` — the component theme data, or null.
  static T? maybeOf<T extends ComponentThemeData>(BuildContext context) {
    final widget = context
        .dependOnInheritedWidgetOfExactType<ComponentTheme<T>>();
    if (widget == null) {
      return ComponentThemeGlobalRegistry.maybeOf<T>();
    }
    return widget.data;
  }

  @override
  /// Executes `updateShouldNotify` behavior for this component/composite.
  bool updateShouldNotify(covariant ComponentTheme<T> oldWidget) {
    return oldWidget.data != data ||
        oldWidget.data.themeDensity != data.themeDensity ||
        oldWidget.data.themeSpacing != data.themeSpacing ||
        oldWidget.data.themeShadows != data.themeShadows;
  }
}

/// Determines which theme mode to use.
///
/// - `system`: Follow system theme preference
/// - `light`: Always use light theme
/// - `dark`: Always use dark theme
enum ThemeMode {
  /// Follow the system theme (light or dark based on device settings).
  system,

  /// Always use light theme.
  light,

  /// Always use dark theme.
  dark,
}
