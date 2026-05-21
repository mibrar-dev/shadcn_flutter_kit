// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../dropdown_menu.dart';

/// DropdownMenu defines a reusable type for this registry module.
class DropdownMenu extends StatefulWidget {
  /// Opacity of the surface blur effect.
  ///
  /// If `null`, uses theme default.
  final double? surfaceOpacity;

  /// Amount of blur to apply to the surface.
  ///
  /// If `null`, uses theme default.
  final double? surfaceBlur;

  /// Menu items to display in the dropdown.
  ///
  /// Each item should be a [MenuItem] or similar menu component.
  final List<MenuItem> children;

  /// Creates a dropdown menu.
  ///
  /// Parameters:
  /// - [children]: Menu items to display (required)
  /// - [surfaceOpacity]: Backdrop blur opacity
  /// - [surfaceBlur]: Amount of surface blur
  const DropdownMenu({
    super.key,
    this.surfaceOpacity,
    this.surfaceBlur,
    required this.children,
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<DropdownMenu> createState() => _DropdownMenuState();
}
