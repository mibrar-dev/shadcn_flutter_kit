// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../avatar.dart';

/// Core class used by the avatar component.
abstract class AvatarWidget extends Widget {
  const AvatarWidget({super.key});

  double? get size;

  double? get borderRadius;
}
