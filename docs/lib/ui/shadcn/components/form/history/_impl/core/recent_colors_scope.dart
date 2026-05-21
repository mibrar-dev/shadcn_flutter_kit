// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../history.dart';

/// Provides color history storage in the widget tree.
///
/// [RecentColorsScope] manages a list of recently used colors and makes it
/// available to descendant widgets through [ColorHistoryStorage]. It supports
/// a configurable maximum capacity and notifies listeners of changes.
class RecentColorsScope extends StatefulWidget {
  /// Initial colors to populate the history.
  final List<Color> initialRecentColors;

  /// Maximum number of colors to keep in the history.
  final int maxRecentColors;

  /// Called when the recent colors list changes.
  final ValueChanged<List<Color>>? onRecentColorsChanged;

  /// The child widget.
  final Widget child;

  /// Creates a [RecentColorsScope].
  const RecentColorsScope({
    super.key,
    this.initialRecentColors = const [],
    this.maxRecentColors = 50,
    this.onRecentColorsChanged,
    required this.child,
  });

  /// Creates the `State` object for this widget.
  @override
  State<RecentColorsScope> createState() => RecentColorsScopeState();
}
