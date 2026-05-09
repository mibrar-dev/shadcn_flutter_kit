// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../chip_input.dart';

/// _ChipProvider represents a form-related type in the registry.
abstract class _ChipProvider<T> {
  Widget? buildChip(BuildContext context, T chip);
}
