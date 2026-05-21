// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../tab_container.dart';

/// KeyedTabItem defines a reusable type for this registry module.
class KeyedTabItem<T> extends TabItem with KeyedTabChild<T> {
  /// Creates a [KeyedTabItem].
  ///
  /// Parameters:
  /// - [key] (`T`, required): unique key for this tab
  /// - [child] (`Widget`, required): content to display in this tab
  KeyedTabItem({required T key, required super.child})
    : super(key: ValueKey(key));

  @override
  /// Stores `key` state/configuration for this implementation.
  ValueKey<T> get key => super.key as ValueKey<T>;

  @override
  /// Stores `tabKey` state/configuration for this implementation.
  T get tabKey => key.value;
}
