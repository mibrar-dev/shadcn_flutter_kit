// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../timeline.dart';

/// TimelineData defines a reusable type for this registry module.
class TimelineData {
  /// Widget displaying the time or timestamp for this timeline entry.
  ///
  /// Positioned in the left column of the timeline with right alignment.
  /// Typically contains time information, dates, or sequence numbers.
  final Widget time;

  /// Widget displaying the main title or heading for this timeline entry.
  ///
  /// Positioned in the right column as the primary content identifier.
  /// Usually contains the event name, milestone title, or key description.
  final Widget title;

  /// Optional widget with additional details about this timeline entry.
  ///
  /// Positioned below the title in the right column when provided.
  /// Can contain descriptions, additional context, or supporting information.
  final Widget? content;

  /// Optional custom color for this entry's indicator and connector.
  ///
  /// When provided, overrides the default theme color for this specific
  /// timeline entry. If null, uses the theme's default color.
  final Color? color;

  /// Creates a [TimelineData] entry for use in [Timeline] widgets.
  ///
  /// Parameters:
  /// - [time] (Widget, required): Time or timestamp display widget.
  /// - [title] (Widget, required): Main title or heading widget.
  /// - [content] (Widget?, optional): Additional details widget.
  /// - [color] (Color?, optional): Custom color for indicator and connector.
  ///
  /// Example:
  /// ```dart
  /// TimelineData(
  ///   time: Text('10:00 AM', style: TextStyle(fontWeight: FontWeight.bold)),
  ///   title: Text('Project Kickoff'),
  ///   content: Text('Initial meeting to discuss project scope and timeline.'),
  ///   color: Colors.blue,
  /// );
  /// ```
  TimelineData({
    required this.time,
    required this.title,
    this.content,
    this.color,
  });
}
