// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../navigation_bar.dart';

/// Base class for navigation bar items.
///
/// Abstract widget class that all navigation items must extend.
/// Provides common interface for items within [NavigationBar].
abstract class NavigationBarItem extends Widget {
  /// Creates a [NavigationBarItem].
  const NavigationBarItem({super.key});

  /// Whether this item can be selected.
  bool get selectable;
}
