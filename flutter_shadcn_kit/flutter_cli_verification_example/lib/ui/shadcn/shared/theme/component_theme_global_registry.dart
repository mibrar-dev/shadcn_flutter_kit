/// Global registry for component theme data provided by token config files.
class ComponentThemeGlobalRegistry {
  static final Map<String, Object? Function()> _resolvers = {};

  /// Registers a resolver by runtime type name (e.g. `ToastTheme`).
  static void registerByName(String typeName, Object? Function() resolver) {
    _resolvers[typeName] = resolver;
  }

  /// Looks up global component theme data for [T], if registered.
  static T? maybeOf<T>() {
    final resolver = _resolvers[T.toString()];
    if (resolver == null) return null;
    return resolver() as T?;
  }
}
