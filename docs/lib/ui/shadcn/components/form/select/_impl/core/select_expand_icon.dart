// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../select.dart';

/// The default icon for Select expandIcon.
class SelectExpandIcon extends StatelessWidget {
  /// Create SelectExpandIcon.
  const SelectExpandIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(LucideIcons.chevronsUpDown).iconSmall();
  }
}
