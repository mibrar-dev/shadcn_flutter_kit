/// Global registry for component theme data provided by token config files.
class ComponentThemeGlobalRegistry {
  static final Map<Type, Object? Function()> _resolvers = {};

  /// Registers a resolver for [T].
  static void register<T>(T? Function() resolver) {
    _resolvers[T] = resolver;
  }

  /// Looks up global component theme data for [T], if registered.
  static T? maybeOf<T>() {
    final resolver = _resolvers[T];
    if (resolver == null) return null;
    return resolver() as T?;
  }
}
