// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../select.dart';

/// A container for grouping related select items with optional headers and footers.
///
/// Organizes select menu items into logical sections with optional header
/// and footer widgets.
class SelectGroup extends StatelessWidget {
  /// Optional header widgets displayed above the group.
  final List<Widget>? headers;

  /// The list of select items in this group.
  final List<Widget> children;

  /// Optional footer widgets displayed below the group.
  final List<Widget>? footers;

  /// Creates a select group.
  const SelectGroup({
    super.key,
    this.headers,
    this.footers,
    required this.children,
  });

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (headers != null) ...headers!,
        ...children,
        if (footers != null) ...footers!,
      ],
    );
  }
}
