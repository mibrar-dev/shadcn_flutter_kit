// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../tabs.dart';

/// KeyedTabChildWidget defines a reusable type for this registry module.
class KeyedTabChildWidget<T> extends TabChildWidget with KeyedTabChild<T> {
  /// Creates a keyed tab child widget.
  ///
  /// Parameters:
  /// - [key]: The unique key value for this tab (required)
  /// - [child]: The widget to wrap (required)
  /// - [indexed]: Whether to use indexed positioning (optional)
  KeyedTabChildWidget({required T key, required super.child, super.indexed})
    : super(key: ValueKey(key));

  @override
  /// Stores `key` state/configuration for this implementation.
  ValueKey<T> get key => super.key as ValueKey<T>;

  @override
  /// Stores `tabKey` state/configuration for this implementation.
  T get tabKey => key.value;
}

/// A basic tab item widget.
///
/// Represents a single tab item with content that can be displayed
/// in a [TabContainer].
