// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../scaffold.dart';

/// ScaffoldBarData defines a reusable type for this registry module.
class ScaffoldBarData {
  /// Whether this bar is in the header section (vs footer).
  final bool isHeader;

  /// Zero-based index of this child bar.
  final int childIndex;

  /// Total number of children in this section.
  final int childrenCount;

  /// Creates [ScaffoldBarData].
  const ScaffoldBarData({
    this.isHeader = true,
    required this.childIndex,
    required this.childrenCount,
  });
}
