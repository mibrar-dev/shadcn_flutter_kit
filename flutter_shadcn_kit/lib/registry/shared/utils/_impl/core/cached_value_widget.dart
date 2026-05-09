// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../util.dart';

/// CachedValueWidget defines a reusable type for this registry module.
class CachedValueWidget<T> extends StatefulWidget {
  /// The value to cache and pass to builder.
  final T value;

  /// Builder function that creates the widget from the value.
  final Widget Function(BuildContext context, T value) builder;

  /// Creates a [CachedValueWidget].
  const CachedValueWidget({
    super.key,
    required this.value,
    required this.builder,
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<StatefulWidget> createState() => _CachedValueWidgetState<T>();
}
