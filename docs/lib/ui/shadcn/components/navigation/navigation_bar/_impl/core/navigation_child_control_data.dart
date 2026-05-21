// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../navigation_bar.dart';

/// NavigationChildControlData defines a reusable type for this registry module.
class NavigationChildControlData {
  /// Logical index for selection (null if not selectable).
  final int? index;

  /// Actual position index in the navigation layout.
  final int actualIndex;

  /// Creates navigation child control data.
  ///
  /// Parameters:
  /// - [index] (int?): Logical selection index
  /// - [actualIndex] (int, required): Layout position index
  NavigationChildControlData({this.index, required this.actualIndex});

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NavigationChildControlData &&
        other.index == index &&
        other.actualIndex == actualIndex;
  }

  @override
  int get hashCode {
    return Object.hash(index, actualIndex);
  }
}
