// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../avatar.dart';

/// Internal helper class used by the avatar component implementation.
class _AvatarWidget extends StatelessWidget implements AvatarWidget {
  /// Layout/size setting that affects avatar rendering.
  @override
  final double? size;

  /// Layout/size setting that affects avatar rendering.
  @override
  final double? borderRadius;

  /// Child content displayed inside the avatar widget.
  final Widget child;

  const _AvatarWidget({required this.child, this.size, this.borderRadius});

  /// Builds the widget tree for avatar.
  @override
  Widget build(BuildContext context) {
    return child;
  }
}
